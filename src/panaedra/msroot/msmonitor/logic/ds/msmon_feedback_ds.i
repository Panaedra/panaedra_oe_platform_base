/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Definition of dsMsMonFeedback (config from ini dir)

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msmonitor_logic_ds_msmon_feedback_ds_i}" = "" &then
&glob dvcs__panaedra_msroot_msmonitor_logic_ds_msmon_feedback_ds_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msmonitor_logic_ds_msmon_feedback_ds_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msmonitor_logic_ds_msmon_feedback_ds_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

{panaedra/msroot/msmonitor/logic/tt/msmon_feedbackdef_tt.i {&*}}

define {&protected} {&static} dataset dsMsMonFeedback for ttMsMonFeedbackDef.

&endif /* {&dvcs__panaedra_msroot_msmonitor_logic_ds_msmon_feedback_ds_i} */

/* EOF : panaedra/msroot/msmonitor/logic/ds/msmon_feedback_ds.i */
