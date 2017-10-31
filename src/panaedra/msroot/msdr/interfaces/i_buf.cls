{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 

interface panaedra.msroot.msdr.interfaces.i_buf:  

  /****************************** Source Header ********************************\

      Description: Interface for a simple class that wraps a single ABL query handle

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define property hBuffer as handle no-undo get. set.

  define property oBindingSource as /* codeQok#7106 */
    &if opsys="unix" &then
    /* Unix compatibility isn't complete yet, this is a stub. */
    Progress.Lang.Object
    &else
    paninui.view.init.display.c_bindingsource
    &endif 
    no-undo get. set.

  method public void UiRefreshRecord().

end interface.

/* EOF */ 
