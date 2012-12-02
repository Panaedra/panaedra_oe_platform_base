/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: ttMsOsCommandDef

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_tt_msutil_oscommanddef_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_tt_msutil_oscommanddef_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_tt_msutil_oscommanddef_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msutil_logic_tt_msutil_oscommanddef_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&endif /* {&dvcs__panaedra_msroot_msutil_logic_tt_msutil_oscommanddef_tt_i} */

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsOsCommandDef~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsOsCommandDef~{~&ttSuffix~}

&if defined(ttMsOsCommandDef{&ttSuffix}) = 0 &then
&glob ttMsOsCommandDef{&ttSuffix} true
define {&protected} {&static} temp-table ttMsOsCommandDef{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDMsOsCommandDef    as int64     format "->>>,>>>,>>>,>>9" initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsOsCommandDef | PersistencyMode=xml-store "
  field cOsCommandToken      as character xml-node-type "attribute"
  field cEnv                   as character xml-node-type "attribute" 
  field cOpsys                 as character xml-node-type "attribute" 
  field cHostname              as character xml-node-type "attribute"
  field cMessageFormat         as character xml-node-type "attribute" initial "commandline"
  field cTempfileBuilderObject as character xml-node-type "attribute"
  field cOsCommand             as character xml-node-type "attribute"
  
  {&ttExtraFields}
  &if not "{&ttSuffix}" matches "*Copy" &then
  index iIDMsOsCommandDef is unique                  iIDMsOsCommandDef
  index cOsCommandTokenEnvOpsysHost is primary unique cOsCommandToken cEnv cOpsys cHostname 
  &endif
  {&ttExtraIndices}
  .

&endif

/* EOF : panaedra/msroot/msutil/logic/tt/msutil_oscommanddef_tt.i */
