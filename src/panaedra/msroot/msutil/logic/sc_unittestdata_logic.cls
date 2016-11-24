using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_unittestdata_logic 
  inherits panaedra.msroot.msutil.logic.sc_record_logic: 

  /****************************** Source Header ********************************\

      Description: Helper methods to maintain data for unittests. 

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  method public static void CreateOrOverwriteRecord(

    /* sc_ttrecord_u:CreateOrOverwriteRecord(temp-table ttTmp:handle, "amgcd=1;amgcdkg=TST1", ";"). */

    input hTableIP#             as handle,  
    input cSvFieldsAndValuesIP# as character,
    input cSeperatorIP#         as character
    ):

    define variable cDummy# as character no-undo.

    CreateOrOverwriteRecord_Implement(hTableIP#:default-buffer-handle, cSvFieldsAndValuesIP#, cSeperatorIP#, false, cDummy#). 
  
  end method.  /* CreateOrOverwriteRecord | temp-table handle, field-value pair csv, seperator */


  method public static void CreateOrOverwriteRecord(

    /* sc_ttrecord_u:CreateOrOverwriteRecord(temp-table ttTmp:handle, "amgcd=1;amgcdkg=TST1"). */

    input hTableIP#             as handle,  
    input cSvFieldsAndValuesIP# as character
    ):

    CreateOrOverwriteRecord(hTableIP#, cSvFieldsAndValuesIP#, ","). 
  
  end method.  /* CreateOrOverwriteRecord | temp-table handle, field-value pair csv, seperator = "," */
    
end class.

/* EOF */ 
