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

&glob CaseTcpCommand ~
  /~* lock it   ~*/  when "ACTION~~004LOCKIT"   then run ip_action_lockit(cIncoming#)  . ~
  /~* unlock it ~*/  when "ACTION~~004UNLOCKIT" then run ip_action_unlockit(cIncoming#).

{panaedra/msroot/msutil/logic/c_unittest_concurrentclient_boot.i}

define variable hBuffExclusiveLockPS# as handle    no-undo.

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
