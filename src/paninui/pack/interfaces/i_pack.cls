{panaedra/msi/logic/ctop_interface.i}
using paninui.view.interfaces.*.

interface paninui.pack.interfaces.i_pack:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/pack/interfaces/i_pack.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-12-11 03:31:30+01:00 $ 
    Date Modified: $Modtime: 2009-12-11 01:43:05+01:00 $ 

      Description: Interface for pack objects

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method logical    LoadPack (oMdiWindowIP# as i_masterwindow).
  method logical    ShowPack (oMdiWindowIP# as i_masterwindow).
  
  method logical LoadSubFrame(
    oGroupframeOverlayOVID# as i_showlocationtype_groupframeoverlay,
    cLocationIP#            as character,
    cSubframeIP#            as character).
  
  define property UniqueInstanceID as int64 no-undo get.
  
end interface.

/* EOF */
