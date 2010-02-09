/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/tt/validation_tt.i $ 
        Version: $Revision: 2 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-02-09 17:29:44+01:00 $ 
  Date Modified: $Modtime: 2010-02-09 17:26:56+01:00 $ 

    Description: ttValidation temp-table, parent of ttValidationLine.

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_tt_validation_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_tt_validation_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_tt_validation_tt_i $Revision: 2 $
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} tt~{~&ttPrefix~}Validation~{~&ttSuffix~}

&if defined(tt{&ttPrefix}Validation{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}Validation{&ttSuffix} true

define {&protected} {&static} temp-table tt{&ttPrefix}Validation{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDValidation            as int64       /* This ID is kept throughout the validation life cycle */ help " [CasedTableName] Validation "
  field dtmCreValidation         as datetime-tz /* Creation datetime */
  field iIDTransactionContext    as int64       /* Parent key        */
  field iOrderTransactionContext as int64       /* Parent order      */
  field cValidationName          as character   /* Logical name of the validation, i.e. "panaedra.msutil.msroot.validation.deletion=not-allowed" */
  field bRequiresAction          as logical     /* Calculated field, is true when there are "dirty" child records                             */
  {&ttExtraFields}
  index iIDValidation               is primary unique iIDValidation         descending
  index iIDTransactionContext_iOrder                  iIDTransactionContext descending  iOrderTransactionContext
  {&ttExtraIndices}.

&endif

&endif /* {&dvcs__panaedra_msroot_msutil_logic_tt_validation_tt_i} */

/* EOF : panaedra/msroot/msutil/logic/tt/validation_tt.i */
