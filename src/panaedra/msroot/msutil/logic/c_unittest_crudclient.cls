using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msas.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.c_unittest_crudclient inherits c_unittest_concurrentclient_base: 

  /****************************** Source Header ********************************\

      Description: For unit tests: Do CRUD actions on records of a table (in another session).
                   
                   You can modify fields of all records in a (small) query, for testing purposes.
                   
                   There are basically four operations:
                     - Add some text (append)
                     - Shrink some text (remove last few number of characters)
                     - Add a number to a decimal, integer, or int64 field
                     - Subtract a number from a decimal, integer, or int64 field
                   
                   Example usage:
                   assign
                     oCrudclient#                       = new c_unittest_crudclient("sports", "_CCMPNY_", "preselect each _CCMPNY_ exclusive-lock where _CCMPNY_._CCMPNY_number = 123") /* codeQok#7102 codeQok#7105 codeQok#7108 */
                     oCrudclient#:cSvFieldsLogged       = "_TERM_UNDISCLOSED_no,trkvol,trkseq,trkds"
                     oCrudclient#:cTxtAppend            = " AROUND THE CLOCK"
                     oCrudclient#:cSvFieldsUpdAppend    = "trkds"
                     oCrudclient#:iValIncrement         = 70
                     oCrudclient#:cSvFieldsUpdIncrement = "trkvol,trkseq"
                   oCrudclient#:FullCrudUpd().
                   
                   This will start a separate progress session, which executes the query exclusive-lock. /* codeQok#7102 codeQok#7105 codeQok#7108 */
                   The query will be run inside one transaction.                                         /* codeQok#7103 */
                   After oCrudclient#:FullCrudUpd() has run, the operation will be complete (or timed out - synchronisation over TCP takes place). 
                   This timeout is as of now hardcoded at 5000 milliseconds.
                    
                   Each field in cSvFieldsLogged will be shown in the separate logfile of the separate session. 
                   Each field in cSvFieldsUpdAppend will be appended by " AROUND THE CLOCK". 
                   Each field in cSvFieldsUpdIncrement will be incremented by 70.
                   
                   You can use cSvFieldsUpdShrink + iTxtShrink to remove the appended text again.
                   You can use a negative iValIncrement of -70 to restore the integer fields.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define property cLdbname as character no-undo
    public get.
    protected set.
    
  define property cTable   as character no-undo
    public get.
    protected set.
    
  define property cPrep   as character no-undo
    public get.
    public set.
  
  define property cPrepDeletePre as character no-undo /* if non-empty: all records within this query will be deleted, *before* any update actions, and *before* the normal query. */
    public get.
    public set.
  
  define property cPrepDeletePost as character no-undo /* if non-empty: all records within this query will be deleted, *after* any update actions, and *after* the normal query. */
    public get.
    public set.
  
  define property cSvFieldsLogged as character no-undo /* list of fields of the table to be logged in logfile */
    public get.
    public set.
  
  define property cTxtAppend as character no-undo /* a text to append to field contents */
    public get.
    public set.
  
  define property cSvFieldsUpdAppend as character no-undo /* list of fields of the table to append cTxtAppend to */
    public get.
    public set.
  
  define property iTxtShrink as integer no-undo /* number of chars to be cut from the end of some field contents */
    public get.
    public set.
  
  define property cSvFieldsUpdShrink as character no-undo /* list of fields of the table to shrink with iTxtShrink number of chars, via substring and length */
    public get.
    public set.
  
  define property iValIncrement as integer no-undo /* number to add to some int or decimal field contents, pos or neg */
    public get.
    public set.
  
  define property cPrepIncrement as character no-undo /* if non-empty: overrules cPrep for the increment action. Query will be run *before* the normal query, and *after* a cPrepDeletePre delete query. */
    public get.
    public set.
  
  define property cSvFieldsUpdIncrement as character no-undo /* list of fields of the table to increment with iValIncrement, pos or neg */
    public get.
    public set.
  
  define property bGuidSync as logical no-undo /* end with a guidsync, for pending _TOOLING_ data */
    public get.
    public set.

  define property cSv_TOOLING_Fxdp as character no-undo /* list of _TOOLING_ datapartitions, ex.: dwan,dlan */
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
  
  
  method public void ClearCrudProperties(
  
    /* Reset all properties, except for cPrep/db/table, which are set in the constructor. */
    
    ):
    
    assign
      this-object:cPrepDeletePre        = ""
      this-object:cPrepDeletePost       = ""
      this-object:cPrepIncrement        = ""
      this-object:cSvFieldsLogged       = ""
      this-object:cSvFieldsUpdAppend    = ""
      this-object:cSvFieldsUpdIncrement = ""
      this-object:cSvFieldsUpdShrink    = ""
      this-object:cSv_TOOLING_Fxdp           = ""
      this-object:cTxtAppend            = ""
      this-object:iTxtShrink            = 0
      this-object:iValIncrement         = 0.
  
  end method. /* ClearCrudProperties */
  
  
  method public void FullCrudUpd():
    
    define variable bClientGuidFeedbackOkay# as logical   no-undo.
    define variable cGuid#                   as character no-undo.
    define variable cFeedback#               as character no-undo.
    
    cGuid# = guid.
    
    if bExtraSessionIsBooted = false then 
    do:
      bExtraSessionIsBooted = true.
      BootExtraSession("panaedra/msroot/msutil/logic/c_unittest_crudclient_boot.p").
    end.
    
    sc_unittest:_sys_SocketClientSend(cUtClientGuid, 
      subst("ACTION~004FULLCRUDUPD~003TASKGUID~004&1~003ldbname~004&2~003table~004&3~003prep~004&4~003fldslogged~004&5", cGuid#, cLdbname, cTable, cPrep, cSvFieldsLogged) +
      subst("~003txtappend~004&1",     cTxtAppend            ) + 
      subst("~003fldsappend~004&1",    cSvFieldsUpdAppend    ) + 
      subst("~003txtshrink~004&1",     iTxtShrink            ) + 
      subst("~003fldsshrink~004&1",    cSvFieldsUpdShrink    ) + 
      subst("~003increment~004&1",     iValIncrement         ) + 
      subst("~003fldsincrement~004&1", cSvFieldsUpdIncrement ) + 
      subst("~003guidsync~004&1",      bGuidSync             ) + 
      subst("~003fxdp~004&1",          cSv_TOOLING_Fxdp           ) + 
      subst("~003prepdelpre~004&1",    cPrepDeletePre        ) + 
      subst("~003prepdelpost~004&1",   cPrepDeletePost       ) + 
      subst("~003prepinc~004&1",       cPrepIncrement        ) + 
      "~012"
      ).
    /* Pauze was 5000 milliseconden. Naar 30000 verhoogd i.v.m. traagheid op srv-ota door bijv. teruglezen backup */  
    sc_unittest:_sys_SocketClientTaskGuidWait(cUtClientGuid, cGuid#, 30000, output bClientGuidFeedbackOkay#, output cFeedback#).
    
    if bClientGuidFeedbackOkay# = false then
      undo, throw new c_panaedraexception(99028162, sc_lang:oEnglish, substitute("UnitTest crudclient client did not respond to FullCrudUpd() in '&1' ms.", 30000)).
      
    if cFeedback# = ? or cFeedback# <> "LockSucceeded~004yes" then
      undo, throw new c_panaedraexception(99028163, sc_lang:oEnglish, substitute("FullCrudUpd remote:'&1'", cFeedback#)).
  
  end method. /* FullCrudUpd */

  method public void FullCrudCre():
    undo, throw new c_panaedraexception(99918352,sc_lang:oEnglish,"Not implemented.").
  end method. /* FullCrudCre */
    
  method public void FullCrudDel():
    undo, throw new c_panaedraexception(99918353,sc_lang:oEnglish,"Use cPrepDeletePre or cPrepDeletePost for delete actions.").
  end method. /* FullCrudDel */
    
end class.

/* EOF */ 
