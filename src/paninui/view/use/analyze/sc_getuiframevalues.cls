{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using paninui.view.interfaces.*.
using paninui.view.use.*.
using paninui.view.init.display.*.
using panaedra.msroot.msdr.interfaces.*.
using paninui.view.use.events.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class paninui.view.use.analyze.sc_getuiframevalues   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/analyze/sc_getuiframevalues.cls $ 
          Version: $Revision: 6 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:11+01:00 $ 

      Description: Functionality to get UI frame values

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_getuiframevalues(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 6 $', '{&sourcecontrolversions}').
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


  method public static datetime-tz GetUiValueDatetimeTz(
    
    /* Directly set any property of a combobox widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.
    define variable dtmReturn#          as datetime-tz          no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "combobox", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      GetUiValueImplement(oWidget#, cPropertyIP#, output dtmReturn#).
      
    return dtmReturn#.

  end method. /* GetUiValue ; ComboBox */


  method public static integer GetUiValueInt(
    
    /* Directly set any property of a grid widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oGridOVID#      as i_widgettype_grid,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.
    define variable iReturn#            as integer              no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "grid", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      GetUiValueImplement(oWidget#, cPropertyIP#, output iReturn#).
    
    return iReturn#.

  end method. /* GetUiValue ; ComboBox */


  method public static c_uivalue_selection GetUiValueSelection( /* codeQok#7302 */

    oFrmLogicIP#    as i_frmlogic,
    oGridOVID#      as i_widgettype_grid,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
  
    define variable bIsDisplayLinkedOP# as logical                                     no-undo.
    define variable oWidget#            as Progress.Lang.Object                        no-undo.
    define variable oSelection#         as paninui.view.use.events.c_uivalue_selection no-undo.
    define variable iDummy#             as integer                                     no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "grid", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      oSelection# = _sys_GetUiValueSelectionImplement(oWidget#, cPropertyIP#, iDummy#).
      
    return oSelection#.  


  end method. /* SetUiValue ; Grid + c_uivalue_selection */
  

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


  method public static integer GetUiValueInt(
    
    /* Directly set any property of a groupframe widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#     as i_frmlogic,
    oGroupFrameOVID# as i_widgettype_groupframe,
    cWidgetNameIP#   as character,
    cPropertyIP#     as character):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.
    define variable iValue#             as integer              no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "groupframe", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      GetUiValueImplement(oWidget#, cPropertyIP#, output iValue#).
    
    return iValue#.
    
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
      /* Cast to string is necessary, for example with property "FirstDisplayedScrollingRowIndex" .
         Otherwise, we get a meaningless handle in the iValueOP#.
      */
      iValueOP# = int(string(oValue#)).
    end.

  end method. /* GetUiValueImplement */


  method protected static void GetUiValueImplement(
    
    /* Directly set any property of any widget to a new value, without databinding.
     */
    
    oWidgetIP#         as Progress.Lang.Object,
    cPropertyIP#       as character,
    output dtmValueOP# as datetime-tz):

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
      &if int(entry(1, proversion, ".")) >= 11 and int(entry(2, proversion, ".")) >= 3 &then /* OE11.3+ */  
      dtmValueOP# = oValue#.
      &else
      /* Earlier progress versions:
         Cast to string is necessary, for example with property "FirstDisplayedScrollingRowIndex" .
         Otherwise, we get a meaningless handle in the iValueOP#.
      */
      define variable oDateTime# as System.DateTime no-undo.
      oDateTime# = cast(cast(oValue#,Progress.Lang.Object),System.DateTime).
      dtmValueOP# = datetime-tz(oDateTime#:Month,oDateTime#:Day,oDateTime#:Year,oDateTime#:Hour,oDateTime#:Minute,oDateTime#:Second,oDateTime#:MilliSecond).
      &endif
    end.

  end method. /* GetUiValueImplement */


  method public static paninui.view.use.events.c_uivalue_selection _sys_GetUiValueSelectionImplement(
    
    /* Directly set any property of any widget to a new value, without databinding.
     */
    
    oWidgetIP#           as Progress.Lang.Object,
    cPropertyIP#         as character,
    iLimitExtentIP#      as integer):
    
    define variable oSelectionOP#         as paninui.view.use.events.c_uivalue_selection             no-undo.
    
    define variable oValue#               as System.Object                                           no-undo.

    define variable oFormsGrid#           as System.Windows.Forms.DataGridView                       no-undo.
    define variable bFirst#               as logical                                                 no-undo init true.
    define variable iRow#                 as integer                                                 no-undo.
    define variable iCell#                as integer                                                 no-undo.
    define variable oGridSelection_Rows#  as System.Windows.Forms.DataGridViewSelectedRowCollection  no-undo.
    define variable oGridSelection_Cells# as System.Windows.Forms.DataGridViewSelectedCellCollection no-undo.
    define variable oGridCell#            as System.Windows.Forms.DataGridViewCell                   no-undo.
    define variable iCellsToRows#         as int64                                                   no-undo extent. 
    define variable iMaxExtent#           as integer                                                 no-undo.
    define variable oOwningRow#           as System.Windows.Forms.DataGridViewRow                    no-undo.
    define variable iGenericID#           as int64                                                   no-undo.
    define variable cIDFieldName#         as character                                               no-undo.
 
    if cPropertyIP# <> "Rows" then 
    do:
      undo, throw new AppError(subst("For GetUiValueSelection, Property should be 'Rows' at this moment. '&1'.", cPropertyIP#), 99950123).
    end.
 
    /* The grid selection is abstracted to a c_uivalue_selection object. 
    */
    if valid-object(oWidgetIP#) and type-of(oWidgetIP#, System.Windows.Forms.DataGridView) then 
    do:
      
      oFormsGrid# = cast(oWidgetIP#, System.Windows.Forms.DataGridView).
      
      oSelectionOP# = new c_uivalue_selection(oFormsGrid#:Name, oFormsGrid#:Enabled, oFormsGrid#:Visible).
      
      assign
        oGridSelection_Rows#  = oFormsGrid#:SelectedRows
        oGridSelection_Cells# = oFormsGrid#:SelectedCells.
        
      if oGridSelection_Rows#:Count > 0 then 
      do: 

        assign
          iMaxExtent#   = oGridSelection_Rows#:Count
          cIDFieldName# = entry(num-entries(oFormsGrid#:Name,"_"),oFormsGrid#:Name,"_") +
            "__iID" +
            entry(num-entries(oFormsGrid#:Name,"_"),oFormsGrid#:Name,"_").
        
        if iLimitExtentIP# > 0 then iMaxExtent# = min(iLimitExtentIP#, iMaxExtent#).
        /* Find the selected rows and put them in a flexible extent property */
        extent(oSelectionOP#:iSelectionID_Rows) = iMaxExtent#.
        do iRow# = 0 to iMaxExtent# - 1:
          /* Get the iID value and put it in the uivalue array, to give to the subscribers */
          oSelectionOP#:iSelectionID_Rows[iRow# + 1] = int64(cast(cast(oGridSelection_Rows#:Item[iRow#],Progress.Lang.Object),System.Windows.Forms.DataGridViewRow):Cells[
            cIDFieldName# 
            ]:Value:ToString()).
        end.
        
      end.
      else 
      do:
        if oGridSelection_Cells#:Count > 0 then 
        do:
                
          /* Find the selected Cells and put them in a flexible extent */

          /* Limit extent if called from SelectionChanged (or other) UI event; 
             Large arrays don't go well as an event object between .net and progress 10.2A02.
             If you need more/all you can always ask GetUiValueSelection.
           */
                 
          assign
            iMaxExtent#   = oGridSelection_Cells#:Count
            cIDFieldName# = entry(num-entries(oFormsGrid#:Name,"_"),oFormsGrid#:Name,"_") +
              "__iID" +
              entry(num-entries(oFormsGrid#:Name,"_"),oFormsGrid#:Name,"_").
              
          if iLimitExtentIP# > 0 then iMaxExtent# = min(iLimitExtentIP#, iMaxExtent#).
          extent(iCellsToRows#) = iMaxExtent#.
          
          do iCell# = 0 to iMaxExtent# - 1:
            /* Get the iID value and put it in the uivalue array, to give to the subscribers
               For now, only "Rows" is supported.
             */
            oOwningRow# = cast(cast(oGridSelection_Cells#:Item[iCell#],Progress.Lang.Object),System.Windows.Forms.DataGridViewCell):OwningRow.
            
            if oOwningRow#:Cells[cIDFieldName#]:Value = ? then 
            do:
              undo, throw new c_panaedraexception(
                99958211,
                sc_lang:oEnglish,
                substitute("Error: The column '&1' of grid '&2' has no value. Is databinding properly set up? Is the iID field of the temp-table filled?", cIDFieldName#,
                if valid-object(oFormsGrid#) then oFormsGrid#:Name else "")
                ).
            end.
            else 
            do:
              iGenericID# = int64(oOwningRow#:Cells[cIDFieldName#]:Value:ToString()).
              iCellsToRows#[iCell# + 1] = iGenericID#.
            end.
          end.
          
          /* Remove duplicate rows */
          oSelectionOP#:iSelectionID_Rows = panaedra.msroot.msutil.logic.sc_array_calculations:ArrayRemoveDuplicates(iCellsToRows#).

          /* Cleanup resources */
          extent(iCellsToRows#) = ?.
                
        end.
      end.
    end.
    
    return oSelectionOP#.
    
  end method. /* GetUiValueImplement */

end class.

/* EOF */ 
