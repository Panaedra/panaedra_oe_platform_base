{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_dataset_xml: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_dataset_xml.cls $ 
          Version: $Revision: 5 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-03-31 10:21:37+02:00 $ 
    Date Modified: $Modtime: 2010-03-31 09:38:21+02:00 $ 

      Description: Functionality to read and write between datasets and xml

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_dataset_xml(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 5 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  constructor protected sc_dataset_xml(
    input oParamIP# as i_unittest_param):
  end constructor.  
  
  method public static void WriteXmlAndSplit(
    hDatasetIP#    as handle,
    iBatchSizeIP#  as integer,
    cOutputFileIP# as character):

    define variable hSplitDataset#  as handle  no-undo.
    define variable iIteration#     as integer no-undo.
    define variable iSplit#         as integer no-undo.
    
    define variable hTopQuery#      as handle  no-undo.
    define variable hChildQuery#    as handle  no-undo.
    define variable hSplitRelation# as handle  no-undo.
    define variable bCreateParent#  as logical no-undo.
    
    if iBatchSizeIP# = ? or iBatchSizeIP# <= 0 then 
    do:
      WriteXmlAndSplit_Sub(hDatasetIP#, cOutputFileIP#, 0).
    end.
    else 
    do:  
    
      create dataset hSplitDataset#.
      hSplitDataset#:create-like(hDatasetIP#).
    
      assign
        hSplitDataset#:namespace-uri                = hDatasetIP#:namespace-uri
        hSplitDataset#:xml-node-name                = hDatasetIP#:xml-node-name
        hTopQuery#                                  = hDatasetIP#:top-nav-query(1)       /* For now, we only support the first top-nav-query */
        hChildQuery#                                = hDatasetIP#:get-relation(1):query  /* For now, we only support one data-relation       */
        hSplitRelation#                             = hSplitDataset#:get-relation(1)     /* For now, we only support one data-relation       */
        hSplitRelation#:parent-buffer:xml-node-name = hTopQuery#:get-buffer-handle(1):xml-node-name
        hSplitRelation#:child-buffer:xml-node-name  = hChildQuery#:get-buffer-handle(1):xml-node-name
        .
      
      assign
        iSplit# = 1.
    
      hTopQuery#:query-open().
    
      do while hTopQuery#:get-next:
        
        bCreateParent# = true.
        hChildQuery#:query-open().
      
        do while hChildQuery#:get-next:
        
          if bCreateParent# then 
          do:
            bCreateParent# = false.
            hSplitRelation#:parent-buffer:buffer-create.
            hSplitRelation#:parent-buffer:buffer-copy(hTopQuery#:get-buffer-handle(1)).
          end.
        
          hSplitRelation#:child-buffer:buffer-create.
          hSplitRelation#:child-buffer:buffer-copy(hChildQuery#:get-buffer-handle(1)).
        
          iIteration# = iIteration# + 1.
        
          if iIteration# mod iBatchSizeIP# = 0 then 
          do:
            WriteXmlAndSplit_Sub(hSplitDataset#, cOutputFileIP#, iSplit#).
            hSplitDataset#:empty-dataset().
            assign
              bCreateParent# = true
              iSplit#        = iSplit# + 1.
          end.
        
        end. /* while hChildQuery#:get-next */
      
      end. /* while hTopQuery#:get-next */
    
      /* Write remaining records to file */
      if iIteration# > 0 and (iIteration# mod iBatchSizeIP#) <> 0 
        then WriteXmlAndSplit_Sub(hSplitDataset#, cOutputFileIP#, iSplit#).
      
    end. /* batchsize > 0 */
              
    finally:
      if valid-handle(hSplitDataset#) then delete object hSplitDataset#.
    end finally.
              
  end method. /* WriteXmlAndSplit */
  
  
  method protected static void WriteXmlAndSplit_Sub(hDatasetIP# as handle, cOutputFileIP# as character, iSplitIP# as integer):
    
    define variable iIndex#    as integer   no-undo.
    define variable cTempfile# as character no-undo.
    
    
    if iSplitIP# > 0 then 
      assign
        iIndex#                             = r-index(cOutputFileIP#, ".")
        substring(cOutputFileIP#,iIndex#,1) = subst("_&1.", trim(string(iSplitIP#, ">>>>99999"))).
    
    cTempfile# = cOutputFileIP# + ".working".
     
    hDatasetIP#:write-xml(
      "File",  /* mode */
      cTempfile#, /* file */
      yes,     /* formatted */
      "utf-8", /* encoding */
      "",      /* schema location */
      no,      /* write xml schema */
      no,      /* min-xmlschema */
      no,      /* write-before-image */
      no       /* omit initial values */
      ).
      
    sc_osfile:SafeFileMoveThrow(cTempfile#, cOutputFileIP#, false).  
        
  end method. /* WriteXmlAndSplit_Sub */  
  
  
  method public static void WriteXmlFile(
    
    /* Write a dataset to an xml-file,
       into the same format as the write-xml ABL method, 
       but support changes on the internal queries prepare strings.
       
    */
    
    hDatasetIP# as handle, 
    cFileIP# as character):  
      
    sc_xml_sax:sys__DatasetToXmlFile(hDatasetIP#, cFileIP#).      
      
  end method. /* WriteXmlFile */
  
  
  method public static character CsvNodenamesGet(
    hDsIP# as handle):
    
    define variable iTell#        as integer   no-undo.
    define variable cSvNodenames# as character no-undo.
      
    do iTell# = 1 to hDsIP#:num-buffers:
      
      cSvNodenames# = cSvNodenames# + subst(",&1|&2",
      
        hDsIP#:get-buffer-handle(iTell#):name,
        hDsIP#:get-buffer-handle(iTell#):xml-node-name
        ).
      
    end.
    
    return substring(cSvNodenames#,2).
    
  end method. /* GetCsvNodenames */
  
  
  method public static void CsvNodenamesApply(
    hDsIP#          as handle,
    cSvNodenamesIP# as character):
    
    define variable iTell#      as integer   no-undo.
    define variable cEntry#     as character no-undo.  
    define variable cNodename#  as character no-undo.
    define variable cTablename# as character no-undo.
    
    do iTell# = 1 to num-entries(cSvNodenamesIP#):
      
      assign
        cEntry#     = entry(iTell#, cSvNodenamesIP#)
        cTablename# = entry(1, cEntry#, "|")
        cNodename#  = entry(2, cEntry#, "|")
        .
      
      hDsIP#:get-buffer-handle(cTablename#):xml-node-name = cNodename#. 
      
    end.
    
  end method. /* GetCsvNodenames */

  
  method public static void CopyNodenames( 
    hDsFromIP# as handle,
    hDsToIP#   as handle
    ):

    CsvNodenamesApply(hDsToIP#,CsvNodenamesGet(hDsFromIP#)).
  
  end method. /* CopyNodenames */
  
  @panaedraannotation file(unittest="yes").
  method public static void SetBufferFieldXmlNodeTypeByCsv(
  
    input hDsIP#          as handle, 
    input cTablenameIP#   as character, 
    input cSvFieldnameIP# as character,
    input cNodeTypeIP#    as character
    ):
  
    define variable iFieldname# as integer no-undo.      
   
    do iFieldname# = 1 to num-entries(cSvFieldNameIP#):   
      hDsIP#:get-buffer-handle(cTablenameIP#):buffer-field(entry(iFieldname#, cSvFieldnameIP#)):xml-node-type = cNodeTypeIP#.
    end. 
  
  end method. /* SetBufferFieldXMLNoteTypeByCSV */

end class.

/* EOF */ 
