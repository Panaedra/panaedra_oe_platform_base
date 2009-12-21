{panaedra/msi/logic/ctop_class.i}
using paninui.view.init.events.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class paninui.view.init.events.sc_sgt_masterwindow_eventhandler   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/init/events/sc_sgt_masterwindow_eventhandler.cls $ 
          Version: $Revision: 13 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-12-21 23:10:56+01:00 $ 
    Date Modified: $Modtime: 2009-12-21 23:06:21+01:00 $ 

      Description: Static Class Singleton implementation for Masterwindow / MDI Window

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_sgt_masterwindow_eventhandler(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 13 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable p_oSgt#      as sc_sgt_masterwindow_eventhandler no-undo.
  define public           variable cInitialPack as character                        no-undo.
  define public           variable oInitialPack as paninui.pack.interfaces.i_pack   no-undo.

  define public static property oMdiWindow as paninui.view.interfaces.i_masterwindow no-undo get. set.
  define public static property oSgt       as sc_sgt_masterwindow_eventhandler       no-undo
    get:
      if p_oSgt# = ? then p_oSgt# = new sc_sgt_masterwindow_eventhandler().
      return p_oSgt#.
    end get.


  constructor protected sc_sgt_masterwindow_eventhandler():

  end constructor.
  
  
  method public void MdiOnLoad(input sender as System.Object, input e as System.EventArgs ):
		
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
		
    oInitialPack = dynamic-new cInitialPack().

    if valid-object(oInitialPack) then oInitialPack:LoadPack(oMdiWindow).
    
    cast(sender,System.Windows.Forms.Form):Load:unsubscribe(this-object:MdiOnLoad).

    catch ex as Progress.Lang.Error :
      panaedra.msex.logic.sc_showexception:ShowException(ex).
    end catch.
    
  end method. /* MdiOnLoad */


  method public void MdiOnShown(input sender as System.Object, input e as System.EventArgs ):
		
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
		
    /* Later via: [RunObject] session parameter */

    if os-getenv("ECLIPSE_PROJECT") > "" then do:
      /* This means the eclipse debugger is running; Startup is postponed to the 
         "Shown" event for less crashes (but uglier screen at startup) 
      */
      if oInitialPack = ? then do:
        oInitialPack = dynamic-new cInitialPack ().
        if valid-object(oInitialPack) then oInitialPack:LoadPack(oMdiWindow).
      end.
    end.
    cast(sender,System.Windows.Forms.Form):Shown:unsubscribe(this-object:MdiOnShown).

    if valid-object(oInitialPack) then oInitialPack:ShowPack(oMdiWindow).

    catch ex as Progress.Lang.Error :
      panaedra.msex.logic.sc_showexception:ShowException(ex).
    end catch.
    
  end method.

end class.

/* EOF */
