/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msas/logic/tt/session_tt.i $ 
        Version: $Revision: 3 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-01-09 18:24:20+01:00 $ 
  Date Modified: $Modtime: 2010-01-09 17:10:27+01:00 $ 

    Description: Session temp-table for appserver context

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msas_logic_tt_session_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msas_logic_tt_session_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msas_logic_tt_session_tt_i $Revision: 3 $
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} tt~{~&ttPrefix~}Session~{~&ttSuffix~}

&if defined(tt{&ttPrefix}Session{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}Session{&ttSuffix} true

define {&protected} {&static} temp-table tt{&ttPrefix}Session{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field cUserID          as character
  field cSessionGuid     as character
  field cEnv             as character
  field cLang            as character
  field cOpsys           as character
  field cLayer           as character
  field cAsCallIntention as character
  field cAsCallPhase     as character
  field dtmAsCallStart   as datetime-tz
  field dtmAsCallEnd     as datetime-tz
  field cDeployID        as character
  field iDeployVersion   as integer
  field cDeployVersion   as character
  field dtmDeployVersion as datetime-tz
  field cSvParams        as character
  /* For future use */
  field iProcessID       as integer
  field bDebug           as logical
  field bBatchmode       as logical
  field dtmSessionStart  as datetime-tz
  field iBatchNumRows    as integer
  field cActionGuid      as character
  {&ttExtraFields}
  index cSessionGuid is primary unique cSessionGuid
  {&ttExtraIndices}.

&endif

&endif /* {&dvcs__panaedra_msroot_msas_logic_tt_session_tt_i} */

/* EOF : panaedra/msroot/msas/logic/tt/session_tt.i */
