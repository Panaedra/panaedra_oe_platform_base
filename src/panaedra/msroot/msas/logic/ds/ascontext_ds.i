/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msas/logic/ds/ascontext_ds.i $ 
        Version: $Revision: 4 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-12-14 12:27:38+01:00 $ 
  Date Modified: $Modtime: 2009-12-14 11:51:02+01:00 $ 

    Description: Context basic tables
                 Worden gebruikt om data over appserver boundaries heen
                 te krijgen.
\**************************** End of Dvcs_ Header ****************************/
&if '{&dvcs__panaedra_msroot_msas_logic_ds_ascontext_ds_i}' = '' &then
&glob dvcs__panaedra_msroot_msas_logic_ds_ascontext_ds_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msas_logic_ds_ascontext_ds_i $Revision: 4 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msas_logic_ds_ascontext_ds_i: return "$Revision: 4 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/
&endif

{panaedra/msroot/msas/logic/tt/exceptions_tt.i {&*}}
{panaedra/msroot/msas/logic/tt/callstack_tt.i {&*}}
{panaedra/msroot/msas/logic/tt/clientroute_tt.i {&*}}
{panaedra/msroot/msas/logic/tt/session_tt.i {&*}}

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

define {&protected} {&static} dataset dsContext    {&reference-only} for ttExceptions, ttCallstack, ttClientRoute, ttSession.

/*define {&protected} {&static} buffer b-ttExceptions for ttExceptions.                                  */
/*define {&protected} {&static} buffer b-ttCallstack  for ttCallstack.                                   */
/*define {&protected} {&static} dataset dsExceptions {&reference-only} for b-ttExceptions, b-ttCallstack.*/


/* EOF : panaedra/msroot/msas/logic/ds/ascontext_ds.i */
