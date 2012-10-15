/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: ttMsIpDetection, for sc_environment

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_tt_msipdetection_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_tt_msipdetection_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_tt_msipdetection_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msutil_logic_tt_msipdetection_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&endif /* {&dvcs__panaedra_msroot_msutil_logic_tt_msipdetection_tt_i} */

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsIpDetection~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsIpDetection~{~&ttSuffix~}

&if defined(ttMsIpDetection{&ttSuffix}) = 0 &then
&glob ttMsIpDetection{&ttSuffix} true
define {&protected} {&static} temp-table ttMsIpDetection{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field cOpsys               as character xml-node-type "attribute"
  field cPreferredIpV4Prefix as character xml-node-type "attribute"
  
  {&ttExtraFields}
  index cOpsys is unique cOpsys
  {&ttExtraIndices}
  .
&endif
  
/* EOF : panaedra/msroot/msutil/logic/tt/msipdetection_tt.i */
