{panaedra/msroot/msutil/logic/top_i/ctop_interface.i}
using paninui.view.interfaces.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using paninui.pack.interfaces.*.

interface paninui.pack.interfaces.i_pack: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/pack/interfaces/i_pack.cls $ 
          Version: $Revision: 18 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:12+01:00 $ 

      Description: Interface for pack objects

  \*****************************  Include Files ********************************/
  {paninui/logic/includes/preproc_dotnetclasses.i &class=class}
  
  /******************************* $NoKeywords:  $ *****************************/
  
  define property iPackID      as int64             no-undo get.
  define property oMdiWindow   as {&i_masterwindow} no-undo get.
  define property oScopeTable  as i_scopetable      no-undo get.
  define property bPackLoaded  as logical           no-undo get.
  define property bPackVisible as logical           no-undo get.

  define property sys__oUiFrame as {&System.Object}     no-undo 
  get. 
  set.
  
  method logical    LoadPack (
    oMdiWindowIP# as {&i_masterwindow},
    oWdgParentIP# as {&System.Object}).

  method void       ShowPack ().
  method void       HidePack ().

  method void  ShowMdi (
    oMdiWindowIP# as {&i_masterwindow}).

  method public void MaximizeSubFrame(
    bMaximizeIP#    as logical,
    cWidgetTypeIP#  as character,
    cWidgetNameIP#  as character).
    
  method void ShowLooseFrame(oPackIP# as i_pack, cLooseFrameIDIP# as character).
  method void ShowMainFrame(oPackIP# as i_pack).
  
  method void LoadSubframe(
    oGroupframeOverlayOVID# as i_showlocationtype_groupframeoverlay,
    cLocationWidgetTypeIP#  as character,
    cLocationWidgetNameIP#  as character,
    cSubframeLinkNameIP#    as character,
    output iSubframeIdOP#   as int64).

  method void LoadSubframe(
    oGroupframeOverlayOVID# as i_showlocationtype_mditopleft,
    cMdiNameIP#             as character,
    cSubframeLinkNameIP#    as character,
    output iSubframeIdOP#   as int64).

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
    iPackIdIP#              as int64,
    cLocationWidgetTypeIP#  as character,
    cLocationWidgetNameIP#  as character,
    oSubpackIP#             as i_pack,
    cScreenbufferTreeIP#    as character,
    output iSubframeIdOP#   as int64).

  method void LoadSubframepack(
    oGroupframeOverlayOVID# as i_showlocationtype_groupframeoverlay,
    iPackIdIP#              as int64,
    cLocationWidgetTypeIP#  as character,
    cLocationWidgetNameIP#  as character,
    cSubpackIP#             as character,
    cScreenbufferTreeIP#    as character,
    output iSubframeIdOP#   as int64).

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
    
  method public character GetPackParam(cKeyIP# as character).

  method public logical StartFrameLogic(cFrmlgLinkNameIP# as character).
  
end interface.

/* EOF */
