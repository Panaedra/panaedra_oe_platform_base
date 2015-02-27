&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}Test~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}Test~{~&ttSuffix~}

&if defined(tt{&ttPrefix}Test{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}Test{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}Test{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDTest as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=Test "  
  field cTest   as character   format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=Test "
  {&ttExtraFields}
  index iIDTest is unique primary iIDTest
  {&ttExtraIndices}
  .

&endif