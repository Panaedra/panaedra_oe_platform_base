{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_datasetcontroller: 

  /****************************** Source Header ********************************\

      Description: Static functionality for c_datasetcontroller objects

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method public static logical IsTrackingChangesEnabled(
  
    /* Determine if tracking-changes is enabled on any of the temp-tables. */
    
    oDatasetControllerIP# as c_datasetcontroller):

    define variable iBuff#   as integer no-undo.
    define variable hBuff#   as handle  no-undo.
    define variable bReturn# as logical no-undo.
    
    /* Go through for every temp-table buffer */
    b_each_ttbuff:
    do iBuff# = 1 to oDatasetControllerIP#:hDataset:num-buffers:
      hBuff# = oDatasetControllerIP#:hDataset:get-buffer-handle(iBuff#).
      if hBuff#:table-handle:tracking-changes then 
      do:
        bReturn# = true.
        leave b_each_ttbuff.
      end.
    end. /* b_each_ttbuff */
    
    return bReturn#.
    
  end method. /* IsTrackingChangesEnabled */


  method public static void TrackingChangesEnableAll(
  
    /* Enable tracking-changes on all temp-tables. */
    
    oDatasetControllerIP# as c_datasetcontroller):

    define variable iBuff# as integer no-undo.
    define variable hBuff# as handle  no-undo.
    
    /* Go through for every temp-table buffer */
    do iBuff# = 1 to oDatasetControllerIP#:hDataset:num-buffers:
      hBuff# = oDatasetControllerIP#:hDataset:get-buffer-handle(iBuff#).
      hBuff#:table-handle:tracking-changes = true.
    end.
    
  end method. /* TrackingChangesEnableAll */


  method public static void TrackingChangesDisableAll(

    /* Disable tracking-changes on all temp-tables. */
    
    oDatasetControllerIP# as c_datasetcontroller):
  
    define variable iBuff# as integer no-undo.
    define variable hBuff# as handle  no-undo.
    
    /* Go through for every temp-table buffer */
    do iBuff# = 1 to oDatasetControllerIP#:hDataset:num-buffers:
      hBuff# = oDatasetControllerIP#:hDataset:get-buffer-handle(iBuff#).
      hBuff#:table-handle:tracking-changes = false.
    end.
    
  end method. /* TrackingChangesDisableAll */

  method public static void WriteXmlFile(oDatasetControllerIP# as c_datasetcontroller, cFileIP# as character):
    
    sc_dataset_xml:WriteXmlFile(oDatasetControllerIP#:hDataset, cFileIP#).
  
  end method. /* WriteXmlFile */

end class.

/* EOF */ 
