{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class paninui.view.use.events.c_uieventdata_keypress 
  inherits 
  paninui.view.use.events.c_uieventdata_handled
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

  define public property bKeyCharChanged as logical no-undo get. 
    protected set.
  
  define public property cKeyChar as character no-undo get. set(cValueIP# as character):
      assign
        bKeyCharChanged = true 
        cKeyChar        = cValueIP#.
    end set.

  
  constructor private c_uieventdata_keypress(
  
    cInfoIP#        as character, 
    cDataIP#        as character, 
    oObjectIP#      as {&Generic_Object}, 
    iPackIdIP#      as int64, 
    iFocusPackIdIP# as int64, 
    oUiValueIP#     as paninui.view.interfaces.i_uivalue):

    super(cInfoIP#,cDataIP#,oObjectIP#,iPackIdIP#,iFocusPackIdIP#,oUiValueIP#).
    
  end constructor.

  
  constructor public c_uieventdata_keypress(
  
    cInfoIP#         as character, 
    cDataIP#         as character, 
    oObjectIP#       as {&Generic_Object}, 
    iPackIdIP#       as int64, 
    iFocusPackIdIP#  as int64, 
    oUiValueIP#      as paninui.view.interfaces.i_uivalue,
    cKeyCharIP#      as character):
    
    super(cInfoIP#,cDataIP#,oObjectIP#,iPackIdIP#,iFocusPackIdIP#,oUiValueIP#).
      
    assign 
      cInfo           = cInfoIP#
      cData           = cDataIP#
      oObject         = oObjectIP#
      iPackID         = iPackIdIP#
      oUiValue        = oUiValueIP#
      cKeyChar        = cKeyCharIP#
      bKeyCharChanged = false.
  
  end constructor.
  
end class.

/* EOF */ 
