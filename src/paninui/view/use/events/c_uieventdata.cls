{panaedra/msi/logic/ctop_class.i} 

class paninui.view.use.events.c_uieventdata
  implements
  paninui.view.interfaces.i_uieventdata
  : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/events/c_uieventdata.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-17 16:35:36+02:00 $ 
    Date Modified: $Modtime: 2009-10-17 16:34:54+02:00 $ 

      Description: Data to be transmitted to custom UI paninUi event handlers in 
                   the UI logic objects (the "trigger logic methods").

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_uieventdata(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  &if opsys = "unix" or "{&window-system}" = "tty" &then
    &glob Generic_Object Progress.Lang.Object
  &else
    &glob Generic_Object System.Object
  &endif
  
  define public property cData   as character     no-undo get. set.
  define public property cInfo   as character     no-undo get. set.
  define public property oObject as {&Generic_Object} no-undo get. set.

  define public property oUiValue as paninui.view.interfaces.i_uivalue get. 
    protected set.

  constructor public c_uieventdata(cInfoIP# as character, cDataIP# as character, oObjectIP# as {&Generic_Object}, oUiValueIP# as paninui.view.interfaces.i_uivalue):
  
    assign 
      cInfo    = cInfoIP#
      cData    = cDataIP#
      oObject  = oObjectIP#
      oUiValue = oUiValueIP#.
  
  end constructor.
  
end class.

/* EOF */ 