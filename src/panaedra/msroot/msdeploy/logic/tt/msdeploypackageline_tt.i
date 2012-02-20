/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Deploy package lines (binaries) to return to the client

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploypackageline_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploypackageline_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msdeploy_logic_tt_msdeploypackageline_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploypackageline_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsDeployPackageLine~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsDeployPackageLine~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsDeployPackageLine{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsDeployPackageLine{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsDeployPackageline{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDMsDeployPackageline  as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsDeployPackageline "  
  field iIDMsDeployPackageDef   as int64   xml-node-type "hidden"   
  field cModuleID               as character   xml-node-type "attribute" 
  field iRepoVersion            as integer     xml-node-type "attribute" 
  field dtmPackageContents      as datetime-tz xml-node-type "attribute" 
  field blobPackageContents     as blob        xml-node-type "attribute"
  field cDestPath               as character   xml-node-type "attribute"
  {&ttExtraFields}
  index iIDMsDeployPackageline is unique primary iIDMsDeployPackageline
  index iDef_Module_Version    iIDMsDeployPackageDef cModuleID iRepoVersion
  {&ttExtraIndices}
  .

&endif


&endif /* {&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeploypackageline_tt_i} */

/* EOF : panaedra/msroot/msdeploy/logic/tt/msdeploypackageline_tt.i */
