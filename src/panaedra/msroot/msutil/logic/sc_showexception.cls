{def/ctop-_FCMPNY_class.i}

&if opsys = "win32" &then
using System.*.
using System.Windows.Forms.*.
&endif

class panaedra.msex.logic.sc_showexception-win32: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msex/logic/sc_showexception-win32.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-21 08:28:34+02:00 $ 
    Date Modified: $Modtime: 2009-09-15 09:16:10+02:00 $ 

      Description: Stop alle informatie in .net window en toon hem daarna,
                   indien het fout gaat, geef een normale message.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_showexception-win32(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/


  &if opsys = "win32" &then
  define protected static variable oForm as panaedra.msex.logic.dotnetformshowexception no-undo.

  method public static void ShowException (input ex as Progress.Lang.Error):
    
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
          ex:GetMessage(2) skip(1)
          panaedra.msses.logic.sc_info:GetCallStack()
          view-as alert-box title "_CMPNY_ " + string(now,"99-99-9999 hh:mm").
        
      end catch.
    end.
  end method. /* ShowException */

  
  method protected static void ShowFormSafe():

    /* Toon het exception scherm en wacht tot er op ok gedrukt is. */
    wait-for oForm:ShowDialog().
    
  end method.

&endif

end class.

/* EOF */
