{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using paninui.view.interfaces.*.
using paninui.view.use.*.
using paninui.view.init.display.*.
using panaedra.msroot.msdr.interfaces.*.
using paninui.view.interfaces.*.
using paninui.view.use.analyze.*.

class paninui.logic.logicbase.c_framelogic_shortcut: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/logic/logicbase/c_framelogic_shortcut.cls $ 
          Version: $Revision: 8 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-02-03 07:50:42+01:00 $ 
    Date Modified: $Modtime: 2010-02-03 04:18:17+01:00 $ 

      Description: Provides a shortcut object to be used in frame logic classes.
                   Only links methods to other methods, technically not required,
                   but makes it easier to program frame logic and makes the code
                   neater.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_framelogic_shortcut(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 8 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected variable oFrmLogic   as paninui.view.interfaces.i_frmlogic no-undo.

  
  constructor public c_framelogic_shortcut(oFrmLogicIP# as paninui.view.interfaces.i_frmlogic):
    
    assign
      oFrmLogic   = oFrmLogicIP#.
    
  end constructor.


  method public character GetUiValue(
    
    /* Directly set any property of any widget to a new value, without databinding.
       For example: 
       Visible property to "false", 
       Text property to "Mr Johnson", 
       or BackColor property to "MediumUrgency". (*) Naming real colors is dependant on locale 
                                                     and *not* suitable for the database logic layer.
                                                     Color indicators should be (per-user-or-environment-)
                                                     mapped in the view layer.
     */
    
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    return sc_getuiframevalues:GetUiValue(oFrmLogic, cWidgetNameIP#, cPropertyIP#).
    
  end method. /* GetUiValue ; direct version with no OVID# for widgettype. Can cause (predictable) name clashes; btnTryout and cbTryout for example. */


  method public character GetUiValue(
    
    /* Directly set any property of a combobox widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    return sc_getuiframevalues:GetUiValue(oFrmLogic, oComboBoxOVID#, cWidgetNameIP#, cPropertyIP#).
    
  end method. /* GetUiValue ; ComboBox */


  method public integer GetUiValueInt(
    
    /* Directly set any property of a combobox widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    return sc_getuiframevalues:GetUiValueInt(oFrmLogic, oComboBoxOVID#, cWidgetNameIP#, cPropertyIP#).

  end method. /* GetUiValue ; ComboBox */


  method public integer GetUiValueInt(
    
    /* Directly get any property of a grid widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oGridOVID#      as i_widgettype_grid,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    return sc_getuiframevalues:GetUiValueInt(oFrmLogic, oGridOVID#, cWidgetNameIP#, cPropertyIP#).

  end method. /* GetUiValue ; ComboBox */
  

  method public datetime-tz GetUiValueDateTime(
    
    /* Directly get any property of a combobox widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    return sc_getuiframevalues:GetUiValueDateTimeTz(oFrmLogic, oComboBoxOVID#, cWidgetNameIP#, cPropertyIP#).

  end method. /* GetUiValue ; ComboBox */


  method public paninui.view.use.events.c_uivalue_selection GetUiValueSelection(

    oGridOVID#      as i_widgettype_grid,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
  
    return sc_getuiframevalues:GetUiValueSelection(oFrmLogic, oGridOVID#, cWidgetNameIP#, cPropertyIP#).

  end method. /* SetUiValue ; Grid + c_uivalue_selection */


  method public character GetUiValue(
    
    /* Directly set any property of a button widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oButtonOVID#    as i_widgettype_button,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    return sc_getuiframevalues:GetUiValue(oFrmLogic, oButtonOVID#, cWidgetNameIP#, cPropertyIP#).
    
  end method. /* GetUiValue ; Button */


  method public character GetUiValue(
    
    /* Directly set any property of a groupframe widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oGroupFrameOVID# as i_widgettype_groupframe,
    cWidgetNameIP#   as character,
    cPropertyIP#     as character):
      
    return sc_getuiframevalues:GetUiValue(oFrmLogic, oGroupFrameOVID#, cWidgetNameIP#, cPropertyIP#).
    
  end method. /* GetUiValue ; Groupframe */


  method public integer GetUiValueInt(
    
    /* Directly set any property of a groupframe widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oGroupFrameOVID# as i_widgettype_groupframe,
    cWidgetNameIP#   as character,
    cPropertyIP#     as character):
      
    return sc_getuiframevalues:GetUiValueInt(oFrmLogic, oGroupFrameOVID#, cWidgetNameIP#, cPropertyIP#).
    
  end method. /* GetUiValue ; Groupframe */


  method public character GetUiValue(
    
    /* Directly set any property of a grid widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oGridOVID#    as i_widgettype_grid,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    return sc_getuiframevalues:GetUiValue(oFrmLogic, oGridOVID#, cWidgetNameIP#, cPropertyIP#).
    
  end method. /* GetUiValue ; Grid */


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
    
    /* Directly set a special semi-property like "Focus" of a combobox widget, without databinding.
     */
    
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oComboBoxOVID#, cWidgetNameIP#, cPropertyIP#).
    
  end method. /* SetUiValue ; ComboBox - only property name (like Focus) */


  method public void SetUiValue(
    
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    iValueIP#       as integer):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oComboBoxOVID#, cWidgetNameIP#, cPropertyIP#, iValueIP#).

  end method. /* SetUiValue ; ComboBox + integer */


  method public void SetUiValue(
    
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    bValueIP#       as logical):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oComboBoxOVID#, cWidgetNameIP#, cPropertyIP#, bValueIP#).

  end method. /* SetUiValue ; ComboBox + integer */


  method public void SetUiValue(
    
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    dtmValueIP#     as datetime-tz):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oComboBoxOVID#, cWidgetNameIP#, cPropertyIP#, dtmValueIP#).

  end method. /* SetUiValue ; ComboBox + integer */


  method public void SetUiValue(
    
    oGridOVID#      as i_widgettype_grid,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    iValueIP#       as integer):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oGridOVID#, cWidgetNameIP#, cPropertyIP#, iValueIP#).

  end method. /* SetUiValue ; Grid + integer */


  method public void SetUiValue(
    
    oGridOVID#      as i_widgettype_grid,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    bValueIP#       as logical):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oGridOVID#, cWidgetNameIP#, cPropertyIP#, bValueIP#).

  end method. /* SetUiValue ; Grid + integer */


  method public void SetUiValue(
    
    oGridItemOVID#     as i_widgettype_griditem,
    cWidgetNameIP#     as character,
    cWidgetItemNameIP# as character,
    cPropertyIP#       as character,
    bValueIP#          as logical):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oGridItemOVID#, cWidgetNameIP#, cWidgetItemNameIP#, cPropertyIP#, bValueIP#).

  end method.


  method public void SetUiValue(
    
    oButtonOVID#    as i_widgettype_button,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    cValueIP#       as character):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oButtonOVID#, cWidgetNameIP#, cPropertyIP#, cValueIP#).

  end method. /* SetUiValue ; Button */


  method public void SetUiValue(
    
    oButtonOVID#    as i_widgettype_button,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    bValueIP#       as logical):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oButtonOVID#, cWidgetNameIP#, cPropertyIP#, bValueIP#).

  end method. /* SetUiValue ; Button + logical */


  method public void SetUiValue(
    
    oGroupFrameOVID# as i_widgettype_groupframe,
    cWidgetNameIP#   as character,
    cPropertyIP#     as character,
    cValueIP#        as character):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oGroupFrameOVID#, cWidgetNameIP#, cPropertyIP#, cValueIP#).

  end method. /* SetUiValue ; Groupframe */


  method public void SetUiValue(
    
    oGroupFrameOVID# as i_widgettype_groupframe,
    cWidgetNameIP#   as character,
    cPropertyIP#     as character,
    bValueIP#        as logical):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oGroupFrameOVID#, cWidgetNameIP#, cPropertyIP#, bValueIP#).

  end method. /* SetUiValue ; Groupframe */


  method public void SetUiValue(
    
    oGroupFrameOVID# as i_widgettype_groupframe,
    cWidgetNameIP#   as character,
    cPropertyIP#     as character,
    iValueIP#        as integer):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oGroupFrameOVID#, cWidgetNameIP#, cPropertyIP#, iValueIP#).

  end method. /* SetUiValue ; Groupframe */


  method public void SetUiValue(
    
    oButtonOVID#    as i_widgettype_grid,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    cValueIP#       as character):
      
    paninui.view.use.display.sc_displaydata:SetUiValue(oFrmLogic, oButtonOVID#, cWidgetNameIP#, cPropertyIP#, cValueIP#).

  end method. /* SetUiValue ; Grid */


  method public void RefreshData(
  
    iGridOVIP#     as i_widgettype_grid,
    cWidgetNameIP# as character,
    oQryIP#        as i_qry):

    paninui.view.use.display.sc_displaydata:RefreshData(oFrmLogic, iGridOVIP#, cWidgetNameIP#, oQryIP#).
      
  end method. /* RefreshData ; Grid + i_qry */


  method public void AppendText(
  
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cTextIP#        as character):

    paninui.view.use.display.sc_displaydata:AppendText(oFrmLogic, oComboBoxOVID#, cWidgetNameIP#, cTextIP#).
  
  end method. /* AppendText */

end class.

/* EOF */ 
