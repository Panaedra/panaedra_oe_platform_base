{panaedra/msi/logic/ctop_class.i}

&if opsys = "win32" &then
using System.*.
using System.Windows.Forms.*.
&endif

class panaedra.msex.logic.sc_showexception: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msex/logic/sc_showexception.cls $ 
          Version: $Revision: 8 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-18 11:43:47+01:00 $ 
    Date Modified: $Modtime: 2010-01-18 11:41:36+01:00 $ 

      Description: Stop alle informatie in .net window en toon hem daarna,
                   indien het fout gaat, geef een normale message.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_showexception(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 8 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/


  &if opsys <> "unix" and "&window-system" <> "tty" &then
  define protected static variable oForm as panaedra.msex.logic.dotnetformshowexception no-undo.
  &endif
  
  method public static void ShowException (input ex as Progress.Lang.Error):
    
    &if opsys <> "unix" and "&window-system" <> "tty" &then
    
    if not valid-object(oForm) then 
      oForm = new panaedra.msex.logic.dotnetformshowexception().
      
    /* Vul het form met de exception. */
    oForm:ShowException(ex).
    
    do on error undo, throw:
      
      /* Laat form zien als dit mogelijk is */
      ShowFormSafe().
      
      catch eDummy as Progress.Lang.Error :
        /* Als we niet ShowDialog kunnen doen, bv Input Blocking vanuit een function,
           gewoon een message tonen en niet re-throwen.
        */
        message 
          ex:GetMessage(1) skip
          ex:GetMessage(2) skip
          ex:GetMessage(3) skip(1)
          panaedra.msses.logic.sc_info:GetCallStack()
          view-as alert-box title "_CMPNY_ " + string(now,"99-99-9999 hh:mm").
        
      end catch.
    end.
    
    &else
    
    define variable cLastProgram# as character no-undo.
    
    assign
      cLastProgram# = panaedra.msses.logic.sc_info:GetCallStack()
      cLastProgram# = entry(num-entries(cLastProgram#,chr(10)), cLastProgram#, chr(10))
      cLastProgram# = entry(num-entries(cLastProgram#," ")    , cLastProgram#, " ").
    
    if length(cLastProgram#) >= 60 then
      cLastProgram# = "..." + 
      substring(cLastProgram#, length(cLastProgram#) - 59).
    
    message 
      ex:GetMessage(1) skip
      ex:GetMessage(2) skip
      cLastProgram#
      view-as alert-box title "_CMPNY_ " + string(now,"99-99-99 hh:mm").
    
  &endif /* unix/tty */
    
  end method. /* ShowException */

  
  &if opsys <> "unix" and "&window-system" <> "tty" &then
  
  method protected static void ShowFormSafe():

    /* Toon het exception scherm en wacht tot er op ok gedrukt is. */
    wait-for oForm:ShowDialog().
    
  end method.
  
  &endif /* unix/tty */

end class.

/* EOF */
