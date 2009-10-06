{panaedra/msi/logic/ptop_procedure.i}

/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_eventbroadcaster_loose.p $ 
        Version: $Revision: 1 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-10-05 19:50:21+02:00 $ 
  Date Modified: $Modtime: 2009-10-05 15:57:27+02:00 $ 

    Description: Support procedure for loose firing of broadcasted events.
                 Can be used by code that is Panaedra-independent (like Eclipse startup 
                 or paninUi).

\**************************** End of Dvcs_ Header ****************************/
&scop dvcs_proc procedure dvcs__panaedra_msroot_msutil_logic_sc_eventbroadcaster_loose_p: return "$Revision: 1 $". end.
{&dvcs_proc}
/******************************* $NoKeywords:  $ *****************************/

define input  parameter cEventNameIP# as character            no-undo.
define input  parameter cDataIP#      as character            no-undo.
define input  parameter oDataIP#      as Progress.Lang.Object no-undo.

if valid-object(oDataIP#) then 
  /**** Object overload *****/ panaedra.msroot.msutil.logic.sc_eventbroadcaster:FireEvent(cEventNameIP#, oDataIP#).
else 
  if cDataIP# > "" then 
    /** Character overload **/ panaedra.msroot.msutil.logic.sc_eventbroadcaster:FireEvent(cEventNameIP#, cDataIP#).
  else 
    /** Simple overload *****/ panaedra.msroot.msutil.logic.sc_eventbroadcaster:FireEvent(cEventNameIP#).

/* EOF */