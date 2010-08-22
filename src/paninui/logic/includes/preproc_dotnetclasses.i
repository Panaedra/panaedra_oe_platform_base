/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/paninui/logic/includes/preproc_dotnetclasses.i $ 
        Version: $Revision: 4 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-08-22 15:30:38+02:00 $ 
  Date Modified: $Modtime: 2010-08-22 15:05:31+02:00 $ 

    Description: Preprocessor definitions for .net classes, which can be translated to
                 a unix counterpart.

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__paninui_logic_includes_preproc_dotnetclasses_i}" = "" &then
&glob dvcs__paninui_logic_includes_preproc_dotnetclasses_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | paninui_logic_includes_preproc_dotnetclasses_i $Revision: 4 $
&if '{&class}' = '' &then
procedure dvcs__paninui_logic_includes_preproc_dotnetclasses_i: return "$Revision: 4 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if opsys = "unix" or "{&window-system}" = "tty" &then
&glob paninui_tty              true
&glob System.Object            Progress.Lang.Object
&glob System.EventArgs         Progress.Lang.Object
&glob i_masterwindow           i_masterwindow_tty
&glob i_uiframe                i_uiframe_tty
&glob i_frmlogic_shortcut      i_frmlogic_shortcut_tty
&glob paninui.view.interfaces. paninui.view.interfaces_tty.
&else
&glob paninui_tty              false
&glob System.Object            System.Object
&glob System.EventArgs         System.EventArgs
&glob i_masterwindow           i_masterwindow
&glob i_uiframe                i_uiframe
&glob i_frmlogic_shortcut      paninui.logic.logicbase.c_framelogic_shortcut
&glob paninui.view.interfaces. paninui.view.interfaces.
&endif

&endif /* {&dvcs__paninui_logic_includes_preproc_dotnetclasses_i} */

/* EOF : paninui/logic/includes/preproc_dotnetclasses.i */
