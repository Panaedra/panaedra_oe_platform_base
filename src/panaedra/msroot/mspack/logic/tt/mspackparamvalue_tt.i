/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Temp-table ttPackParam definition. Contains generic purpose parameters to use by pack logic.

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_mspack_logic_tt_mspackparamvalue_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_mspack_logic_tt_mspackparamvalue_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_mspack_logic_tt_mspackparamvalue_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_mspack_logic_tt_mspackparamvalue_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsPackParamValue~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsPackParamValue~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsPackParamValue{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsPackParamValue{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsPackParamValue{&ttSuffix} {&no-undo}
  xml-node-name "Parameter"
  {&reference-only} {&rcode-information} {&before-table}
  field iIDMsPackParamValue as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsPackParamValue "  
  field iIDMsPackParams     as int64       format "->>>,>>>,>>>,>>9"    xml-node-type "hidden"  
  field bActive             as logical     xml-node-type "attribute"
  field bCompilable         as logical     xml-node-type "attribute"
  field cKey                as character   xml-node-type "attribute"   
  field cValue              as character   xml-node-type "element"      xml-node-name "Value" /* This is an element, for supporting line breaks. */  
  {&ttExtraFields}
  index iIDMsPackParamValue  is unique         iIDMsPackParamValue
  index iIDMsPackParams_cKey is unique primary iIDMsPackParams cKey
  {&ttExtraIndices}
  .

&endif

&endif /* {&dvcs__panaedra_msroot_mspack_logic_tt_mspackparamvalue_tt_i} */

/* EOF : panaedra/msroot/mspack/logic/tt/mspackparamvalue_tt.i */
