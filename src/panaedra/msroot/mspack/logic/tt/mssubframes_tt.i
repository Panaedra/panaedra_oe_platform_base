/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Temp-table definition

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_mspack_logic_tt_mssubframes_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_mspack_logic_tt_mssubframes_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_mspack_logic_tt_mssubframes_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_mspack_logic_tt_mssubframes_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsSubframes~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsSubframes~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsSubframes{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsSubframes{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsSubframes{&ttSuffix} {&no-undo}
  xml-node-name "{&xml-node-name-tt}"
  {&reference-only} {&rcode-information} {&before-table}
  field iIDMsSubframes as int64       format "->>>,>>>,>>>,>>9"    initial 1 xml-node-type "attribute" help " [private-data] CasedTableName=MsSubframes "  
  {&ttExtraFields}
  index iIDMsSubframes is unique primary iIDMsSubframes
  {&ttExtraIndices}
  .

&endif


&endif /* {&dvcs__panaedra_msroot_mspack_logic_tt_mssubframes_tt_i} */

/* EOF : panaedra/msroot/mspack/logic/tt/mssubframes_tt.i */
