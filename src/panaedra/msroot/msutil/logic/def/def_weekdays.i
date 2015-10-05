/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Definitions for the weekday INTEGER values from 1 (Sunday) to 7 (Saturday)

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_def_def_weekdays_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_def_def_weekdays_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_def_def_weekdays_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msutil_logic_def_def_weekdays_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&global-define sunday    1
&global-define monday    2
&global-define tuesday   3
&global-define wednesday 4
&global-define thu_TERM_UNDISCLOSED_ay  5
&global-define friday    6
&global-define saturday  7

&endif /* {&dvcs__panaedra_msroot_msutil_logic_def_def_weekdays_i} */

/* EOF : panaedra/msroot/msutil/logic/def/def_weekdays.i */
