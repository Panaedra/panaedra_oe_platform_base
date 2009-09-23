{panaedra/msi/logic/ctop_class.i}
using paninui.view.interfaces.*.
using paninui.view.use.*.
using paninui.view.init.display.*.

class paninui.view.use.display.sc_displaydata   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/display/sc_displaydata.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-23 09:36:41+02:00 $ 
    Date Modified: $Modtime: 2009-09-21 11:19:16+02:00 $ 

      Description: Display data on a paninUi frame.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_displaydata(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 4 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  method public static void DisplayData (
    oFrmLogicIP# as i_frmlogic,
    iGridOVIP#   as i_widgettype_grid,
    dataset-handle dsIP#,
    hBuffOrQueryIP# as handle):
    
    define variable oWidget#            as Progress.Lang.Object                    no-undo.
    define variable oFormsGrid#         as System.Windows.Forms.DataGridView       no-undo.
    
    define variable bIsDisplayLinkedOP# as logical                                 no-undo.
    define variable oBindingSource#     as c_bindingsource                         no-undo.
    
    define variable oGridColumns#       as Progress.Lang.Object                    no-undo extent.
    define variable iExtent#            as integer                                 no-undo.
    define variable oColumn#            as System.Windows.Forms.DataGridViewColumn no-undo.
    
    define variable hQuery#             as handle                                  no-undo.
    
    oWidget# = sc_coll_widgetdata:GetWidget(
      oFrmLogicIP#:iPackID, 
      "grid", 
      hBuffOrQueryIP#, 
      "" /* field not needed to determine grid */ , 
      output bIsDisplayLinkedOP#).
    
    if not bIsDisplayLinkedOP# then 
    do:
      if type-of(oWidget#, System.Windows.Forms.DataGridView) then 
      do:
        oFormsGrid# = cast(oWidget#, System.Windows.Forms.DataGridView).
        hQuery# = dsIP#:top-nav-query(hBuffOrQueryIP#:name).
        if (hQuery# = ?) then message program-name(2) skip "Top-level query niet gevonden."
            view-as alert-box.
        else 
        do:                      
          oBindingSource# = new c_bindingsource(sc_bindingsourcetype:i_Query,   dsIP#:top-nav-query(hBuffOrQueryIP#:name):handle).
          oFormsGrid#:AutoGenerateColumns = false.
          oFormsGrid#:DataSource = oBindingSource#.
          sc_coll_widgetdata:GetGridColumns(oFormsGrid#, output oGridColumns#).
          do iExtent# = 1 to extent(oGridColumns#):
            if type-of(oGridColumns#[iExtent#], System.Windows.Forms.DataGridViewColumn) then 
            do:
              oColumn# = cast(oGridColumns#[iExtent#], System.Windows.Forms.DataGridViewColumn).
              oColumn#:DataPropertyName = entry(2,replace(oColumn#:Name,"__",",")).
            end.
          end. /* Browse/grid columns aflopen */
        end. /* Geldige query */
      end.
      sc_coll_widgetdata:SetDisplayLinked(oWidget#).
    end.

  end method. /* DisplayData : Grid */
    

  method public static void DisplayData(
    oFrmLogicIP#    as i_frmlogic,
    iComboboxOVIP#  as i_widgettype_combobox,
    iListItemsOVIP# as i_widgetproperty_listitems,
    dataset-handle  dsIP#,
    hBuffOrQueryIP# as handle,
    cDataRefIP#     as character):

    define variable bIsDisplayLinkedOP# as logical                       no-undo.
    define variable oBindingSource#     as c_bindingsource               no-undo.
    define variable oWidget#            as Progress.Lang.Object          no-undo.
    define variable oComboBox#          as System.Windows.Forms.ComboBox no-undo.
    

    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "combobox", hBuffOrQueryIP#, cDataRefIP#, output bIsDisplayLinkedOP#).
    
    if not bIsDisplayLinkedOP# then
    do:
      if type-of(oWidget#, System.Windows.Forms.ComboBox) then
      do:
        oComboBox# = cast(oWidget#, System.Windows.Forms.ComboBox).
        oBindingSource# = new c_bindingsource(sc_bindingsourcetype:i_Query /* Als het een buffer is, moet het een query worden; alle items. */, hBuffOrQueryIP#).
        oComboBox#:DataSource = oBindingSource#. /* Dit vult automatisch de listitems van de combobox. */
        oComboBox#:DisplayMember = entry(2,cDataRefIP#,".").
        oComboBox#:ValueMember   = subst("iID&1", entry(1,cDataRefIP#,".")).
      end.
      sc_coll_widgetdata:SetDisplayLinked(oWidget#).
    end.

  end method. /* DisplayData : ComboBox ListItems */
  

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

  end method.
          
end class.

/* EOF */
