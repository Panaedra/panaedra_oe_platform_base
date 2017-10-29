using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msutil.view.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_developerfeedback: 

  /****************************** Source Header ********************************\

      Description: Provide feedback specifically for developers

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method public static void DevMsg(cMsgIP# as character):
    
    if sc_environment:IsIdeRunning() then
      sc_trayicon_win32:ShowTrayIconMessage(cMsgIP#, "devinfo").
  
  end method. /* DevMsg ; character */
  

  method public static void DevMsg(cMsgIP# as character, cCallStackIP# as character):
    
    if sc_environment:IsIdeRunning() then
      sc_trayicon_win32:ShowTrayIconMessage(cMsgIP# + chr(10) + cCallStackIP#, "devinfo").
  
  end method. /* DevMsg ; character, character */
  

  method public static void DevMsg(oExIP# as Progress.Lang.Error):

    if sc_environment:IsIdeRunning() then
      sc_trayicon_win32:ShowTrayIconMessage(ExceptionToString(oExIP#), "devinfo").
  
  end method. /* DevMsg ; exception */
  

  method public static void DevMsg(cMsgIP# as character, oExIP# as Progress.Lang.Error):

    if sc_environment:IsIdeRunning() then
      sc_trayicon_win32:ShowTrayIconMessage(cMsgIP# + chr(10) + ExceptionToString(oExIP#), "devinfo").
  
  end method. /* DevMsg ; character, exception */
  
  
  method protected static character ExceptionToString(oExIP# as Progress.Lang.Error):
    
    define variable cReturn# as character no-undo.
    define variable iTell#   as integer   no-undo.
    
    if valid-object(oExIP#) then 
    do:
      
      cReturn# = cReturn# + chr(10) + sc_showexception:ExceptionMsgToString(oExIP#) + subst(" (&1)",oExIP#:GetClass():TypeName).
      
      do iTell# = 1 to num-entries(oExIP#:CallStack): /* codeQok#7120 */
        cReturn# = cReturn# + chr(10) + entry(iTell#,oExIP#:CallStack). /* codeQok#7120 */
      end.
       
    end.
    
    return substring(cReturn#,2).
    
  end method. /* ExceptionToString */

end class.

/* EOF */ 
