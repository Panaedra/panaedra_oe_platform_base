using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msutil.view.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_developerfeedback: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Provide feedback specifically for developers

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_developerfeedback(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

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
      
      cReturn# = cReturn# + chr(10) + oExIP#:GetMessage(1) + subst(" (&1)",oExIP#:GetClass():TypeName).
      
      do iTell# = 1 to num-entries(oExIP#:CallStack):
        cReturn# = cReturn# + chr(10) + entry(iTell#,oExIP#:CallStack).
      end.
       
    end.
    
    return substring(cReturn#,2).
    
  end method. /* ExceptionToString */

end class.

/* EOF */ 
