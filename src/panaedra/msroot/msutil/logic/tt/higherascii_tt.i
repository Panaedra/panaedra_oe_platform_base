/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: ttHigherAscii

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_tt_higherascii_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_tt_higherascii_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_tt_higherascii_tt_i $Revision: 1 $
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}HigherAscii~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}HigherAscii~{~&ttSuffix~}

&if defined(tt{&ttPrefix}HigherAscii{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}HigherAscii{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}HigherAscii{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDHigherAscii as int64     format "->>>,>>>,>>>,>>9" initial ? xml-node-type "attribute" help " [private-data] CasedTableName=HigherAscii "
  field cTable         as character 
  field rRowid         as rowid 
  field cSvKeyValues   as character 
  field cSvFields      as character
  field cSvValues      as character 
  {&ttExtraFields}
  index iIDHigherAscii is unique primary iIDHigherAscii
  index rRowid is unique                 rRowid
  {&ttExtraIndices}
  .

&endif

&endif /* {&dvcs__panaedra_msroot_msutil_logic_tt_higherascii_tt_i} */

/* EOF : panaedra/msroot/msutil/logic/tt/higherascii_tt.i */
