/****************************** Source Header ********************************\

    Description: temp-table for sc_osfile

\**************************** End of Source Header ***************************/


&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}FileAndAttributes~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}FileAndAttributes~{~&ttSuffix~}

&if defined(tt{&ttPrefix}FileAndAttributes{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}FileAndAttributes{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}FileAndAttributes{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field cFullPath               as character
  field dtmModificationDatetime as datetime-tz  
  {&ttExtraFields}
  index dtmModificationDatetime is primary dtmModificationDatetime
  {&ttExtraIndices}
  .


&endif /* {&source_panaedra_msroot_msutil_logic_tt_file_and_attributes_tt_i} */

/* EOF : panaedra/msroot/msutil/logic/tt/file_and_attributes_tt.i */
