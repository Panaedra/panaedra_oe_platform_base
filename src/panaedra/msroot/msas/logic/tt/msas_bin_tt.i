/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Send generic binaries over appserver connection

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msas_logic_tt_msas_bin_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msas_logic_tt_msas_bin_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msas_logic_tt_msas_bin_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msas_logic_tt_msas_bin_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/


&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsAsBin~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsAsBin~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsAsBin{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsAsBin{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsAsBin{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDMsAsBin as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsAsBin "  
  field cBinType   as character
  field blobData   as blob
  {&ttExtraFields}
  index iIDMsAsBin is unique primary iIDMsAsBin
  {&ttExtraIndices}
  .

&endif

&endif /* {&dvcs__panaedra_msroot_msas_logic_tt_msas_bin_tt_i} */

/* EOF : panaedra/msroot/msas/logic/tt/msas_bin_tt.i */
