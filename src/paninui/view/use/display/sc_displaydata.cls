{panaedra/msi/logic/ctop_class.i}
using paninui.view.interfaces.*.
using paninui.view.use.*.
using paninui.view.init.display.*.

class paninui.view.use.display.sc_displaydata   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/display/sc_displaydata.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-08-31 10:37:54+02:00 $ 
    Date Modified: $Modtime: 2009-08-30 18:18:00+02:00 $ 

      Description: Display data on a paninUi frame.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_displaydata(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
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
    
    oWidget# = sc_coll_widgetdata:GetWidget(oFrmLogicIP#:iPackID, "grid", hBuffOrQueryIP#, output bIsDisplayLinkedOP#).
    
    if not bIsDisplayLinkedOP# then 
    do:
      if type-of(oWidget#, System.Windows.Forms.DataGridView) then 
      do:
        oFormsGrid# = cast(oWidget#, System.Windows.Forms.DataGridView).
        oBindingSource# = new c_bindingsource(dsIP#:top-nav-query(hBuffOrQueryIP#:name):handle).
        oFormsGrid#:AutoGenerateColumns = false.
        oFormsGrid#:DataSource = oBindingSource#.
        sc_coll_widgetdata:GetGridColumns(oFormsGrid#, output oGridColumns#).
        do iExtent# = 1 to extent(oGridColumns#):
          if type-of(oGridColumns#[iExtent#], System.Windows.Forms.DataGridViewColumn) then 
          do:
            oColumn# = cast(oGridColumns#[iExtent#], System.Windows.Forms.DataGridViewColumn).
            oColumn#:DataPropertyName = entry(2,replace(oColumn#:Name,"__",",")).
          end.
        end.
      end.
      sc_coll_widgetdata:SetDisplayLinked(oWidget#).
    end.

  end method. /* DisplayData */  


end class.

/* EOF */
