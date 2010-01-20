{panaedra/msi/logic/ctop_interface.i}
using paninui.view.interfaces.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using paninui.pack.interfaces.*.

interface paninui.pack.interfaces.i_pack: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/pack/interfaces/i_pack.cls $ 
          Version: $Revision: 17 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-20 15:42:02+01:00 $ 
    Date Modified: $Modtime: 2010-01-20 12:01:30+01:00 $ 

      Description: Interface for pack objects

  \*****************************  Include Files ********************************/
  {paninui/logic/includes/preproc_dotnetclasses.i &class=class}
  
  /******************************* $NoKeywords:  $ *****************************/
  
  define property iPackID     as int64             no-undo get.
  define property oMdiWindow  as {&i_masterwindow} no-undo get.
  define property oScopeTable as i_scopetable      no-undo get.

  define property sys__oUiFrame as {&System.Object}     no-undo 
  get. 
  set.
  
  method logical    LoadPack (
    oMdiWindowIP# as {&i_masterwindow}).

  method void       ShowPack ().

  method void  ShowMdi (
    oMdiWindowIP# as {&i_masterwindow}).
  
  method void LoadSubframe(
    oGroupframeOverlayOVID# as i_showlocationtype_groupframeoverlay,
    cLocationWidgetTypeIP#  as character,
    cLocationWidgetNameIP#  as character,
    cSubframeLinkNameIP#    as character).

  method void HideSubframe(
    cLocationWidgetTypeIP#  as character,
    cLocationWidgetNameIP#  as character,
    cSubframeLinkNameIP#    as character).

  method void UnhideSubframe(
    cLocationWidgetTypeIP#  as character,
    cLocationWidgetNameIP#  as character,
    cSubframeLinkNameIP#    as character).

  method void LoadSubframepack(
    oGroupframeOverlayOVID# as i_showlocationtype_groupframeoverlay,
    cLocationWidgetTypeIP#  as character,
    cLocationWidgetNameIP#  as character,
    oSubpackIP#             as i_pack).

  method void HideSubframepack(
    oModalPackIP#           as i_pack,
    cLocationWidgetTypeIP#  as character,
    cLocationWidgetNameIP#  as character).
    
  method void UnhideSubframepack(
    oModalPackIP#           as i_pack,
    cLocationWidgetTypeIP#  as character,
    cLocationWidgetNameIP#  as character).
    
  method public void AddFrameLogicToPack(
    iFrmlgIndexIP# as integer, 
    hDatasetArrayIP# as handle extent).
    
  method c_datasetcontroller GetDatasetController(
    dataset-handle hDatasetIP# /* By reference */).
  
end interface.

/* EOF */
