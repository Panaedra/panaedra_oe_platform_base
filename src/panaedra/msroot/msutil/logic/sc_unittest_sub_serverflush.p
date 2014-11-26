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
                 This "flush" persistent procedure is used for read-responses of already "killed" sessions.

******************************** $NoKeywords:  $ *****************************/

procedure ReadResponseFlush:
  
  define variable iLength#    as integer  no-undo.
  define variable clobOutput# as longchar no-undo.
  define variable iBytes#     as integer  no-undo.
  define variable mPoint#     as memptr   no-undo. 
  
  iBytes# = self:get-bytes-available().
  if iBytes# > 0 then 
  do:
    set-size(mPoint#) = iBytes# + 1.
    self:read(mPoint#,1,iBytes#,1).
    clobOutput# = get-string(mPoint#,1).
    set-size(mPoint#) = 0.
  end.
  
  /* And it's flushed, we don't return clobOutput# */

end procedure. /* ReadResponseFlush */

/* EOF */
