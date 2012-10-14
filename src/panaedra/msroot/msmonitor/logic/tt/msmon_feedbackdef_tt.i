/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Definition of ttMsMonFeedbackDef

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msmonitor_logic_tt_msmon_feedbackdef_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msmonitor_logic_tt_msmon_feedbackdef_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msmonitor_logic_tt_msmon_feedbackdef_tt_i $Revision: 1 $

/******************************* $NoKeywords:  $ *****************************/
&endif /* {&dvcs__panaedra_msroot_msmonitor_logic_tt_msmon_feedbackdef_tt_i} */

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsMonFeedbackDef~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsMonFeedbackDef~{~&ttSuffix~}

&if defined(ttMsMonFeedbackDef{&ttSuffix}) = 0 &then
&glob ttMsMonFeedbackDef{&ttSuffix} true
define {&protected} {&static} temp-table ttMsMonFeedbackDef{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDMsMonFeedbackDef    as int64     format "->>>,>>>,>>>,>>9" initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsMonFeedbackDef | PersistencyMode=xml-store "
  field cEvent                 as character xml-node-type "attribute"
  field cEnv                   as character xml-node-type "attribute" 
  field cOpsys                 as character xml-node-type "attribute" 
  field cHostname              as character xml-node-type "attribute"
  field cMonitorID             as character xml-node-type "attribute"
  /* service = service,application                      */
  /* part    = service parameter/application module     */
  /* level   = event level: debug/info/warn/error/fatal */
  /* message = description of error condition           */
  field cService               as character xml-node-type "attribute"
  field cPart                  as character xml-node-type "attribute"
  field cLevel                 as character xml-node-type "attribute" initial "error"
  field cMessage               as character xml-node-type "attribute" 
  field cMessageFormat         as character xml-node-type "attribute" initial "commandline"
  field cTempfileBuilderObject as character xml-node-type "attribute"
  field cMessageDispatchObject as character xml-node-type "attribute" /* use cMessageDispatchObject *or* cOsCommand */
  field cOsCommand             as character xml-node-type "attribute" /* use cMessageDispatchObject *or* cOsCommand */
  field cLocation              as character xml-node-type "attribute"
  field cProcessId             as character xml-node-type "attribute"
  field cThread                as character xml-node-type "attribute"
  field cException             as character xml-node-type "attribute"
  field cStackTrace            as character xml-node-type "attribute"
  field cUsername              as character xml-node-type "attribute"
  
  {&ttExtraFields}
  &if not "{&ttSuffix}" matches "*Copy" &then
  index iIDMsMonFeedbackDef is unique                  iIDMsMonFeedbackDef
  index cEvent_cEnv_cOpsys_cHost_MID is primary unique cEvent              cEnv cOpsys cHostname cMonitorID 
  &endif
  {&ttExtraIndices}
  .

&endif

/* EOF : panaedra/msroot/msmonitor/logic/tt/msmon_feedbackdef_tt.i */
