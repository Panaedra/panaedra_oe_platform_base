{panaedra/msi/logic/ctop_interface.i}
using paninui.view.interfaces.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using paninui.pack.interfaces.*.

interface paninui.pack.interfaces.i_pack:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/pack/interfaces/i_pack.cls $ 
          Version: $Revision: 10 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-04 11:36:06+01:00 $ 
    Date Modified: $Modtime: 2010-01-04 11:31:33+01:00 $ 

      Description: Interface for pack objects

  \*****************************  Include Files ********************************/
  {paninui/logic/includes/preproc_dotnetclasses.i &class=class}
  
  /******************************* $NoKeywords:  $ *****************************/
  
  define property iPackID    as int64             no-undo get.
  define property oMdiWindow as {&i_masterwindow} no-undo get.

  define property sys__oUiFrame as {&System.Object} no-undo get. set.
  
  method logical    LoadPack (
    oMdiWindowIP# as {&i_masterwindow}).

  method void       ShowPack (
    oMdiWindowIP# as {&i_masterwindow}).
  
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
