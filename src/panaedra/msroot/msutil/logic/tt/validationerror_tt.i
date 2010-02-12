/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/tt/validationerror_tt.i $ 
        Version: $Revision: 3 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-02-12 16:36:58+01:00 $ 
  Date Modified: $Modtime: 2010-02-12 16:35:33+01:00 $ 

    Description: Child of ttValidation.
                 Validation error temp-table, to feed back validation errors to the 
                 user (i.e. Contact last name cannot be empty. )

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_tt_validationerror_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_tt_validationerror_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_tt_validationerror_tt_i $Revision: 3 $
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} tt~{~&ttPrefix~}ValidationError~{~&ttSuffix~}

&if defined(tt{&ttPrefix}ValidationError{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}ValidationError{&ttSuffix} true

define {&protected} {&static} temp-table tt{&ttPrefix}ValidationError{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDValidationError    as int64       help " [private-data] CasedTableName=ValidationError "
  field dtmCreValidationError as datetime-tz
  field iIDValidation         as int64
  field iOrderValidation      as int64
  field cMessage              as character
  field cTable                as character /* Can be used for focus in the UI */
  field cField                as character /* Can be used for focus in the UI */
  {&ttExtraFields}
  index iIDValidationError   is primary unique iIDValidationError descending
  index iIDValidation_iOrder                   iIDValidation      descending iOrderValidation
  {&ttExtraIndices}.

&endif

&endif /* {&dvcs__panaedra_msroot_msutil_logic_tt_validationerror_tt_i} */

/* EOF : panaedra/msroot/msutil/logic/tt/validationerror_tt.i */
