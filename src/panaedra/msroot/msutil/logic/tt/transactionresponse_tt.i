/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/tt/transactionresponse_tt.i $ 
        Version: $Revision: 2 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-02-09 17:29:44+01:00 $ 
  Date Modified: $Modtime: 2010-02-09 17:26:02+01:00 $ 

    Description: Transaction-context temp-table, 1 per logical transaction (i.e. api call).
    
                 Parent of ttValidation (with ttValidationError e.a.).
                  
                 Parent of ttTransactionResponse (generic user feedback information which 
                 isn't the result of a validation).

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_tt_transactionresponse_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_tt_transactionresponse_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_tt_transactionresponse_tt_i $Revision: 2 $
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} tt~{~&ttPrefix~}TransactionResponse~{~&ttSuffix~}

&if defined(tt{&ttPrefix}TransactionResponse{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}TransactionResponse{&ttSuffix} true

define {&protected} {&static} temp-table tt{&ttPrefix}TransactionResponse{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDTransactionResponse    as int64       /* Own ID            */ help " [CasedTableName] TransactionResponse "
  field dtmCreTransactionResponse as datetime-tz /* Creation datetime */
  field iIDTransactionContext     as int64       /* Parent key        */
  field iOrderTransactionContext  as int64       /* Parent order      */
  field cMessage                  as character
  field cTable                    as character   /* Can be used for focus in the UI */
  field cField                    as character   /* Can be used for focus in the UI */
  {&ttExtraFields}
  index iIDTransactionResponse       is primary unique iIDTransactionResponse descending
  index iIDTransactionContext_iOrder                   iIDTransactionContext  descending  iOrderTransactionContext
  {&ttExtraIndices}.

&endif

&endif /* {&dvcs__panaedra_msroot_msutil_logic_tt_transactionresponse_tt_i} */

/* EOF : panaedra/msroot/msutil/logic/tt/transactionresponse_tt.i */
