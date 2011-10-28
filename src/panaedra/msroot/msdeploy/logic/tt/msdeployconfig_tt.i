/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: ttMsDeployConfig

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeployconfig_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msdeploy_logic_tt_msdeployconfig_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msdeploy_logic_tt_msdeployconfig_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msdeploy_logic_tt_msdeployconfig_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsDeployConfig~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsDeployConfig~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsDeployConfig{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsDeployConfig{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsDeployConfig{&ttSuffix} {&no-undo} 
  xml-node-name "DeployConfig"
  {&reference-only} {&rcode-information} {&before-table}
  field iIDMsDeployConfig as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsDeployConfig | PersistencyMode=xml-store "  
  field cDeployID         as character   xml-node-type "attribute"
  field cSvUserInclude    as character   xml-node-type "attribute"
  field cSvUserExclude    as character   xml-node-type "attribute"
  {&ttExtraFields}
  index iIDMsDeployConfig is unique         iIDMsDeployConfig
  index cDeployID         is unique primary cDeployID
  {&ttExtraIndices}
  .

&endif


&endif /* {&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeployconfig_tt_i} */

/* EOF : panaedra/msroot/msdeploy/logic/tt/msdeployconfig_tt.i */
