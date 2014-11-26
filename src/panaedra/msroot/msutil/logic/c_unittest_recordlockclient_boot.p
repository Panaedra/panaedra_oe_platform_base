using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ptop_procedure.i}

/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: $ 
        Version: $Revision: $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: $ 
  Date Modified: $Modtime: $ 

    Description: Boot procedure (started per record lock) that connects to 
                 the sc_unittest.cls server-socket. Not to be used directly.

\**************************** End of Dvcs_ Header ****************************/
&scop dvcs_proc procedure dvcs__panaedra_msroot_msutil_logic_c_unittest_recordlockclient_boot_p: return "$Revision: $". end.
{&dvcs_proc}
/******************************* $NoKeywords:  $ *****************************/

&scop max_char_value 31979

define variable hClientSocketPS#      as handle    no-undo.
define variable cUtClientGuid#        as character no-undo.
define variable iPortPS#              as integer   no-undo.
define variable bConnected#           as logical   no-undo.
define variable bKeepLoopingPS#       as logical   no-undo init true.
define variable iIntervalPS#          as integer   no-undo init 1.
define variable clobIncomingPS#       as longchar  no-undo.
define variable mPing#                as memptr    no-undo.
define variable mSend#                as memptr    no-undo.
define variable cSend#                as character no-undo.
define variable bGuidRegistered#      as logical   no-undo.
define variable hBuffExclusiveLockPS# as handle    no-undo.
define variable iTell#                as integer   no-undo.
define variable cEntry#               as character no-undo.

do on error undo, leave
  on stop undo, leave:

  /* Initialization */
  
  iPortPS# = int(sc_boot:SessionParameter("UnittestPort")).
  
  cUtClientGuid# = os-getenv("UtClientGuid").
  
  message subst("&1: Client SockGuid: &2", sc_date_timestamp:cTimeStamp_Readable_DateAndTime, cUtClientGuid#)
    view-as alert-box.

  /* Create the client socket */

  create socket hClientSocketPS#.
  
  bConnected# = hClientSocketPS#:connect(subst("-S &1", iPortPS#)) no-error.

  message subst("&1: Socket connected: &2, at port &3", sc_date_timestamp:cTimeStamp_Readable_DateAndTime, bConnected#, iPortPS#)
    view-as alert-box.
  
  if bConnected# then 
  do:
    set-size(mPing#) = 6.
    put-string(mPing#,1) = "PING~012". /* octal, chr(10) */
    hClientSocketPS#:set-socket-option("TCP-NODELAY",  "FALSE").
    hClientSocketPS#:set-socket-option("SO-LINGER",    "FALSE").
    hClientSocketPS#:set-socket-option("SO-RCVTIMEO",  "10").
    hClientSocketPS#:set-socket-option("SO-KEEPALIVE", "TRUE").
    hClientSocketPS#:set-socket-option("SO-RCVBUF",    "{&max_char_value}").
    hClientSocketPS#:set-socket-option("SO-SNDBUF",    "{&max_char_value}").
    hClientSocketPS#:set-read-response-procedure ("SocketIncomingRaw", this-procedure).
  end.
  else 
    bKeepLoopingPS# = false.

  /* Start the loop */

  do while bKeepLoopingPS# 
    on error undo, leave
    on stop undo, leave:
  
    if valid-handle(hClientSocketPS#) then 
      wait-for read-response of hClientSocketPS# pause iIntervalPS#.
    else
      wait-for close of this-procedure pause iIntervalPS#.
  
    if valid-handle(hClientSocketPS#) then 
    do:
      if not bGuidRegistered# then 
      do:
        assign
          bGuidRegistered# = true
          cSend#           = subst("GuidRegister~004&1~012",cUtClientGuid#). /* octal, chr(4) and chr(10) */
        set-size(mSend#) = length(cSend#,"raw") + 1.
        put-string(mSend#,1) = cSend#.
        hClientSocketPS#:write(mSend#,1,length(cSend#)) no-error.
        set-size(mSend#) = 0.
      end.
      else 
        hClientSocketPS#:write(mPing#,1,5) no-error.
      sc_abl:ProcessEvents().
      if not (valid-handle(hClientSocketPS#) and hClientSocketPS#:connected()) then 
      do:
        message subst("&1: No UnitTest server-socket -> exiting loop.", sc_date_timestamp:cTimeStamp_Readable_DateAndTime)
          view-as alert-box.
        delete object hClientSocketPS#.
        assign
          hClientSocketPS# = ?
          bKeepLoopingPS#  = false.
      end.
    end. /* Valid */
    else 
      assign
        hClientSocketPS# = ?
        bKeepLoopingPS#  = false.
    
    if bKeepLoopingPS# then 
    do:
      
      sc_abl:ProcessEvents().
      
      if length(clobIncomingPS#) > 0 then 
        message subst("&1: clobIncomingPS# = '&2'", sc_date_timestamp:cTimeStamp_Readable_DateAndTime, trim(clobIncomingPS#)).
      
      do iTell# = 1 to num-entries(clobIncomingPS#,"~012"):
        cEntry# = entry(iTell#,clobIncomingPS#,"~012").
        if length(cEntry#) > 0 then 
        do:
          if cEntry# = "QuitUtClient" then 
          do:
            message subst("&1: QuitUtClient request; quitting.", sc_date_timestamp:cTimeStamp_Readable_DateAndTime)
              view-as alert-box.
            sc_eventbroadcaster:FireEvent("evt@SessionClose").  
            quit.
          end.
          else 
          do:
            case entry(1,cEntry#,"~003"):
              when "ACTION~004LOCKIT"   then run ip_action_lockit(cEntry#). 
              when "ACTION~004UNLOCKIT" then run ip_action_unlockit(cEntry#). 
            end case.
          end.
        end. /* length(cEntry#) > 0 */
      end. /* iTell# = 1 to num-entries(clobIncomingPS#,"~012") */ 
        
      if length(clobIncomingPS#) > 0 or clobIncomingPS# = ? then 
        clobIncomingPS# = "".
  
    end. /* if bKeepLoopingPS# */
    
  end. /* do while true */
  
end. /* Main block */


procedure SocketIncomingRaw:
  
  define variable hSock#     as handle    no-undo.
  define variable iBytes#    as integer   no-undo.
  define variable pData#     as memptr    no-undo.
  define variable bOk#       as logical   no-undo.
  define variable cHeader#   as character no-undo.
  define variable bHeader#   as logical   no-undo.
  define variable iBlockID#  as integer   no-undo.
  define variable iBlockLen# as integer   no-undo.

  apply "read-response" to this-procedure.
  
  sc_abl:ProcessEvents().

  hSock# = self.
  iBytes# = hSock#:get-bytes-available().
  
  if iBytes# > 0 then 
  do:
    set-size(pData#) = iBytes#.
    hSock#:read(pData#,1,iBytes#, read-exact-num).
    clobIncomingPS# = clobIncomingPS# + get-string(pData#,1,iBytes#) + chr(10).
    set-size(pData#) = 0.
  end.

end procedure. /* SocketIncomingRaw */


procedure ip_sendGuidTaskComplete private:
  
  define input  parameter cGuidIP#     as character no-undo.
  define input  parameter cFeedbackIP# as character no-undo.
  
  assign
    cSend# = subst("GuidTaskComplete~004&1~003GuidTaskFeedback~003&2~012",cGuidIP#, cFeedbackIP#). /* octal, chr(4) and chr(10) */
  set-size(mSend#) = length(cSend#,"raw") + 1.
  put-string(mSend#,1) = cSend#.
  hClientSocketPS#:write(mSend#,1,length(cSend#)).
  set-size(mSend#) = 0.

end procedure. /* ip_sendGuidTaskComplete */


procedure ip_action_lockit:
  
  define input  parameter cSockMsgIP# as character no-undo.
  
  define variable cTaskGuid# as character no-undo.
  define variable cLdbname#  as character no-undo.
  define variable cTable#    as character no-undo.
  define variable cRowid#    as character no-undo.
  
  assign
    cTaskGuid# = entry(2,cSockMsgIP#,"~003")
    cTaskGuid# = entry(2,cTaskGuid#,"~004")
    cLdbname#  = entry(3,cSockMsgIP#,"~003")
    cLdbname#  = entry(2,cLdbname#,"~004")
    cTable#    = entry(4,cSockMsgIP#,"~003")
    cTable#    = entry(2,cTable#,"~004")
    cRowid#    = entry(5,cSockMsgIP#,"~003")
    cRowid#    = entry(2,cRowid#,"~004")
    .
  
  if not valid-handle(hBuffExclusiveLockPS#) then 
  do:
    
    message subst("&1: Connected &2: &3", sc_date_timestamp:cTimeStamp_Readable_DateAndTime, cLdbname#, connected(cLdbname#))
      view-as alert-box.
  
    create buffer hBuffExclusiveLockPS# for table subst("&1.&2", cLdbname#, cTable#).

  end.
  
  do transaction /* codeQok#7103 codeQok#7108 Note: transaction is ONLY for the exclusive-lock. We do NO updates. codeQok#7102 */
    on error undo, throw:
      
    hBuffExclusiveLockPS#:find-by-rowid(to-rowid(cRowid#), exclusive-lock, no-wait). /* codeQok#7102 */
  
    message subst("&1: LockIt (after) : Buffer locked by someone else: &2, buffer avail: &3, dbtaskid: &4.", sc_date_timestamp:cTimeStamp_Readable_DateAndTime, trim(string(hBuffExclusiveLockPS#:locked,"YES-SO-I-CANNOT-LOCK/no")), hBuffExclusiveLockPS#:available, dbtaskid(hBuffExclusiveLockPS#:dbname))
      view-as alert-box.
      
  end. /* transaction */
  
  run ip_sendGuidTaskComplete(cTaskGuid#, subst("LockSucceeded~004&1", not hBuffExclusiveLockPS#:locked)).
  
end procedure. /* ip_action_lockit */


procedure ip_action_unlockit:
  
  define input  parameter cSockMsgIP# as character no-undo.

  define variable cTaskGuid# as character no-undo.
  
  assign
    cTaskGuid# = entry(2,cSockMsgIP#,"~003")
    cTaskGuid# = entry(2,cTaskGuid#,"~004")
    .

  if valid-handle(hBuffExclusiveLockPS#) then 
  do:
    hBuffExclusiveLockPS#:buffer-release().
    message subst("&1: UnlockIt (after) : Buffer locked by someone else: &2, buffer avail: &3, dbtaskid: &4.", sc_date_timestamp:cTimeStamp_Readable_DateAndTime, hBuffExclusiveLockPS#:locked, hBuffExclusiveLockPS#:available, dbtaskid(hBuffExclusiveLockPS#:dbname))
      view-as alert-box.
  end.
  else
    message subst("&1: UnlockIt (after) : Buffer invalid.", sc_date_timestamp:cTimeStamp_Readable_DateAndTime)
      view-as alert-box.
  
  run ip_sendGuidTaskComplete(cTaskGuid#, subst("LockReleased~004&1", valid-handle(hBuffExclusiveLockPS#))).
  
end procedure. /* ip_action_unlockit */

/* EOF */
