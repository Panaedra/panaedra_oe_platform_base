/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/tt/transactioncontext_tt.i $ 
        Version: $Revision: 3 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-02-12 16:36:58+01:00 $
  Date Modified: $Modtime: 2010-02-12 16:35:03+01:00 $ 

    Description: Transaction-context temp-table, 1 per logical transaction (i.e. api call). codeQok#7103
    
                 Parent of ttValidation (with ttValidationError e.a.).
                  
                 Parent of ttTransactionResponse (generic user feedback information which 
                 isn't the result of a validation).

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_tt_transactioncontext_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_tt_transactioncontext_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_tt_transactioncontext_tt_i $Revision: 3 $
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} tt~{~&ttPrefix~}TransactionContext~{~&ttSuffix~}

&if defined(tt{&ttPrefix}TransactionContext{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}TransactionContext{&ttSuffix} true

define {&protected} {&static} temp-table tt{&ttPrefix}TransactionContext{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDTransactionContext    as int64       /* This ID is kept throughout the "logical-transaction" life cycle                             */ help " [private-data] CasedTableName=TransactionContext " /* codeQok#7103 */
  field dtmCreTransactionContext as datetime-tz /* Creation datetime                                                                           */
  field iInitiatorID             as int64       /* Group multiple transaction-contexts of one initiator of one transaction (api-) call.        */ /* codeQok#7103 */
  field cTransactionName         as character   /* Logical name of the transaction, i.e. "panaedra.msutil.msroot.dsexample.changeset.transaction" */ /* codeQok#7103 */
  field bRequiresAction          as logical     /* Calculated field, is true when there are "dirty" child records                              */
  {&ttExtraFields}
  index iIDTransactionContext is primary unique iIDTransactionContext descending
  index iInitiatorID                            iInitiatorID          ascending  iIDTransactionContext descending
  {&ttExtraIndices}.

&endif

&endif /* {&dvcs__panaedra_msroot_msutil_logic_tt_transactioncontext_tt_i} */

/* EOF : panaedra/msroot/msutil/logic/tt/transactioncontext_tt.i */
