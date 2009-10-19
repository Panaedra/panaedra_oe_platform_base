{panaedra/msi/logic/ctop_class.i}
using paninui.view.interfaces.*.
using paninui.view.use.*.
using paninui.view.init.display.*.

class paninui.view.use.display.sc_displaydata   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/display/sc_displaydata.cls $ 
          Version: $Revision: 11 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-19 10:55:43+02:00 $ 
    Date Modified: $Modtime: 2009-10-19 10:32:59+02:00 $ 

      Description: Display data on a paninUi frame.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_displaydata(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 11 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  method public static void DisplayData (
    oFrmLogicIP#     as i_frmlogic,
    iGroupFrameOVIP# as i_widgettype_groupframe,
    iTextOVIP#       as i_widgetproperty_text,
    cGroupNameIP#    as character,
    oBufIP#          as panaedra.msroot.msdr.interfaces.i_buf):

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
          undo, throw new Progress.Lang.AppError(subst("Error in sc_displaydata:DisplayData of a GroupFrame with Buffer '&1'~n&2", oBufIP#:ToString(), e:GetMessage(1)), e:GetMessageNum(1)).
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
  
  
  method public static void DisplayData (
    oFrmLogicIP#   as i_frmlogic,
    iGridOVIP#     as i_widgettype_grid,
    cWidgetNameIP# as character,
    oQryIP#        as panaedra.msroot.msdr.interfaces.i_qry):
    
    define variable oWidget#              as Progress.Lang.Object no-undo.
    define variable oBindingSource#       as Progress.Lang.Object no-undo.
    define variable oBindingSourceStrong# as c_bindingsource      no-undo.
    define variable bIsDisplayLinkedOP#   as logical              no-undo.
    
    oWidget# = sc_coll_widgetdata:GetWidget(
      oFrmLogicIP#:iPackID, 
      "grid", 
      oQryIP#:hQuery, 
      cWidgetNameIP#, 
      output bIsDisplayLinkedOP#).
    
    if not bIsDisplayLinkedOP# then 
    do:

      oBindingSource# = paninui.view.use.sc_coll_widgetdata:GetBindingSource(
        oFrmLogicIP#:iPackID, 
        "grid", 
        oQryIP#:hQuery, 
        cWidgetNameIP#).

      if oBindingSource# <> ? then
        oBindingSourceStrong# = cast(oBindingSource#, c_bindingsource).
      else 
        oBindingSourceStrong# = ?.

      DisplayDataSubGrid(oWidget#, oQryIP#:hQuery, input-output oBindingSource#).

      sc_coll_widgetdata:SetBindingSource(oWidget#, oBindingSourceStrong#, oQryIP#:hQuery).
      sc_coll_widgetdata:SetDisplayLinked(oWidget#).
      
    end.
    
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
        DisplayDataSubGrid(oWidget#, hQuery#, input-output oBindingSource#).
        sc_coll_widgetdata:SetDisplayLinked(oWidget#).
      end. /* Valid query */
      
    end. /* Not displayLinked */

  end method. /* DisplayData : Grid + DataSet */


  method protected static void DisplayDataSubGrid(oWidgetIP# as Progress.Lang.Object, hQueryIP# as handle, input-output oBindingSourceIOP# as Progress.Lang.Object):
    
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

  end method. /* DisplayData : ComboBox + ListItems */
  

  method public static void DisplayData(
    oFrmLogicIP#    as i_frmlogic,
    iComboboxOVIP#  as i_widgettype_any,
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


end class.

/* EOF */
