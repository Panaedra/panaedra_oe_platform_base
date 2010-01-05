{panaedra/msi/logic/ctop_interface.i}
using paninui.view.interfaces.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using paninui.pack.interfaces.*.

interface paninui.pack.interfaces.i_pack:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/pack/interfaces/i_pack.cls $ 
          Version: $Revision: 11 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-05 18:40:57+01:00 $ 
    Date Modified: $Modtime: 2010-01-05 18:26:44+01:00 $ 

      Description: Interface for pack objects

  \*****************************  Include Files ********************************/
  {paninui/logic/includes/preproc_dotnetclasses.i &class=class}
  
  /******************************* $NoKeywords:  $ *****************************/
  
  define property iPackID    as int64             no-undo get.
  define property oMdiWindow as {&i_masterwindow} no-undo get.

  define property sys__oUiFrame as {&System.Object} no-undo 
  get. 
  set.
  
  method logical    LoadPack (
    oMdiWindowIP# as {&i_masterwindow}).

  method void  ShowPack (
    oMdiWindowIP# as {&i_masterwindow}).
  
  method void LoadSubframe(
    oGroupframeOverlayOVID# as i_showlocationtype_groupframeoverlay,
    cWidgetTypeIP#          as character,
    cWidgetNameIP#          as character,
    cSubframeIP#            as character).

  method void LoadSubframepack(
    oGroupframeOverlayOVID# as i_showlocationtype_groupframeoverlay,
    cWidgetTypeIP#          as character,
    cWidgetNameIP#          as character,
    oSubpackIP#             as i_pack).

  method void HideSubframepack(
    oLocationPackIP#          as i_pack,
    cLocationWidgetTypeIP#    as character,
    cLocationWidgetNameIP#    as character).
    
  method c_datasetcontroller GetDatasetController(
    dataset-handle hDatasetIP# /* By reference */).
  
end interface.

/* EOF */
