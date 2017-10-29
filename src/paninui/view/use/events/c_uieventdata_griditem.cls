{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class paninui.view.use.events.c_uieventdata_griditem 
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
  
  define public property iIDCurrentRow as int64 no-undo get. 
    protected set.
  
  
  constructor private c_uieventdata_griditem(
  
    cInfoIP#        as character, 
    cDataIP#        as character, 
    oObjectIP#      as {&Generic_Object}, 
    iPackIdIP#      as int64, 
    iFocusPackIdIP# as int64, 
    oUiValueIP#     as paninui.view.interfaces.i_uivalue)
  :

    super(cInfoIP#,cDataIP#,oObjectIP#,iPackIdIP#,iFocusPackIdIP#,oUiValueIP#).
    
  end constructor.

  
  constructor public c_uieventdata_griditem(
  
    cInfoIP#         as character, 
    cDataIP#         as character, 
    oObjectIP#       as {&Generic_Object}, 
    iPackIdIP#       as int64, 
    iFocusPackIdIP#  as int64, 
    oUiValueIP#      as paninui.view.interfaces.i_uivalue,
    iIDCurrentRowIP# as int64):
    
    super(cInfoIP#,cDataIP#,oObjectIP#,iPackIdIP#,iFocusPackIdIP#,oUiValueIP#).
      
    assign 
      cInfo         = cInfoIP#
      cData         = cDataIP#
      oObject       = oObjectIP#
      iPackID       = iPackIdIP#
      iFocusPackId  = iFocusPackIdIP#
      oUiValue      = oUiValueIP#
      iIDCurrentRow = iIDCurrentRowIP#.
  
  end constructor.
  
end class.

/* EOF */ 
