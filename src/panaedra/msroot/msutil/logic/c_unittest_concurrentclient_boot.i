/******************************  Dvcs_ Header ********************************\

    Description: To be included in boot procedures of sessions started 
                 by c_unittest_concurrentclient_base.cls, via 
                 BootExtraSession(my-proc). 

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_c_unittest_concurrentclient_boot_i}" = "" &then

&glob max_char_value 31979

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
define variable iIncoming#            as integer   no-undo.
define variable cIncoming#            as character no-undo.

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
      
      do iIncoming# = 1 to num-entries(clobIncomingPS#,"~012"):
        cIncoming# = entry(iIncoming#,clobIncomingPS#,"~012").
        if length(cIncoming#) > 0 then 
        do:
          if cIncoming# = "QuitUtClient" then 
          do:
            message subst("&1: QuitUtClient request; quitting.", sc_date_timestamp:cTimeStamp_Readable_DateAndTime)
              view-as alert-box.
            sc_eventbroadcaster:FireEvent("evt@SessionClose").  
            quit.
          end.
          else 
          do:
            case entry(1,cIncoming#,"~003"):
              {&CaseTcpCommand}
            end case.
          end.
        end. /* length(cIncoming#) > 0 */
      end. /* iIncoming# = 1 to num-entries(clobIncomingPS#,"~012") */ 
        
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

&endif /* {&dvcs__panaedra_msroot_msutil_logic_c_unittest_concurrentclient_boot_i} */

/* EOF : panaedra/msroot/msutil/logic/c_unittest_concurrentclient_boot.i */
