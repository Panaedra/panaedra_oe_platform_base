/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msdr/logic/c_triggerlogicdata_tt.i $ 
        Version: $Revision: 1 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-08-07 21:22:38+02:00 $ 
  Date Modified: $Modtime: 2009-08-07 21:22:38+02:00 $ 

    Description: Wordt gebruikt in classes die de i_triggerlogic interface gebruiken.

\**************************** End of Dvcs_ Header ****************************/
&if '{&dvcs__panaedra_msdr_logic_c_triggerlogicdata_tt_i}' = '' &then
&glob dvcs__panaedra_msdr_logic_c_triggerlogicdata_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msdr_logic_c_triggerlogicdata_tt_i $Revision: 1 $
&if '{&class}' = '' &then
&scop dvcs_proc procedure dvcs__panaedra_msdr_logic_c_triggerlogicdata_tt_i: return "$Revision: 1 $". end.
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
