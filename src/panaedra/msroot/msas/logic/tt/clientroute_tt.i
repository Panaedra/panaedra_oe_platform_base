/************* Generated: 2009-08-29T15:06:01.828+02:00 *********************/
&if defined(panaedra_msroot_msas_logic_tt_clientroute_tt_i) = 0 &then
&glob panaedra_msroot_msas_logic_tt_clientroute_tt_i true
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msas_logic_tt_clientroute_tt_i $Revision: 1 $
&endif
/*************************** $NoKeywords:  $ ********************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}clientroute~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} tt~{~&ttPrefix~}clientroute~{~&ttSuffix~}

&if defined(tt{&ttPrefix}clientroute{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}clientroute{&ttSuffix} true

define {&protected} {&static} temp-table tt{&ttPrefix}clientroute{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field cClientRoute as character
  {&ttExtraFields}
  index cClientRoute is primary unique cClientRoute
  {&ttExtraIndices}.

&endif

/* EOF : panaedra/msroot/msas/logic/tt/clientroute_tt.i */
