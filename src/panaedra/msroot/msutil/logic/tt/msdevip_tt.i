/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: ttMsDevIP (IP addresses developer workstations, for special event monitor handling and other feedback)

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_tt_msdevip_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_tt_msdevip_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_tt_msdevip_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msutil_logic_tt_msdevip_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsDevIp~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsDevIp~{~&ttSuffix~}

&if defined(ttMsDevIp{&ttSuffix}) = 0 &then
&glob ttMsDevIp{&ttSuffix} true
define {&protected} {&static} temp-table ttMsDevIp{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDShortIP             as integer   format ">,>>9" initial ? xml-node-type "attribute"
  field cFullIpAddress         as character xml-node-type "attribute"
  
  {&ttExtraFields}
  index iIDShortIP is unique                  iIDShortIP
  {&ttExtraIndices}
  .

&endif


&endif /* {&dvcs__panaedra_msroot_msutil_logic_tt_msdevip_tt_i} */

/* EOF : panaedra/msroot/msutil/logic/tt/msdevip_tt.i */
