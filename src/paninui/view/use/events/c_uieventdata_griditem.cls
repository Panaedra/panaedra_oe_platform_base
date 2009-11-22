{panaedra/msi/logic/ctop_class.i} 

class paninui.view.use.events.c_uieventdata_griditem 
  inherits 
  paninui.view.use.events.c_uieventdata_handled
  implements
  paninui.view.interfaces.i_uieventdata
  : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/events/c_uieventdata_griditem.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-11-22 23:39:07+01:00 $ 
    Date Modified: $Modtime: 2009-11-22 23:35:57+01:00 $ 

      Description: Data to be transmitted to custom UI paninUi event handlers in 
                   the UI logic objects (the "trigger logic methods").

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_uieventdata_griditem(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    super(o-sourcecontrol, this-object).
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  &if opsys = "unix" or "{&window-system}" = "tty" &then
    &glob Generic_Object Progress.Lang.Object
  &else
    &glob Generic_Object System.Object
  &endif
  
  define public property iIDCurrentRow as int64 get. 
    protected set.
  
  
  constructor private c_uieventdata_griditem(
  
    cInfoIP# as character, 
    cDataIP# as character, 
    oObjectIP# as {&Generic_Object}, 
    oUiValueIP# as paninui.view.interfaces.i_uivalue):

    super(cInfoIP#,cDataIP#,oObjectIP#,oUiValueIP#).
    
  end constructor.

  
  constructor public c_uieventdata_griditem(
  
    cInfoIP#         as character, 
    cDataIP#         as character, 
    oObjectIP#       as {&Generic_Object}, 
    oUiValueIP#      as paninui.view.interfaces.i_uivalue,
    iIDCurrentRowIP#      as int64):
    
    super(cInfoIP#,cDataIP#,oObjectIP#,oUiValueIP#).
      
    assign 
      cInfo         = cInfoIP#
      cData         = cDataIP#
      oObject       = oObjectIP#
      oUiValue      = oUiValueIP#
      iIDCurrentRow = iIDCurrentRowIP#.
  
  end constructor.
  
end class.

/* EOF */ 
