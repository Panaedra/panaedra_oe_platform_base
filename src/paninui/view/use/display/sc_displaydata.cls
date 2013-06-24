{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
using paninui.view.interfaces.*.
using paninui.view.init.display.*.
using paninui.view.use.*.
using paninui.view.use.analyze.*.
using paninui.view.use.display.*.

using panaedra.msroot.msdr.logic.*.
using panaedra.msroot.msdr.interfaces.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class paninui.view.use.display.sc_displaydata   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/display/sc_displaydata.cls $ 
          Version: $Revision: 30 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-02-03 07:50:42+01:00 $ 
    Date Modified: $Modtime: 2010-02-03 04:18:57+01:00 $ 

      Description: Display data on a paninUi frame.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_displaydata(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 30 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  method public static void DisplayData (
  
    oFrmLogicIP#     as i_frmlogic,
    iGroupFrameOVIP# as i_widgettype_groupframe,
    iTextOVIP#       as i_widgetproperty_text,
    cGroupNameIP#    as character,
    oBufIP#          as i_buf):

    define variable oBindingSourceStrong# as c_bindingsource                         no-undo.
    define variable oChildWidgets#        as Progress.Lang.Object                    no-undo extent.
    define variable iExtentSize#          as integer                                 no-undo.
    define variable iTell#                as integer                                 no-undo.
    define variable oBindableComponent#   as System.Windows.Forms.IBindableComponent no-undo.
    define variable oChildNames#          as character                               no-undo extent.

    define variable cLinkName#            as character                               no-undo.
    define variable cLinkNameAlt#         as character                               no-undo.
    
    paninui.view.use.sc_coll_widgetdata:GetLinkNameLinkNameAlt(
      "" /* No named reference, get directly from the buffer handle */,
      "bufferchilds", 
      oBufIP#:hBuffer, 
      output cLinkName#, 
      output cLinkNameAlt#).
    
    oChildWidgets# = sc_coll_widgetdata:GetChildWidgets(oFrmLogicIP#:iPackID, iGroupFrameOVIP#, cGroupNameIP#, output oChildNames#).
      
    iExtentSize# = extent(oChildWidgets#).
    
    if iExtentSize# > 0 then 
    do:
      
      if valid-object(oBufIP#:oBindingSource) then oBindingSourceStrong# = oBufIP#:oBindingSource.  
      else 
      do on error undo, throw:
        assign
          oBindingSourceStrong#  = new c_bindingsource(sc_bindingsourcetype:i_Buffer, oBufIP#:hBuffer)
          oBufIP#:oBindingSource = oBindingSourceStrong#.
        catch e as Progress.Lang.Error :
          undo, throw new Progress.Lang.AppError(subst("Error in sc_displaydata:DisplayData of a GroupFrame with Buffer '&1'~n&2", oBufIP#:ToString(), sc_showexception:ExceptionMsgToString(e)), e:GetMessageNum(1)).
        end catch.
      end.

      do iTell# = 1 to iExtentSize#:
        if type-of(oChildWidgets#[iTell#], System.Windows.Forms.IBindableComponent) 
          and num-entries(oChildNames#[iTell#],".") >= 2
          then 
        do: 
          if entry(1,oChildNames#[iTell#],".") = cLinkName#
            or
            ( cLinkNameAlt# > "" and entry(1,oChildNames#[iTell#],".") = cLinkNameAlt#)
            then 
          do:
            if entry(1,oChildNames#[iTell#],".") = cLinkName# then cLinkNameAlt#. /* Specific buffer name is found, 
                                                                                     use this for the rest of the matches */
            oBindableComponent# = cast(oChildWidgets#[iTell#], System.Windows.Forms.IBindableComponent).
            /* Create a new binding between 
               the binding source and the widget */
            oBindableComponent#:DataBindings:Add(
              new System.Windows.Forms.Binding(
              "Text", 
              oBindingSourceStrong#, 
              entry(2,oChildNames#[iTell#],"."), 
              true)).
          end.
        end.
      end. 
      
      /* Cleanup */
      assign
        extent(oChildWidgets#) = ?
        extent(oChildNames#)   = ?.
      
    end. /* We get something back in the extent */
    
  end method. /* DisplayData: GroupFrame child widgets Text property */
  
  
  method public static void DisplayData(
  
    oFrmLogicIP#   as i_frmlogic,
    iGridOVIP#     as i_widgettype_grid,
    cWidgetNameIP# as character,
    oQryIP#        as i_qry):
    
    define variable oWidget#              as Progress.Lang.Object no-undo.
    define variable oBindingSource#       as Progress.Lang.Object no-undo.
    define variable oBindingSourceStrong# as c_bindingsource      no-undo.
    define variable bIsDisplayLinkedOP#   as logical              no-undo.
    
    oWidget# = sc_coll_widgetdata:GetWidget(
      oFrmLogicIP#:iPackID, 
      "grid", 
      oQryIP#:sys__hQuery, 
      cWidgetNameIP#, 
      output bIsDisplayLinkedOP#).
    
    if not bIsDisplayLinkedOP# then 
    do:

      oBindingSource# = paninui.view.use.sc_coll_widgetdata:GetBindingSource(
        oFrmLogicIP#:iPackID, 
        "grid", 
        oQryIP#:sys__hQuery, 
        cWidgetNameIP#).

      DisplayDataSubGrid(
        oWidget#, 
        oQryIP#:sys__hQuery, 
        input-output oBindingSource#).

      if oBindingSource# <> ? then
        oBindingSourceStrong# = cast(oBindingSource#, c_bindingsource).
      else 
        oBindingSourceStrong# = ?.

      sc_coll_widgetdata:SetBindingSource(oWidget#, oBindingSourceStrong#, oQryIP#:sys__hQuery).

      oQryIP#:sys__oBindingSource = oBindingSourceStrong#.
      
      sc_coll_widgetdata:SetDisplayLinked(oWidget#).
      
    end. /* Not linked yet */
    
  end method. /* DisplayData: Grid + i_qry */


  method public static void DisplayData (
  
    oFrmLogicIP# as i_frmlogic,
    iGridOVIP#   as i_widgettype_grid,
    dataset-handle dsIP#,
    hBuffOrQueryOrRelationIP# as handle):
    
    define variable oWidget#            as Progress.Lang.Object no-undo.
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oBindingSource#     as Progress.Lang.Object no-undo.
    define variable hQuery#             as handle               no-undo.
    define variable hRelation#          as handle               no-undo.
    
    oWidget# = sc_coll_widgetdata:GetWidget(
      oFrmLogicIP#:iPackID, 
      "grid", 
      hBuffOrQueryOrRelationIP#, 
      "" /* field not needed to determine grid */ , 
      output bIsDisplayLinkedOP#).
    
    if not bIsDisplayLinkedOP# then 
    do:

      if hBuffOrQueryOrRelationIP#:type <> "data-relation" then 
      do:
        hQuery# = dsIP#:top-nav-query(hBuffOrQueryOrRelationIP#:name).
        if (hQuery# = ?) then message program-name(2) skip hBuffOrQueryOrRelationIP#:type skip "Top-level query niet gevonden."
            view-as alert-box.
      end.
        
      else 
      do:
        hRelation# = hBuffOrQueryOrRelationIP#.
        hQuery# = hRelation#:query.
      end.
        
      if (hQuery# <> ?) then 
      do:
         
        DisplayDataSubGrid(
          oWidget#, 
          hQuery#, 
          input-output oBindingSource#).
          
        sc_coll_widgetdata:SetDisplayLinked(oWidget#).
        
      end. /* Valid query */
      
    end. /* Not displayLinked */

  end method. /* DisplayData : Grid + DataSet */


  method protected static void DisplayDataSubGrid(
  
    input        oWidgetIP#         as Progress.Lang.Object, 
    input        hQueryIP#          as handle, 
    input-output oBindingSourceIOP# as Progress.Lang.Object):
    
    define variable oFormsGrid#           as System.Windows.Forms.DataGridView       no-undo.
    define variable oBindingSourceStrong# as c_bindingsource                         no-undo.
    define variable oGridColumns#         as Progress.Lang.Object                    no-undo extent.
    define variable iExtent#              as integer                                 no-undo.
    define variable oColumn#              as System.Windows.Forms.DataGridViewColumn no-undo.

    if type-of(oWidgetIP#, System.Windows.Forms.DataGridView) then 
    do:
      oFormsGrid# = cast(oWidgetIP#, System.Windows.Forms.DataGridView).
      if (hQueryIP# <> ?) then 
      do:
        if oBindingSourceIOP# = ? then 
        do:                      
          oBindingSourceStrong# = new c_bindingsource(sc_bindingsourcetype:i_Query, hQueryIP#).
          oBindingSourceIOP# = oBindingSourceStrong#.
        end.
        else 
        do:
          oBindingSourceStrong# = cast(oBindingSourceIOP#, c_bindingsource).
        end.
        oFormsGrid#:AutoGenerateColumns = false.
        oFormsGrid#:DataSource = oBindingSourceStrong#.
        sc_coll_widgetdata:GetGridColumns(oFormsGrid#, output oGridColumns#).
        do iExtent# = 1 to extent(oGridColumns#):
          if type-of(oGridColumns#[iExtent#], System.Windows.Forms.DataGridViewColumn) then 
          do:
            oColumn# = cast(oGridColumns#[iExtent#], System.Windows.Forms.DataGridViewColumn).
            oColumn#:DataPropertyName = entry(2,replace(oColumn#:Name,"__",",")).
          end.
        end. /* Walk Browse/grid columns */
      end. /* Valid query */
    end. /* This is a DataGridView */
    
  end method. /* DisplayDataSubGrid (protected) */


  method public static void DisplayData(

    oFrmLogicIP#    as i_frmlogic,
    iComboboxOVIP#  as i_widgettype_combobox,
    iListItemsOVIP# as i_widgetproperty_listitems,
    dataset-handle  dsIP#,
    hBuffOrQueryOrRelationIP# as handle,
    cDataRefIP#     as character):

    define variable bIsDisplayLinkedOP# as logical                       no-undo.
    define variable oBindingSource#     as c_bindingsource               no-undo.
    define variable oWidget#            as Progress.Lang.Object          no-undo.
    define variable oComboBox#          as System.Windows.Forms.ComboBox no-undo.
    

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "combobox", hBuffOrQueryOrRelationIP#, cDataRefIP#, output bIsDisplayLinkedOP#).
    
    if not bIsDisplayLinkedOP# then
    do:
      if type-of(oWidget#, System.Windows.Forms.ComboBox) then
      do:
        oComboBox# = cast(oWidget#, System.Windows.Forms.ComboBox).
        oBindingSource# = new c_bindingsource(sc_bindingsourcetype:i_Query /* Als het een buffer is, moet het een query worden; alle items. */, hBuffOrQueryOrRelationIP#).
        oComboBox#:DataSource = oBindingSource#. /* Dit vult automatisch de listitems van de combobox. */
        oComboBox#:DisplayMember = entry(2,cDataRefIP#,".").
        oComboBox#:ValueMember   = subst("iID&1", entry(1,cDataRefIP#,".")).
      end.
      sc_coll_widgetdata:SetDisplayLinked(oWidget#).
    end.

  end method. /* DisplayData : ComboBox + ListItems + dataset handle */
  

  method public static void DisplayData(

    oFrmLogicIP#              as i_frmlogic,
    iComboboxOVIP#            as i_widgettype_combobox,
    iListItemsOVIP#           as i_widgetproperty_listitems,
    cWidgetNameIP#            as character,
    hBuffOrQueryOrRelationIP# as handle,
    cDataRefIP#               as character):

    define variable bIsDisplayLinkedOP# as logical                       no-undo.
    define variable oBindingSource#     as c_bindingsource               no-undo.
    define variable oWidget#            as Progress.Lang.Object          no-undo.
    define variable oComboBox#          as System.Windows.Forms.ComboBox no-undo.
    define variable cBase#              as character                     no-undo.
    define variable cDataRef#           as character                     no-undo.
    define variable cRemainder#         as character                     no-undo.
    define variable cCased#             as character                     no-undo.
    
    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "combobox", ?, cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    cDataRef# = panaedra.msroot.msutil.logic.sc_string_prefixsuffix:GetPrefix(cDataRefIP#, output cRemainder#).
    
    if cDataRef# <> "tt" then cDataRef# = cDataRefIP#.
    else cDataRef# = cRemainder#.
    
    if not bIsDisplayLinkedOP# then
    do:
      if type-of(oWidget#, System.Windows.Forms.ComboBox) then
      do:
        oComboBox# = cast(oWidget#, System.Windows.Forms.ComboBox).
        oBindingSource# = new c_bindingsource(sc_bindingsourcetype:i_Query /* Als het een buffer is, moet het een query worden; alle items. */, hBuffOrQueryOrRelationIP#).
        oComboBox#:DataSource = oBindingSource#. /* Dit vult automatisch de listitems van de combobox. */
        oComboBox#:DisplayMember = entry(num-entries(cDataRef#,"."),cDataRef#,".").
        if num-entries(cDataRef#,".") >= 2 then
          oComboBox#:ValueMember   = subst("iID&1", entry(1,cDataRef#,".")).
        else 
        do:
          if hBuffOrQueryOrRelationIP#:type = "buffer" then 
          do:
            cCased# = sc_dbtrig:GetCased(hBuffOrQueryOrRelationIP#).
            oComboBox#:ValueMember   = subst("iID&1", cCased#).
          end.
        end.
      end.
      sc_coll_widgetdata:SetDisplayLinked(oWidget#).
    end.
    
  end method. /* DisplayData : ComboBox + ListItems + buffer or query handle */
  

  method public static void DisplayData(

    oFrmLogicIP#     as i_frmlogic,
    iComboboxOVIP#   as i_widgettype_combobox,
    iListItemsOVIP#  as i_widgetproperty_listitems,
    cWidgetNameIP#   as character,
    oQryIP#          as i_qry):

    define variable bIsDisplayLinkedOP# as logical                       no-undo.
    define variable oBindingSource#     as c_bindingsource               no-undo.
    define variable oWidget#            as Progress.Lang.Object          no-undo.
    define variable oComboBox#          as System.Windows.Forms.ComboBox no-undo.
    define variable cBase#              as character                     no-undo.
    define variable cDataRef#           as character                     no-undo.
    define variable cRemainder#         as character                     no-undo.
    define variable cCased#             as character                     no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "combobox", ?, cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    cDataRef# = panaedra.msroot.msutil.logic.sc_string_prefixsuffix:GetPrefix(oQryIP#:sys__hQuery:get-buffer-handle(1):name, output cRemainder#).
    
    cDataRef# = cRemainder#.
    
    if not bIsDisplayLinkedOP# then
    do:
      if type-of(oWidget#, System.Windows.Forms.ComboBox) then
      do:
        oComboBox# = cast(oWidget#, System.Windows.Forms.ComboBox).
        oBindingSource# = oQryIP#:sys__oBindingSource.
        if not valid-object(oBindingSource#) then 
        do:
          oBindingSource# = new c_bindingsource(sc_bindingsourcetype:i_Query /* Als het een buffer is, moet het een query worden; alle items. */, oQryIP#:sys__hQuery).
          oQryIP#:sys__oBindingSource = oBindingSource#.
        end.
        
        oComboBox#:DataSource = oBindingSource#. /* Dit vult automatisch de listitems van de combobox. */
        
        if extent(oQryIP#:hDisplayField)= ? then undo, throw new panaedra.msroot.msutil.logic.c_apiproxyexception(99950822, "You didn't set the extent of the field to display in the combobox (oQry:hDisplayField)").
        
        oComboBox#:DisplayMember = oQryIP#:hDisplayField[1]:name.
        
        if num-entries(cDataRef#,".") >= 2 then
          oComboBox#:ValueMember   = subst("iID&1", entry(1,cDataRef#,".")).
        else 
        do:
          cCased# = sc_dbtrig:GetCased(oQryIP#:sys__hQuery:get-buffer-handle(1)).
          do on error undo, throw:
            oComboBox#:ValueMember   = subst("iID&1", cCased#).
            catch ex as Progress.Lang.Error :
              undo, throw new Progress.Lang.AppError(subst("ValueMember of combobox could not be set. Does your temp-table contain a &1 field?", subst("iID&1", cCased#)), 99950823).
            end catch.
          end.
        end.
      end.
      sc_coll_widgetdata:SetDisplayLinked(oWidget#).
    end.

  end method. /* DisplayData : ComboBox + ListItems + c_qry */
  

  method public static void DisplayData(

    oFrmLogicIP#    as i_frmlogic,
    iAnyWidgetOVIP# as i_widgettype_any,
    iListItemsOVIP# as i_widgetproperty_enabled,
    cDataRefIP#     as character,
    bEnabledIP#     as logical):

    define variable bIsDisplayLinkedOP# as logical                      no-undo.
    define variable oWidget#            as Progress.Lang.Object         no-undo.
    define variable oControl#           as System.Windows.Forms.Control no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "any", cDataRefIP#, output bIsDisplayLinkedOP#).
    
    if type-of(oWidget#, System.Windows.Forms.Control) then
    do:
      oControl# = cast(oWidget#, System.Windows.Forms.Control).
      oControl#:Enabled = bEnabledIP#.
    end.

  end method. /* DisplayData : Any + Enabled/Disabled */


  method public static void RefreshData(
  
    oFrmLogicIP#   as i_frmlogic,
    iGridOVIP#     as i_widgettype_grid,
    cWidgetNameIP# as character,
    oQryIP#        as i_qry):

    define variable bIsDisplayLinkedOP#   as logical                               no-undo.
    define variable oWidget#              as Progress.Lang.Object                  no-undo.
    define variable oControl#             as System.Object                         no-undo.
    define variable oFormsGrid#           as System.Windows.Forms.DataGridView     no-undo.
    define variable oFormsCell#           as System.Windows.Forms.DataGridViewCell no-undo.
    define variable oBindingSource#       as Progress.Lang.Object                  no-undo.
    define variable oBindingSourceStrong# as c_bindingsource                       no-undo.
    define variable iFirstDispRow#        as integer                               no-undo.
    define variable iCurrentColumn#       as integer                               no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "grid", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
    do:
      
      oBindingSource# = paninui.view.use.sc_coll_widgetdata:_sys_GetBindingSource(oWidget#).
      
      if oBindingSource# <> ? then 
      do:
        
        oBindingSourceStrong# = cast(oBindingSource#, c_bindingsource).
        
        if type-of(oWidget#, System.Windows.Forms.DataGridView) then 
        do:
          oFormsGrid# = cast(oWidget#, System.Windows.Forms.DataGridView).
          iFirstDispRow# = sc_getuiframevalues:GetUiValueInt(oFrmLogicIP#, sc_widgettype:i_Grid, cWidgetNameIP#, "FirstDisplayedScrollingRowIndex").
          if iFirstDispRow# >= 0 then 
          do:
            paninui.view.use.sys_display._sys_sc_display:_sys_GetUiValue(oFormsGrid#, "CurrentCell", output oControl#).
            if valid-object(oControl#) and type-of(oControl#, System.Windows.Forms.DataGridViewCell) then 
            do:
              oFormsCell# = cast(oControl#, System.Windows.Forms.DataGridViewCell).
              iCurrentColumn# = oFormsCell#:OwningColumn:DisplayIndex.
            end.
          end.
          oFormsGrid#:SuspendLayout().
        end.
        
        /* N.B. If we need to scroll to the column as well, we can use FirstDisplayedScrollingColumnIndex. */
        
        oQryIP#:QueryOpenAndReposition().
        
        if oFormsGrid# <> ? then 
        do:
          if iFirstDispRow# > 0 then 
          do:
            sc_displaydata:SetUiValue(oFrmLogicIP#, sc_widgettype:i_Grid, "_DATA_", "FirstDisplayedScrollingRowIndex", iFirstDispRow#).
          end.
          if iCurrentColumn# > 0 then 
          do:
            oFormsGrid#:CurrentCell = oFormsGrid#:CurrentCell:OwningRow:Cells[iCurrentColumn#].
          end.
          oFormsGrid#:ResumeLayout().
        end.
        
      end.
      
    end.
    
  end method. /* RefreshData ; Grid + i_qry */
  
  
  method public static void SetUiValue(
    
    /* Directly set any property of any widget to a new value, without databinding.
       For example: 
       Visible property to "false", 
       Text property to "Mr Johnson", 
       or BackColor property to "MediumUrgency". (*) Naming real colors is dependent on locale 
                                                     and *not* suitable for the database logic layer.
                                                     Color indicators should be (per-user-or-environment-)
                                                     mapped in the view layer.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    cValueIP#       as character):

    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "any", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      SetUiValueImplement(oWidget#, cPropertyIP#, cValueIP#).

  end method. /* SetUiValue ; direct version with no OVID# for widgettype. Can cause (predictable) name clashes; btnTryout and cbTryout for example. */


  method public static void SetUiValue(
    
    /* Directly set any property of a combobox widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    cValueIP#       as character):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "combobox", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      SetUiValueImplement(oWidget#, cPropertyIP#, cValueIP#).

  end method. /* SetUiValue ; ComboBox */


  method public static void SetUiValue(
    
    /* Directly set a special semi-property like "Focus" of a combobox widget, without databinding.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character):
      
    define variable bIsDisplayLinkedOP# as logical                      no-undo.
    define variable oWidget#            as Progress.Lang.Object         no-undo.
    define variable cSvAllowed#         as character                    no-undo init "Focus".
    define variable oFormsControl#      as System.Windows.Forms.Control no-undo.
    
    if lookup(cPropertyIP#, cSvAllowed#) > 0 then 
    do:
    
      oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "combobox", cWidgetNameIP#, output bIsDisplayLinkedOP#).
      
      if valid-object(oWidget#) then 
      do:
        
        if type-of(oWidget#, System.Windows.Forms.Control) then 
        do:
          oFormsControl# = cast(oWidget#, System.Windows.Forms.Control).
        end.
        
        case cPropertyIP#: 
          
          when "Focus" then 
            do:
              if oFormsControl# <> ? then oFormsControl#:Focus().
            end.
            
        end case.
      end.
    end.
    else 
      undo, throw new Progress.Lang.AppError(subst("Invalid property without value: '&1'", cPropertyIP#),99950017).
    
  end method. /* SetUiValue ; ComboBox - only property name (like Focus) */


  method public static void SetUiValue(
    
    /* Directly set any property of a combobox widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    iValueIP#       as integer):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "combobox", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      SetUiValueImplement(oWidget#, cPropertyIP#, iValueIP#).

  end method. /* SetUiValue ; ComboBox */


  method public static void SetUiValue(
    
    /* Directly set any property of a combobox widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    bValueIP#       as logical):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "combobox", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      SetUiValueImplement(oWidget#, cPropertyIP#, bValueIP#).

  end method. /* SetUiValue ; ComboBox */


  method public static void SetUiValue(
    
    /* Directly set any property of a combobox widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    dtmValueIP#     as datetime-tz):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "combobox", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      SetUiValueImplement(oWidget#, cPropertyIP#, dtmValueIP#).

  end method. /* SetUiValue ; ComboBox */


  method public static void SetUiValue(
    
    /* Directly set any property of a grid widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oGridOVID#      as i_widgettype_grid,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    iValueIP#       as integer):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "grid", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      SetUiValueImplement(oWidget#, cPropertyIP#, iValueIP#).

  end method. /* SetUiValue ; Grid */


  method public static void SetUiValue(
    
    /* Directly set any property of a grid widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oGridOVID#      as i_widgettype_grid,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    bValueIP#       as logical):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "grid", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      SetUiValueImplement(oWidget#, cPropertyIP#, bValueIP#).

  end method. /* SetUiValue ; Grid */


  method public static void SetUiValue(
    
    /* Directly set a property of a griditem semi-widget (grid column) to a new value, without databinding.
       Currently only Visible is supported.
     */
    
    oFrmLogicIP#       as i_frmlogic,
    oGridItemOVID#     as i_widgettype_griditem,
    cWidgetNameIP#     as character,
    cWidgetItemNameIP# as character,
    cPropertyIP#       as character,
    bValueIP#          as logical):
      
    define variable bIsDisplayLinkedOP# as logical                                 no-undo.
    define variable oWidget#            as Progress.Lang.Object                    no-undo.
    define variable oFormsGrid#         as System.Windows.Forms.DataGridView       no-undo.
    define variable oFormsGridColumn#   as System.Windows.Forms.DataGridViewColumn no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "grid", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
    do:
      if type-of(oWidget#, System.Windows.Forms.DataGridView) then 
      do:
        assign
          oFormsGrid#       = cast(oWidget#, System.Windows.Forms.DataGridView)
          oFormsGridColumn# = oFormsGrid#:Columns[cWidgetItemNameIP#] no-error.
        if oFormsGridColumn# <> ? then 
          case cPropertyIP#:
            when "Visible" then 
              do:
                oFormsGridColumn#:Visible = bValueIP#.
              end.
            otherwise 
            do:
              undo, throw new Progress.Lang.AppError(subst("This property is not supported: &1", cPropertyIP#),99950231).
            end.
          end case.
      end.
      else undo, throw new Progress.Lang.AppError("This widget is not a Forms DataGridView.",99950232).
    end.

  end method. /* SetUiValue ; Griditem + logical */


  method public static void SetUiValue(
    
    /* Directly set any property of a button widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oButtonOVID#    as i_widgettype_button,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    cValueIP#       as character):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "button", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      SetUiValueImplement(oWidget#, cPropertyIP#, cValueIP#).

  end method. /* SetUiValue ; Button */
  

  method public static void SetUiValue(
    
    /* Directly set any property of a button widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oButtonOVID#    as i_widgettype_button,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    bValueIP#       as logical):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "button", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      SetUiValueImplement(oWidget#, cPropertyIP#, bValueIP#).

  end method. /* SetUiValue ; Button + logical */


  method public static void SetUiValue(
    
    /* Directly set any property of a groupframe widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#     as i_frmlogic,
    oGroupFrameOVID# as i_widgettype_groupframe,
    cWidgetNameIP#   as character,
    cPropertyIP#     as character,
    cValueIP#        as character):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "groupframe", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      SetUiValueImplement(oWidget#, cPropertyIP#, cValueIP#).

  end method. /* SetUiValue ; Groupframe */


  method public static void SetUiValue(
    
    /* Directly set any property of a groupframe widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#     as i_frmlogic,
    oGroupFrameOVID# as i_widgettype_groupframe,
    cWidgetNameIP#   as character,
    cPropertyIP#     as character,
    iValueIP#        as integer):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "groupframe", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      SetUiValueImplement(oWidget#, cPropertyIP#, iValueIP#).

  end method. /* SetUiValue ; Groupframe */


  method public static void SetUiValue(
    
    /* Directly set any property of a groupframe widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#     as i_frmlogic,
    oGroupFrameOVID# as i_widgettype_groupframe,
    cWidgetNameIP#   as character,
    cPropertyIP#     as character,
    bValueIP#        as logical):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "groupframe", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      SetUiValueImplement(oWidget#, cPropertyIP#, bValueIP#).

  end method. /* SetUiValue ; Groupframe */


  method public static void SetUiValue(
    
    /* Directly set any property of a grid widget to a new value, without databinding.
       See the overload without OVID# parameter for more information.
     */
    
    oFrmLogicIP#    as i_frmlogic,
    oButtonOVID#    as i_widgettype_grid,
    cWidgetNameIP#  as character,
    cPropertyIP#    as character,
    cValueIP#       as character):
      
    define variable bIsDisplayLinkedOP# as logical              no-undo.
    define variable oWidget#            as Progress.Lang.Object no-undo.

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "grid", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
    if valid-object(oWidget#) then 
      SetUiValueImplement(oWidget#, cPropertyIP#, cValueIP#).

  end method. /* SetUiValue ; Grid */


  method protected static void SetUiValueImplement(
    
    /* Directly set any property of any widget to a new value, without databinding.
     */
    
    oWidgetIP#      as Progress.Lang.Object,
    cPropertyIP#    as character,
    cValueIP#       as character):

    define variable oControl#       as System.Object                 no-undo.
    define variable oValue#         as Progress.Lang.Object          no-undo.
    define variable bEnumProperty#  as logical                       no-undo.

    define variable oFormsCombobox# as System.Windows.Forms.ComboBox no-undo.

    /* We only support Text objects for cValueIP#, and we can convert this to other objects
       later in time 
       (I.e. "green" to Color object etc.; in WPF we can use existing Type Converters) 
    */
    if valid-object(oWidgetIP#) then 
    do:
      RenameWidgetPropertyByUiTechnology(oWidgetIP#, input-output cPropertyIP#, input-output cValueIP#, output oValue#).
      
      if type-of(oWidgetIP#, System.Windows.Forms.ComboBox) then 
      do:
        oFormsCombobox# = cast(oWidgetIP#, System.Windows.Forms.ComboBox).
        bEnumProperty# = yes.
        
        case cPropertyIP#:
          
          when "DropDownStyle" then 
            case cValueIP# :
              when "Simple" then
                oFormsCombobox#:DropDownStyle = System.Windows.Forms.ComboBoxStyle:Simple.
              when "DropDown" then
                oFormsCombobox#:DropDownStyle = System.Windows.Forms.ComboBoxStyle:DropDown.
              when "DropDownList" then
                oFormsCombobox#:DropDownStyle = System.Windows.Forms.ComboBoxStyle:DropDownList.
              otherwise 
              undo, throw new c_panaedraexception(
                99908672,
                sc_lang:oEnglish,
                substitute("Unsupported value '&1' for property 'DropDownStyle'", cValueIP#)
                ).
                
            end case.
            
          otherwise  
            bEnumProperty# = no.
          
        end case.     
         
      end. /* if type-of ... */
      
      
      if not bEnumProperty# then
      do: 
      
        oControl# = cast(oWidgetIP#, System.Object).
        if oValue# <> ? then
          paninui.view.use.sys_display._sys_sc_display:_sys_SetUiValue(oControl#, cPropertyIP#, cast(oValue#,System.Object)).
        else
          paninui.view.use.sys_display._sys_sc_display:_sys_SetUiValue(oControl#, cPropertyIP#, cValueIP#).
          
      end.
        
    end.

  end method. /* SetUiValueImplement ; character */


  method protected static void SetUiValueImplement(
    
    /* Directly set any property of any widget to a new value, without databinding.
     */
    
    oWidgetIP#    as Progress.Lang.Object,
    cPropertyIP#    as character,
    iValueIP#       as integer):

    define variable oControl# as System.Object        no-undo.
    define variable cDummy#   as character            no-undo.
    define variable oValue#   as Progress.Lang.Object no-undo.
    
    /* We only support Text objects for cValueIP#, and we can convert this to other objects
       later in time 
       (I.e. "green" to Color object etc.; in WPF we can use existing Type Converters) 
    */
    if valid-object(oWidgetIP#) then 
    do:
      RenameWidgetPropertyByUiTechnology(oWidgetIP#, input-output cPropertyIP#, input-output cDummy#, output oValue#).
      oControl# = cast(oWidgetIP#, System.Object).
      paninui.view.use.sys_display._sys_sc_display:_sys_SetUiValue(oControl#, cPropertyIP#, iValueIP#).
    end.

  end method. /* SetUiValueImplement ; integer */


  method protected static void SetUiValueImplement(
    
    /* Directly set any property of any widget to a new value, without databinding.
     */
    
    oWidgetIP#    as Progress.Lang.Object,
    cPropertyIP#  as character,
    dtmValueIP#   as datetime-tz):

    define variable oControl# as System.Object        no-undo.
    define variable cDummy#   as character            no-undo.
    define variable oValue#   as Progress.Lang.Object no-undo.
    
    /* We only support Text objects for cValueIP#, and we can convert this to other objects
       later in time 
       (I.e. "green" to Color object etc.; in WPF we can use existing Type Converters) 
    */
    if valid-object(oWidgetIP#) then 
    do:
      RenameWidgetPropertyByUiTechnology(oWidgetIP#, input-output cPropertyIP#, input-output cDummy#, output oValue#).
      oControl# = cast(oWidgetIP#, System.Object).
      paninui.view.use.sys_display._sys_sc_display:_sys_SetUiValue(oControl#, cPropertyIP#, dtmValueIP#).
    end.

  end method. /* SetUiValueImplement ; integer */


  method protected static void SetUiValueImplement(
    
    /* Directly set any property of any widget to a new value, without databinding.
     */
    
    oWidgetIP#    as Progress.Lang.Object,
    cPropertyIP#    as character,
    bValueIP#       as logical):

    define variable oControl# as System.Object        no-undo.
    define variable cDummy#   as character            no-undo.
    define variable oValue#   as Progress.Lang.Object no-undo.

    /* We only support Text objects for cValueIP#, and we can convert this to other objects
       later in time 
       (I.e. "green" to Color object etc.; in WPF we can use existing Type Converters) 
    */
    if valid-object(oWidgetIP#) then 
    do:
      RenameWidgetPropertyByUiTechnology(oWidgetIP#, input-output cPropertyIP#, input-output cDummy#, output oValue#).
      oControl# = cast(oWidgetIP#, System.Object).
      paninui.view.use.sys_display._sys_sc_display:_sys_SetUiValue(oControl#, cPropertyIP#, bValueIP#).
    end.

  end method. /* SetUiValueImplement ; logical */


  method public static void RenameWidgetPropertyByUiTechnology(
  
    /* For example: "Enabled" must be renamed to "IsEnabled" for WPF widgets */
    
    input        oWidgetIP#    as Progress.Lang.Object, 
    input-output cPropertyIOP# as character,
    input-output cValueIOP#    as character,
    output       oValueOP#     as Progress.Lang.Object):

    /* Abstraction of widget properties (Note: syntax Ctrl-I formatting is a bit hayward here, can't be helped.) */
    case sc_analyzewidget:IsOfUiTechnology(oWidgetIP#):
        
      when "windows_wpf" then 
        case cPropertyIOP#:
          when "Enabled" then 
            cPropertyIOP# = "IsEnabled".
        end case.
        
      when "windows_forms" then
        case  cPropertyIOP#:
          when "Dock" then 
            case cValueIOP#:
              when "Bottom" then 
                oValueOP# = System.Windows.Forms.DockStyle:Bottom.
              when "Top" then 
                oValueOP# = System.Windows.Forms.DockStyle:Top.
              when "Left" then 
                oValueOP# = System.Windows.Forms.DockStyle:Left.
              when "Right" then 
                oValueOP# = System.Windows.Forms.DockStyle:Right.
            end case.
        end case. 
        
      otherwise sc_messagebox:Show(sc_messageboxtype:oDebug,
        sc_analyzewidget:IsOfUiTechnology(oWidgetIP#),
        "is not implemented.").
                
    end case. /* IsOfUiTechnology ; Abstraction of widget properties  */

  end method. /* RenameWidgetPropertyByUiTechnology */
  
  method public static void AppendText(
  
    oFrmLogicIP#    as i_frmlogic,
    oComboBoxOVID#  as i_widgettype_combobox,
    cWidgetNameIP#  as character,
    cTextIP#        as character):

    define variable bIsDisplayLinkedOP# as logical                      no-undo.
    define variable oWidget#            as Progress.Lang.Object         no-undo.
    define variable oTextbox#           as System.Windows.Forms.TextBox no-undo.
    
    if cTextIP# > "" then 
    do:
      oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "combobox", cWidgetNameIP#, output bIsDisplayLinkedOP#).
    
      if valid-object(oWidget#) and type-of(oWidget#,System.Windows.Forms.TextBox) then 
      do:
        oTextbox# = cast(oWidget#, System.Windows.Forms.TextBox).
        oTextbox#:AppendText(cTextIP#).
      end.
      
    end.
    
  end method. /* AppendText */

end class.

/* EOF */
