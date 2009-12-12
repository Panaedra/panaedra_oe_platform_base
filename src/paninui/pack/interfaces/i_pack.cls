{panaedra/msi/logic/ctop_interface.i}
using paninui.view.interfaces.*.

interface paninui.pack.interfaces.i_pack:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/pack/interfaces/i_pack.cls $ 
          Version: $Revision: 5 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-12-12 14:30:55+01:00 $ 
    Date Modified: $Modtime: 2009-12-12 14:13:05+01:00 $ 

      Description: Interface for pack objects

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method logical    LoadPack (oMdiWindowIP# as i_masterwindow).
  method void       ShowPack (oMdiWindowIP# as i_masterwindow).
  
  method logical LoadSubFrame(
    oGroupframeOverlayOVID# as i_showlocationtype_groupframeoverlay,
    cLocationIP#            as character,
    cSubframeIP#            as character).
  
  define property UniqueInstanceID as int64 no-undo get.
  
end interface.

/* EOF */
