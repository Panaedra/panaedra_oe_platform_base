/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Definition of ttMsMonICheckDef

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msmonitor_logic_tt_msmon_icheckdef_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msmonitor_logic_tt_msmon_icheckdef_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msmonitor_logic_tt_msmon_icheckdef_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msmonitor_logic_tt_msmon_icheckdef_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsMonICheckDef~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsMonICheckDef~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsMonICheckDef{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsMonICheckDef{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsMonICheckDef{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDMsMonICheckDef     as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsMonICheckDef "
  field cIntegrationCheckName as character
  field dtmFinished           as datetime-tz  
  {&ttExtraFields}
  index iIDMsMonICheckDef is unique primary iIDMsMonICheckDef
  {&ttExtraIndices}
  .

&endif

&endif /* {&dvcs__panaedra_msroot_msmonitor_logic_tt_msmon_icheckdef_tt_i} */

/* EOF : panaedra/msroot/msmonitor/logic/tt/msmon_icheckdef_tt.i */
