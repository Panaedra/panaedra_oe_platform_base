/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Temp-table for displaying/handling the contents of a zip file.
                 Note: this temp-table doesn't have an iID field, it's a simple list.

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_tt_mszipfilelist_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_tt_mszipfilelist_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_tt_mszipfilelist_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msutil_logic_tt_mszipfilelist_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsZipFilelist~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsZipFilelist~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsZipFilelist{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsZipFilelist{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsZipFilelist{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field cPathInZip     as character format "x(300)"  xml-node-type "attribute"   
  field iIndexInZip    as integer                    xml-node-type "attribute"
  field cExtractToPath as character format "x(300)"  xml-node-type "attribute"   
  {&ttExtraFields}
  index cPathInZip  is unique primary cPathInZip
  index iIndexInZip is unique         iIndexInZip
  {&ttExtraIndices}
  .

&endif

&endif /* {&dvcs__panaedra_msroot_msutil_logic_tt_mszipfilelist_tt_i} */

/* EOF : panaedra/msroot/msutil/logic/tt/mszipfilelist_tt.i */
