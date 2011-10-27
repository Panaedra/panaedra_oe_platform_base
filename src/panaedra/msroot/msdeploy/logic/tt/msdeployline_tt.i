/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: ttMsDeployLine

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeployline_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msdeploy_logic_tt_msdeployline_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msdeploy_logic_tt_msdeployline_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msdeploy_logic_tt_msdeployline_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsDeployLine~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsDeployLine~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsDeployLine{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsDeployLine{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsDeployLine{&ttSuffix} {&no-undo}
  xml-node-name "DeployLine"
  {&reference-only} {&rcode-information} {&before-table}
  field iIDMsDeployLine   as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsDeployLine | PersistencyMode=xml-store "  
  field iIDMsDeployModule as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "hidden"
  {&ttExtraFields}
  index iIDMsDeployLine   is unique         iIDMsDeployLine
  index iIDMsDeployModule is unique primary iIDMsDeployModule iIDMsDeployLine
  {&ttExtraIndices}
  .

&endif


&endif /* {&dvcs__panaedra_msroot_msdeploy_logic_tt_msdeployline_tt_i} */

/* EOF : panaedra/msroot/msdeploy/logic/tt/msdeployline_tt.i */
