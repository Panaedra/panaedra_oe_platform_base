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


  method protected static void CreateRecord_Implement(
  
    /* Create record and fill data.
       Throws an error if the records already exists.       
    */
  
    input  hBufferIP#            as handle,    
    input  cSvFieldsAndValuesIP# as character,  /* format: veld1=a,veld2=1 */
    input  cSeperatorIP#         as character
    ):

    define variable rBuffer#            as rowid     no-undo.

    do transaction on error undo, throw: /* codeQok#7103 */     

      hBufferIP#:buffer-create().

      rBuffer# = hBufferIP#:rowid.

      SetBufferValues(hBufferIP#, cSvFieldsAndValuesIP#, cSeperatorIP#).

      /* Make sure the record is available */
      hBufferIP#:buffer-release(). /* When you skip the release it can cause problems with temp-tables */
      hBufferIP#:find-by-rowid(rBuffer#, exclusive-lock). /* codeQok#7102 */

    end.  /* transaction */
      
  end method.  /* CreateRecord_Implement */  


  method protected static void CreateRecord_Implement(
  
    input hBufferIP#            as handle,    
    input cSvFieldsAndValuesIP# as character  /* format: veld1=a,veld2=1 */
    ):

    CreateRecord_Implement(hBufferIP#, cSvFieldsAndValuesIP#, ",").
    
  end method.  /* CreateRecord_Implement | seperator = "," */  


  method protected static void CreateOrOverwriteRecord_Implement(
  
    /* Find or create record and fill data.       
       With the cSvKeyFieldsAndValuesIP# parameter the where clause of the find is constructed.
       Returns an unlocked buffer. (Even if it was locked).
    */
  
    input  hBufferIP#                 as handle,    
    input  cSvKeyFieldsAndValuesIP#   as character,  /* format: veld1=a,veld2=1 */
    input  cSvOtherFieldsAndValuesIP# as character,  /* format: veld1=a,veld2=1 */
    input  cSeperatorIP#              as character,
    input  bSaveOldValuesIP#          as logical,
    output cSvOldValuesOP#            as character   /* format: veld1=a,veld2=1 */
    ):

    define variable cSvFieldsAndValues# as character no-undo.
    define variable rBuffer#            as rowid     no-undo.

    do transaction on error undo, throw: /* codeQok#7103 */     

      /* Try to find the record with the given key-values */
      if length(cSvKeyFieldsAndValuesIP#) > 0 then
        GetUniqueRecordBuffer(hBufferIP#, cSvKeyFieldsAndValuesIP#, cSeperatorIP#).

      /* GetUniqueRecordBuffer returns an unlocked buffer therefore lock it now */
      if hBufferIP#:available then
      do:
        hBufferIP#:find-current (exclusive-lock, no-wait). /* codeQok#7102 */    
        /* Save the values of all(!) the fields in the record so we can eventual restore them later */
        if bSaveOldValuesIP# then
          cSvOldValuesOP# = GetBufferValues(hBufferIP#, cSeperatorIP#).
      end.        

      /* If the record is not found, create it */
      else
        hBufferIP#:buffer-create().

      assign
        rBuffer#            = hBufferIP#:rowid
        cSvFieldsAndValues# = trim(substitute("&1&3&2", cSvKeyFieldsAndValuesIP#, cSvOtherFieldsAndValuesIP#, cSeperatorIP#), cSeperatorIP#)
        .

      SetBufferValues(hBufferIP#, cSvFieldsAndValues#, cSeperatorIP#).

      /* Make sure the record is available */
      hBufferIP#:buffer-release(). /* When you skip the release it can cause problems with temp-tables */
      hBufferIP#:find-by-rowid(rBuffer#, exclusive-lock). /* codeQok#7102 */

    end.  /* transaction */
      
  end method.  /* CreateOrOverwriteRecord_Implement */  


  method protected static void CreateOrOverwriteRecord_Implement(

    /* Find a record and will data.
       Fields in the csv wich are key-fields are used to try to find the record 
    */

    input  hBufferIP#            as handle,    
    input  cSvFieldsAndValuesIP# as character,  /* format: veld1=a,veld2=1 */
    input  cSeperatorIP#         as character,
    input  bSaveOldValuesIP#     as logical,
    output cSvOldValuesOP#       as character   /* format: veld1=a,veld2=1 */
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
        
    CreateOrOverwriteRecord_Implement(hBufferIP#, cSvKeyFieldsAndValues#, cSvOtherFieldsAndValues#, cSeperatorIP#, bSaveOldValuesIP#, output cSvOldValuesOP#). 
  
  end method.  /* CreateOrOverwriteRecord_Implement | overload without seperate keyvalues */


  method protected static handle GetUniqueRecordBuffer(

    /* Find a (unique) record with the given key-fields and values */

    input hBufferIP#               as handle,    
    input cSvKeyFieldsAndValuesIP# as character,  /* format: veld1=a,veld2=1 */
    input cSeperatorIP#            as character  
    ):

    define variable cWhere# as character no-undo.    

    hBufferIP#:buffer-release().

    cWhere# = GetWhereClause(hBufferIP#, cSvKeyFieldsAndValuesIP#, cSeperatorIP#).

    hBufferIP#:find-unique(cWhere#, no-lock) no-error.

    if hBufferIP#:ambiguous then 
      undo, throw new c_panaedraexception(99913109, sc_lang:oEnglish, substitute("Key not unique (&1 &2)", hBufferIP#:table, cWhere#)).
  
  end method. /* GetUniqueRecordBuffer */


  method public static void SetBufferValues(
  
    input hBufferIP#            as handle,    
    input cSvFieldsAndValuesIP# as character,  /* format: veld1=a,veld2=1 */
    input cSeperatorIP#         as character
    ):

    define variable hField#    as handle    no-undo.
    define variable cEntry#    as character no-undo.    
    define variable cWhere#    as character no-undo.    
    define variable cField#    as character no-undo.
    define variable iTell#     as integer   no-undo.
    define variable cValue#    as character no-undo.
    define variable iIndex#    as integer   no-undo.
    define variable iMinIndex# as integer   no-undo.
    define variable iMaxIndex# as integer   no-undo.

    do transaction on error undo, throw: /* codeQok#7103 */     

      /* Fill the fields in the buffer */
      do iTell# = 1 to num-entries(cSvFieldsAndValuesIP#, cSeperatorIP#) on error undo, throw:
        
        assign
          cEntry#    = entry(iTell#, cSvFieldsAndValuesIP#, cSeperatorIP#)
          cField#    = entry(1, cEntry#, "=")
          iMinIndex# = 0
          iMaxIndex# = 0
          .

        cValue# = replace(substring(cEntry#, index(cEntry#, "=") + 1), chr(10), cSeperatorIP#).

        if cField# matches "*[*]" then
          assign
            iMinIndex# = int(trim(substring(cField#, index(cField#, "[")), "[]"))
            iMaxIndex# = iMinIndex#
            cField#    = substring(cField#, 1, index(cField#, "[") - 1)
            .
                    
        hField# = hBufferIP#:buffer-field(cField#).          

        /* If the field is an extent but no index is given then all entries wil get the value */
        if iMinIndex# = 0 and hField#:extent > 0 then
          assign
            iMinIndex# = 1
            iMaxIndex# = hField#:extent
            .
        
        do iIndex# = iMinIndex# to iMaxIndex#:
          SetBufferFieldValue(hField#, iIndex#, cValue#).
        end.

        catch oError# as Progress.Lang.Error:
          undo, throw new c_panaedraexception(99913110,
            oError#, 
            "",
            sc_lang:oEnglish, 
            substitute("Error setting value of table &1 field &2 to '&3' (sep=&4)", 
                       hBufferIP#:table, 
                       entry(1, cEntry#, "="), 
                       cValue#,
                       (if asc(cSeperatorIP#) < 32 then substitute("chr(&1)", asc(cSeperatorIP#)) else cSeperatorIP#) 
                      )  
            ).            
        end catch.

      end. /* do iTell# = 1 */

    end.  /* transaction */
      
  end method.  /* SetBufferValues */  


  method public static character GetBufferValues(
  
    /* Returns the values of all the fields in a buffer.
       For example: "_DATA_=1|cusnm=_TERM_UNDISCLOSED_"
       If the value of the field contains the seperator character that character is replace with chr(10).
       When the value are restored with the SetBufferValues method, chr(10) is replaced back. 
     */
  
    input hBufferIP#    as handle,    
    input cSeperatorIP# as character
    ):

    define variable cSvFieldsValues# as character no-undo.
    define variable iField#          as integer   no-undo.
    define variable hField#          as handle    no-undo.
    define variable iIndex#          as integer   no-undo.
    define variable iMinIndex#       as integer   no-undo.
    define variable iMaxIndex#       as integer   no-undo.
    define variable cValue#          as character no-undo.

    do iField# = 1 to hBufferIP#:num-fields:

      assign
        hField#    = hBufferIP#:buffer-field(iField#)
        iMinIndex# = (if hField#:extent > 0 then 1 else 0)
        iMaxIndex# = hField#:extent
        .         

      do iIndex# = iMinIndex# to iMaxIndex#:
        
        cValue# = replace(hField#:buffer-value(iIndex#), cSeperatorIP#, chr(10)).
                
        cSvFieldsValues# = cSvFieldsValues# 
                         + (if iField# > 1 then cSeperatorIP# else "")
                         + substitute("&1&2=&3", hField#:name, (if iIndex# > 0 then substitute("[&1]", iIndex#) else ""), cValue#).

      end. 

    end. /* do iField# = 1 to ... */
    
    return cSvFieldsValues#.
  
  end method. /* GetBufferValues */    


  method protected static character GetWhereClause(
    input hBufferIP#               as handle,
    input cSvKeyFieldsAndValuesIP# as character,
    input cSeperatorIP#            as character
    ):

    define variable iTell#  as integer   no-undo.
    define variable hField# as handle    no-undo.
    define variable cEntry# as character no-undo.    
    define variable cValue# as character no-undo.
    define variable cWhere# as character no-undo.

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
      
    end. /* do iTell# = 1 to ... */
  
    return cWhere#.
  
  end method. /* GetWhereClause */


  method protected static void SetBufferFieldValue(
    input hFieldIP# as handle,
    input iIndexIP# as integer,
    input cValueIP# as character
    ):

    case hFieldIP#:data-type:
      
      when "data" or when "datetime" or when "datetime-tz" then
      do:

        case cValueIP#:

          when "today" then
            hFieldIP#:buffer-value(iIndexIP#) = today.

          when "now" then
            hFieldIP#:buffer-value(iIndexIP#) = now.

          otherwise  
            hFieldIP#:buffer-value(iIndexIP#) = cValueIP#.
                     
        end case.
        
      end.
      
      otherwise  
        hFieldIP#:buffer-value(iIndexIP#) = cValueIP#.

    end case.
    
  end method. /* SetBufferFieldValue */

end class.

/* EOF */ 
