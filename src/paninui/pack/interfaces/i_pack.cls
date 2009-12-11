{panaedra/msi/logic/ctop_interface.i}
using paninui.view.interfaces.*.

interface paninui.pack.interfaces.i_pack:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/pack/interfaces/i_pack.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-12-11 01:17:59+01:00 $ 
    Date Modified: $Modtime: 2009-12-10 22:46:58+01:00 $ 

      Description: add_your_comments_here

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method logical    LoadPack (oMdiWindowIP# as i_masterwindow).
  method logical    ShowPack (oMdiWindowIP# as i_masterwindow).
  method i_frmlogic ShowSubFrame(cSubframeIP# as character).
  
  define property UniqueInstanceID as int64 no-undo get.
  
end interface.

/* EOF */
