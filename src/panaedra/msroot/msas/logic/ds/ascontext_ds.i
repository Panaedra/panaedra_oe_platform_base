/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msas/logic/ds/ascontext_ds.i $ 
        Version: $Revision: 6 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-01-27 17:01:59+01:00 $ 
  Date Modified: $Modtime: 2010-01-27 16:43:33+01:00 $ 

    Description: Context basic tables
                 Worden gebruikt om data over appserver boundaries heen
                 te krijgen.
\**************************** End of Dvcs_ Header ****************************/
&if '{&dvcs__panaedra_msroot_msas_logic_ds_ascontext_ds_i}' = '' &then
&glob dvcs__panaedra_msroot_msas_logic_ds_ascontext_ds_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msas_logic_ds_ascontext_ds_i $Revision: 6 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msas_logic_ds_ascontext_ds_i: return "$Revision: 6 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/
&endif

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

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

define {&protected} {&static} dataset dsContext {&reference-only} for ttExceptions, ttCallstack, ttClientRoute, ttSession, ttTransactionContext, ttTransactionResponse, ttValidation, ttValidationError, ttValidationQuestion, ttValidationReply.


/* EOF : panaedra/msroot/msas/logic/ds/ascontext_ds.i */
