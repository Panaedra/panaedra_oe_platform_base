using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ptop_procedure.i}

/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: $ 
        Version: $Revision: $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: $ 
  Date Modified: $Modtime: $ 

    Description: Sub procedure of sc_unittest.cls. Not to be used directly.
                 Persistent response procedure for the UnitTest server-socket.

\**************************** End of Dvcs_ Header ****************************/
&scop dvcs_proc procedure dvcs__panaedra_msroot_msutil_logic_sc_unittest_sub_serversocket_p: return "$Revision: $". end.
{&dvcs_proc}
/******************************* $NoKeywords:  $ *****************************/
 
procedure OnConnect:
  
  define input  parameter hSocketIP# as handle no-undo.
  
  define variable hProc# as handle no-undo.
  
  hSocketIP#:write(sc_unittest:sys_mGreeting,1,length(sc_unittest:sys_cGreeting)).
  
  run panaedra/msroot/msutil/logic/sc_unittest_sub_socketclient.p persistent set hProc# (hSocketIP#).
  sc_unittest:_sys_SocketClientRegister(hProc#).

  hSocketIP#:set-read-response-procedure("ReadResponse", hProc#).
  
end procedure. /* OnConnect */

/* EOF */
