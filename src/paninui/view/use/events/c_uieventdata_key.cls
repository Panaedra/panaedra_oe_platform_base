{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class paninui.view.use.events.c_uieventdata_key 
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
  
  define public variable cCasedLetter as character no-undo case-sensitive.
  
  define public property cKeyCode as character no-undo get. 
    protected set.
  define public property bShift as logical no-undo get. 
    protected set.
  define public property bCtrl as logical no-undo get. 
    protected set.
  define public property bAlt as logical no-undo get. 
    protected set.
  
  
  constructor private c_uieventdata_key(
  
    cInfoIP#        as character, 
    cDataIP#        as character, 
    oObjectIP#      as {&Generic_Object}, 
    iPackIdIP#      as int64, 
    iFocusPackIdIP# as int64, 
    oUiValueIP#     as paninui.view.interfaces.i_uivalue):

    super(cInfoIP#,cDataIP#,oObjectIP#,iPackIdIP#,iFocusPackIdIP#,oUiValueIP#).
    
  end constructor.

  
  constructor public c_uieventdata_key(
  
    cInfoIP#         as character, 
    cDataIP#         as character, 
    oObjectIP#       as {&Generic_Object}, 
    iPackIdIP#       as int64, 
    iFocusPackIdIP#  as int64, 
    oUiValueIP#      as paninui.view.interfaces.i_uivalue,
    cKeyCodeIP#      as character,
    cCasedLetterIP#  as character,
    bShiftIP#        as logical,
    bCtrlIP#         as logical,
    bAltIP#          as logical):
    
    super(cInfoIP#,cDataIP#,oObjectIP#,iPackIdIP#,iFocusPackIdIP#,oUiValueIP#).
      
    assign 
      cInfo        = cInfoIP#
      cData        = cDataIP#
      oObject      = oObjectIP#
      iPackID      = iPackIdIP#
      oUiValue     = oUiValueIP#
      cKeyCode     = cKeyCodeIP#
      cCasedLetter = cCasedLetterIP#
      bShift       = bShiftIP#
      bCtrl        = bCtrlIP#
      bAlt         = bAltIP#.
  
  end constructor.
  
  
  method public override character ToString():
    
    return substitute(
      "&1 &2 info: &3 data: &4 object: &5 pack: &6 uivalue: &7 keycode: &8 casedletter: &9",
      super:ToString(),
      substitute("Ctrl/Alt/Shift=&1/&2/&3", bCtrl, bAlt, bShift),
      cInfo        ,
      cData        ,
      oObject      ,
      iPackID      ,
      oUiValue     ,
      cKeyCode     ,
      cCasedLetter 
      ).
    
  end method. /* ToString */
  
end class.

/* EOF */ 
