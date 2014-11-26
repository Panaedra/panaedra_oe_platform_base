using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msas.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.c_unittest_recordlock: 

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
  
  define protected variable bExtraSessionIsBooted as logical no-undo.
  
  define property cLdbname as character no-undo
    public get.
    protected set.
    
  define property cUtClientGuid as character no-undo
    public get:
      if length(cUtClientGuid) = 0 then
        cUtClientGuid = guid.
      return cUtClientGuid.
    end get.
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
      
    assign
      cLdbname = cLdbnameIP#  
      cTable   = cTableIP#   
      rRowid   = rRowidIP#.   
    
  end constructor.
  

  destructor c_unittest_recordlock():
    sc_unittest:_sys_SocketClientUnregister(cUtClientGuid).  
  end destructor.
  
  
  method public void LockIt():
    
    define variable bClientGuidFeedbackOkay# as logical   no-undo.
    define variable cGuid#                   as character no-undo.
    define variable cFeedback#               as character no-undo.
    
    cGuid# = guid.
    
    if bExtraSessionIsBooted = false then 
    do:
      bExtraSessionIsBooted = true.
      BootExtraSession(). 
    end.
    
    sc_unittest:_sys_SocketClientSend(cUtClientGuid, subst("ACTION~004LOCKIT~003TASKGUID~004&1~003ldbname~004&2~003table~004&3~003rowid~004&4~012", cGuid#, cLdbname, cTable, rRowid)).
    sc_unittest:_sys_SocketClientTaskGuidWait(cUtClientGuid, cGuid#, 5000, output bClientGuidFeedbackOkay#, output cFeedback#).
    
    if bClientGuidFeedbackOkay# = false then
      undo, throw new c_panaedraexception(99028162, sc_lang:oEnglish, substitute("UnitTest recordlock client did not respond to LockIt() in '&1' ms.", 5000)).
      
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
  
  
  method protected void BootExtraSession():

    define variable cCommand#                as character no-undo.
    define variable cEnv#                    as character no-undo.
    define variable cWorkPath#               as character no-undo.
    define variable bDevToken#               as logical   no-undo.
    define variable bClientGuidFeedbackOkay# as logical   no-undo.
    
    /* Set up a server-socket (if not already running) */
    sc_unittest:_sys_InitializeUtServerSocket().

    /* Start a separate session that connects to the server socket */
    assign
      cEnv#      = sc_boot:SessionParameter("Env")
      cWorkPath# = sc_boot:SessionParameter("WorkPath").

    bDevToken# = length(os-getenv("DevToken")) > 0 no-error.
    if bDevToken# = ? then bDevToken# = false.

    if cWorkPath# = ? or cWorkPath# = "" then
      cWorkPath# = sc_path:cWorkDir.
    
    cCommand# = subst('. /etc/profile ; unset PROPATH ; &1 &2 ; export LOGFILEID=&3 ; export UtClientGuid=&3 ; export AsModeSuffixPre=&4 ; CpSuffix=_utf8_s850 $SCRIPTS/RunRaw  "panaedra/msroot/msutil/logic/c_unittest_recordlockclient_boot.p" &5 &6 BATCH " [UnittestPort] &7 [SharedIniDir] &8 &9 "',
      " export OTAUSER=yes ;" 
      /* tmp solution, remove if live is OE113 */
      + if sc_environment:cEnv <> "misc" then "" else ". /progress/scripts/progressProfile113A;",
      subst(". $SCRIPTS/PropathSet &1 ; export PROPATHPRE=$PROPATH", if bDevToken# then os-getenv("DlcTest_") else "test"),
      cUtClientGuid,
      replace(sc_asconnect:GetSuffix(), "_batch", "") /* _batch can be removed here */,
      sc_environment:cEnv, 
      cWorkPath# /* Working directory */,
      sc_unittest:sys_iUtServerPort,
      sc_path:cIniDir,
      if sc_boot:SessionParameter("DevIP") > "" then subst("[DevIP] &1 ", sc_boot:SessionParameter("DevIP")) else ""
      ).
    
    /* Start the client process. */
    os-command silent value(cCommand#).
    /* After 5 seconds the process should be in the air. */
    sc_unittest:_sys_SocketClientGuidWait(cUtClientGuid, 5000, output bClientGuidFeedbackOkay#).
    
    if not bClientGuidFeedbackOkay# then
      undo, throw new c_panaedraexception(
        99028172,
        sc_lang:oEnglish,
        substitute("UnitTest client '&1' did not respond after '&2' ms.", cUtClientGuid, 5000)).
      
  end method. /* BootExtraSession */

end class.

/* EOF */ 
