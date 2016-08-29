/************* Generated: 2009-08-29T15:06:01.828+02:00 *********************/
&if defined(panaedra_msroot_msas_logic_tt_exceptions_tt_i) = 0 &then
&glob panaedra_msroot_msas_logic_tt_exceptions_tt_i true
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msas_logic_tt_exceptions_tt_i $Revision: 3 $
&endif
/*************************** $NoKeywords:  $ ********************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} tt~{~&ttPrefix~}Exceptions~{~&ttSuffix~}

&if defined(tt{&ttPrefix}Exceptions{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}Exceptions{&ttSuffix} true

define {&protected} {&static} temp-table tt{&ttPrefix}Exceptions{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iOrder as int
  field iError as int
  field cError as char
  field iDepth as int
  {&ttExtraFields}
  index iOrder is primary iOrder /* Not unique, but only to prevent exceptions within i.e. abl stop events. Is used unique. */
  {&ttExtraIndices}.

&endif

/* EOF : panaedra/msroot/msas/logic/tt/exceptions_tt.i */
