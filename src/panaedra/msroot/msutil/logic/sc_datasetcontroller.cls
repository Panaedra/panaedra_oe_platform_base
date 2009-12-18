{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_datasetcontroller: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_datasetcontroller.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-12-15 00:05:09+01:00 $ 
    Date Modified: $Modtime: 2009-12-15 00:03:42+01:00 $ 

      Description: Static functionality for c_datasetcontroller objects

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_datasetcontroller(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
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

end class.

/* EOF */ 