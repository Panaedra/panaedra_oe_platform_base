{panaedra/msroot/msutil/logic/top_i/ptop_procedure.i}

/****************************** Source Header ********************************\

    Description: Support procedure for loose firing of broadcasted events.
                 Can be used by code that is Panaedra-independent (like Eclipse startup 
                 or paninUi).

\*****************************  Include Files ********************************/
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
