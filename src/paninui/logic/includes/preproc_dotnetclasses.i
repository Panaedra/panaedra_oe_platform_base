/****************************** Source Header ********************************\

    Description: Preprocessor definitions for .net classes, which can be translated to
                 a unix counterpart.

\**************************** End of Source Header ***************************/
&if "{&dvcs__paninui_logic_includes_preproc_dotnetclasses_i}" = "" &then
&glob dvcs__paninui_logic_includes_preproc_dotnetclasses_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | paninui_logic_includes_preproc_dotnetclasses_i $Revision: 4 $
&if '{&class}' = '' &then
&endif
/******************************* $NoKeywords:  $ *****************************/

&if opsys = "unix" or "{&window-system}" = "tty" &then
&glob paninui_tty                          true
&glob System.Object                        Progress.Lang.Object
&glob System.Windows.Forms.Control         Progress.Lang.Object
&glob System.Windows.FrameworkElement      Progress.Lang.Object
&glob System.EventArgs                     Progress.Lang.Object
&glob System.Windows.Controls.ItemsControl Progress.Lang.Object
&glob i_masterwindow                       i_masterwindow_tty
&glob i_uiframe                            i_uiframe_tty
&glob i_frmlogic_shortcut                  i_frmlogic_shortcut_tty
&glob paninui.view.interfaces.             paninui.view.interfaces_tty.
&glob eint                                 
&else
&glob paninui_tty                          false
&glob System.Object                        System.Object
&glob System.Windows.Forms.Control         System.Windows.Forms.Control
&glob System.Windows.FrameworkElement      System.Windows.FrameworkElement
&glob System.Windows.Controls.ItemsControl System.Windows.Controls.ItemsControl
&glob System.EventArgs                     System.EventArgs
&glob i_masterwindow                       i_masterwindow
&glob i_uiframe                            i_uiframe
&glob i_frmlogic_shortcut                  paninui.logic.logicbase.c_framelogic_shortcut
&glob paninui.view.interfaces.             paninui.view.interfaces.
&if int(entry(1,proversion,".")) <= 11 and int(entry(2,proversion,".")) < 6 &then 
&glob eint                                 :value__
&else
&glob eint                                 
&endif
&endif

&endif /* {&dvcs__paninui_logic_includes_preproc_dotnetclasses_i} */

/* EOF : paninui/logic/includes/preproc_dotnetclasses.i */
