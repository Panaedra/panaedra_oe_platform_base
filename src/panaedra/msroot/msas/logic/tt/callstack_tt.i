/************* Generated: 2009-08-29T15:06:01.828+02:00 *********************/
&if defined(panaedra_msroot_msas_logic_tt_Callstack_tt_i) = 0 &then
&glob panaedra_msroot_msas_logic_tt_Callstack_tt_i true
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msas_logic_tt_Callstack_tt_i $Revision: 2 $
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

&glob TtAllDefined {&TtAllDefined} tt~{~&ttPrefix~}Callstack~{~&ttSuffix~}

&if defined(tt{&ttPrefix}Callstack{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}Callstack{&ttSuffix} true

define {&protected} {&static} temp-table tt{&ttPrefix}Callstack{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field cCallStack as character
  {&ttExtraFields}
  index cCallStack is primary cCallStack
  {&ttExtraIndices}.

&endif

/* EOF : panaedra/msroot/msas/logic/tt/Callstack_tt.i */
