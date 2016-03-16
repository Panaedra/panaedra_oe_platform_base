using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msas.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.c_unittest_recordlock inherits c_unittest_concurrentclient_base: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: For unit tests: lock a record of a table (in another session).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_unittest_recordlock(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define property cLdbname as character no-undo
    public get.
    protected set.
    
  define property cTable   as character no-undo
    public get.
    protected set.
    
  define property rRowid   as rowid     no-undo
    public get.
    protected set.
  
  constructor public c_unittest_recordlock(
    cLdbnameIP# as character,
    cTableIP#   as character,
    rRowidIP#   as rowid):
      
    super().  
      
    assign
      cLdbname = cLdbnameIP#  
      cTable   = cTableIP#   
      rRowid   = rRowidIP#.   
    
  end constructor.
  
  
  method public void LockIt():
    
    define variable bClientGuidFeedbackOkay# as logical   no-undo.
    define variable cGuid#                   as character no-undo.
    define variable cFeedback#               as character no-undo.
    
    cGuid# = guid.
    
    if bExtraSessionIsBooted = false then 
    do:
      bExtraSessionIsBooted = true.
      BootExtraSession("panaedra/msroot/msutil/logic/c_unittest_recordlockclient_boot.p").
    end.
    
    sc_unittest:_sys_SocketClientSend(cUtClientGuid, subst("ACTION~004LOCKIT~003TASKGUID~004&1~003ldbname~004&2~003table~004&3~003rowid~004&4~012", cGuid#, cLdbname, cTable, rRowid)).
    
    /* Pauze was 5000 milliseconden. Naar 30000 verhoogd i.v.m. traagheid op srv-ota door bijv. teruglezen backup */  
    sc_unittest:_sys_SocketClientTaskGuidWait(cUtClientGuid, cGuid#, 30000, output bClientGuidFeedbackOkay#, output cFeedback#).
    
    if bClientGuidFeedbackOkay# = false then
      undo, throw new c_panaedraexception(99028162, sc_lang:oEnglish, substitute("UnitTest recordlock client did not respond to LockIt() in '&1' ms.", 30000)).
      
    if cFeedback# = ? or cFeedback# <> "LockSucceeded~004yes" then
      undo, throw new c_panaedraexception(99028163, sc_lang:oEnglish, substitute("LockIt remote:'&1'", cFeedback#)).
  
  end method. /* LockIt */
  
  
  method public void UnlockIt():
    
    define variable bClientGuidFeedbackOkay# as logical   no-undo.
    define variable cGuid#                   as character no-undo.
    define variable cFeedback#               as character no-undo.
    
    cGuid# = guid.
    
    sc_unittest:_sys_SocketClientSend(cUtClientGuid, subst("ACTION~004UNLOCKIT~003TASKGUID~004&1~003ldbname~004&2~003table~004&3~003rowid~004&4~012", cGuid#, cLdbname, cTable, rRowid)).
    sc_unittest:_sys_SocketClientTaskGuidWait(cUtClientGuid, cGuid#, 5000, output bClientGuidFeedbackOkay#, output cFeedback#).
    
    if bClientGuidFeedbackOkay# = false then
      undo, throw new c_panaedraexception(99028164, sc_lang:oEnglish, substitute("UnitTest recordlock client did not respond to UnlockIt() in '&1' ms.", 5000)).
  
    if cFeedback# = ? or cFeedback# <> "LockReleased~004yes" then
      undo, throw new c_panaedraexception(99028165, sc_lang:oEnglish, substitute("UnlockIt remote:'&1'", cFeedback#)).
  
  end method. /* UnlockIt */
  
end class.

/* EOF */ 
