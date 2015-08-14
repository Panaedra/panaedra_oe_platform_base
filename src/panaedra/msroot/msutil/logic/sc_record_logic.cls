using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_record_logic: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: db and tt record help methods

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_record_logic(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  constructor public sc_record_logic(): 
  
  end constructor. /* sc_record_logic */ 


  method protected static void CreateOrOverwriteRecord_Implement(
  
    /* Find or create record and fill data.
       
       With the cSvKeyFieldsAndValuesIP# parameter the where clause of the find is constructed
     */
  
    input hBufferIP#                 as handle,    
    input cSvKeyFieldsAndValuesIP#   as character,  /* veld1=a,veld2=1 */
    input cSvOtherFieldsAndValuesIP# as character,  /* idem */
    input cSeperatorIP#              as character
    ):

    define variable hField#             as handle    no-undo.
    define variable cEntry#             as character no-undo.    
    define variable cWhere#             as character no-undo.    
    define variable iTell#              as integer   no-undo.
    define variable cValue#             as character no-undo.
    define variable cSvFieldsAndValues# as character no-undo.

    do transaction on error undo, throw: /* codeQok#7103 */     

      /* Try to find the record with the given key-values */
      if length(cSvKeyFieldsAndValuesIP#) > 0 then
      do:
    
        /* Construct the where clause */
        do iTell# = 1 to num-entries(cSvKeyFieldsAndValuesIP#, cSeperatorIP#):
          
          assign
            cEntry# = entry(iTell#, cSvKeyFieldsAndValuesIP#, cSeperatorIP#)
            hField# = hBufferIP#:buffer-field(entry(1, cEntry#, "="))
            cValue# = substring(cEntry#, index(cEntry#, "=") + 1)
            cWhere# = substitute("&1 &2 &3 = &4",
                                 cWhere#,
                                 string(iTell# = 1, "where/ and"),
                                 hField#:name,
                                 (if hField#:data-type = "character" then quoter(cValue#) else cValue#) 
                                )
            .
          
        end. /* do iTell# = 1 */

        hBufferIP#:find-unique (cWhere#, exclusive-lock, no-wait) no-error. /* codeQok#7102 */

        if hBufferIP#:ambiguous then 
          undo, throw new c_panaedraexception(99913109, sc_lang:oEnglish, substitute("Key not unique (&1 &2)", hBufferIP#:table, cWhere#)).
      
      end. /* if */
      
      /* If the record is not found, create it */
      if not hBufferIP#:available then
      do:
        hBufferIP#:buffer-create().
        hBufferIP#:private-data = "new".
      end.

      cSvFieldsAndValues# = trim(substitute("&1&3&2", cSvKeyFieldsAndValuesIP#, cSvOtherFieldsAndValuesIP#, cSeperatorIP#), cSeperatorIP#).

      /* Fill the fields in the buffer */
      do iTell# = 1 to num-entries(cSvFieldsAndValues#, cSeperatorIP#) on error undo, throw:
        
        assign
          cEntry#              = entry(iTell#, cSvFieldsAndValues#, cSeperatorIP#)
          cValue#              = substring(cEntry#, index(cEntry#, "=") + 1)
          hField#              = hBufferIP#:buffer-field(entry(1, cEntry#, "="))
          hField#:buffer-value = cValue#
          .

        catch oError# as Progress.Lang.Error:
          undo, throw new c_panaedraexception(99913110,
            oError#, 
            "",
            sc_lang:oEnglish, 
            substitute("Error setting value of table &1 field &2 to '&3'", hBufferIP#:table, entry(1, cEntry#, "="), cValue#)  
            ).            
        end catch.

      end. /* do iTell# = 1 */

    end.  /* transaction */

    /* Make sure the record is available*/
    hBufferIP#:find-current(no-lock). 
      
  end method.  /* CreateOrOverwriteRecord_Implement */  


  method protected static void CreateOrOverwriteRecord_Implement(

    input hBufferIP#            as handle,    
    input cSvFieldsAndValuesIP# as character,
    input cSeperatorIP#         as character
    ):

    define variable iTell#                   as integer   no-undo.
    define variable cEntry#                  as character no-undo.    
    define variable cSvKeyFieldsAndValues#   as character no-undo.
    define variable cSvOtherFieldsAndValues# as character no-undo.

    /* Split the fieldlist in a list with primary keyfields (for constructing the where clause later) and a list with the other fields */
    do iTell# = 1 to num-entries(cSvFieldsAndValuesIP#, cSeperatorIP#):

      cEntry# = entry(iTell#, cSvFieldsAndValuesIP#, cSeperatorIP#).

      /* keys = "rowid" when there is no primary key defined */
      if length(hBufferIP#:keys) > 0 and hBufferIP#:keys <> "rowid" and lookup(entry(1, cEntry#, "="), hBufferIP#:keys) > 0 then
        cSvKeyFieldsAndValues# = cSvKeyFieldsAndValues# + cSeperatorIP# + cEntry#.
      else
        cSvOtherFieldsAndValues# = cSvOtherFieldsAndValues# + cSeperatorIP# + cEntry#.

    end.  

    assign
      cSvKeyFieldsAndValues#   = left-trim(cSvKeyFieldsAndValues#,   cSeperatorIP#)
      cSvOtherFieldsAndValues# = left-trim(cSvOtherFieldsAndValues#, cSeperatorIP#)
      .
        
    CreateOrOverwriteRecord_Implement(hBufferIP#, cSvKeyFieldsAndValues#, cSvOtherFieldsAndValues#, cSeperatorIP#). 
  
  end method.  /* CreateOrOverwriteRecord_Implement */

end class.

/* EOF */ 
