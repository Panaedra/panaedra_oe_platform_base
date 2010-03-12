{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_dataset_xml   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_dataset_xml.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-03-12 10:37:00+01:00 $ 
    Date Modified: $Modtime: 2010-03-12 10:35:59+01:00 $ 

      Description: Functionality to read and write between datasets and xml

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_dataset_xml(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
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
    
    create dataset hSplitDataset#.
    hSplitDataset#:create-like(hDatasetIP#).
    
    assign
      hSplitDataset#:namespace-uri                = hDatasetIP#:namespace-uri
      hSplitDataset#:xml-node-name                = hDatasetIP#:xml-node-name
      hSplitRelation#                             = hDatasetIP#:get-relation(1)  /* For now, we only support one data-relation       */
      hTopQuery#                                  = hDatasetIP#:top-nav-query(1) /* For now, we only support the first top-nav-query */
      hChildQuery#                                = hSplitRelation#:query  
      hSplitRelation#:parent-buffer:xml-node-name = hTopQuery#:get-buffer-handle(1):xml-node-name
      hSplitRelation#:child-buffer:xml-node-name  = hChildQuery#:get-buffer-handle(1):xml-node-name
      .
      
    iSplit# = 1.
    
    hTopQuery#:query-open().
    
    do while hTopQuery#:get-next:
      
      hChildQuery#:query-open().
      
      do while hChildQuery#:get-next:
        
        if not hSplitRelation#:parent-buffer:available then 
        do:
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
          iSplit# = iSplit# + 1.
        end.
        
      end. /* while hChildQuery#:get-next */
      
    end. /* while hTopQuery#:get-next */
    
    /* Write remaining records to file */
    if iIteration# > 0 and (iIteration# mod iBatchSizeIP#) <> 0 
      then WriteXmlAndSplit_Sub(hSplitDataset#, cOutputFileIP#, iSplit#).
              
    finally:
      if valid-handle(hSplitDataset#) then delete object hSplitDataset#.
    end finally.
              
  end method. /* WriteXmlAndSplit */
  
  
  method protected static void WriteXmlAndSplit_Sub(hDatasetIP# as handle, cOutputFileIP# as character, iSplitIP# as integer):
    
    define variable iIndex# as integer no-undo.
    
    assign
      iIndex#                             = r-index(cOutputFileIP#, ".")
      substring(cOutputFileIP#,iIndex#,1) = subst("_&1.", trim(string(iSplitIP#, ">>>>99999"))).
    
    hDatasetIP#:write-xml(
      "File", /* mode */
      cOutputFileIP#, /* file */
      yes,     /* formatted */
      "utf-8", /* encoding */
      "",      /* schema location */
      no,      /* write xml schema */
      no,      /* min-xmlschema */
      no,      /* write-before-image */
      no       /* omit initial values */
      ).
      
  end method. /* WriteXmlAndSplit_Sub */  

end class.

/* EOF */ 
