using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_data_analysis   : 

  /****************************** Source Header ********************************\

      Description: Analyze contents of a (temp-)table or (temp-)table buffer.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/


  method public static logical IsRecordEmpty(
    
    /* Check for empty record; meaning equal to its initial values.
    */

    hBufferIP# as handle):
      
    return IsRecordEmpty(hBufferIP#, "", false).
    
  end method. /* IsRecordEmpty  */
  
  
  method public static logical IsRecordEmpty(
  
    /* Check for empty record; meaning equal to its initial values. Ignore certains fields.
    */

    hBufferIP#          as handle, 
    cSvExcludeFieldsIP# as character):
  
    return IsRecordEmpty(hBufferIP#, cSvExcludeFieldsIP#, false).
  
  end method. /* IsRecordEmpty ; buffer handle + cSvExcludeFieldsIP# */
  

  method public static logical IsRecordEmpty(
  
    /* Check for empty record; meaning equal to its initial values. Ignore certains fields, trim char/longchar before compare.
    */
  
    hBufferIP#          as handle, 
    cSvExcludeFieldsIP# as character, 
    bTrimIP#            as logical):

    /* ShouldHave: Support extra data-types in IsRecordEmpty
       Summary: 
       - Progress.Lang.Object 
       - com-handle 
       - date 
       - datetime 
       - datetime-tz
       - handle 
       - int64 
       - logical
       - longchar + trim
       - memptr
       - blob
       - clob
       - raw 
       - recid          codeQok#7127
       - rowid 
    */
    
    define variable hField#     as handle    no-undo.
    define variable iFieldNr#   as integer   no-undo.
    define variable bEmpty#     as logical   no-undo initial true.
    define variable cDataType#  as character no-undo.
    define variable iExtent#    as integer   no-undo.
    define variable cDataValue# as character no-undo.
    
    if hBufferIP# <> ? then 
    do:
      
      if not hBufferIP#:available then bEmpty# = ?.
      else
      /* Walk through fields */
      b_LoopDoorVelden:
      do iFieldNr# = 1 to hBufferIP#:num-fields:
        
        hField# = hBufferIP#:buffer-field(iFieldNr#).
        
        /* Check exclude field */
        if lookup(hField#:name, cSvExcludeFieldsIP#) = 0 then
        do:
          
          /* Walk extent (or 0 to 0) */
          do iExtent# = 
            (if hField#:extent = 0 then 0 else 1) to 
            (if hField#:extent = 0 then 0 else hField#:extent):
          
            cDataType# = hField#:data-type.
                   
            case cDataType#:
        
              when "character" then
                do:
                  cDataValue# = if bTrimIP# then trim(hField#:buffer-value[iExtent#]) else hField#:buffer-value[iExtent#].
                  
                  if 
                    (cDataValue# = ? and hField#:initial = ?) 
                    or 
                    (cDataValue# = hField#:initial) then
                    . /* Ok, no action. */
                  else  
                    bEmpty# = false.
                    
                end. /* character */  
      
              when "integer" then
                do:
                  if 
                    (hField#:buffer-value[iExtent#] = ? and int(hField#:initial) = ?) 
                    or
                    hField#:buffer-value[iExtent#] = int(hField#:initial) then
                    . /* Ok, no action. */
                  else
                    bEmpty# = false.
                    
                end. /* integer */  
      
              when "decimal" then
                do:
                  if 
                    (hField#:buffer-value[iExtent#] = ? and dec(hField#:initial) = ?) 
                    or
                    hField#:buffer-value[iExtent#] = dec(hField#:initial) then
                    . /* Ok, no action. */
                  else
                    bEmpty# = false.
                    
                end. /* decimal */  
      
              otherwise 
              do:
                undo, throw new c_panaedraexception(
                  99968211,
                  sc_lang:oEnglish,
                  subst("No support for datatype '&1' (yet).", hField#:data-type)).
                
              end. /* otherwise ; unknown datatype */  
      
            end case. /* cDataType# */
      
            /* Stop at first conflict */
            if bEmpty# = false then 
              leave b_LoopDoorVelden.
      
          end. /* do iExtent# = */   
      
        end. /* lookup(hField#:name, cSvExcludeFieldsIP#) = 0 */ 
    
      end. /* buffer is available; iFieldNr# = 1 to hBufferIP#:num-fields */
    
      return bEmpty#.
    
    end. /* if hBufferIP# <> ? */
    else
      return ?.
    
  end method. /* IsRecordEmpty ; buffer handle + cSvExcludeFieldsIP# + bTrimIP# */


  method public static logical IsDataSetEmpty(
    
    /* Determine if every (temp-)table in this dataset is empty. */
    
    input hDataSetIP#          as handle):
      
    return IsDataSetEmpty(hDataSetIP#, true /* Use dataset buffers, the quickest method */).  
  
  end method. /* IsDataSetEmpty ; dataset */
  
  
  method public static logical IsDataSetEmpty(
    
    /* Determine if every (temp-)table in this dataset is empty.
    
       If it's not important that you loose the rowid's of buffers
       in the dataset, use true for bUseDsBuffersIP#.
       Otherwise, use false, so temporary buffers are created 
       and destroyed inside this method.
     */
    
    input hDataSetIP#      as handle,
    input bUseDsBuffersIP# as logical):
    
    define variable iBuff#            as integer no-undo.
    define variable hBuff#            as handle  no-undo.
    define variable hBuffNew#         as handle  no-undo.
    define variable hBuffBefore#      as handle  no-undo.
    define variable hTtBefore#        as handle  no-undo.
    define variable bBuffFound#       as logical no-undo.
    define variable bBuffBeforeFound# as logical no-undo.
    define variable bIsEmpty#         as logical no-undo initial true.
    
    /* Check for every (temp-)table is there is data available */
    b_each_buff:
    do iBuff# = 1 to hDataSetIP#:num-buffers on error undo, throw:
      
      assign
        bBuffFound#       = true
        bBuffBeforeFound# = true.
      
      /* Get (temp-)table buffer handle */
      hBuff# = hDataSetIP#:get-buffer-handle(iBuff#).
      
      /* First the normal buffer */
      if not bUseDsBuffersIP# then create buffer hBuffNew# for table hBuff# buffer-name hBuff#:name.
      else hBuffNew# = hBuff#.
      
      hBuffNew#:find-first("", no-lock) no-error.
      if error-status:get-number(1) = 565 /* Normal error "find first/last failed for table x." */
        then bBuffFound# = false.      
      else 
      do:
        if error-status:num-messages > 0 then
          undo, throw new AppError(
            substitute("&1~n&2", 
            error-status:get-message(1), 
            "Unexpected find-first error in IsDataSetEmpty"),
            error-status:get-number(1)).  
      end.      
      
      /* Then the before-table buffer */
      hTtBefore# = hBuff#:table-handle:before-table.
      if hTtBefore# = ? then bBuffBeforeFound# = false.
      else 
      do:
        hBuffBefore# = hTtBefore#:default-buffer-handle.
        hBuffBefore#:find-first("", no-lock) no-error.
        if error-status:get-number(1) = 565 /* Normal error "find first/last failed for table x." */
          then bBuffBeforeFound# = false.      
        else 
        do:
          if error-status:num-messages > 0 then
            undo, throw new AppError(
              substitute("&1~n&2", 
              error-status:get-message(1), 
              "Unexpected find-first before-table error in IsDataSetEmpty"),
              error-status:get-number(1)).  
        end.      
      end.
      
      /* If there is a record available then dataset is not empty */
      if bBuffFound# or bBuffBeforeFound# then
      do:
        bIsEmpty# = false.  
        leave b_each_buff.        
      end.
      
      finally:
        if (not bUseDsBuffersIP#) and valid-handle(hBuffNew#) then delete object hBuffNew#.
      end finally.
      
    end. /* b_each_buff */
    
    return bIsEmpty#.
    
  end method. /* IsDataSetEmpty ; dataset + logical */
  

  method public static logical DatasetCompare(
    
    /* Compare the complete contents of two datasets.
       We do an xml comparison and a json comparison.
       We could implement a query-parsing buffer-compare comparison later.
     */
  
    dataset-handle hDatasetOneIP#, 
    dataset-handle hDatasetTwoIP#):
      
    define variable bXmlOne# as longchar no-undo.  
    define variable bXmlTwo# as longchar no-undo.
    define variable bJsonOne# as longchar no-undo.  
    define variable bJsonTwo# as longchar no-undo.
    
    hDatasetOneIP#:write-xml("longchar", bXmlOne#, true, "utf-8").  
    hDatasetTwoIP#:write-xml("longchar", bXmlTwo#, true, "utf-8").
    
    if bXmlOne# <> bXmlTwo# then return false.  

    hDatasetOneIP#:write-json("longchar", bJsonOne#, true, "utf-8").  
    hDatasetTwoIP#:write-json("longchar", bJsonTwo#, true, "utf-8").
    
    if bJsonOne# <> bJsonTwo# then return false.  
    
    return true.
    
    finally:
      /* Parameter cleanup */
      delete object hDatasetOneIP# no-error. /* by-ref/not : no other way than no-error */
      delete object hDatasetTwoIP# no-error. /* by-ref/not : no other way than no-error */
    end finally.

  end method. /* DatasetCompare */  

end class.

/* EOF */
