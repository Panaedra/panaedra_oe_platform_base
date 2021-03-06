/****************************** Source Header ********************************\

    Description: Context basic tables. Transfer session context over appserver boundaries.
    
\*****************************  Include Files ********************************/

/******************************* $NoKeywords:  $ *****************************/

{panaedra/msroot/msas/logic/tt/exceptions_tt.i {&*}}
{panaedra/msroot/msas/logic/tt/callstack_tt.i {&*}}
{panaedra/msroot/msas/logic/tt/clientroute_tt.i {&*}}
{panaedra/msroot/msas/logic/tt/session_tt.i {&*}}
{panaedra/msroot/msutil/logic/tt/transactioncontext_tt.i {&*}}
{panaedra/msroot/msutil/logic/tt/transactionresponse_tt.i {&*}}
{panaedra/msroot/msutil/logic/tt/validation_tt.i {&*}}
{panaedra/msroot/msutil/logic/tt/validationerror_tt.i {&*}}
{panaedra/msroot/msutil/logic/tt/validationquestion_tt.i {&*}}
{panaedra/msroot/msutil/logic/tt/validationreply_tt.i {&*}}
{panaedra/msroot/msas/logic/tt/msas_bin_tt.i {&*}}
{panaedra/msroot/msas/logic/tt/msas_clob_tt.i {&*}}
{panaedra/msroot/msas/logic/tt/msas_version_tt.i {&*}}

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

define {&protected} {&static} dataset dsContext {&reference-only} for 
  ttExceptions, 
  ttCallstack, 
  ttClientRoute, 
  ttSession, 
  ttTransactionContext,
  ttTransactionResponse, 
  ttValidation, 
  ttValidationError, 
  ttValidationQuestion, 
  ttValidationReply,
  ttMsAsBin,
  ttMsAsVersion.

/* EOF : panaedra/msroot/msas/logic/ds/ascontext_ds.i */
