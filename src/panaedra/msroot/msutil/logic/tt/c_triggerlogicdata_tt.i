/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/tt/c_triggerlogicdata_tt.i $ 
        Version: $Revision: 2 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
  Date Modified: $Modtime: 2010-01-27 19:42:48+01:00 $ 

    Description: Wordt gebruikt in classes die de i_triggerlogic interface gebruiken.

\**************************** End of Dvcs_ Header ****************************/
&if '{&dvcs__panaedra_msdr_logic_c_triggerlogicdata_tt_i}' = '' &then
&glob dvcs__panaedra_msdr_logic_c_triggerlogicdata_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msdr_logic_c_triggerlogicdata_tt_i $Revision: 2 $
&if '{&class}' = '' &then
&scop dvcs_proc procedure dvcs__panaedra_msdr_logic_c_triggerlogicdata_tt_i: return "$Revision: 2 $". end.
{&dvcs_proc}
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then
/* Dit wordt in OE10.2A nog niet ondersteund, hopelijk later wel */
/* Kan helaas niet in onderliggende include                      */
&undefine reference-only
&endif

define {&protected} {&static} temp-table ttTriggerLogicData no-undo {&reference-only} rcode-information
  field iOrder              as int
  field iError              as int
  field cError              as char
  field cTable              as char
  field cCased              as char
  field cField              as char
  field hBuff               as handle
  field hBuffOld            as handle
  field bShowAsError        as log
  field bShowAsWarning      as log
  field bShowAsConfirmation as log
  field bBuffersAreSet      as log
  index iOrder is primary unique iOrder
  index bBuffersAreSet bBuffersAreSet.

/* Datasets */
define {&protected} {&static} dataset dsTriggerLogicData {&reference-only} for ttTriggerLogicData.

&endif

/* EOF */
