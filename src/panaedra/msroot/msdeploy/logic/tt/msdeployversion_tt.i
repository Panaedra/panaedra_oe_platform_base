/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: ttMsDeployVersion is used for deploy_version.xconfig files.
    
                 It tells the client which version of each module is deployed 
                 and installed on the client.
                 
                 Use Ctrl+Alt+Shift+F1 to see all deployed versions (using 
                 the msscreeninfo pack).
    

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeployversion_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msdeploy_logic_tt_msdeployversion_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msdeploy_logic_tt_msdeployversion_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msdeploy_logic_tt_msdeployversion_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/


&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsDeployVersion~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsDeployVersion~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsDeployVersion{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsDeployVersion{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsDeployVersion{&ttSuffix} {&no-undo} xml-node-name "deploy_version" {&reference-only} {&rcode-information} {&before-table}
  field iIDMsDeployVersion     as int64       format "->>>,>>>,>>>,>>9"  initial ? xml-node-name "ID" xml-node-type "attribute" help " [private-data] CasedTableName=MsDeployVersion | PersistencyMode=xml-store"
  field dtmCreMsDeployVersion  as datetime-tz xml-node-type "attribute" xml-node-name "created"
  field cDeployID              as character   xml-node-type "attribute" xml-node-name "deploy_id"
  field cModuleID              as character   xml-node-type "attribute" xml-node-name "module"
  field cInfo                  as character   xml-node-type "attribute" xml-node-name "info"
  field iRepoVersion           as integer     xml-node-type "attribute" xml-node-name "repo_version"
  field dtmRepoVersion         as datetime-tz xml-node-type "attribute" xml-node-name "repo_changed"

  {&ttExtraFields}
  index iIDMsDeployVersion is unique primary iIDMsDeployVersion
  {&ttExtraIndices}
  .

&endif

&endif /* {&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeployversion_tt_i} */

/* EOF : panaedra/msroot/msdeploy/logic/tt/msdeployversion_tt.i */
