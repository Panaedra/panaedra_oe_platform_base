/************* Generated: 2009-08-29T15:06:01.828+02:00 *********************/
&if defined(panaedra_msroot_msas_logic_tt_Callstack_tt_i) = 0 &then /* codeQok#7120 */
&glob panaedra_msroot_msas_logic_tt_Callstack_tt_i true             /* codeQok#7120 */
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

&glob TtAllDefined {&TtAllDefined} tt~{~&ttPrefix~}Callstack~{~&ttSuffix~} /* codeQok#7120 */

&if defined(tt{&ttPrefix}Callstack{&ttSuffix}) = 0 &then /* codeQok#7120 */
&glob tt{&ttPrefix}Callstack{&ttSuffix} true             /* codeQok#7120 */

define {&protected} {&static} temp-table tt{&ttPrefix}Callstack{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table} /* codeQok#7120 */
  field cCallStack as character help " [private-date] CasedTableName=Callstack" /* codeQok#7120 */
  {&ttExtraFields}
  {&ttExtraIndices}.

&endif

/* EOF : panaedra/msroot/msas/logic/tt/Callstack_tt.i */ /* codeQok#7120 */
