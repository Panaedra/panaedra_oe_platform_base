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
                 Per-client persistent procedure for the UnitTest server-socket.

\**************************** End of Dvcs_ Header ****************************/
&scop dvcs_proc procedure dvcs__panaedra_msroot_msutil_logic_sc_unittest_sub_socketclient_p: return "$Revision: $". end.
{&dvcs_proc}
/******************************* $NoKeywords:  $ *****************************/

define input parameter hSocketPSIP# as handle no-undo.

procedure ReadResponse:
  
  define variable iLength# as integer   no-undo.
  define variable cOutput# as character no-undo.
  define variable iBytes#  as integer   no-undo.

  define variable mPoint#  as memptr    no-undo. 
  
  iBytes# = hSocketPSIP#:get-bytes-available().
  if iBytes# > 0 then 
  do:
    set-size (mPoint#) = iBytes# + 1.
    hSocketPSIP#:read(mPoint#,1,iBytes#,1).
    cOutput# = get-string(mPoint#,1).
    set-size (mPoint#) = 0.
  end.
  
  if cOutput# > "" then
    sc_unittest:_sys_SocketClientResponse(this-procedure, self, cOutput#).

end procedure. /* ReadResponse */

/* EOF */
