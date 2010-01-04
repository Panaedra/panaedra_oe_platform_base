/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/paninui/logic/includes/preproc_dotnetclasses.i $ 
        Version: $Revision: 2 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-01-04 11:36:06+01:00 $ 
  Date Modified: $Modtime: 2010-01-04 11:30:47+01:00 $ 

    Description: Preprocessor definitions for .net classes, which can be translated to
                 a unix counterpart.

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__paninui_logic_includes_preproc_dotnetclasses_i}" = "" &then
&glob dvcs__paninui_logic_includes_preproc_dotnetclasses_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | paninui_logic_includes_preproc_dotnetclasses_i $Revision: 2 $
&if '{&class}' = '' &then
procedure dvcs__paninui_logic_includes_preproc_dotnetclasses_i: return "$Revision: 2 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if opsys = "unix" or "{&window-system}" = "tty" &then
&glob System.Object    Progress.Lang.Object
&glob System.EventArgs Progress.Lang.Object
&glob i_masterwindow   i_masterwindow_tty
&glob i_uiframe        i_uiframe_tty
&else
&glob System.Object    System.Object
&glob System.EventArgs System.EventArgs
&glob i_masterwindow   i_masterwindow
&glob i_uiframe        i_uiframe
&endif

&endif /* {&dvcs__paninui_logic_includes_preproc_dotnetclasses_i} */

/* EOF : paninui/logic/includes/preproc_dotnetclasses.i */
