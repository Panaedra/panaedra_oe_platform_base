/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Appserver version/deploy information

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msas_logic_tt_msas_version_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msas_logic_tt_msas_version_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msas_logic_tt_msas_version_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msas_logic_tt_msas_version_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsAsVersion~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsAsVersion~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsAsVersion{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsAsVersion{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsAsVersion{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDMsAsVersion as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsAsVersion "
  field cDeployID              as character   xml-node-type "attribute" 
  field iRepoVersion           as integer     xml-node-type "attribute" 
  field dtmRepoVersion         as datetime-tz xml-node-type "attribute"  
  field cModuleID              as character   xml-node-type "attribute"   
  {&ttExtraFields}
  index iIDMsAsVersion is unique primary iIDMsAsVersion
  {&ttExtraIndices}
  .

&endif


&endif /* {&dvcs__panaedra_msroot_msas_logic_tt_msas_version_tt_i} */

/* EOF : panaedra/msroot/msas/logic/tt/msas_version_tt.i */
