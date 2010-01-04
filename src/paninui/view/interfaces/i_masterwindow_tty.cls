{panaedra/msi/logic/ctop_interface.i} 
using paninui.view.interfaces.*.

interface paninui.view.interfaces.i_masterwindow_tty:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/interfaces/i_masterwindow_tty.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-04 11:35:43+01:00 $ 
    Date Modified: $Modtime: 2010-01-04 11:35:19+01:00 $ 

      Description: paninui.dll i_masterwindow stub for tty/unix

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property iMdiWindowID as int64 no-undo get.

  define property oUiFrameMenuStrip as i_uiframe_tty no-undo get.
  define property oUiFrameStatusBar as i_uiframe_tty no-undo get.
  define property oUiFrameWorkSpace as i_uiframe_tty no-undo get.
  
  method public void AddFrameToMainContainer (oFrmlgIP# as i_uiframe_tty).
  method public void SetStatusBarInfo (cLocationIP# as character, cMessageIP# as character).
  
end interface.

/* EOF */ 
