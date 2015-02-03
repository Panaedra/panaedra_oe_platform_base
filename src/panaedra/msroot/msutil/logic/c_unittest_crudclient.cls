using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msas.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.c_unittest_crudclient inherits c_unittest_concurrentclient_base: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: For unit tests: Do CRUD actions on records of a table (in another session).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_unittest_crudclient(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
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
    
  define property cPrep   as character no-undo
    public get.
    protected set.
  
  define property cSvFieldsLogged as character no-undo /* list of fields of the table to be logged in logfile */
    public get.
    public set.
  
  constructor public c_unittest_crudclient(
    cLdbnameIP# as character,
    cTableIP#   as character,
    cPrepIP#    as character):
      
    super().  
      
    assign
      cLdbname = cLdbnameIP#  
      cTable   = cTableIP#   
      cPrep    = cPrepIP#.   
    
  end constructor.
  
  
  method public void FullCrud():
    
    define variable bClientGuidFeedbackOkay# as logical   no-undo.
    define variable cGuid#                   as character no-undo.
    define variable cFeedback#               as character no-undo.
    
    cGuid# = guid.
    
    if bExtraSessionIsBooted = false then 
    do:
      bExtraSessionIsBooted = true.
      BootExtraSession("panaedra/msroot/msutil/logic/c_unittest_crudclient_boot.p").
    end.
    
    sc_unittest:_sys_SocketClientSend(cUtClientGuid, subst("ACTION~004FULLCRUD~003TASKGUID~004&1~003ldbname~004&2~003table~004&3~003prep~004&4~003fldslogged~004&5~012", cGuid#, cLdbname, cTable, cPrep, cSvFieldsLogged)).
    sc_unittest:_sys_SocketClientTaskGuidWait(cUtClientGuid, cGuid#, 5000, output bClientGuidFeedbackOkay#, output cFeedback#).
    
    if bClientGuidFeedbackOkay# = false then
      undo, throw new c_panaedraexception(99028162, sc_lang:oEnglish, substitute("UnitTest crudclient client did not respond to FullCrud() in '&1' ms.", 5000)).
      
    if cFeedback# = ? or cFeedback# <> "LockSucceeded~004yes" then
      undo, throw new c_panaedraexception(99028163, sc_lang:oEnglish, substitute("FullCrud remote:'&1'", cFeedback#)).
  
  end method. /* FullCrud */
    
end class.

/* EOF */ 
