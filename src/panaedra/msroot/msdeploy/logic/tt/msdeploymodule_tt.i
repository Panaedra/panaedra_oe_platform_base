/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Modules per DeployID

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploymodule_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploymodule_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msdeploy_logic_tt_msdeploymodule_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploymodule_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsDeployModule~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsDeployModule~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsDeployModule{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsDeployModule{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsDeployModule{&ttSuffix} {&no-undo} 
  xml-node-name "DeployModule"
  {&reference-only} {&rcode-information} {&before-table}
  field iIDMsDeployModule     as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsDeployModule | PersistencyMode=xml-store "  
  field iIDMsDeployConfig     as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "hidden"  
  field iIDMsDeployDef        as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute"  
  /* Implemented features */
  field iRepoVersion          as integer     xml-node-type "attribute" 
  field cRepoVersion          as character   xml-node-type "attribute" 
  field dtmRepoVersion        as datetime-tz xml-node-type "attribute" 
  field cDestPath             as character   xml-node-type "attribute"
  /* Future features */
  field cSvAllowRepoVersion   as character   xml-node-type "attribute"
  field cSvRepoVersionPerUser as character   xml-node-type "attribute"
  {&ttExtraFields}
  index iIDMsDeployModule is unique         iIDMsDeployModule
  index iIDMsDeployConfig is unique primary iIDMsDeployConfig iIDMsDeployModule
  index iIDMsDeployDef    is unique         iIDMsDeployDef    iIDMsDeployModule
  {&ttExtraIndices}
  .

&endif


&endif /* {&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploymodule_tt_i} */

/* EOF : panaedra/msroot/msdeploy/logic/tt/msdeploymodule_tt.i */
