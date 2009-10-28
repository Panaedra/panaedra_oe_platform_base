{panaedra/msi/logic/ctop_class.i} 
using paninui.view.interfaces.*.
using paninui.view.use.*.
using paninui.view.init.display.*.
using panaedra.msroot.msdr.interfaces.*.

class paninui.view.use.analyze.sc_getuiframevalues   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/analyze/sc_getuiframevalues.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-28 15:21:29+01:00 $ 
    Date Modified: $Modtime: 2009-10-28 15:21:29+01:00 $ 

      Description: add_your_comments_here

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_getuiframevalues(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  method public static character GetUiValue(
    
    /* Directly set any property of any widget to a new value, without databinding.
       For example: 
       Visible property to "false", 
       Text property to "Mr Johnson", 
       or BackColor property to "MediumUrgency". (*) Naming real colors is dependant on locale 
                                                     and *not* suitable for the database logic layer.
                                                     Color indicators should be (per-user-or-environment-)
                                                     mapped in the view layer.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):

    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.
    define variable cValue#             as character            no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "any", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      GetUiValueImplement(oWidget#, cPropertyIP#, output cValue#).
      
    return cValue#.
    
  end method. /* GetUiValue ; direct version with no OVID# for widgettype. Can cause (predictable) name clashes; btnTryout and cbTryout for example. */


  method public static character GetUiValue(
    
    /* Directly set any property of a combobox widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.
    define variable cValue#             as character            no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "combobox", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      GetUiValueImplement(oWidget#, cPropertyIP#, output cValue#).
    
    return cValue#.
    
  end method. /* GetUiValue ; ComboBox */


  method public static integer GetUiValueInt(
    
    /* Directly set any property of a combobox widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.
    define variable iReturn#            as integer              no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "combobox", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      GetUiValueImplement(oWidget#, cPropertyIP#, output iReturn#).
      
    return iReturn#.  

  end method. /* GetUiValue ; ComboBox */


  method public static character GetUiValue(
    
    /* Directly set any property of a button widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oButtonOVID#    as i_widgettype_button,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.
    define variable cValue#             as character            no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "button", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      GetUiValueImplement(oWidget#, cPropertyIP#, output cValue#).
      
    return cValue#.
    
  end method. /* GetUiValue ; Button */


  method public static character GetUiValue(
    
    /* Directly set any property of a groupframe widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#     as i_frmlogic,
    oGroupFrameOVID# as i_widgettype_groupframe,
    cWidgetNameIP#   as character,
    cPropertyIP#     as character):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.
    define variable cValue#             as character            no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "groupframe", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      GetUiValueImplement(oWidget#, cPropertyIP#, output cValue#).
    
    return cValue#.
    
  end method. /* GetUiValue ; Groupframe */


  method public static character GetUiValue(
    
    /* Directly set any property of a grid widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oGridOVID#      as i_widgettype_grid,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.
    define variable cValue#             as character            no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "grid", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      GetUiValueImplement(oWidget#, cPropertyIP#, output cValue#).
    
    return cValue#.
    
  end method. /* GetUiValue ; Grid */


  method protected static void GetUiValueImplement(
    
    /* Directly set any property of any widget to a new value, without databinding.
     */
    
    oWidgetIP#       as Progress.Lang.Object,
    cPropertyIP#     as character,
    output cValueOP# as character):

    define variable oControl# as System.Object no-undo.
    define variable oValue#   as System.Object no-undo.

    /* We only support Text or Int objects for cValueIP#, and we can convert this to other objects
       later in time 
       (I.e. "green" to Color object etc.; in WPF we can use existing Type Converters) 
    */
    if valid-object(oWidgetIP#) then 
    do:
      oControl# = cast(oWidgetIP#, System.Object).
      paninui.view.use.sys_display._sys_sc_display:_sys_GetUiValue(oControl#, cPropertyIP#, output oValue#).
      cValueOP# = string(oValue#).
    end.

  end method. /* GetUiValueImplement */


  method protected static void GetUiValueImplement(
    
    /* Directly set any property of any widget to a new value, without databinding.
     */
    
    oWidgetIP#       as Progress.Lang.Object,
    cPropertyIP#     as character,
    output iValueOP# as integer):

    define variable oControl# as System.Object no-undo.
    define variable oValue#   as System.Object no-undo.

    /* We only support Text or Int objects for cValueIP#, and we can convert this to other objects
       later in time 
       (I.e. "green" to Color object etc.; in WPF we can use existing Type Converters) 
    */
    if valid-object(oWidgetIP#) then 
    do:
      oControl# = cast(oWidgetIP#, System.Object).
      paninui.view.use.sys_display._sys_sc_display:_sys_GetUiValue(oControl#, cPropertyIP#, output oValue#).
      iValueOP# = int(oValue#).
    end.

  end method. /* GetUiValueImplement */

end class.

/* EOF */ 
