{panaedra/msi/logic/ctop_interface.i}
using paninui.view.interfaces.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

interface paninui.pack.interfaces.i_pack:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/pack/interfaces/i_pack.cls $ 
          Version: $Revision: 6 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-12-15 00:05:32+01:00 $ 
    Date Modified: $Modtime: 2009-12-14 23:17:19+01:00 $ 

      Description: Interface for pack objects

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property UniqueInstanceID as int64 no-undo get.
  
  method logical    LoadPack (
    oMdiWindowIP# as i_masterwindow).

  method void       ShowPack (
    oMdiWindowIP# as i_masterwindow).
  
  method logical LoadSubFrame(
    oGroupframeOverlayOVID# as i_showlocationtype_groupframeoverlay,
    cLocationIP#            as character,
    cSubframeIP#            as character).
  
  method c_datasetcontroller GetDatasetController(
    dataset-handle hDatasetIP# /* By reference */).
  
end interface.

/* EOF */
