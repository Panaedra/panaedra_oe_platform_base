{panaedra/msi/logic/ctop_interface.i}
using paninui.view.interfaces.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using paninui.pack.interfaces.*.

interface paninui.pack.interfaces.i_pack:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/pack/interfaces/i_pack.cls $ 
          Version: $Revision: 7 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-12-18 11:29:30+01:00 $ 
    Date Modified: $Modtime: 2009-12-17 23:31:19+01:00 $ 

      Description: Interface for pack objects

  \*****************************  Include Files ********************************/
  {paninui/logic/includes/preproc_dotnetclasses.i &class=class}

  /******************************* $NoKeywords:  $ *****************************/
  
  /* TODO: rename  UniqueInstanceID naar iPackID */
  define property UniqueInstanceID as int64 no-undo get.

  define property sys__oUiFrame as {&System.Object} no-undo get. set.
  
  method logical    LoadPack (
    oMdiWindowIP# as i_masterwindow).

  method void       ShowPack (
    oMdiWindowIP# as i_masterwindow).
  
  method logical LoadSubFrame(
    oGroupframeOverlayOVID# as i_showlocationtype_groupframeoverlay,
    cWidgetTypeIP#          as character,
    cWidgetNameIP#          as character,
    cSubframeIP#            as character).

  method public logical LoadSubPack(
  oGroupframeOverlayOVID# as i_showlocationtype_groupframeoverlay,
    cWidgetTypeIP#          as character,
    cWidgetNameIP#          as character,
    oSubpackIP#             as i_pack).
    
  method c_datasetcontroller GetDatasetController(
    dataset-handle hDatasetIP# /* By reference */).
  
end interface.

/* EOF */
