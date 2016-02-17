{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 
{paninui/logic/includes/preproc_dotnetclasses.i}
using paninui.view.interfaces.*.

interface paninui.view.interfaces.i_masterwindow_tty:  

  /****************************** Source Header ********************************\

      Description: paninui.dll i_masterwindow stub for tty/unix

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property iMdiWindowID as int64 no-undo get.

  define property oUiFrameMenuStrip as i_uiframe_tty no-undo get.
  define property oUiFrameStatusBar as i_uiframe_tty no-undo get.
  define property oUiFrameWorkSpace as i_uiframe_tty no-undo get.
  define property bIsShown          as logical       no-undo get.
  
  method public void AddFrameToMainContainer (oFrmIP# as i_uiframe_tty).
  method public void AddSubframeToWidget(oWdgParentIP# as {&System.Object}, oFrmChildIP# as i_uiframe_tty).
  method public void SetStatusBarInfo (cLocationIP# as character, cMessageIP# as character).

end interface.

/* EOF */ 
