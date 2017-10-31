/****************************** Source Header ********************************\

    Description: Used in classes implementing i_triggerlogic interface.

\**************************** End of Source Header ***************************/
&if '{&dvcs__panaedra_msdr_logic_c_triggerlogicdata_tt_i}' = '' &then
&glob dvcs__panaedra_msdr_logic_c_triggerlogicdata_tt_i yes
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then
/* OE10.2A limitation */
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

/* EOF : panaedra/msroot/msutil/logic/tt/c_triggerlogicdata_tt.i */
