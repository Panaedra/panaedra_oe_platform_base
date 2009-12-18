/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/paninui/logic/includes/preproc_dotnetclasses.i $ 
        Version: $Revision: 1 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-12-18 11:46:36+01:00 $ 
  Date Modified: $Modtime: 2009-12-18 11:28:22+01:00 $ 

    Description: Preprocessor definitions for .net classes, which can be translated to
                 a unix counterpart.

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__paninui_logic_includes_preproc_dotnetclasses_i}" = "" &then
&glob dvcs__paninui_logic_includes_preproc_dotnetclasses_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | paninui_logic_includes_preproc_dotnetclasses_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__paninui_logic_includes_preproc_dotnetclasses_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if opsys = "unix" or "{&window-system}" = "tty" &then
&glob System.Object    Progress.Lang.Object
&glob System.EventArgs Progress.Lang.Object
&else
&glob System.Object    System.Object
&glob System.EventArgs System.EventArgs
&endif

&endif /* {&dvcs__paninui_logic_includes_preproc_dotnetclasses_i} */

/* EOF : paninui/logic/includes/preproc_dotnetclasses.i */
