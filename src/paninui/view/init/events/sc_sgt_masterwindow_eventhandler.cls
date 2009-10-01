{panaedra/msi/logic/ctop_class.i}
using paninui.view.init.events.*.

class paninui.view.init.events.sc_sgt_masterwindow_eventhandler   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/init/events/sc_sgt_masterwindow_eventhandler.cls $ 
          Version: $Revision: 8 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-01 10:45:25+02:00 $ 
    Date Modified: $Modtime: 2009-10-01 08:46:17+02:00 $ 

      Description: Static Class Singleton implementation for Masterwindow / MDI Window

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_sgt_masterwindow_eventhandler(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 8 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  constructor protected sc_sgt_masterwindow_eventhandler():
  end constructor.
  
  define protected static variable p_oSgt# as sc_sgt_masterwindow_eventhandler no-undo.
  
  define public static property oSgt as sc_sgt_masterwindow_eventhandler no-undo
    get:
      if p_oSgt# = ? then p_oSgt# = new sc_sgt_masterwindow_eventhandler().
      return p_oSgt#.
    end get.

  define public static property oMdiWindow as paninui.view.interfaces.i_masterwindow get. set.

  method public void MdiOnLoadOrShown(input sender as System.Object, input e as System.EventArgs ):
		
    /* Note: "Load" and "Shown" are functionally the same in paninUi.
       However, both have some side effects:
       -Load-
       Load is fired before the window is shown. Everything is nice and hidden this way.
       However, the Eclipse debugger (ánd the Visual Studio debugger for that matter) don't
       like this and crashes often.
       -Shown-
       Shown is fired just after the window is shown. Because of the work done in the
       initializion of the paninUi screen objects, for about one second an ugly
       partially painted MDI screen is shown.
       However, the Eclipse debugger likes this and doesn't crash (well, far less often anyway).
     */
		
    panaedra.msroot.msutil.view.sc_trayicon_win32:ShowTrayIconMessage(program-name(1),"mdi").

    define variable oPack# as paninui.pack.interfaces.i_pack no-undo.
   
    /* Later via: [RunObject] session parameter */

    oPack# = dynamic-new "panaedra.ar.pack.c_pack__DATA_" ().

    oPack#:LoadPack(oMdiWindow).
    
    if os-getenv("ECLIPSE_PROJECT") > "" then
      /* This means the eclipse debugger is running; use Shown event for less crashes (but uglier screen at startup) */
      cast(sender,System.Windows.Forms.Form):Shown:unsubscribe(this-object:MdiOnLoadOrShown).
    else
      cast(sender,System.Windows.Forms.Form):Load:unsubscribe(this-object:MdiOnLoadOrShown).

    catch ex as Progress.Lang.Error :
      panaedra.msex.logic.sc_showexception-win32:ShowException(ex).
    end catch.
    
  end method.

end class.

/* EOF */
