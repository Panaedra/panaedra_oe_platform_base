/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Deploy Module Definitions

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploydef_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploydef_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msdeploy_logic_tt_msdeploydef_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploydef_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsDeployDef~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsDeployDef~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsDeployDef{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsDeployDef{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsDeployDef{&ttSuffix} {&no-undo} 
  xml-node-name "DeployDef"
  {&reference-only} {&rcode-information} {&before-table}
  field iIDMsDeployDef as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsDeployDef | PersistencyMode=xml-store "  
  field cModuleID      as character   xml-node-type "attribute"
  field cPackageType   as character   xml-node-type "attribute"
  field cRepoUrl       as character   xml-node-type "attribute"
  field cSvRepoPath    as character   xml-node-type "attribute"
  field cInfo          as character   xml-node-type "attribute"
  {&ttExtraFields}
  index iIDMsDeployDef is unique primary iIDMsDeployDef
  {&ttExtraIndices}
  .

&endif


&endif /* {&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploydef_tt_i} */

/* EOF : panaedra/msroot/msdeploy/logic/tt/msdeploydef_tt.i */
