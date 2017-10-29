{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class paninui.view.use.events.c_uieventdata
  &if not (opsys = "unix" or "{&window-system}" = "tty") &then
  inherits paninui.view.use.events.c_uieventargs
  &endif
  implements
  paninui.view.interfaces.i_uieventdata
  : 

  /****************************** Source Header ********************************\

      Description: Data to be transmitted to custom UI paninUi event handlers in 
                   the UI logic objects (the "trigger logic methods").

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  &if opsys = "unix" or "{&window-system}" = "tty" &then
    &glob Generic_Object Progress.Lang.Object
  &else
    &glob Generic_Object System.Object
  &endif
  
  define public property cData   as character                          no-undo get. set.
  define public property cInfo   as character                          no-undo get. set.
  define public property oObject as {&Generic_Object}                  no-undo get. set.
                                                                       
  define public property iPackID   as int64     no-undo get. 
    protected set.

  define public property iFocusPackID   as int64     no-undo get. /* For a global event delegate, like a common shortcut key, iPackID is the owner of the event, and iFocusPackID is the pack that had focus at the firing of the event */
    protected set.

  define public property oUiValue as paninui.view.interfaces.i_uivalue no-undo get. 
    protected set.

  constructor public c_uieventdata(
    cInfoIP#        as character, 
    cDataIP#        as character, 
    oObjectIP#      as {&Generic_Object}, 
    iPackIdIP#      as int64, 
    iFocusPackIdIP# as int64, 
    oUiValueIP#     as paninui.view.interfaces.i_uivalue):
  
    assign 
      cInfo        = cInfoIP#
      cData        = cDataIP#
      oObject      = oObjectIP#
      iPackID      = iPackIdIP#
      iFocusPackID = iFocusPackIdIP#
      oUiValue     = oUiValueIP#.
  
  end constructor.
  
end class.

/* EOF */ 
