/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Collect the fieldnames of the iBuffer in a dynamic dataset.

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_tt_msdynds_bufferfields_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_tt_msdynds_bufferfields_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_tt_msdynds_bufferfields_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msutil_logic_tt_msdynds_bufferfields_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}DynDsBufferFieldname~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}DynDsBufferFieldname~{~&ttSuffix~}

&if defined(tt{&ttPrefix}DynDsBufferFieldname{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}DynDsBufferFieldname{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}DynDsBufferFieldname{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDDynDsBufferFieldname as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=DynDsBufferFieldname "  
  field cFieldname              as character
  {&ttExtraFields}
  index iIDDynDsBufferFieldname is unique primary iIDDynDsBufferFieldname
  {&ttExtraIndices}
  .

&endif

&endif
/* EOF : panaedra/msroot/msutil/logic/tt/msdynds_bufferfields_tt.i */