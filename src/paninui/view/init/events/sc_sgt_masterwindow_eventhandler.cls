{panaedra/msi/logic/ctop_class.i}
using paninui.view.init.events.*.

class paninui.view.init.events.sc_sgt_masterwindow_eventhandler   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/init/events/sc_sgt_masterwindow_eventhandler.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-04 08:02:43+02:00 $ 
    Date Modified: $Modtime: 2009-09-03 11:03:16+02:00 $ 

      Description: Static Class Singleton implementation for Masterwindow / MDI Window

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_sgt_masterwindow_eventhandler(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
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

  method public void MdiOnShown(input sender as System.Object, input e as System.EventArgs ):
		
    tool.sc-trayicon-win32:ShowTrayIconMessage(program-name(1),"mdi").

    define variable oPack# as paninui.view.interfaces.i_pack no-undo.
   
   
   /* Later via: [RunObject] session parameter */

    oPack# = dynamic-new "panaedra.ar.pack.c_pack__DATA_" ().

    oPack#:LoadForm(oMdiWindow).

    catch ex as Progress.Lang.Error :
      tool.sc-showexception-win32:ShowException(ex).
    end catch.
    
  end method.

end class.

/* EOF */
