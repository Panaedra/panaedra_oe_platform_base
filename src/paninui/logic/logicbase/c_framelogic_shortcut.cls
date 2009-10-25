{panaedra/msi/logic/ctop_class.i} 
using paninui.view.interfaces.*.
using paninui.view.use.*.
using paninui.view.init.display.*.
using panaedra.msroot.msdr.interfaces.*.

class paninui.logic.logicbase.c_framelogic_shortcut: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/logic/logicbase/c_framelogic_shortcut.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-25 21:17:24+01:00 $ 
    Date Modified: $Modtime: 2009-10-25 21:16:19+01:00 $ 

      Description: Provides a shortcut object to be used in frame logic classes.
                   Only links methods to other methods, technically not required,
                   but makes it easier to program frame logic and makes the code
                   neater.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_framelogic_shortcut(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define variable oFrmLogic as paninui.view.interfaces.i_frmlogic no-undo.

  
  constructor public c_framelogic_shortcut(oFrmLogicIP# as paninui.view.interfaces.i_frmlogic):
    
    oFrmLogic = oFrmLogicIP#.
    
  end constructor.

  method public void SetUiValue(
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    cValueIP#       as character):

    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, cWidgetNameIP#, cPropertyIP#, cValueIP#).

  end method. /* SetUiValue ; direct version with no OVID# for widgettype. Can cause (predictable) name clashes; btnTryout and cbTryout for example. */


  method public void SetUiValue(
    
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    cValueIP#       as character):

    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oComboBoxOVID#, cWidgetNameIP#, cPropertyIP#, cValueIP#).

  end method. /* SetUiValue ; ComboBox */


  method public void SetUiValue(
    
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    iValueIP#       as integer):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oComboBoxOVID#, cWidgetNameIP#, cPropertyIP#, iValueIP#).

  end method. /* SetUiValue ; ComboBox */


  method public void SetUiValue(
    
    oButtonOVID#    as i_widgettype_button,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    cValueIP#       as character):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oButtonOVID#, cWidgetNameIP#, cPropertyIP#, cValueIP#).

  end method. /* SetUiValue ; Button */


  method public void SetUiValue(
    
    oGroupFrameOVID# as i_widgettype_groupframe,
    cWidgetNameIP#   as character,
    cPropertyIP#     as character,
    cValueIP#        as character):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oGroupFrameOVID#, cWidgetNameIP#, cPropertyIP#, cValueIP#).

  end method. /* SetUiValue ; Groupframe */


  method public void SetUiValue(
    
    oButtonOVID#    as i_widgettype_grid,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    cValueIP#       as character):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oButtonOVID#, cWidgetNameIP#, cPropertyIP#, cValueIP#).

  end method. /* SetUiValue ; Grid */

end class.

/* EOF */ 
