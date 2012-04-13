/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Definition of dsMsMonICheck

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msmonitor_logic_ds_msmon_icheck_ds_i}" = "" &then
&glob dvcs__panaedra_msroot_msmonitor_logic_ds_msmon_icheck_ds_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msmonitor_logic_ds_msmon_icheck_ds_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msmonitor_logic_ds_msmon_icheck_ds_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

{panaedra/msroot/msmonitor/logic/tt/msmon_icheckdef_tt.i {&*}}
{panaedra/msroot/msmonitor/logic/tt/msmon_icheckassertfile.i {&*}}

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

define {&protected} {&static} dataset dsMsMonICheck {&reference-only} for 
  ttMsMonICheckDef,
  ttMsMonICheckAssertFile.

&endif /* {&dvcs__panaedra_msroot_msmonitor_logic_ds_msmon_icheck_ds_i} */

/* EOF : panaedra/msroot/msmonitor/logic/ds/msmon_icheck_ds.i */
