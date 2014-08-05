/******************************  Source Control Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Include to be used at the top of each replication trigger procedure.

\**************************** End of Source Control Header ****************************/
/******************************* $NoKeywords:  $ **************************************/

&if "{&_panaedra_msroot_msutil_logic_top_i_ptop_replicationtrigger_i}" = "" &then

routine-level on error undo, throw.

&glob _TOOLING_ReplicationEnabled false

&if not {&_TOOLING_ReplicationEnabled} &then
if panaedra.msroot.msutil.logic.sc_environment:bLiveEnv
  or 
  (subst("&1 &2", os-getenv("DlcTest_"), os-getenv("test#")) matches "*testT*") 
  or 
  (subst("&1 &2", os-getenv("DlcTest_"), os-getenv("test#")) matches "*_PPL_UNDISCLOSED_*") 
  then.   /* Do nothing -> Continue with replication trigger */
else 
  return. /* Andere developers even niet lastig vallen; ALLEEN LIVE en testT */ 
&endif

&endif

/* EOF : panaedra/msroot/msutil/logic/top_i/ptop_replicationtrigger.i */
