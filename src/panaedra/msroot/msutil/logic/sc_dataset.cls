using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_dataset: 

  /****************************** Source Header ********************************\

      Description: Entry points for generic dataset functionality

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method public static logical IsDataSetEmpty(
    
    /* Determine if every (temp-)table in this dataset is empty.
    
       If it's not important that you loose the rowid's of buffers
       in the dataset, use true for bUseDsBuffersIP#.
       Otherwise, use false, so temporary buffers are created 
       and destroyed inside this method.
     */
    
    input hDataSetIP#      as handle,
    input bUseDsBuffersIP# as logical):
      
    return sc_data_analysis:IsDataSetEmpty(
      hDataSetIP#,    
      bUseDsBuffersIP#).  
      
  end method. /* IsDataSetEmpty */
  
  
  method public static logical DatasetCompare(
    
    /* Compare the complete contents of two datasets.
       We do an xml comparison and a json comparison.
       We could implement a query-parsing buffer-compare comparison later.
     */
  
    dataset-handle hDatasetOneIP#, 
    dataset-handle hDatasetTwoIP#):
      
    return sc_data_analysis:DatasetCompare(
      dataset-handle hDatasetOneIP# by-reference, 
      dataset-handle hDatasetTwoIP# by-reference).  
    
    finally:
      /* Parameter cleanup */
      delete object hDatasetOneIP# no-error. /* by-ref/not : no other way than no-error */
      delete object hDatasetTwoIP# no-error. /* by-ref/not : no other way than no-error */  
    end finally.
    
  end method. /* DatasetCompare */
  
  
  method public static character FieldAttr_i18n(
    /* Internationalized version of FieldAttr
       supports Html special characters and symbols
       ex: &amp;  &gt;  &eacute; 
       see: http://www.ascii.cl/htmlcodes.htm */
  
    cAttrIP#        as char,
    hFieldHandleIP# as handle,
    hFieldIP#       as handle):
      
    define variable cReturn# as character no-undo.
    
    cReturn# = FieldAttrImplement(
      cAttrIP#,
      hFieldHandleIP#,
      hFieldIP#       
      ).
      
    cReturn# = sc_html_convert:ConvertFromHtml(cReturn#).    
      
    return cReturn#.  
  
  end method. /* FieldAttr_i18n */
  

  method public static character FieldAttr(
  
    /* Helper method, see if a field handle attribute (like 'label' or 'format') is overruled.  */
    cAttrIP#        as char,
    hFieldHandleIP# as handle,
    hFieldIP#       as handle):
      
    define variable cReturn# as character no-undo.
    
    cReturn# = FieldAttrImplement(
      cAttrIP#,
      hFieldHandleIP#,
      hFieldIP#       
      ).  
      
    return cReturn#.  
  
  end method. /* FieldAttr */
  
  
  method protected static character FieldAttrImplement(
  
    /* Helper method, see if a field handle attribute (like 'label' or 'format') is overruled.  */
    
    cAttrIP#        as char,
    hFieldHandleIP# as handle,
    hFieldIP#       as handle):

    def var cValue#  as char no-undo.
    def var cReturn# as char no-undo.
   
   &scop cWhen ~
   when "~{~&cAttr~}" then do: ~
     if hFieldHandleIP# = ? ~
       then cReturn# = hFieldIP#:~{~&cAttr~}. ~
     else do: ~
       if (hFieldHandleIP#:~{~&cAttr~} <> ? or ~
          (hFieldHandleIP#:help <> ? and ~
           index(hFieldHandleIP#:help,"[~{~&cAttr~}]") > 0)) ~
       then do: ~
         if not can-do("data-type,format", cAttrIP#) ~
           and hFieldHandleIP#:~{~&cAttr~} > "" /* codeQok#7122 */ ~
           and not (can-do("label,column-label",cAttrIP#) ~
                    and hFieldHandleIP#:~{~&cAttr~} = hFieldHandleIP#:name) ~
           then cReturn# = hFieldHandleIP#:~{~&cAttr~}. ~
         else do: ~
           cValue# = sc_string_csv:GetParam(hFieldHandleIP#:help,cAttrIP#). ~
           if cValue# = ? or cValue# = "" ~
             then cReturn# = hFieldIP#:~{~&cAttr~}. ~
           else ~
             cReturn# = cValue#. ~
         end. ~
       end. ~
       else ~
         cReturn# = hFieldIP#:~{~&cAttr~}. ~
     end. ~
     return cReturn#. ~
   end. 

    case cAttrIP#:
     &scop cAttr label
      {&cWhen}
     &scop cAttr column-label
      {&cWhen}
     &scop cAttr format
      {&cWhen}
     &scop cAttr name
      {&cWhen}
     &scop cAttr private-data
      {&cWhen}
     &scop cAttr data-type
      {&cWhen}
    end  case.
   
    return "???".
  
  end method. /* FieldAttr */
 
 
  method public static void FieldHandlesFromQuery(
  
   /* This method walks through the buffers of the query,
      and puts the field handles in correspondingly named fields
      of the abstraction/reporting temp-table.
    */

    input hQueryIP# as handle,
    input hBuffIP#  as handle
    ):

  
    def var iTell#      as int    no-undo.
    def var hField#     as handle no-undo.
  
    def var iBuff#      as int    no-undo.
    def var hBuffQuery# as handle no-undo.
    def var iTellBuff#  as int    no-undo.
    def var hFieldBuff# as handle no-undo.
    def var cBuffer#    as char   no-undo.
    def var cField#     as char   no-undo.
  
    if not valid-handle(hQueryIP#) or not valid-handle(hBuffIP#) then 
    do:
      sc_messagebox:Show(sc_messageboxtype:AsAlertbox, substitute("&1~n&2~nError: Incorrect use of this method.",program-name(1),program-name(2))).
      return error.
    end.
  
    if not hBuffIP#:available then 
    do:
      sc_messagebox:Show(sc_messageboxtype:AsAlertbox, substitute("&1 Error: The buffer has to be available.",program-name(1))).
      return.
    end.
    do iTell# = 1 to hBuffIP#:num-fields:
      hField# = hBuffIP#:buffer-field(iTell#).
      if hField#:data-type = "handle" /*and hField#:buffer-value = ? 
      /* Workaround for Progress 9.1E bug;
         Define a temp-table no-undo + rcodeinfo.
         Define directly below that a temp-table no-undo *like the first* + rcodeinfo.
         Fields type "handle" of the second temp-table have initial values of 0, first temp-table has initial values of ?.
         Weird.
       */
      or hField#:buffer-value = 0 */ then 
      FillTtField:
      do:
      
        /* First reset handle fields to unknown value */
        hField#:buffer-value = ?. 
      
        /* Fields can be customized to pick a specific buffer.*/
        cBuffer# = sc_string_csv:GetParam(hField#:help,"buffer").
        if cBuffer# = ? then cBuffer# = "".
      
        cField# = hField#:name.
        cField# = sc_string_csv:GetParam(hField#:help,"field").
       
        if cField# = ? or cField# = "" 
          then cField# = hField#:name.

        do iBuff# = 1 to hQueryIP#:num-buffers:
          hBuffQuery# = hQueryIP#:get-buffer-handle(iBuff#).
          if cBuffer# > "" and  hBuffQuery#:name <> cBuffer# then next.
          do iTellBuff# = 1 to hBuffQuery#:num-fields:
            hFieldBuff# = hBuffQuery#:buffer-field(iTellBuff#).
            if hFieldBuff#:name = cField# then 
            do:
              hField#:buffer-value = hFieldBuff#.
              leave FillTtField.
            end.
          end. 
        end.
      end.
    end.
  
  end method. /* FieldHandlesFromQuery */
 
end class.

/* EOF */ 
