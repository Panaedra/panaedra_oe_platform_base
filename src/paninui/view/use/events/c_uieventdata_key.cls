{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class paninui.view.use.events.c_uieventdata_key 
  inherits 
  paninui.view.use.events.c_uieventdata_handled
  implements
  paninui.view.interfaces.i_uieventdata
  : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/events/c_uieventdata_key.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:11+01:00 $ 

      Description: Data to be transmitted to custom UI paninUi event handlers in 
                   the UI logic objects (the "trigger logic methods").

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_uieventdata_key(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    super(o-sourcecontrol, this-object).
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
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
  
end class.

/* EOF */ 
