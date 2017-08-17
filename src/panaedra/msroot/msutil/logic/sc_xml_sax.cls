using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_xml_sax: 

  /******************************  Source Header ********************************\

      Description: XML SAX helper methods

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
    

  method public static logical WriteSaxXmlFileWithoutRoot(
    /* ----------------------------------------
       write dataset to xml without root node.
       ---------------------------------------- */
    hDatasetIP# as handle, 
    cFileIP# as character):  
      
    sys__DatasetToXmlFileImplement(hDatasetIP#, cFileIP#, no).  
  
  end method. /* WriteXmlFileWithoutRoot */
  

  method public static void sys__DatasetToXmlFile(
    
    /* Write a dataset to an xml-file,
       into the same format as the write-xml ABL method, 
       but support changes on the internal queries prepare strings.
       
       This is a "sys__"  method, use sc_dataset_xml:WriteXmlFile (so that
        sc_dataset_xml can choose the technical implementation 'black box')   */
    
    hDatasetIP# as handle, 
    cFileIP# as character):
      
    sys__DatasetToXmlFileImplement(hDatasetIP#, cFileIP#, yes).  
      
  end method.  
  
  
  method public static void DbQueryToXmlFile(
    hQueryIP# as handle, 
    cFileIP# as character,
    bWithRootNodeIP# as logical
  
    ):
    
    sys__DatasetToXmlFileImplement(hQueryIP#, cFileIP#, bWithRootNodeIP#).
    
  end method. /* DbQueryToXmlFile */


  method protected static void sys__DatasetToXmlFileImplement(
    
    /* Write a dataset to an xml-file,
       into the same format as the write-xml ABL method, 
       but support changes on the internal queries prepare strings.
       
       This is a "sys__"  method, use sc_dataset_xml:WriteXmlFile (so that
        sc_dataset_xml can choose the technical implementation 'black box')
       
    */
    
    hDatasetOrQueryIP# as handle, 
    cFileIP# as character,
    bWithRootNodeIP# as logical):
    
    define variable hSax#       as handle  no-undo.
    define variable hBuff#      as handle  no-undo.
    define variable iField#     as integer no-undo.
    define variable bHasChilds# as logical no-undo.
    define variable hAttrib#    as handle  no-undo.
    define variable hQuery#     as handle  no-undo.
    define variable hDataSet#   as handle  no-undo.
    
    create sax-writer  hSax#.
  
    hSax#:formatted = true.
    hSax#:strict    = true.
  
    hSax#:set-output-destination ("file", cFileIP#).
    hSax#:encoding = "utf-8".
  
    hSax#:start-document().
    
    if hDatasetOrQueryIP#:type = "dataset"
      then 
    do:
      hDataset# = hDatasetOrQueryIP#.
      /* Note: 
         For now, we only support 1 top-buffer query. Can easily be extended. 
      */
      hQuery# = hDataset#:top-nav-query(1).
    end.
    else if hDatasetOrQueryIP#:type = "query"
        then hQuery# = hDatasetOrQueryIP#.
  
    if bWithRootNodeIP# then 
    do: 
      hSax#:start-element(if valid-handle(hDataset#) then hDataset#:xml-node-name else "ds" + hQuery#:get-buffer-handle(1):name).
  
      if valid-handle(hDataset#) and hDataset#:namespace-uri > "" then 
      do:
        hSax#:declare-namespace(hDataset#:namespace-uri, "").
      end.
      
      hSax#:declare-namespace("http://www.w3.org/2001/XMLSchema-instance", "xsi").
    end.
    
    hQuery#:query-open().
    
    do while hQuery#:get-next:
      hBuff# = hQuery#:get-buffer-handle(1).
      if valid-handle(hDataset#) then
        bHasChilds# = DatasetBufferHasChildRelation(hDataset#, hBuff#).
      else
        bHasChilds# = hQuery#:num-buffers > 1.
      
      hSax#:start-element(hBuff#:xml-node-name).
      if not bHasChilds# then 
      do:
        hAttrib# = GetSaxAttributesFromBuffer(hBuff#).
        hSax#:write-empty-element(hBuff#:xml-node-name, "", hAttrib#).
        delete object hAttrib#.
      end.
      else
      do iField# = 1 to hBuff#:num-fields:
        WriteSaxBufferField(hSax#, hBuff#:buffer-field(iField#)).
      end.
      if valid-handle(hDataset#) then
        WriteSaxXmlDsrelations(hSax#, hDataset#, hBuff#).
      hSax#:end-element(hQuery#:get-buffer-handle(1):xml-node-name).
    end.

    if bWithRootNodeIP# then
      hSax#:end-element( if valid-handle(hDataset#) then hDataset#:xml-node-name else  "ds" + hQuery#:get-buffer-handle(1):name).
    
    hSax#:end-document().
    
    finally:
      if valid-handle(hSax#) then delete object hSax#.
    end finally.
  
  end method. /* sys__DatasetToXmlFile */
  
  
  method protected static void WriteSaxXmlDsrelations(hSaxIP# as handle, hDatasetIP# as handle, hParentBuffIP# as handle):

    define variable iRelation#  as integer no-undo.
    define variable hRelation#  as handle  no-undo.
    define variable iField#     as integer no-undo.
    define variable bHasChilds# as logical no-undo.
    define variable hAttrib#    as handle  no-undo.

    do iRelation# = 1 to hDatasetIP#:num-relations:
      hRelation# = hDatasetIP#:get-relation(iRelation#).
      if hRelation#:parent-buffer:name = hParentBuffIP#:name then 
      do:
        bHasChilds# = DatasetBufferHasChildRelation(hDatasetIP#, hRelation#:child-buffer).
        hRelation#:query:query-open().
        do while hRelation#:query:get-next():
          if not bHasChilds# then 
          do:
            hAttrib# = GetSaxAttributesFromBuffer(hRelation#:child-buffer).
            hSaxIP#:write-empty-element(hRelation#:child-buffer:xml-node-name, "", hAttrib#).
            delete object hAttrib#.
          end.
          else 
          do:
            hSaxIP#:start-element(hRelation#:child-buffer:xml-node-name).
            do iField# = 1 to hRelation#:child-buffer:num-fields:
              WriteSaxBufferField(hSaxIP#, hRelation#:child-buffer:buffer-field(iField#)).
            end.
            WriteSaxXmlDsrelations(hSaxIP#, hDatasetIP#, hRelation#:child-buffer).
            hSaxIP#:end-element(hRelation#:child-buffer:xml-node-name).
          end.
        end.
      end.
    end.
  
  end method. /* WriteSaxXmlDsrelations */
  
  
  method public static void WriteSaxBufferField(hSaxIP# as handle, hFieldIP# as handle):
    
    case hFieldIP#:xml-node-type:
      
      when "attribute" then 
        InsertAttribute(hSaxIP#, hFieldIP#, sc_bufferfield:IsoString(hFieldIP#), false /* SkipUnknown */, false /* SkipEmpty */).
      
      when "hidden"    then.
      
      otherwise hSaxIP#:write-data-element(hFieldIP#:xml-node-name, sc_bufferfield:IsoString(hFieldIP#)).
    end.
    
  end method. /* WriteSaxBufferField */
  

  method public static void InsertAttribute(
    hSaxIP#         as handle, 
    hFieldIP#       as handle, 
    cValueIP#       as character, 
    bSkipUnknownIP# as logical,
    bSkipEmptyIP#   as logical):
    
    if bSkipUnknownIP# and cValueIP# = ? then .
    else if bSkipEmptyIP# and trim(cValueIP#) = "" then .
      else
      do:
    
        if cValueIP# = ? then
          cValueIP# = "".
        
        hSaxIP#:insert-attribute(hFieldIP#:xml-node-name, cValueIP#).
    
      end.
    
  end method. /* InsertAttribute */  
  
  
  method protected static logical DatasetBufferHasChildRelation(hDatasetIP# as handle, hParentBuffIP# as handle):
    
    define variable iRelation# as integer no-undo.
    define variable hRelation# as handle  no-undo.
    define variable iField#    as integer no-undo.

    do iRelation# = 1 to hDatasetIP#:num-relations:
      hRelation# = hDatasetIP#:get-relation(iRelation#).
      if hRelation#:parent-buffer:name = hParentBuffIP#:name then 
        return true.
      do iField# = 1 to hRelation#:child-buffer:num-fields:
        case hRelation#:child-buffer:buffer-field(iField#):xml-node-type:
          when "attribute" or
          when "hidden"    then.
          otherwise 
          return true.
        end.
      end.
    end.
    
    return false.
  
  end method. /* DatasetBufferHasChildRelation */
  
  
  method public static handle GetSaxAttributesFromBuffer(hBuffIP# as handle):
    
    define variable hAttrib# as handle  no-undo.
    define variable iField#  as integer no-undo.
    define variable hField#  as handle  no-undo.
    
    create sax-attributes hAttrib#. 
    
    do iField# = 1 to hBuffIP#:num-fields:
      hField# = hBuffIP#:buffer-field(iField#).
      if hField#:xml-node-type = "attribute" then
        hAttrib#:insert-attribute(hField#:xml-node-name, sc_bufferfield:IsoString(hField#)).
    end.
    
    return hAttrib#.
    
  end method. /* GetSaxAttributesFromBuffer */
  

end class.

/* EOF */ 
