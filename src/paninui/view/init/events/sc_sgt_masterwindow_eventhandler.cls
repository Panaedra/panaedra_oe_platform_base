{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
using paninui.view.init.events.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class paninui.view.init.events.sc_sgt_masterwindow_eventhandler   : 

  /****************************** Source Header ********************************\

      Description: Static Class Singleton implementation for Masterwindow / MDI Window

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable p_oSgt#            as sc_sgt_masterwindow_eventhandler no-undo.
  define public           variable cInitialPack       as character                        no-undo.
  define public           variable cInitialPackCfg    as character                        no-undo.
  define public           variable oInitialPack       as paninui.pack.interfaces.i_pack   no-undo.
  define public           variable bInitialPackExtras as logical                          no-undo.

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
       like this and crash often.
       -Shown-
       Shown is fired just after the window is shown. Because of the work done in the
       initializion of the paninUi screen objects, for about one second an ugly
       partially painted MDI screen is shown.
       However, the Eclipse debugger likes this and doesn't crash (well, far less often anyway).
     */
    
    do on error undo, throw:
    
      /* This method is called if there is no eclipse debugger. 
         From the eclipse debugger, only MdiOnShown is called. */
      if cInitialPackCfg = "" then
        oInitialPack = dynamic-new cInitialPack().
      else
        oInitialPack = dynamic-new cInitialPack(cInitialPackCfg).
      
      if valid-object(oInitialPack) then oInitialPack:LoadPack(oMdiWindow, ? /* no parent frame, directly on mdi */).
    
      cast(sender,System.Windows.Forms.Form):Load:Unsubscribe(this-object:MdiOnLoad).

      catch ex as Progress.Lang.Error :
        panaedra.msroot.msutil.logic.sc_showexception:ShowException(ex).
      end catch.
      
    end.
    
  end method. /* MdiOnLoad */


  method public void MdiOnShown(input sender as System.Object, input e as System.EventArgs ):
    
    /* Note: "Load" and "Shown" are functionally the same in paninUi.
       However, both have some side effects:
       -Load-
       Load is fired before the window is shown. Everything is nice and hidden this way.
       However, the Eclipse debugger (ánd the Visual Studio debugger for that matter) don't
       like this and crash often.
       -Shown-
       Shown is fired just after the window is shown. Because of the work done in the
       initializion of the paninUi screen objects, for about one second an ugly
       partially painted MDI screen is shown.
       However, the Eclipse debugger likes this and doesn't crash (well, far less often anyway).
     */
    
    if os-getenv("ECLIPSE_PROJECT") > "" then 
    do:
      /* This means the eclipse debugger is running; Startup is postponed to the 
         "Shown" event for less crashes (but uglier screen at startup) 
      */
      if oInitialPack = ? then 
      do:
        if cInitialPackCfg = "" then
          oInitialPack = dynamic-new cInitialPack().
        else
          oInitialPack = dynamic-new cInitialPack(cInitialPackCfg).
        if valid-object(oInitialPack) then oInitialPack:LoadPack(oMdiWindow, ? /* no parent frame, directly on mdi */).
      end.
    end.
    
    /* The rest of this method always fires, eclipse or no eclipse. */
    
    cast(sender,System.Windows.Forms.Form):Shown:Unsubscribe(this-object:MdiOnShown).

    if valid-object(oInitialPack) then 
    do:
      oInitialPack:ShowMdi(oMdiWindow).
      /* And fire the "Shown" logic, always last after LoadPack */
      oInitialPack:ShowPack().
    end.

    catch ex as Progress.Lang.Error :
      panaedra.msroot.msutil.logic.sc_showexception:ShowException(ex).
    end catch.
    
  end method.

end class.

/* EOF */
