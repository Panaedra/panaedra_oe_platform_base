using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using paninui.view.interfaces.*.
using paninui.view.use.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
{paninui/logic/includes/preproc_dotnetclasses.i &class=class}

class paninui.view.use.analyze.sc_analyzewidget   : 

  /****************************** Source Header ********************************\

      Description: Analysis on widgets of any UI technology

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method public static character IsOfUiTechnology(oWidgetIP# as Progress.Lang.Object):
    
    /* Returns an identifier to the used UI technology.
       For now: "windows_forms" and "windows_wpf" is supported (and "progress_class" if something strange happens). 
    */
    
    define variable bDetermined# as logical   no-undo.
    define variable cReturn#     as character no-undo.
    
    &if {&paninui_tty} = false &then
    
    /* Check for WPF */
    if not bDetermined# and type-of(oWidgetIP#, System.Windows.UIElement) then 
      assign
        bDetermined# = true 
        cReturn#     = "windows_wpf".
    
    /* Check for WPF */
    if not bDetermined# and type-of(oWidgetIP#, System.Windows.UIElement3D) then 
      assign
        bDetermined# = true 
        cReturn#     = "windows_wpf".
    
    /* Keep this last for namespace "System.*" */
    if not bDetermined# and type-of(oWidgetIP#, System.Object) then 
      assign
        bDetermined# = true 
        cReturn#     = "windows_forms".
    
    &endif
      
    /* We don't know what this is, must be non-dotnet */
    if not bDetermined# then 
      assign
        bDetermined# = true 
        cReturn#     = "progress_class".
    
    return cReturn#.

  end method. /* IsOfUiTechnology */
  

  method public static logical IsCtrlAFixNecessary(
    
    /* Check if the Ctrl+A fix (to select all text) is necessary.
       See: http://stackoverflow.com/questions/16197915/how-can-i-allow-ctrla-with-textbox-in-winform
       And: https://msdn.microsoft.com/en-us/library/system.windows.forms.textboxbase.shortcutsenabled.aspx (remark on Multiline)
     */
    
    oWidgetIP# as Progress.Lang.Object):
    
    define variable bReturn#  as logical                      no-undo.
    
    &if {&paninui_tty} = false &then
    
    define variable oTextBox# as System.Windows.Forms.TextBox no-undo.

    if valid-object(oWidgetIP#) then 
    do:
      
      if type-of(oWidgetIP#, System.Windows.Forms.TextBox) then 
      do:
        oTextBox# = cast(oWidgetIP#, System.Windows.Forms.TextBox).
        bReturn# = (oTextBox#:ShortcutsEnabled and oTextBox#:Multiline).
      end.
    end.
    
    &endif
    
    return bReturn#.
    
  end method. /* IsCtrlAFixNecessary ; ComboBox */

end class.

/* EOF */ 
