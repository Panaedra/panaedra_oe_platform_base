/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: dsMsEnvironment, for sc_environment

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_ds_msenvironment_ds_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_ds_msenvironment_ds_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_ds_msenvironment_ds_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msutil_logic_ds_msenvironment_ds_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

{panaedra/msroot/msutil/logic/tt/msipdetection_tt.i {&*}}

define {&protected} {&static} dataset dsMsEnvironment {&reference-only}
  for ttMsIpDetection
  .

&endif /* {&dvcs__panaedra_msroot_msutil_logic_ds_msenvironment_ds_i} */

/* EOF : panaedra/msroot/msutil/logic/ds/msenvironment_ds.i */
