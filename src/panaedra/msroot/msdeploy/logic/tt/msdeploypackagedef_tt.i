/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Deploy package definitions to return to the client

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploypackagedef_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploypackagedef_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msdeploy_logic_tt_msdeploypackagedef_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploypackagedef_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsDeployPackageDef~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsDeployPackageDef~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsDeployPackageDef{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsDeployPackageDef{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsDeployPackageDef{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDMsDeployPackageDef  as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsDeployPackageDef "  
  field cEnv                   as character   xml-node-type "attribute" 
  field cDeployID              as character   xml-node-type "attribute" 
  field cWorkdir               as character   xml-node-type "attribute"
  field cOpsys                 as character   xml-node-type "attribute"
  field cLayer                 as character   xml-node-type "attribute"
  field cWindowSystem          as character   xml-node-type "attribute"
  field iRepoVersion           as integer     xml-node-type "attribute" 
  field cRepoVersion           as character   xml-node-type "attribute" 
  field dtmRepoVersion         as datetime-tz xml-node-type "attribute" 
  field cSvCleanupDirs         as character   xml-node-type "attribute"
  {&ttExtraFields}
  index iIDMsDeployPackageDef is unique primary iIDMsDeployPackageDef
  {&ttExtraIndices}
  .

&endif

&endif /* {&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploypackagedef_tt_i} */

/* EOF : panaedra/msroot/msdeploy/logic/tt/msdeploypackage_tt.i */
