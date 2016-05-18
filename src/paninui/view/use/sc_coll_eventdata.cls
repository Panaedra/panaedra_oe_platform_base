{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using paninui.view.init.display.*.
using paninui.view.interfaces.*.
using paninui.view.use.*.
using paninui.view.use.delegates.*.
using paninui.view.use.events.*.
using paninui.pack.interfaces.*.
using paninui.logic.logicbase.*.

using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class paninui.view.use.sc_coll_eventdata
  implements 
  panaedra.msroot.msutil.interfaces.i_eventbroadcastclient: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/sc_coll_eventdata.cls $ 
          Version: $Revision: 37 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-02-05 13:57:09+01:00 $
    Date Modified: $Modtime: 2010-02-05 13:55:00+01:00 $ 

      Description: Collection of UI event data. "Collection" (_coll_) is used to 
                   indicate local storage of runtime data, normally in a temp-table.

  \*****************************  Include Files ********************************/

  {paninui/view/use/sc_coll_eventdata_tt.i &protected=protected &static=static &class=class}
  
  /************************  Source control constructor ************************/
  constructor public sc_coll_eventdata(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 37 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected static variable oSingleton                           as sc_coll_eventdata no-undo.
  define protected        variable bSuspendCurrentCellDirtyStateChanged as logical           no-undo.

  constructor protected sc_coll_eventdata():
    
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@c_qry@queryopen").
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@c_qry@queryclose").
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@c_bindingsource@queryopen").
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@c_qry@UiResetCurrentItem").

  end constructor.

  
  method public static void Initialize():
    
    /* Can be fired from outside, to ensure our singleton 
       reacts to broadcasted events. 
    */
      
    if oSingleton = ? then oSingleton = new sc_coll_eventdata().
      
  end method. /* Initialize */
  

  method public static int64 ItemAdd(
  
    oWidgetType_QueryOVID# as i_widgettype_query, /* *OVID# is not a real parameter, but an interface overload ID */
    iPackIDIP#             as int64,
    iFrmLogicIDIP#         as int64,
    iDelegateIDIP#         as int64,
    oFrmLogicQryIP#        as panaedra.msroot.msdr.interfaces.i_qry,
    cWidgetNameIP#         as character,
    cEventTypeIP#          as character):
    
    define variable oBindingSource#       as Progress.Lang.Object no-undo.
    define variable oBindingSourceStrong# as c_bindingsource      no-undo.
    define buffer ttUiEvent for ttUiEvent.

    if oSingleton = ? then oSingleton = new sc_coll_eventdata().
    
    if lookup(cEventTypeIP#,"QueryOpen,QueryClose,DeleteObject") > 0 then 
    do:
      
      return ItemAddImplement(iPackIDIP#, iFrmLogicIDIP#, iDelegateIDIP#, oFrmLogicQryIP#, oFrmLogicQryIP#:sys__hQuery, cWidgetNameIP#, "query", cEventTypeIP#, "").
    
    end.    
    else
    do for ttUiEvent:
      oBindingSource# = sc_coll_widgetdata:GetBindingSource(iPackIDIP#,"grid",?,cWidgetNameIP#).
    
      if oBindingSource# <> ? and type-of(oBindingSource#,c_bindingsource) then 
      do:
        oBindingSourceStrong# = cast(oBindingSource#,c_bindingsource).
        case cEventTypeIP#:
          when "PositionChanged" then 
            do:
              if not can-find(first ttUiEvent where ttUiEvent.oWidget = oBindingSource# and ttUiEvent.cEventType = cEventTypeIP#) then 
              do:
                oBindingSourceStrong#:PositionChanged:Subscribe(oSingleton:OnEventArgsHandler_PositionChanged).
              end.
            end.
          when "SortRequest" then 
            do:
              if not can-find(first ttUiEvent where ttUiEvent.oWidget = oBindingSource# and ttUiEvent.cEventType = cEventTypeIP#) then 
              do:
                /* With AutoSort, a Sort doesn't fire PositionChanged, since the Position (row) number doesn't have to change (but the record does) */
                /* Sadly, SortRequest also doesn't fire with the DataGridView... */
                /* ShouldHave: solve problem regarding SortRequest. */
                oBindingSourceStrong#:SortRequest:Subscribe(oSingleton:OnEventArgsHandler_SortRequest).
              end.
            end.
        end case.
      end.
      
      return ItemAddImplement(iPackIDIP#, iFrmLogicIDIP#, iDelegateIDIP#, oBindingSource#, oFrmLogicQryIP#:sys__hQuery, cWidgetNameIP#, "query", cEventTypeIP#, "").
    
    end.
    
  end method. /* ItemAdd ; Query */
  

  method public static int64 ItemAdd(
  
    oWidgetType_GridOVID# as i_widgettype_grid, /* *OVID# is not a real parameter, but an interface overload ID */
    iPackIDIP#             as int64,
    iFrmLogicIDIP#         as int64,
    iDelegateIDIP#         as int64,
    oFrmLogicObjectIP#     as panaedra.msroot.msdr.interfaces.i_qry,
    cWidgetNameIP#         as character,
    cEventTypeIP#          as character,
    cEventOptionsIP#       as character):
    
    define variable oFormsGrid# as System.Windows.Forms.DataGridView no-undo.
    define variable oWidget#    as Progress.Lang.Object              no-undo.
    define variable bDummy#     as logical                           no-undo.
    
    define buffer ttUiEvent for ttUiEvent.

    if oSingleton = ? then oSingleton = new sc_coll_eventdata().
    
    do for ttUiEvent:
          
      assign
        cWidgetNameIP# = replace(cWidgetNameIP#,"_",".")
        oWidget#       = sc_coll_widgetdata:GetWidget(iPackIDIP#,"grid",?,cWidgetNameIP#, output bDummy#).

      if oWidget# <> ? then 
      do:

        if type-of(oWidget#, System.Windows.Forms.DataGridView) then 
          oFormsGrid# = cast(oWidget#, System.Windows.Forms.DataGridView).

        case cEventTypeIP#:

          when "SelectionChanged" then 
            do:
              if not can-find(first ttUiEvent where ttUiEvent.oWidget = oFormsGrid# and ttUiEvent.cEventType = cEventTypeIP#) then
                oFormsGrid#:SelectionChanged:Subscribe(oSingleton:OnEventArgsHandler_SelectionChanged).
            end.

        end case.
        
      end. /* Widget is found */
            
      return ItemAddImplement(iPackIDIP#, iFrmLogicIDIP#, iDelegateIDIP#, oWidget#, if oFrmLogicObjectIP# = ? then ? else oFrmLogicObjectIP#:sys__hQuery, cWidgetNameIP#, "grid", cEventTypeIP#, cEventOptionsIP#).
    
    end.
    
  end method. /* ItemAdd ; Grid + query */


  method public static int64 ItemAdd(
  
    oWidgetType_GridOVID# as i_widgettype_grid, 
    iPackIDIP#              as int64,
    iFrmLogicIDIP#          as int64,
    iDelegateIDIP#          as int64,
    bDummyIP#               as logical,
    cWidgetNameIP#          as character,
    cEventTypeIP#           as character):
      
    define variable oWidget#              as Progress.Lang.Object              no-undo.
    define variable oBindingSource#       as Progress.Lang.Object              no-undo.
    define variable oBindingSourceStrong# as c_bindingsource                   no-undo.
    define variable bDummy#               as logical                           no-undo.
    define variable oFormsGrid#           as System.Windows.Forms.DataGridView no-undo.

    define buffer ttUiEvent for ttUiEvent.

    if oSingleton = ? then oSingleton = new sc_coll_eventdata().
    
    do for ttUiEvent:
          
      assign
        cWidgetNameIP# = replace(cWidgetNameIP#,"_",".")
        oWidget#       = sc_coll_widgetdata:GetWidget(iPackIDIP#,"grid",?,cWidgetNameIP#, output bDummy#).
        
      if oWidget# <> ? then 
      do:
        
        if type-of(oWidget#,System.Windows.Forms.DataGridView) then 
        do:
          
          oFormsGrid# = cast(oWidget#,System.Windows.Forms.DataGridView).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
            case cEventTypeIP#:
              when "ColumnSortModeChanged" then 
                do:
                  oFormsGrid#:ColumnSortModeChanged:Subscribe(oSingleton:OnEventArgsHandler_ColumnSortModeChanged).
                end.
              when "CurrentCellChanged" then 
                do:
                  oFormsGrid#:CurrentCellChanged:Subscribe(oSingleton:OnEventArgsHandler_CurrentCellChanged).
                end.
              when "CellBeginEdit" then 
                do:
                  oFormsGrid#:CellBeginEdit:Subscribe(oSingleton:OnEventArgsHandler_CellBeginEdit).
                end.
              when "CellContentClick" then 
                do:
                  oFormsGrid#:CellContentClick:Subscribe(oSingleton:OnEventArgsHandler_CellContentClick).
                end.
              when "CellEndEdit" then 
                do:
                  oFormsGrid#:CellEndEdit:Subscribe(oSingleton:OnEventArgsHandler_CellEndEdit).
                end.
              when "CellValueChanged" then 
                do:
                  /*                  oFormsGrid#:CellValueChanged:Subscribe(oSingleton:OnEventArgsHandler_CellValueChanged).*/
                  /* MSDN: 
                     In the case of check box cells, however, you will typically want to handle the change immediately. 
                     To commit the change when the cell is clicked, you must handle the DataGridView..::.CurrentCellDirtyStateChanged event. 
                     In the handler, if the current cell is a check box cell, call the DataGridView..::.CommitEdit 
                     method and pass in the Commit value.  
                     Panaedra:
                     On CurrentCellDirtyStateChanged, we also always fire CellValueChanged
                  */
                  oFormsGrid#:CurrentCellDirtyStateChanged:Subscribe(oSingleton:OnEventArgsHandler_CurrentCellDirtyStateChanged).
                end.
                
            end case.
            
        end.
        
        return ItemAddImplement(
          iPackIDIP#, 
          iFrmLogicIDIP#, 
          iDelegateIDIP#, 
          oWidget#, 
          ?, 
          cWidgetNameIP#, 
          "grid", 
          cEventTypeIP#,
          "").
      
      end.
      
    end. /* oWidget# is found */

    return 0.
          
  end method.   /* ItemAdd ; Grid zonder query */
  

  method public static int64 ItemAdd(
  
    oWidgetType_ButtonOVID# as i_widgettype_button, 
    iPackIDIP#              as int64,
    iFrmLogicIDIP#          as int64,
    iDelegateIDIP#          as int64,
    oFrmLogicBufferIP#      as panaedra.msroot.msdr.logic.c_buf,
    cWidgetNameIP#          as character,
    cEventTypeIP#           as character):

    define variable oWidget#              as Progress.Lang.Object                          no-undo.
    define variable oBindingSource#       as Progress.Lang.Object                          no-undo.
    define variable oBindingSourceStrong# as c_bindingsource                               no-undo.
    define variable bDummy#               as logical                                       no-undo.
    define variable oFormsButton#         as System.Windows.Forms.Button                   no-undo.
    define variable oFormsCheckBox#       as System.Windows.Forms.CheckBox                 no-undo.
    define variable oWpfButton#           as System.Windows.Controls.Primitives.ButtonBase no-undo.
    define variable oFormsMenuItem#       as System.Windows.Controls.MenuItem              no-undo.
    define variable oFormsToolStripItem#  as System.Windows.Forms.ToolStripItem            no-undo.
    define variable oFormsRadioButton#    as System.Windows.Forms.RadioButton              no-undo.
    
    
    define buffer ttUiEvent for ttUiEvent.

    if oSingleton = ? then oSingleton = new sc_coll_eventdata().
    
    do for ttUiEvent:
          
      assign
        cWidgetNameIP# = replace(cWidgetNameIP#,"_",".")
        oWidget#       = sc_coll_widgetdata:GetWidget(iPackIDIP#,"button",?,cWidgetNameIP#, output bDummy#).
        
      if oWidget# <> ? then 
      do:
        
        if oFrmLogicBufferIP# <> ? then 
        do:
          
          oBindingSource# = sc_coll_widgetdata:GetBindingSource(iPackIDIP#,"button",oFrmLogicBufferIP#:hBuffer,cWidgetNameIP#).
        
          if oBindingSource# = ? then 
          do:
            assign
              oBindingSourceStrong# = new c_bindingsource(sc_bindingsourcetype:i_Buffer, oFrmLogicBufferIP#:hBuffer)
              oBindingSource#       = oBindingSourceStrong#.
            sc_coll_widgetdata:SetBindingSource(oFrmLogicBufferIP#, oBindingSourceStrong#, oFrmLogicBufferIP#:hBuffer).
          end.
          else
            oBindingSourceStrong# = cast(oBindingSource#,c_bindingsource).
            
        end. /* A c_buf object is given. This is optional, you can also solely use the screen values (i_uivalue). */
        
        if type-of(oWidget#,System.Windows.Forms.CheckBox) then 
        do:
          
          oFormsCheckBox# = cast(oWidget#,System.Windows.Forms.CheckBox).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
            case cEventTypeIP#:
              when "Press" then oFormsCheckBox#:CheckedChanged:Subscribe(oSingleton:OnEventArgsHandler_Press).
            end case.
            
        end.
        
        if type-of(oWidget#,System.Windows.Forms.RadioButton) then 
        do:
          oFormsRadioButton# = cast(oWidget#,System.Windows.Forms.RadioButton).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
            case cEventTypeIP#:
              when "Press" then oFormsRadioButton#:CheckedChanged:Subscribe(oSingleton:OnEventArgsHandler_Press).
            end case.
            
        end.
        
        if type-of(oWidget#,System.Windows.Forms.Button) then 
        do:
          
          oFormsButton# = cast(oWidget#,System.Windows.Forms.Button).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
            case cEventTypeIP#:
              when "Press" then oFormsButton#:Click:Subscribe(oSingleton:OnEventArgsHandler_Press).
            end case.
            
        end.
        
        if type-of(oWidget#,System.Windows.Controls.Primitives.ButtonBase) then 
        do:
          
          oWpfButton# = cast(oWidget#,System.Windows.Controls.Primitives.ButtonBase).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
            case cEventTypeIP#:
              when "Press" then oWpfButton#:Click:Subscribe(oSingleton:OnEventArgsHandler_Press).
            end case.
            
        end.
        
        if type-of(oWidget#,System.Windows.Controls.MenuItem) then 
        do:
          
          oFormsMenuItem# = cast(oWidget#,System.Windows.Controls.MenuItem).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
            case cEventTypeIP#:
              when "Press" then oFormsMenuItem#:Click:Subscribe(oSingleton:OnEventArgsHandler_Press).
            end case.
            
        end.
        
        if type-of(oWidget#,System.Windows.Forms.ToolStripItem) then 
        do:
          oFormsToolStripItem# = cast(oWidget#,System.Windows.Forms.ToolStripItem).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
            case cEventTypeIP#:
              when "Press" then oFormsToolStripItem#:Click:Subscribe(oSingleton:OnEventArgsHandler_Press).
            end case.
        end.
        
        return ItemAddImplement(
          iPackIDIP#, 
          iFrmLogicIDIP#, 
          iDelegateIDIP#, 
          oWidget#, 
          (if oFrmLogicBufferIP# = ? then ? else oFrmLogicBufferIP#:hBuffer), 
          cWidgetNameIP#, 
          "button", 
          cEventTypeIP#,
          "").
      
      end.
      
    end. /* oWidget# is found */

    return 0.
    
  end method. /* ItemAdd ; Button */


  method public static int64 ItemAdd(
  
    oWidgetType_ComboBoxOVID# as i_widgettype_combobox, 
    iPackIDIP#                as int64,
    iFrmLogicIDIP#            as int64,
    iDelegateIDIP#            as int64,
    oFrmLogicBufferIP#        as panaedra.msroot.msdr.logic.c_buf,
    cWidgetNameIP#            as character,
    cEventTypeIP#             as character):

    define variable oWidget#              as Progress.Lang.Object                           no-undo.
    define variable oBindingSource#       as Progress.Lang.Object                           no-undo.
    define variable oBindingSourceStrong# as c_bindingsource                                no-undo.
    define variable bDummy#               as logical                                        no-undo.
    define variable oFormsListControl#    as System.Windows.Forms.ListControl               no-undo.
    define variable oFormsCombobox#       as System.Windows.Forms.ComboBox                  no-undo.
    define variable oFormsTextbox#        as System.Windows.Forms.TextBox                   no-undo.
    define variable oFormsDateTimePicker# as System.Windows.Forms.DateTimePicker            no-undo. 
    define variable oWpfTextBoxBase#      as System.Windows.Controls.Primitives.TextBoxBase no-undo.
    define variable oWpfSelector#         as System.Windows.Controls.Primitives.Selector    no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    if oSingleton = ? then oSingleton = new sc_coll_eventdata().

    do for ttUiEvent:
      
      assign
        cWidgetNameIP# = replace(cWidgetNameIP#,"_",".")
        oWidget#       = sc_coll_widgetdata:GetWidget(iPackIDIP#,"combobox",?,cWidgetNameIP#, output bDummy#).
        
      &if 0 &then
      if type-of(oWidget#,System.Windows.FrameworkElement) then
        message "pok WPF" cWidgetNameIP# skip
          program-name(2) skip  
          program-name(3) skip  
          program-name(4) skip  
          cast(oWidget#,System.Windows.FrameworkElement):Name skip
          cEventTypeIP#
          view-as alert-box.
      else if cEventTypeIP# matches "*Key*" then
        message "pok" cWidgetNameIP# skip
          program-name(2) skip  
          program-name(3) skip  
          program-name(4) skip  
          cast(oWidget#,System.Windows.Forms.Control):Name skip
          cEventTypeIP#
          view-as alert-box.
      &endif
      
      if oWidget# <> ? then 
      do:
        
        if oFrmLogicBufferIP# <> ? then 
        do:
          
          oBindingSource# = sc_coll_widgetdata:GetBindingSource(iPackIDIP#,"combobox",oFrmLogicBufferIP#:hBuffer,cWidgetNameIP#).
        
          if oBindingSource# = ? then 
          do:
            assign
              oBindingSourceStrong# = new c_bindingsource(sc_bindingsourcetype:i_Buffer, oFrmLogicBufferIP#:hBuffer)
              oBindingSource#       = oBindingSourceStrong#.
            sc_coll_widgetdata:SetBindingSource(oFrmLogicBufferIP#, oBindingSourceStrong#, oFrmLogicBufferIP#:hBuffer).
          end.
          else
            oBindingSourceStrong# = cast(oBindingSource#,c_bindingsource).
            
        end. /* A c_buf object is given. This is optional, you can also solely use the screen values (i_uivalue). */
       
        /* ComboBox en ListBox events */ 
        if type-of(oWidget#,System.Windows.Forms.ListControl) then 
        do:
          
          oFormsListControl# = cast(oWidget#,System.Windows.Forms.ListControl).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
          do: 
            case cEventTypeIP#:
              
              when "TextChanged" then 
                oFormsListControl#:TextChanged:Subscribe(oSingleton:OnEventArgsHandler_TextChanged).
              
              when "SelectedValueChanged" 
              then oFormsListControl#:SelectedValueChanged:Subscribe(oSingleton:OnEventArgsHandler_SelectedValueChanged).

              when "SelectedIndexChanged" 
              then oFormsCombobox#:SelectedIndexChanged:Subscribe(oSingleton:OnEventArgsHandler_SelectedIndexChanged).
              
              when "DoubleClick"
              then oFormsListControl#:DoubleClick:Subscribe(oSingleton:OnEventArgsHandler_DoubleClick).
              
            end case.
            
          end. /* First ttUiEvent */
            
        end. /* ListControl */
        
        if type-of(oWidget#,System.Windows.Forms.ComboBox) then 
        do:
          oFormsCombobox# = cast(oWidget#,System.Windows.Forms.ComboBox).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
          do: 
            case cEventTypeIP#:
              
              when "DelayedTextChanged" then
                do: 
                  if type-of(oFormsCombobox#,paninui.view.loose.widgets.c_forms_delayed_combobox) then
                    cast(oFormsCombobox#,paninui.view.loose.widgets.c_forms_delayed_combobox):DelayedTextChanged:Subscribe(oSingleton:OnEventArgsHandler_TextChanged).
                end.
              
              when "SelectionChangeCommitted" 
              then oFormsCombobox#:SelectionChangeCommitted:Subscribe(oSingleton:OnEventArgsHandler_SelectionChangeCommitted).
              
              when "DropDown" 
              then oFormsCombobox#:DropDown:Subscribe(oSingleton:OnEventArgsHandler_DropDown).
              
              when "DropDownClosed" 
              then oFormsCombobox#:DropDownClosed:Subscribe(oSingleton:OnEventArgsHandler_DropDownClosed).
              
            end case.
          
          end.   
        end. 
        
        if type-of(oWidget#,System.Windows.Forms.TextBox) then 
        do:
            
          oFormsTextbox# = cast(oWidget#,System.Windows.Forms.TextBox).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
          do:
               
            case cEventTypeIP#:
              when "TextChanged" 
              then 
                oFormsTextBox#:TextChanged:Subscribe(oSingleton:OnEventArgsHandler_TextChanged).
              when "KeyDown" 
              then 
                oFormsTextBox#:KeyDown:Subscribe(oSingleton:OnEventArgsHandler_KeyDown).
            end case.
              
          end. /* First ttUiEvent */
            
        end. /* TextBox (Forms) */
          
/*        /* ItemsControl / Combobox (WPF) */    pok pok                                                                                                                                                                 */
/*        if type-of(oWidget#, System.Windows.Controls.ComboBox) then                                                                                                                                             */
/*        do:                                                                                                                                                                                                     */
/*                                                                                                                                                                                                                */
/*          oWpfSelector# = cast(oWidget#, System.Windows.Controls.ComboBox).                                                                                                                                     */
/*          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then                                                                                     */
/*          do:                                                                                                                                                                                                   */
/*                                                                                                                                                                                                                */
/*            case cEventTypeIP#:                                                                                                                                                                                 */
/*              when "TextChanged"                                                                                                                                                                                */
/*              then                                                                                                                                                                                              */
/*                do:                                                                                                                                                                                             */
/*                                                                                                                                                                                                                */
/*/*                  oWpfSelector#:AddHandler(System.Windows.Controls.Primitives.TextBoxBase:TextChangedEvent, new System.Windows.Controls.TextChangedEventHandler(oSingleton:OnEventArgsHandler_TextChanged)).*/*/
/*                                                                                                                                                                                                                */
/*                end.                                                                                                                                                                                            */
/*              when "KeyDown"                                                                                                                                                                                    */
/*              then                                                                                                                                                                                              */
/*                do:                                                                                                                                                                                             */
/*                /*                oWpfSelector#:KeyDown:Subscribe(oSingleton:OnEventArgsHandler_KeyDown).*/                                                                                                     */
/*                end.                                                                                                                                                                                            */
/*            end case.                                                                                                                                                                                           */
/*                                                                                                                                                                                                                */
/*          end. /* First ttUiEvent */                                                                                                                                                                            */
/*                                                                                                                                                                                                                */
/*        end. /* ItemsControl / ComboBox (WPF) */                                                                                                                                                                */
        
        /* TextBoxBase (WPF) */
        if type-of(oWidget#,System.Windows.Controls.Primitives.TextBoxBase) then 
        do:
          
          oWpfTextBoxBase# = cast(oWidget#,System.Windows.Controls.Primitives.TextBoxBase).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
          do:
               
            case cEventTypeIP#:
              when "TextChanged"
              then
                oWpfTextBoxBase#:TextChanged:subscribe(oSingleton:OnEventArgsHandler_TextChanged).
              when "KeyDown"
              then
                do:
                  oWpfTextBoxBase#:KeyDown:Subscribe(oSingleton:OnEventArgsHandler_KeyDown).
                end.
              when "KeyUp"
              then
                do:
                  oWpfTextBoxBase#:KeyUp:Subscribe(oSingleton:OnEventArgsHandler_KeyUp).
                end.
            end case.
              
          end. /* First ttUiEvent */
            
        end. /* TextBoxBase (WPF) */
        
        
        /*        if type-of(oWidget#,System.Windows.Controls.Primitives.ButtonBase) then                                            POK POK */
        /*        do:                                                                                                                */
        /*                                                                                                                           */
        /*          oWpfButton# = cast(oWidget#,System.Windows.Controls.Primitives.ButtonBase).                                      */
        /*          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then*/
        /*            case cEventTypeIP#:                                                                                            */
        /*              when "Press" then oWpfButton#:Click:Subscribe(oSingleton:OnEventArgsHandler_Press).                          */
        /*            end case.                                                                                                      */
        /*                                                                                                                           */
        /*        end. /* pok pok */                                                                                                 */
        
        
          
        if type-of(oWidget#,System.Windows.Forms.DateTimePicker) then 
        do: 

          oFormsDateTimePicker# = cast(oWidget#, System.Windows.Forms.DateTimePicker).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then
          do:
              
            case cEventTypeIP#:
              
              when "ValueChanged" 
              then 
                do:
                  oFormsDateTimePicker#:ValueChanged:Subscribe(oSingleton:OnEventArgsHandler_ValueChanged).
                end.
              when "TextChanged" 
              then 
                do:
                  oFormsDateTimePicker#:ValueChanged:Subscribe(oSingleton:OnEventArgsHandler_TextChanged).
                end.
              
            end case. /* cEventTypeIP# */
              
          end. /* not can-find(first ttUiEvent */
           
        end. /* DateTimePicker */

        return ItemAddImplement(
          iPackIDIP#, 
          iFrmLogicIDIP#, 
          iDelegateIDIP#, 
          oWidget#, 
          (if oFrmLogicBufferIP# = ? then ? else oFrmLogicBufferIP#:hBuffer), 
          cWidgetNameIP#, 
          "combobox", 
          cEventTypeIP#,
          "").
      
      end.
      
    end. /* oWidget# is found */

    return 0.
    
  end method. /* ItemAdd ; ComboBox */


  method public static int64 ItemAdd(
  
    oWidgetType_GroupFrameOVID# as i_widgettype_groupframe, 
    iPackIDIP#                  as int64,
    iFrmLogicIDIP#              as int64,
    iDelegateIDIP#              as int64,
    oFrmLogicBufferIP#          as panaedra.msroot.msdr.logic.c_buf,
    cWidgetNameIP#              as character,
    cEventTypeIP#               as character):

    define variable oWidget#              as Progress.Lang.Object            no-undo.
    define variable oBindingSource#       as Progress.Lang.Object            no-undo.
    define variable oBindingSourceStrong# as c_bindingsource                 no-undo.
    define variable bDummy#               as logical                         no-undo.
    define variable oFormsTabcontrol#     as System.Windows.Forms.TabControl no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    if oSingleton = ? then oSingleton = new sc_coll_eventdata().
    
    do for ttUiEvent:
          
      assign
        cWidgetNameIP# = replace(cWidgetNameIP#,"_",".")
        oWidget#       = sc_coll_widgetdata:GetWidget(iPackIDIP#,"groupframe",?,cWidgetNameIP#, output bDummy#).

      if oWidget# <> ? then 
      do:
        
        if oFrmLogicBufferIP# <> ? then 
        do:
          
          oBindingSource# = sc_coll_widgetdata:GetBindingSource(iPackIDIP#,"groupframe",oFrmLogicBufferIP#:hBuffer,cWidgetNameIP#).
        
          if oBindingSource# = ? then 
          do:
            assign
              oBindingSourceStrong# = new c_bindingsource(sc_bindingsourcetype:i_Buffer, oFrmLogicBufferIP#:hBuffer)
              oBindingSource#       = oBindingSourceStrong#.
            sc_coll_widgetdata:SetBindingSource(oFrmLogicBufferIP#, oBindingSourceStrong#, oFrmLogicBufferIP#:hBuffer).
          end.
          else
            oBindingSourceStrong# = cast(oBindingSource#,c_bindingsource).
            
        end. /* A c_buf object is given. This is optional, you can also solely use the screen values (i_uivalue). */
        
        if type-of(oWidget#,System.Windows.Forms.TabControl) then 
        do:
          
          oFormsTabcontrol# = cast(oWidget#,System.Windows.Forms.TabControl).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
          do: 
            case cEventTypeIP#:
              
              when "SelectedIndexChanged" 
              then oFormsTabcontrol#:SelectedIndexChanged:Subscribe(oSingleton:OnEventArgsHandler_SelectedIndexChanged).
              
            end case.
            
          end. /* First ttUiEvent */
            
        end. /* TabControl */
        
        return ItemAddImplement(
          iPackIDIP#, 
          iFrmLogicIDIP#, 
          iDelegateIDIP#, 
          oWidget#, 
          (if oFrmLogicBufferIP# = ? then ? else oFrmLogicBufferIP#:hBuffer), 
          cWidgetNameIP#, 
          "combobox", 
          cEventTypeIP#,
          "").
      
      end.
      
    end. /* oWidget# is found */

    return 0.
    
  end method. /* ItemAdd ; GroupFrame */


  method public static int64 ItemAdd(
  
    oWidgetType_FormOVID# as i_widgettype_form, 
    iPackIDIP#                as int64,
    iFrmLogicIDIP#            as int64,
    iDelegateIDIP#            as int64,
    oFrmLogicBufferIP#        as panaedra.msroot.msdr.logic.c_buf,
    cWidgetNameIP#            as character,
    cEventTypeIP#             as character):

    define variable oWidget#              as Progress.Lang.Object      no-undo.
    define variable oBindingSource#       as Progress.Lang.Object      no-undo.
    define variable oBindingSourceStrong# as c_bindingsource           no-undo.
    define variable bDummy#               as logical                   no-undo.
    define variable oFormsForm#           as System.Windows.Forms.Form no-undo.
    
    define buffer ttUiEvent for ttUiEvent.

    if oSingleton = ? then oSingleton = new sc_coll_eventdata().
    
    do for ttUiEvent:
          
      assign
        cWidgetNameIP# = replace(cWidgetNameIP#,"_",".").
      
      if cWidgetNameIP# = "MdiMaster" then
        oWidget#       = paninui.view.init.events.sc_sgt_masterwindow_eventhandler:oMdiWindow.
      
      &if 0 &then
      if type-of(oWidget#,System.Windows.FrameworkElement) then
        message "pok form WPF" cWidgetNameIP# skip
          program-name(2) skip  
          program-name(3) skip  
          program-name(4) skip  
          cast(oWidget#,System.Windows.FrameworkElement):Name skip
          cEventTypeIP#
          view-as alert-box.
      else if cEventTypeIP# matches "*Key*" then
        message "pok form" cWidgetNameIP# skip
          program-name(2) skip  
          program-name(3) skip  
          program-name(4) skip  
          cast(oWidget#,System.Windows.Forms.Control):Name skip
          cEventTypeIP#
          view-as alert-box.
      &endif
        
      if oWidget# <> ? then 
      do:
        
        if oFrmLogicBufferIP# <> ? then 
        do:
          undo, throw new AppError(subst("The paninUi event 'form' shouldn't be passed a c_buf object '&1'.", oFrmLogicBufferIP#:ToString()), 99950121).
        end. /* A c_buf object is given. This is optional, you can also solely use the screen values (i_uivalue). */
        
        if type-of(oWidget#,System.Windows.Forms.Form) then 
        do:
          
          
          oFormsForm# = cast(oWidget#,System.Windows.Forms.Form).

          if lookup(cEventTypeIP#, "KeyPress,KeyDown,KeyUp") > 0 and 
            not oFormsForm#:KeyPreview then
            undo, throw new Progress.Lang.AppError(subst("Event &1 will never fire. Set attribute KeyPreview to true in Form &2 (&3)", cEventTypeIP#, oFormsForm#:ToString(), oFormsForm#:Text), 99950131).

          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
            case cEventTypeIP#:
              when "KeyPress" then oFormsForm#:KeyPress:Subscribe(oSingleton:OnEventArgsHandler_KeyPress).
              when "KeyDown"  then oFormsForm#:KeyDown:Subscribe(oSingleton:OnEventArgsHandler_KeyDown).
              when "KeyUp"    then oFormsForm#:KeyUp:Subscribe(oSingleton:OnEventArgsHandler_KeyUp).
            end case.
            
        end.
        
        return ItemAddImplement(
          iPackIDIP#, 
          iFrmLogicIDIP#, 
          iDelegateIDIP#, 
          oWidget#, 
          (if oFrmLogicBufferIP# = ? then ? else oFrmLogicBufferIP#:hBuffer), 
          cWidgetNameIP#, 
          "form", 
          cEventTypeIP#,
          "").
      
      end.
      
    end. /* oWidget# is found */

    return 0.
    
  end method. /* ItemAdd ; Form */


  method public /* Note: must be public, because called in oSingleton. Strange OE102A crash otherwise. OE102B gives compile error. */ 
    void OnEventArgsHandler_PositionChanged(
    
    oSender# as System.Object, 
    oArgs# as System.EventArgs):
    
    define variable bEclipseFix#      as logical                           no-undo.
    define variable oUiValue#         as paninui.view.interfaces.i_uivalue no-undo.
    define variable iSuspendedPackID# as int64                             no-undo.
    define variable bFirst#           as logical                           no-undo init true.
    define variable oFocus#           as Progress.Lang.Object              no-undo.
    define variable iFocusPackID#     as int64                             no-undo.
    define variable cFocusLinkName#   as character                         no-undo.
    
    define buffer b-ttUiEvent for ttUiEvent.

    for each b-ttUiEvent where b-ttUiEvent.oWidget = oSender# and b-ttUiEvent.cEventType = "PositionChanged"
      on error undo,throw:
      
      if bFirst# then 
      do:
        bFirst# = false.
        oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
        paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
      end.
          
      iSuspendedPackID# = EvtSuspendedEvent("query", "PositionChanged", oSender#, b-ttUiEvent.iDelegateID).
      if iSuspendedPackID# = 0 then 
        sc_coll_delegatedata:InvokeEventHandler(b-ttUiEvent.iDelegateID, oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).
      else 
      do:
      /* Normally we would have to store data for the suspended event here. 
         But oUiValue# and c_uieventdata are empty, so it's not necessary here. */
      end.

    end.
      
    catch ex as Progress.Lang.Error:
      /* Catch needed in all .NET events */
      sc_showexception:ShowException(ex).
    end catch.
    
  end. /* OnEventArgsHandler_PositionChanged */
  
  
  method private void OnEventArgsHandler_SelectionChanged(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#      as logical                           no-undo.
    define variable oUiValue#         as paninui.view.interfaces.i_uivalue no-undo.
    define variable oSelection#       as c_uivalue_selection               no-undo.
    define variable bFirst#           as logical                           no-undo init true.

    define variable oFocus#           as Progress.Lang.Object              no-undo.
    define variable iFocusPackID#     as int64                             no-undo.
    define variable cFocusLinkName#   as character                         no-undo.
    
    define variable iSuspendedPackID# as int64                             no-undo.
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "SelectionChanged"
        on error undo,throw:
        
        iSuspendedPackID# = EvtSuspendedEvent("query", "SelectionChanged", oSender#, ttUiEvent.iDelegateID).
        if iSuspendedPackID# = 0 then 
        do:
          
          if ttUiEvent.cEventOptions <> "Rows" then 
          do:
            undo, throw new AppError(subst("For SelectionChanged, EventOptions should be 'Rows' at this moment. '&1'.", ttUiEvent.cEventOptions), 99950122).
          end.
          
          if bFirst# then 
          do:
            assign
              bFirst#     = false
              oSelection# = paninui.view.use.analyze.sc_getuiframevalues:_sys_GetUiValueSelectionImplement(ttUiEvent.oWidget, "Rows", 25 /* Limit num rows to 25 in UI events */)
              oFocus#     = paninui.view.use.analyze.sc_analyzeform:GetFocus().
            paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
          end.  

          sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oSelection#, new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).
          
        end. 

      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_SelectionChanged */
  
  
  method private void OnEventArgsHandler_SortRequest(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#    as logical                           no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue no-undo.

    define variable bFirst#         as logical                           no-undo init true.
    define variable oFocus#         as Progress.Lang.Object              no-undo.
    define variable iFocusPackID#   as int64                             no-undo.
    define variable cFocusLinkName# as character                         no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "SortRequest"
        on error undo,throw:
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_SortRequest */
  
  
  method private void OnEventArgsHandler_ColumnSortModeChanged(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue no-undo.
    define variable bFirst#         as logical                           no-undo init true.
    define variable oFocus#         as Progress.Lang.Object              no-undo.
    define variable iFocusPackID#   as int64                             no-undo.
    define variable cFocusLinkName# as character                         no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "ColumnSortModeChanged"
        on error undo,throw:
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_ColumnSortModeChanged */ 
   
  
  method private void OnEventArgsHandler_CurrentCellChanged(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#    as logical                               no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue     no-undo.
    define variable oUiEventData#   as paninui.view.use.events.c_uieventdata no-undo.

    define variable bFirst#         as logical                               no-undo init true.
    define variable oFocus#         as Progress.Lang.Object                  no-undo.
    define variable iFocusPackID#   as int64                                 no-undo.
    define variable cFocusLinkName# as character                             no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "CurrentCellChanged"
        on error undo,throw:
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        oUiEventData# = new paninui.view.use.events.c_uieventdata("Allowed:Request_PositionChanged","",?,ttUiEvent.iPackID,iFocusPackID#,?).
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oUiValue#, oUiEventData#).
        if oUiEventData#:cData = "Request_PositionChanged" then 
        do:
          ForceGridPositionChanged(cast(oUiEventData#:oObject, c_framelogicbase):iPackID, ttUiEvent.cWidgetName, oArgs#).
        end.
        delete object oUiEventData#.
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_CurrentCellChanged */ 


  method protected static void ForceGridPositionChanged(iPackIDIP# as int64, cGridnameIP# as character, oArgsIP# as System.EventArgs):
    
    define variable oBindingSource#       as Progress.Lang.Object no-undo.
    define variable oBindingSourceSystem# as System.Object        no-undo.

    oBindingSource# = sc_coll_widgetdata:GetBindingSource(iPackIDIP#,"grid",?,cGridNameIP#).
    oBindingSourceSystem# = cast(oBindingSource#, System.Object).
    
    oSingleton:OnEventArgsHandler_PositionChanged(oBindingSourceSystem#, oArgsIP#).
    
  end method. /* ForceGridPositionChanged */
   
  
  method private void OnEventArgsHandler_Press(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#             as logical                                       no-undo.
    define variable oCheckBox#               as System.Windows.Forms.CheckBox                 no-undo.
    define variable oFormsButton#            as System.Windows.Forms.Button                   no-undo.
    define variable oFormsToolStripItem#     as System.Windows.Forms.ToolStripItem            no-undo.
    define variable oFormsToolStripMenuItem# as System.Windows.Forms.ToolStripMenuItem        no-undo.
    define variable oWpfButton#              as System.Windows.Controls.Primitives.ButtonBase no-undo.
    define variable oUiValue#                as paninui.view.interfaces.i_uivalue             no-undo.
    define variable bInvokePrepared#         as logical                                       no-undo.

    define variable bFirst#                  as logical                                       no-undo init true.
    define variable oFocus#                  as Progress.Lang.Object                          no-undo.
    define variable iFocusPackID#            as int64                                         no-undo.
    define variable cFocusLinkName#          as character                                     no-undo.
        
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "Press"
        on error undo,throw:

        bInvokePrepared# = false.
        
        if not bInvokePrepared# and type-of(oSender#, System.Windows.Forms.CheckBox) then 
        do:
          assign
            bInvokePrepared# = true
            oCheckBox#       = cast(oSender#, System.Windows.Forms.CheckBox)
            oUiValue#        = new c_uivalue_button(sc_coll_widgetdata:WidgetNameToLinkName(oCheckBox#, oCheckBox#:Name, ""), oCheckBox#:Enabled, oCheckBox#:Visible, oCheckBox#:Checked).
        end.
        
        if not bInvokePrepared# and type-of(oSender#, System.Windows.Forms.Button) then 
        do:
          assign
            bInvokePrepared# = true
            oFormsButton#    = cast(oSender#, System.Windows.Forms.Button)
            oUiValue#        = new c_uivalue_button(sc_coll_widgetdata:WidgetNameToLinkName(oCheckBox#, oFormsButton#:Name, ""), oFormsButton#:Enabled, oFormsButton#:Visible, false).
        end.
        
        if not bInvokePrepared# and type-of(oSender#, System.Windows.Controls.Primitives.ButtonBase) then 
        do:
          assign
            bInvokePrepared# = true
            oWpfButton#      = cast(oSender#, System.Windows.Controls.Primitives.ButtonBase)
            oUiValue#        = new c_uivalue_button(sc_coll_widgetdata:WidgetNameToLinkName(oCheckBox#, oWpfButton#:Name, ""), oWpfButton#:IsEnabled, oWpfButton#:IsVisible, false).
        end.
        
        if not bInvokePrepared# and type-of(oSender#, System.Windows.Forms.ToolStripMenuItem) then 
        do:
          assign
            bInvokePrepared#         = true
            oFormsToolStripMenuItem# = cast(oSender#, System.Windows.Forms.ToolStripMenuItem)
            oUiValue#                = new c_uivalue_button(sc_coll_widgetdata:WidgetNameToLinkName(oFormsToolStripMenuItem#, oFormsToolStripMenuItem#:Name, ""), oFormsToolStripMenuItem#:Enabled, oFormsToolStripMenuItem#:Visible, oFormsToolStripMenuItem#:Checked).
        end.
        
        if not bInvokePrepared# and type-of(oSender#, System.Windows.Forms.ToolStripItem) then 
        do:
          assign
            bInvokePrepared#     = true
            oFormsToolStripItem# = cast(oSender#, System.Windows.Forms.ToolStripItem)
            oUiValue#            = new c_uivalue_button(sc_coll_widgetdata:WidgetNameToLinkName(oFormsToolStripItem#,oFormsToolStripItem#:Name, ""), oFormsToolStripItem#:Enabled, oFormsToolStripItem#:Visible, false).
        end.
        
        if not bInvokePrepared# then 
        do:
          assign
            bInvokePrepared# = true
            /* Make sure we provide a valid uivalue object, but it should be obvious that the actual data can't be determined.
               The ToString() function should give a clue for debugging. The sender object handle will ofcourse never 
               be passed to the logic layer.
             */
            oUiValue#        = new c_uivalue_button(oSender#:ToString(), ?, ?, ?).
        end.
        
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  

        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).
        
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_Press */
  
  
  method private void OnEventArgsHandler_TextChanged(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#     as logical                             no-undo.
    define variable oComboBox#       as System.Windows.Forms.ListControl    no-undo.
    define variable oFormsTextBox#   as System.Windows.Forms.TextBox        no-undo.
    define variable oWpfTextBox#     as System.Windows.Controls.TextBox     no-undo.
    define variable oWpfCombobox#    as System.Windows.Controls.ComboBox    no-undo.
    define variable oDateTimePicker# as System.Windows.Forms.DateTimePicker no-undo. 
    define variable oUiValue#        as paninui.view.interfaces.i_uivalue   no-undo.
    
    
    define variable bFirst#          as logical                             no-undo init true.
    define variable oFocus#          as Progress.Lang.Object                no-undo.
    define variable iFocusPackID#    as int64                               no-undo.
    define variable cFocusLinkName#  as character                           no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent 
        where ttUiEvent.oWidget = oSender# 
        and   (ttUiEvent.cEventType = "TextChanged" or ttUiEvent.cEventType = "DelayedTextChanged")
        on error undo,throw:
        
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.
        if type-of(oSender#, System.Windows.Forms.ListControl) then 
        do:
          assign
            oComboBox# = cast(oSender#, System.Windows.Forms.ListControl)
            oUiValue#  = new c_uivalue_combobox(sc_coll_widgetdata:WidgetNameToLinkName(oComboBox#,oComboBox#:Name,""), oComboBox#:Enabled, oComboBox#:Visible, oComboBox#:Text, int64(string(oComboBox#:SelectedValue))).

          sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata_combobox("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).
        end.
        else if type-of(oSender#, System.Windows.Forms.TextBox) then 
          do:
            assign
              oFormsTextBox# = cast(oSender#, System.Windows.Forms.TextBox)
              oUiValue#      = new c_uivalue_combobox(sc_coll_widgetdata:WidgetNameToLinkName(oFormsTextBox#, oFormsTextBox#:Name,""), oFormsTextBox#:Enabled, oFormsTextBox#:Visible, oFormsTextBox#:Text).

            sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).
          end.
          else 
          do: 
            if type-of(oSender#, System.Windows.Forms.DateTimePicker) then 
            do:
              assign 
                oDateTimePicker# = cast(oSender#, System.Windows.Forms.DateTimePicker)
                oUiValue#        = new c_uivalue_combobox(sc_coll_widgetdata:WidgetNameToLinkName(oDateTimePicker#, oDateTimePicker#:Name,""), oDateTimePicker#:Enabled, oDateTimePicker#:Visible, oDateTimePicker#:Text).
              
              sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata_combobox("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).  
            end.
          end.
        
        if type-of(oSender#, System.Windows.Controls.TextBox) then 
        do:
          assign
            oWpfTextBox# = cast(oSender#, System.Windows.Controls.TextBox)
            oUiValue#    = new c_uivalue_combobox(sc_coll_widgetdata:WidgetNameToLinkName(oWpfTextBox#, oWpfTextBox#:Name,""), oWpfTextBox#:IsEnabled, oWpfTextBox#:IsVisible, oWpfTextBox#:Text).
        
          sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).
        end.
        
        if type-of(oSender#, System.Windows.Controls.ComboBox) then 
        do:
          assign
            oWpfCombobox# = cast(oSender#, System.Windows.Controls.ComboBox)
            oUiValue#     = new c_uivalue_combobox(sc_coll_widgetdata:WidgetNameToLinkName(oWpfCombobox#, oWpfCombobox#:Name, ""), oWpfCombobox#:IsEnabled, oWpfCombobox#:IsVisible, oWpfCombobox#:Text).
        
          sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).
        end.
        

      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_TextChanged */
  
  
  method private void OnEventArgsHandler_SelectionChangeCommitted(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#      as logical                                        no-undo.
    define variable oComboBox#        as System.Windows.Forms.ListControl               no-undo.
    define variable oUiValue#         as paninui.view.interfaces.i_uivalue              no-undo.
    define variable oUiValueCombobox# as paninui.view.use.events.c_uivalue_combobox     no-undo.
    define variable oUiEventData#     as paninui.view.use.events.c_uieventdata_combobox no-undo.
    define variable bHandled#         as logical                                        no-undo.
    define variable cPreviousText#    as character                                      no-undo.

    define variable bFirst#           as logical                                        no-undo init true.
    define variable oFocus#           as Progress.Lang.Object                           no-undo.
    define variable iFocusPackID#     as int64                                          no-undo.
    define variable cFocusLinkName#   as character                                      no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      if type-of(oSender#, System.Windows.Forms.ListControl) then 
      do:
        assign
          oComboBox# = cast(oSender#, System.Windows.Forms.ListControl).
      end.

      b_selectionchangecommitted:
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "SelectionChangeCommitted"
        on error undo,throw:
          
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        
        oUiEventData# = new paninui.view.use.events.c_uieventdata_combobox("","",?,ttUiEvent.iPackID,iFocusPackID#,?).
        
        if type-of(oSender#, System.Windows.Forms.ListControl) then 
        do:
          assign
            oUiValueCombobox# = new c_uivalue_combobox(sc_coll_widgetdata:WidgetNameToLinkName(oComboBox#,oComboBox#:Name,""), oComboBox#:Enabled, oComboBox#:Visible, oComboBox#:Text, int64(string(oComboBox#:SelectedValue)))
            oUiValue#         = oUiValueCombobox#
            cPreviousText#    = oComboBox#:Text.
        end.
        
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, oUiEventData#).
        
        if valid-object(oUiValueCombobox#) and 
          (oUiValueCombobox#:cText <> cPreviousText# or 
          oUiEventData#:bForceTextUpdate) then
        do:
          /* Do a delayed display, via BeginInvoke. */
          paninui.view.use.sys_display._sys_sc_display:_sys_SetUiValueByFormsInvoke(oComboBox#, "Text", oUiValueCombobox#:cText).
        end.
        
        delete object oUiEventData#.
          
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_SelectionChangeCommitted */  

  
  method private void OnEventArgsHandler_SelectedValueChanged(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable oComboBox#      as System.Windows.Forms.ListControl  no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue no-undo.

    define variable bFirst#         as logical                           no-undo init true.
    define variable oFocus#         as Progress.Lang.Object              no-undo.
    define variable iFocusPackID#   as int64                             no-undo.
    define variable cFocusLinkName# as character                         no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "SelectedValueChanged"
        on error undo,throw:
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        if type-of(oSender#, System.Windows.Forms.ListControl) then 
        do:
          assign
            oComboBox# = cast(oSender#, System.Windows.Forms.ListControl)
            oUiValue#  = new c_uivalue_combobox(sc_coll_widgetdata:WidgetNameToLinkName(oComboBox#,oComboBox#:Name,""), oComboBox#:Enabled, oComboBox#:Visible, oComboBox#:Text, int64(string(oComboBox#:SelectedValue))).
        end.
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end method. /* OnEventArgsHandler_SelectedValueChanged */ 
    
    
  method private void OnEventArgsHandler_SelectedIndexChanged(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable oComboBox#      as System.Windows.Forms.ListControl  no-undo.
    define variable oTabControl#    as System.Windows.Forms.TabControl   no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue no-undo.

    define variable bFirst#         as logical                           no-undo init true.
    define variable oFocus#         as Progress.Lang.Object              no-undo.
    define variable iFocusPackID#   as int64                             no-undo.
    define variable cFocusLinkName# as character                         no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "SelectedIndexChanged"
        on error undo,throw:
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        if type-of(oSender#, System.Windows.Forms.ListControl) then 
        do:
          assign
            oComboBox# = cast(oSender#, System.Windows.Forms.ListControl)
            oUiValue#  = new c_uivalue_combobox(sc_coll_widgetdata:WidgetNameToLinkName(oComboBox#,oComboBox#:Name,""), oComboBox#:Enabled, oComboBox#:Visible, oComboBox#:Text, int64(oComboBox#:SelectedValue:ToString())).
        end.
        else
          if type-of(oSender#, System.Windows.Forms.TabControl) then 
          do:
            assign
              oTabControl# = cast(oSender#, System.Windows.Forms.TabControl)
              oUiValue#    = new c_uivalue_groupframe(sc_coll_widgetdata:WidgetNameToLinkName(oTabControl#,oTabControl#:Name,""), oTabControl#:Enabled, oTabControl#:Visible, oTabControl#:SelectedIndex).
          end.
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end method. /* OnEventArgsHandler_SelectedIndexChanged */ 
    
    
  method private void OnEventArgsHandler_DropDown(oSender# as System.Object, oArgs# as System.EventArgs):
                                                     
    define variable oComboBox#      as System.Windows.Forms.ListControl  no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue no-undo.

    define variable bFirst#         as logical                           no-undo init true.
    define variable oFocus#         as Progress.Lang.Object              no-undo.
    define variable iFocusPackID#   as int64                             no-undo.
    define variable cFocusLinkName# as character                         no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "DropDown"
        on error undo,throw:
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        if type-of(oSender#, System.Windows.Forms.ListControl) then 
        do:
          assign
            oComboBox# = cast(oSender#, System.Windows.Forms.ListControl)
            oUiValue#  = new c_uivalue_combobox(sc_coll_widgetdata:WidgetNameToLinkName(oComboBox#,oComboBox#:Name,""), oComboBox#:Enabled, oComboBox#:Visible, oComboBox#:Text, int64(string(oComboBox#:SelectedValue))).
        end.
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end method. /* OnEventArgsHandler_DropDown */ 
    
    
  method private void OnEventArgsHandler_DropDownClosed(oSender# as System.Object, oArgs# as System.EventArgs):
                                                     
    define variable oComboBox#      as System.Windows.Forms.ListControl  no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue no-undo.

    define variable bFirst#         as logical                           no-undo init true.
    define variable oFocus#         as Progress.Lang.Object              no-undo.
    define variable iFocusPackID#   as int64                             no-undo.
    define variable cFocusLinkName# as character                         no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "DropDownClosed"
        on error undo,throw:
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        if type-of(oSender#, System.Windows.Forms.ListControl) then 
        do:
          assign
            oComboBox# = cast(oSender#, System.Windows.Forms.ListControl)
            oUiValue#  = new c_uivalue_combobox(sc_coll_widgetdata:WidgetNameToLinkName(oComboBox#,oComboBox#:Name,""), oComboBox#:Enabled, oComboBox#:Visible, oComboBox#:Text, int64(string(oComboBox#:SelectedValue))).
        end.
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,iFocusPackID#,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end method. /* OnEventArgsHandler_DropDownClosed */ 
  
  
  method private void OnEventArgsHandler_ValueChanged(oSender# as System.Object, oArgs# as System.EventArgs):
                                                     
    define variable oDateTimePicker# as System.Windows.Forms.DateTimePicker no-undo.
    define variable oUiValue#        as paninui.view.interfaces.i_uivalue   no-undo.

    define variable bFirst#          as logical                             no-undo init true.
    define variable oFocus#          as Progress.Lang.Object                no-undo.
    define variable iFocusPackID#    as int64                               no-undo.
    define variable cFocusLinkName#  as character                           no-undo.
    
    define buffer ttUiEvent for ttUiEvent.

    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "ValueChanged"
        on error undo,throw:
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        
        if type-of(oSender#, System.Windows.Forms.DateTimePicker) then 
        do:
          assign 
            oDateTimePicker# = cast(oSender#, System.Windows.Forms.DateTimePicker)
            oUiValue#        = new c_uivalue_combobox(sc_coll_widgetdata:WidgetNameToLinkName(oDateTimePicker#, oDateTimePicker#:Name,""), oDateTimePicker#:Enabled, oDateTimePicker#:Visible, oDateTimePicker#:Text).
          .
          
          sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata_combobox("", "", ?, ttUiEvent.iPackID,iFocusPackID#,? )).  
        end.
     
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end method. /* OnEventArgsHandler_DropDownClosed */ 
    
    
  method private void OnEventArgsHandler_KeyPress(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#        as logical                                        no-undo.
    define variable oFormsForm#         as System.Windows.Forms.Form                      no-undo.
    define variable oFormsKeyPressArgs# as System.Windows.Forms.KeyPressEventArgs         no-undo.
    define variable oUiValue#           as paninui.view.interfaces.i_uivalue              no-undo.
    define variable oUiEventData#       as paninui.view.use.events.c_uieventdata_keypress no-undo.
    define variable iAscii#             as integer                                        no-undo.
    define variable bHandled#           as logical                                        no-undo.

    define variable bFirst#             as logical                                        no-undo init true.
    define variable oFocus#             as Progress.Lang.Object                           no-undo.
    define variable iFocusPackID#       as int64                                          no-undo.
    define variable cFocusLinkName#     as character                                      no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      b_EachUiEvent:
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "KeyPress"
        on error undo,throw:
        
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        
        if (not ttUiEvent.bAllPacks) 
          and ttUiEvent.iPackID <> iFocusPackID# 
          then next b_EachUiEvent.
  
        if type-of(oSender#, System.Windows.Forms.Form) then 
        do:
          assign
            oFormsForm# = cast(oSender#, System.Windows.Forms.Form)
            oUiValue#   = new c_uivalue_form(sc_coll_widgetdata:WidgetNameToLinkName(oFormsForm#,oFormsForm#:Name,""), oFormsForm#:Enabled, oFormsForm#:Visible, oFormsForm#:Text, cFocusLinkName#).
        end.
        if type-of(oArgs#, System.Windows.Forms.KeyPressEventArgs) then 
        do:
          assign
            oFormsKeyPressArgs# = cast(oArgs#, System.Windows.Forms.KeyPressEventArgs).
          if length(ttUiEvent.cSvFilterKeyCode) > 0 
            and lookup(string(oFormsKeyPressArgs#:KeyChar), ttUiEvent.cSvFilterKeyCode) = 0 
            then next b_EachUiEvent.
          if length(ttUiEvent.cSvFilterKeyCodeNoFocus) > 0 
            and ttUiEvent.iPackID <> iFocusPackID#
            and lookup(string(oFormsKeyPressArgs#:KeyChar), ttUiEvent.cSvFilterKeyCodeNoFocus) = 0 
            then next b_EachUiEvent.
          /*            cCasedLetter#  = string(oFormsKeyPressArgs#:KeyChar).                                                  */
          /*          if length(cCasedLetter#) <> 1 then cCasedLetter# = "".                                                   */
          /*          if                                                                                                       */
          /*            (asc(cCasedLetter#) >= asc("A") and asc(cCasedLetter#) <= asc("Z"))                                    */
          /*            or                                                                                                     */
          /*            (asc(cCasedLetter#) >= asc("a") and asc(cCasedLetter#) <= asc("z"))                                    */
          /*            then                                                                                                   */
          /*          do:                                                                                                      */
          /*          end.                                                                                                     */
          /*          else cCasedLetter# = "". /* Platform user should use cKeyArgs for special characters, not cCasedLetter */*/
          assign
            oUiEventData# = new c_uieventdata_keypress("","",?,ttUiEvent.iPackID,iFocusPackID#,?, 
            string(oFormsKeyPressArgs#:KeyChar)).
        end.
        
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oUiValue#, oUiEventData#).
        
        if valid-object(oUiEventData#) and type-of(oUiEventData#, paninui.view.use.events.c_uieventdata_handled) then 
        do:
          bHandled# = cast(oUiEventData#, paninui.view.use.events.c_uieventdata_handled):bHandled.
          if bHandled# and valid-object(oFormsKeyPressArgs#) then 
          do:
            oFormsKeyPressArgs#:Handled = true.
          end.
        end.
        
        if    valid-object(oUiEventData#) 
          and oUiEventData#:bKeyCharChanged
          and valid-object(oFormsKeyPressArgs#) then 
        do:
          iAscii# = asc(oUiEventData#:cKeyChar).
          
          if iAscii# > 1114111 then iAscii# = 42. /* Character '*' */ 
          
          oFormsKeyPressArgs#:KeyChar = System.Char:ConvertFromUtf32(iAscii#). 

        end.
        
        if bHandled# then leave b_EachUiEvent.
        
      end. /* b_EachUiEvent */
      
      &if int(entry(1,proversion,".")) >= 11 and dec(proversion) >= 11.1 &then 
      
      catch oDotNetError# as System.ArgumentOutOfRangeException:
        /* ShouldHave: this extra catch block should not be necessary, every exception is Progress.Lang.Error. Contact TechSupport */
        message oDotNetError#:ToString()
          view-as alert-box.
      end catch.
      
      &endif
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_KeyPress */
  
  
  method private void OnEventArgsHandler_KeyDown(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#    as logical                               no-undo.
    define variable oFormsForm#     as System.Windows.Forms.Form             no-undo.
    define variable oFormsKeyArgs#  as System.Windows.Forms.KeyEventArgs     no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue     no-undo.
    define variable oUiEventData#   as paninui.view.interfaces.i_uieventdata no-undo.
    define variable bFirst#         as logical                               no-undo init true.
    define variable oFocus#         as Progress.Lang.Object                  no-undo.
    define variable iFocusPackID#   as int64                                 no-undo.
    define variable cFocusLinkName# as character                             no-undo.
    define variable cCasedLetter#   as character                             no-undo.
    define variable bCapsLock#      as logical                               no-undo.
    define variable bShift#         as logical                               no-undo.
    define variable bHandled#       as logical                               no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      b_EachUiEvent:
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "KeyDown"
        on error undo,throw:
        
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          if oFocus# <> ? then 
            paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
          else 
          do:
            /* Can happen if no widget has the focus. Happens always with an empty mdi window. */
            assign
              oFocus#       = oSender#
              iFocusPackID# = ttUiEvent.iPackID.
          end.  
        end.  
        
        if (not ttUiEvent.bAllPacks) 
          and ttUiEvent.iPackID <> iFocusPackID# 
          then next b_EachUiEvent.
        
        if type-of(oSender#, System.Windows.Forms.Form) then 
        do:
          assign
            oFormsForm# = cast(oSender#, System.Windows.Forms.Form)
            oUiValue#   = new c_uivalue_form(sc_coll_widgetdata:WidgetNameToLinkName(oFormsForm#,oFormsForm#:Name,""), oFormsForm#:Enabled, oFormsForm#:Visible, oFormsForm#:Text, cFocusLinkName#).
        end.
        if type-of(oArgs#, System.Windows.Forms.KeyEventArgs) then 
        do:
          assign
            oFormsKeyArgs# = cast(oArgs#, System.Windows.Forms.KeyEventArgs)
            cCasedLetter#  = string(oFormsKeyArgs#:KeyCode).
          if length(ttUiEvent.cSvFilterKeyCode) > 0
            and lookup(string(oFormsKeyArgs#:KeyCode), ttUiEvent.cSvFilterKeyCode) = 0 
            then next b_EachUiEvent.
          if length(ttUiEvent.cSvFilterKeyCodeNoFocus) > 0 
            and ttUiEvent.iPackID <> iFocusPackID#
            and lookup(string(oFormsKeyArgs#:KeyCode), ttUiEvent.cSvFilterKeyCodeNoFocus) = 0 
            then next b_EachUiEvent.
          if length(cCasedLetter#) <> 1 then cCasedLetter# = "".
          if 
            (asc(cCasedLetter#) >= asc("A") and asc(cCasedLetter#) <= asc("Z"))
            or  
            (asc(cCasedLetter#) >= asc("a") and asc(cCasedLetter#) <= asc("z"))
            then 
          do:
            bCapsLock# = panaedra.msroot.msutil.logic.sc_win32:GetCapsLockOn().
            bShift# = oFormsKeyArgs#:Shift.
            if not bCapsLock# then 
              cCasedLetter# = if bShift# then caps(cCasedLetter#) else lc(cCasedLetter#).
            else 
              cCasedLetter# = if not bShift# then caps(cCasedLetter#) else lc(cCasedLetter#).
          end.
          else cCasedLetter# = "". /* Platform user should use cKeyArgs for special characters, not cCasedLetter */
          assign
            oUiEventData# = new c_uieventdata_key("","",?,ttUiEvent.iPackID,iFocusPackID#,?, 
            string(oFormsKeyArgs#:KeyCode), 
            cCasedLetter#,
            oFormsKeyArgs#:Shift, oFormsKeyArgs#:Control, oFormsKeyArgs#:Alt).
        end.
        
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oUiValue#, oUiEventData#).
        
        if valid-object(oUiEventData#) and type-of(oUiEventData#, paninui.view.use.events.c_uieventdata_handled) then 
        do:
          bHandled# = cast(oUiEventData#, paninui.view.use.events.c_uieventdata_handled):bHandled.
          if bHandled# and valid-object(oFormsKeyArgs#) then 
          do:
            oFormsKeyArgs#:Handled = true.
          end.
        end.
        
        if bHandled# then leave b_EachUiEvent.
        
      end. /* b_EachUiEvent */

      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_KeyDown */
  
  
  method private void OnEventArgsHandler_KeyUp(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#    as logical                               no-undo.
    define variable oFormsForm#     as System.Windows.Forms.Form             no-undo.
    define variable oFormsKeyArgs#  as System.Windows.Forms.KeyEventArgs     no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue     no-undo.
    define variable oUiEventData#   as paninui.view.interfaces.i_uieventdata no-undo.
    define variable bFirst#         as logical                               no-undo init true.
    define variable oFocus#         as Progress.Lang.Object                  no-undo.
    define variable iFocusPackID#   as int64                                 no-undo.
    define variable cFocusLinkName# as character                             no-undo.
    define variable cCasedLetter#   as character                             no-undo.
    define variable bCapsLock#      as logical                               no-undo.
    define variable bShift#         as logical                               no-undo.
    define variable bHandled#       as logical                               no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      b_EachUiEvent:
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "KeyUp"
        on error undo,throw:
        
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        
        if (not ttUiEvent.bAllPacks) 
          and ttUiEvent.iPackID <> iFocusPackID# 
          then next b_EachUiEvent.
          
        if type-of(oSender#, System.Windows.Forms.Form) then 
        do:
          assign
            oFormsForm# = cast(oSender#, System.Windows.Forms.Form)
            oUiValue#   = new c_uivalue_form(sc_coll_widgetdata:WidgetNameToLinkName(oFormsForm#,oFormsForm#:Name,""), oFormsForm#:Enabled, oFormsForm#:Visible, oFormsForm#:Text, cFocusLinkName#).
        end.
        if type-of(oArgs#, System.Windows.Forms.KeyEventArgs) then 
        do:
          assign
            oFormsKeyArgs# = cast(oArgs#, System.Windows.Forms.KeyEventArgs)
            cCasedLetter#  = string(oFormsKeyArgs#:KeyCode).
          if length(ttUiEvent.cSvFilterKeyCode) > 0 
            and lookup(string(oFormsKeyArgs#:KeyCode), ttUiEvent.cSvFilterKeyCode) = 0 
            then next b_EachUiEvent.
          if length(ttUiEvent.cSvFilterKeyCodeNoFocus) > 0 
            and ttUiEvent.iPackID <> iFocusPackID#
            and lookup(string(oFormsKeyArgs#:KeyCode), ttUiEvent.cSvFilterKeyCodeNoFocus) = 0 
            then next b_EachUiEvent.
          if length(cCasedLetter#) <> 1 then cCasedLetter# = "".
          if 
            (asc(cCasedLetter#) >= asc("A") and asc(cCasedLetter#) <= asc("Z"))
            or  
            (asc(cCasedLetter#) >= asc("a") and asc(cCasedLetter#) <= asc("z"))
            then 
          do:
            bCapsLock# = panaedra.msroot.msutil.logic.sc_win32:GetCapsLockOn().
            bShift# = oFormsKeyArgs#:Shift.
            if not bCapsLock# then 
              cCasedLetter# = if bShift# then caps(cCasedLetter#) else lc(cCasedLetter#).
            else 
              cCasedLetter# = if not bShift# then caps(cCasedLetter#) else lc(cCasedLetter#).
          end.
          else cCasedLetter# = "". /* Platform user should use cKeyArgs for special characters, not cCasedLetter */
          assign
            oUiEventData# = new c_uieventdata_key("","",?,ttUiEvent.iPackID,iFocusPackID#,?, 
            string(oFormsKeyArgs#:KeyCode), 
            cCasedLetter#,
            oFormsKeyArgs#:Shift, oFormsKeyArgs#:Control, oFormsKeyArgs#:Alt).
        end.
        
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oUiValue#, oUiEventData#).
        
        if valid-object(oUiEventData#) and type-of(oUiEventData#, paninui.view.use.events.c_uieventdata_handled) then 
        do:
          bHandled# = cast(oUiEventData#, paninui.view.use.events.c_uieventdata_handled):bHandled.
          if bHandled# and valid-object(oFormsKeyArgs#) then 
          do:
            oFormsKeyArgs#:Handled = true.
          end.
        end.
        
        if bHandled# then leave b_EachUiEvent.
        
      end. /* b_EachUiEvent */

      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_KeyUp */

  
  method private void OnEventArgsHandler_DoubleClick(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable oControl#       as System.Windows.Forms.Control      no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue no-undo.

    define variable bFirst#         as logical                           no-undo init true.
    define variable oFocus#         as Progress.Lang.Object              no-undo.
    define variable iFocusPackID#   as int64                             no-undo.
    define variable cFocusLinkName# as character                         no-undo.
    
    define buffer ttUiEvent for ttUiEvent.

    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent 
        where ttUiEvent.oWidget    = oSender# 
        and   ttUiEvent.cEventType = "DoubleClick"
        on error undo,throw:
        
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        
        if type-of(oSender#, System.Windows.Forms.Control) then 
        do:
          assign 
            oControl# = cast(oSender#, System.Windows.Forms.Control)
            oUiValue# = new c_uivalue(sc_coll_widgetdata:WidgetNameToLinkName(oControl#, oControl#:Name,"")).
          .
          
          sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oUiValue#, new paninui.view.use.events.c_uieventdata("", "", ?, ttUiEvent.iPackID,iFocusPackID#,? )).  
        end.
     
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
  
  end method. /* OnEventArgsHandler_DoubleClick */
  

  method private void OnEventArgsHandler_CellBeginEdit(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#    as logical                                              no-undo.
    define variable oFormsGrid#     as System.Windows.Forms.DataGridView                    no-undo.
    define variable oFormsGridArgs# as System.Windows.Forms.DataGridViewCellCancelEventArgs no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue                    no-undo.
    define variable iIDCurrentRow#  as int64                                                no-undo.

    define variable bFirst#         as logical                                              no-undo init true.
    define variable oFocus#         as Progress.Lang.Object                                 no-undo.
    define variable iFocusPackID#   as int64                                                no-undo.
    define variable cFocusLinkName# as character                                            no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "CellBeginEdit"
        on error undo,throw:
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        if type-of(oSender#, System.Windows.Forms.DataGridView) then 
        do:
          assign
            oFormsGrid#     = cast(oSender#, System.Windows.Forms.DataGridView)
            oFormsGridArgs# = cast(oArgs#, System.Windows.Forms.DataGridViewCellCancelEventArgs)
            oUiValue#       = new c_uivalue_griditem(sc_coll_widgetdata:WidgetNameToLinkName(oFormsGrid#,oFormsGrid#:Name,""), oFormsGrid#:Enabled, oFormsGrid#:Visible).
        end.
        
        iIDCurrentRow# = int64(cast(cast(oFormsGrid#:CurrentRow,Progress.Lang.Object),System.Windows.Forms.DataGridViewRow):Cells[
          entry(num-entries(oFormsGrid#:Name,"_"),oFormsGrid#:Name,"_") +
          "__iID" +
          entry(num-entries(oFormsGrid#:Name,"_"),oFormsGrid#:Name,"_")
          ]:Value:ToString()) no-error.
            
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oUiValue#, new paninui.view.use.events.c_uieventdata_griditem("","",?,ttUiEvent.iPackID,iFocusPackID#,?, iIDCurrentRow#)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_CellBeginEdit */


  method private void OnEventArgsHandler_CellContentClick(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#    as logical                                        no-undo.
    define variable oFormsGrid#     as System.Windows.Forms.DataGridView              no-undo.
    define variable oFormsGridArgs# as System.Windows.Forms.DataGridViewCellEventArgs no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue              no-undo.
    define variable iIDCurrentRow#  as int64                                          no-undo.

    define variable bFirst#         as logical                                        no-undo init true.
    define variable oFocus#         as Progress.Lang.Object                           no-undo.
    define variable iFocusPackID#   as int64                                          no-undo.
    define variable cFocusLinkName# as character                                      no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "CellContentClick"
        on error undo,throw:
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        if type-of(oSender#, System.Windows.Forms.DataGridView) then 
        do:
          assign
            oFormsGrid#     = cast(oSender#, System.Windows.Forms.DataGridView)
            oFormsGridArgs# = cast(oArgs#, System.Windows.Forms.DataGridViewCellEventArgs)
            oUiValue#       = new c_uivalue_griditem(
              /* Since it's *cell*contentsclick, we give the name of the column. */
              sc_coll_widgetdata:WidgetNameToLinkName(? /* A cell doesn't have an object handle */, oFormsGrid#:Columns[oFormsGridArgs#:ColumnIndex]:Name, ""), 
              oFormsGrid#:Enabled, 
              oFormsGrid#:Visible).
        end.
        
        iIDCurrentRow# = int64(cast(cast(oFormsGrid#:CurrentRow,Progress.Lang.Object),System.Windows.Forms.DataGridViewRow):Cells[
          entry(num-entries(oFormsGrid#:Name,"_"),oFormsGrid#:Name,"_") +
          "__iID" +
          entry(num-entries(oFormsGrid#:Name,"_"),oFormsGrid#:Name,"_")
          ]:Value:ToString()) no-error.
            
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oUiValue#, new paninui.view.use.events.c_uieventdata_griditem("","",?,ttUiEvent.iPackID,iFocusPackID#,?, iIDCurrentRow#)).
        
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_CellContentClick */


  method private void OnEventArgsHandler_CellEndEdit(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#    as logical                                        no-undo.
    define variable oFormsGrid#     as System.Windows.Forms.DataGridView              no-undo.
    define variable oFormsGridArgs# as System.Windows.Forms.DataGridViewCellEventArgs no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue              no-undo.

    define variable bFirst#         as logical                                        no-undo init true.
    define variable oFocus#         as Progress.Lang.Object                           no-undo.
    define variable iFocusPackID#   as int64                                          no-undo.
    define variable cFocusLinkName# as character                                      no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "CellEndEdit"
        on error undo,throw:
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        if type-of(oSender#, System.Windows.Forms.DataGridView) then 
        do:
          assign
            oFormsGrid#     = cast(oSender#, System.Windows.Forms.DataGridView)
            oFormsGridArgs# = cast(oArgs#, System.Windows.Forms.DataGridViewCellEventArgs)
            oUiValue#       = new c_uivalue_griditem(sc_coll_widgetdata:WidgetNameToLinkName(oFormsGrid#,oFormsGrid#:Name,""), oFormsGrid#:Enabled, oFormsGrid#:Visible).
        end.
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oUiValue#, new paninui.view.use.events.c_uieventdata_griditem("","",?,ttUiEvent.iPackID,iFocusPackID#,?,1234)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_CellEndEdit */


  method private void OnEventArgsHandler_CellValueChanged(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#    as logical                                        no-undo.
    define variable oFormsGrid#     as System.Windows.Forms.DataGridView              no-undo.
    define variable oFormsGridArgs# as System.Windows.Forms.DataGridViewCellEventArgs no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue              no-undo.

    define variable bFirst#         as logical                                        no-undo init true.
    define variable oFocus#         as Progress.Lang.Object                           no-undo.
    define variable iFocusPackID#   as int64                                          no-undo.
    define variable cFocusLinkName# as character                                      no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "CellValueChanged"
        on error undo,throw:
        if bFirst# then 
        do:
          bFirst# = false.
          oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        if type-of(oSender#, System.Windows.Forms.DataGridView) then 
        do:
          assign
            oFormsGrid#     = cast(oSender#, System.Windows.Forms.DataGridView)
            oFormsGridArgs# = cast(oArgs#, System.Windows.Forms.DataGridViewCellEventArgs)
            oUiValue#       = new c_uivalue_griditem(sc_coll_widgetdata:WidgetNameToLinkName(oFormsGrid#,oFormsGrid#:Name,""), oFormsGrid#:Enabled, oFormsGrid#:Visible).
        end.
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oUiValue#, new paninui.view.use.events.c_uieventdata_griditem("","",?,ttUiEvent.iPackID,iFocusPackID#,?,1234)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_CellValueChanged */
  

  method private void OnEventArgsHandler_CurrentCellDirtyStateChanged(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#    as logical                           no-undo.
    define variable oFormsGrid#     as System.Windows.Forms.DataGridView no-undo.
    define variable oUiValue#       as paninui.view.interfaces.i_uivalue no-undo.

    define variable bFirst#         as logical                           no-undo init true.
    define variable oFocus#         as Progress.Lang.Object              no-undo.
    define variable iFocusPackID#   as int64                             no-undo.
    define variable cFocusLinkName# as character                         no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      if not bSuspendCurrentCellDirtyStateChanged then
        for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "CellValueChanged"
          on error undo,throw:
          if bFirst# then 
          do:
            bFirst# = false.
            oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
            paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
          end.  
          if type-of(oSender#, System.Windows.Forms.DataGridView) then 
          do:
            assign
              oFormsGrid# = cast(oSender#, System.Windows.Forms.DataGridView)
              oUiValue#   = new c_uivalue_griditem(sc_coll_widgetdata:WidgetNameToLinkName(oFormsGrid#,oFormsGrid#:Name,""), oFormsGrid#:Enabled, oFormsGrid#:Visible).
          end.
          sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oUiValue#, new paninui.view.use.events.c_uieventdata_griditem("","",?,ttUiEvent.iPackID,iFocusPackID#,?,1234)).
          if type-of(oSender#, System.Windows.Forms.DataGridView) then 
          do:
            bSuspendCurrentCellDirtyStateChanged = true.
            oFormsGrid#:CommitEdit(System.Windows.Forms.DataGridViewDataErrorContexts:Commit).
            bSuspendCurrentCellDirtyStateChanged = false.
          end.
        
        end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_CurrentCellDirtyStateChanged */


  method protected static int64 ItemAddImplement(
    iPackIDIP#       as int64,
    iFrmLogicIDIP#   as int64,
    iDelegateIDIP#   as int64,
    oWidgetIP#       as Progress.Lang.Object,   
    hWidgetIP#       as handle,   
    cWidgetNameIP#   as character,
    cEventNameIP#    as character,
    cEventTypeIP#    as character,
    cEventOptionsIP# as character):
    
    /* This method returns the new iID of the created ttUiEvent. */ 
    
    define buffer ttUiEvent for ttUiEvent.
    
    if oSingleton = ? then oSingleton = new sc_coll_eventdata().
    
    do for ttUiEvent:
    
      create ttUiEvent.
      sc_dbtrig:OnWriteOrCreate(buffer ttUiEvent:handle ).
      assign 
        ttUiEvent.iPackID       = iPackIDIP#
        ttUiEvent.iFrmLogicID   = iFrmLogicIDIP#
        ttUiEvent.iDelegateID   = iDelegateIDIP#
        ttUiEvent.oWidget       = oWidgetIP#
        ttUiEvent.hWidget       = hWidgetIP#
        ttUiEvent.cWidgetName   = cWidgetNameIP#
        ttUiEvent.cEventName    = cEventNameIP#
        ttUiEvent.cEventType    = cEventTypeIP#
        ttUiEvent.cEventOptions = cEventOptionsIP#
        .
        
      return ttUiEvent.iIDUiEvent.
      
    end.
    
  end method. /* ItemAddImplement */


  method public void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
    case oBroadcastDataIP#:cEventName:
      
      when "evt@c_qry@queryopen" then 
        do:
          OnQueryOpen(cast(oBroadcastDataIP#:oData, panaedra.msroot.msdr.logic.c_qry)).
        end.
        
      when "evt@c_qry@queryclose" then 
        do:
          OnQueryClose(cast(oBroadcastDataIP#:oData, panaedra.msroot.msdr.logic.c_qry)).
        end.
        
      when "evt@c_bindingsource@queryopen" then 
        do:
          OnBindingSourceQueryOpen(cast(oBroadcastDataIP#:oData, paninui.view.init.display.c_bindingsource)).
        end.
      
      when "evt@c_qry@UiResetCurrentItem" then 
        do:
          
          define variable cSvPackID#    as character no-undo.
          define variable cSvGridnames# as character no-undo.
          define variable iTell#        as integer   no-undo.
          
          paninui.view.use.sc_coll_widgetdata:GetGridWidgetsByQry(
          cast(oBroadcastDataIP#:oData, panaedra.msroot.msdr.interfaces.i_qry), 
            output cSvPackID#, 
            output cSvGridnames#).
          
          if cSvPackID# > "" then 
          do iTell# = 1 to num-entries(cSvPackID#):
            ForceGridPositionChanged(int64(entry(iTell#,cSvPackID#)), entry(iTell#,cSvGridnames#), ?).
          end.
          
        end. /* UiResetCurrentItem */
        
    end case.
    
  end method. /* OnEventBroadcast */


  method protected static void OnQueryOpen(oQryIP# as panaedra.msroot.msdr.interfaces.i_qry):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      /* For queries (a normal ABL query, packed in a c_qry object) we 
         use hWidget (the ABL query handle) and not oWidget. 
      */      
      for each ttUiEvent where ttUiEvent.hWidget = oQryIP#:sys__hQuery and ttUiEvent.cEventType = "QueryOpen"
        on error undo,throw:
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, ?,new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,?,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events 
           Note: QueryOpen in fact isn't a real .NET event, but a broadcasted event.
                 For consistancy, we handle it the same way.
         */
        panaedra.msroot.msutil.logic.sc_showexception:ShowException(ex).
      end catch.
    
    end.
    

  end method. /* OnQueryOpen */
  

  method protected static void OnQueryClose(oQryIP# as panaedra.msroot.msdr.interfaces.i_qry):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      /* For queries (a normal ABL query, packed in a c_qry object) we 
         use hWidget (the ABL query handle) and not oWidget. 
      */      
      for each ttUiEvent where ttUiEvent.hWidget = oQryIP#:sys__hQuery and ttUiEvent.cEventType = "QueryClose"
        on error undo,throw:
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, ?,new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,?,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events 
           Note: QueryClose in fact isn't a real .NET event, but a broadcasted event.
                 For consistancy, we handle it the same way.
         */
        panaedra.msroot.msutil.logic.sc_showexception:ShowException(ex).
      end catch.
    
    end.
    

  end method. /* OnQueryClose */
  

  method protected static void OnBindingSourceQueryOpen(oBindIP# as paninui.view.init.display.c_bindingsource):
    
    define variable iSuspendedPackID# as int64 no-undo.
    define buffer ttUiEvent for ttUiEvent.
    
    iSuspendedPackID# = EvtSuspendedEvent("query", "QueryOpen", oBindIP#, 0 /* No delegate id needed for queryopen */).

    if iSuspendedPackID# = 0 then 
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.hWidget = oBindIP#:Handle and ttUiEvent.cEventType = "QueryOpen"
        on error undo,throw:
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, ?, new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,?,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events 
           Note: QueryOpen in fact isn't a real .NET event, but a broadcasted event.
                 For consistancy, we handle it the same way.
         */
        panaedra.msroot.msutil.logic.sc_showexception:ShowException(ex).
      end catch.
    
    end. /* Strong scoping */

  end method. /* OnBindingSourceQueryOpen */

 
  method protected static int64 EvtSuspendedEvent(
    cEventNameIP# as character,
    cEventTypeIP# as character,
    oWidgetIP# as Progress.Lang.Object,
    iDelegateIDIP# as int64):

    define variable iReturn# as int64 no-undo.
    define buffer b-ttEventsSuspend for ttEventsSuspend.
    
    find first b-ttEventsSuspend
      where   b-ttEventsSuspend.cEventName = cEventNameIP#
      and     b-ttEventsSuspend.cEventType = cEventTypeIP#
      and     b-ttEventsSuspend.bSuspendAll
      no-error.
      
    if avail b-ttEventsSuspend then 
    do:
        
      iReturn# = b-ttEventsSuspend.iPackID.
        
      create b-ttEventsSuspend.
      sc_dbtrig:OnWriteOrCreate(buffer b-ttEventsSuspend:handle).
      assign 
        b-ttEventsSuspend.cEventName  = cEventNameIP#
        b-ttEventsSuspend.cEventType  = cEventTypeIP#
        b-ttEventsSuspend.oWidget     = oWidgetIP#
        b-ttEventsSuspend.iDelegateID = iDelegateIDIP#
        .
          
      if type-of(oWidgetIP#,paninui.view.init.display.c_bindingsource) then
        b-ttEventsSuspend.hWidget     = cast(oWidgetIP#,paninui.view.init.display.c_bindingsource):Handle.
      else 
      do:
        if type-of(oWidgetIP#,panaedra.msroot.msdr.interfaces.i_qry) then
          b-ttEventsSuspend.hWidget   = cast(oWidgetIP#,panaedra.msroot.msdr.interfaces.i_qry):sys__hQuery.
      end.

      return iReturn#.
        
    end.  
    
    return iReturn#.

  end method. /* EvtSuspendedEvent */ 


  method protected static void EvtSuspendedEventAddData(
    cEventNameIP#  as character,
    cEventTypeIP#  as character,
    oWidgetIP#     as Progress.Lang.Object,
    iDelegateIDIP# as int64,
    oUiValueIP#    as i_uivalue):
  
    define variable bEclipseFix# as logical no-undo.
    
    define buffer ttEventsSuspend for ttEventsSuspend.
    
    do for ttEventsSuspend:

      find last ttEventsSuspend
        where   ttEventsSuspend.cEventName = cEventNameIP#
        and     ttEventsSuspend.cEventType = cEventTypeIP#
        and     ttEventsSuspend.bSuspendAll = false
        and     ttEventsSuspend.oUiValue    = ?
        no-error.
      
      if available ttEventsSuspend then 
      do:
        ttEventsSuspend.oUiValue = oUiValueIP#.
      end.
      
    end.

  end method. /* EvtSuspendedEventAddData */ 
  

  method public static void EventsSuspend(
    iPackIDIP#    as int64,
    cEventNameIP# as character,
    cEventTypeIP# as character):
    
    /* Set a trigger record to puts events in a seperate temp-table instead of firing them directly */
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventsSuspend for ttEventsSuspend.
    
    do for ttEventsSuspend:
      
      if not can-find
        (first ttEventsSuspend 
        where  ttEventsSuspend.iPackID     = iPackIDIP#
        and    ttEventsSuspend.cEventName  = cEventNameIP#
        and    ttEventsSuspend.cEventType  = cEventTypeIP#
        and    ttEventsSuspend.bSuspendAll = true)
        then 
      do:
        create ttEventsSuspend.
        sc_dbtrig:OnWriteOrCreate(buffer ttEventsSuspend:handle).
        assign 
          ttEventsSuspend.iPackID     = iPackIDIP#
          ttEventsSuspend.cEventName  = cEventNameIP#
          ttEventsSuspend.cEventType  = cEventTypeIP#
          ttEventsSuspend.bSuspendAll = true
          .
      end.
      
    end. /* strong scope */
    
  end method. /* EventsSuspend */


  method public static void EventsResume(iPackIDIP# as int64):
    
    /* Fires the suspended events and removes them from the temp-table.              */
    /* To debug this, call DebugShowData just before you call EventsResume.          */
    /* You will see the suspend "flags" (bSuspendAll) and all suspended real events. */
    
    define variable oUiValue#          as i_uivalue            no-undo.
    define variable oUiEventData#      as i_uieventdata        no-undo.
    define variable bFirst#            as logical              no-undo init true.
    define variable oUiValueSelection# as i_uivalue            no-undo.

    define variable bFirstFocus#       as logical              no-undo init true.
    define variable oFocus#            as Progress.Lang.Object no-undo.
    define variable iFocusPackID#      as int64                no-undo.
    define variable cFocusLinkName#    as character            no-undo.
    
    define buffer ttEventsSuspend   for ttEventsSuspend.
    define buffer b-ttEventsSuspend for ttEventsSuspend.
    
    do for ttEventsSuspend:
      
      for each ttEventsSuspend
        where ttEventsSuspend.iPackID = iPackIDIP#
        and   ttEventsSuspend.bSuspendAll
        on error undo, throw:
          
        delete ttEventsSuspend.
        
      end.
      
      if not can-find(first ttEventsSuspend where ttEventsSuspend.bSuspendAll) then 
      do:
        /* Note: negative ID's, so sort descending */
        for each ttEventsSuspend 
          by ttEventsSuspend.iIDEventsSuspend descending
          on error undo, throw:

          if bFirstFocus# then 
          do:
            bFirstFocus# = false.
            oFocus# = paninui.view.use.analyze.sc_analyzeform:GetFocus().
            paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
          end.  
          
          case ttEventsSuspend.cEventType:
          
            when "QueryOpen" then 
              do:
                OnBindingSourceQueryOpen(cast(ttEventsSuspend.oWidget,paninui.view.init.display.c_bindingsource)).
              end.
          
            when "PositionChanged" or 
            when "SelectionChanged" then 
              do:
                
                /* For position changed and selection changed, we only want the last event to be fired per delegate. */  
                if not can-find
                  (first b-ttEventsSuspend 
                  where b-ttEventsSuspend.cEventType = ttEventsSuspend.cEventType 
                  and b-ttEventsSuspend.iPackID      = ttEventsSuspend.iPackID
                  and b-ttEventsSuspend.iDelegateID  = ttEventsSuspend.iDelegateID 
                  and rowid(b-ttEventsSuspend) <> rowid(ttEventsSuspend)) 
                  then 
                do:
                  
                  if ttEventsSuspend.cEventType = "SelectionChanged" then 
                  do:
                    if bFirst# then 
                    do:
                      bFirst# = false.
                      /* Get the grid selection once for all suspended events */
                      oUiValueSelection# = paninui.view.use.analyze.sc_getuiframevalues:_sys_GetUiValueSelectionImplement(ttEventsSuspend.oWidget, "Rows", 25 /* Limit num rows to 25 in UI events */).
                    end.  
                  end.
                
                  if ttEventsSuspend.oUiValue <> ? then oUiValue# = cast(ttEventsSuspend.oUiValue,i_uivalue).
                  if ttEventsSuspend.oUiEventData <> ? then oUiEventData# = cast(ttEventsSuspend.oUiEventData,i_uieventdata).
                  
                  if oUiEventData# = ? then oUiEventData# = new paninui.view.use.events.c_uieventdata("","",?,ttUiEvent.iPackID,iFocusPackID#,?).
                  
                  sc_coll_delegatedata:InvokeEventHandler(
                    ttEventsSuspend.iDelegateID, 
                    if ttEventsSuspend.cEventType = "SelectionChanged" then oUiValueSelection# else oUiValue#, 
                    oUiEventData#
                    ).
                  
                end. /* The last record of this delegate */
                
              end. /* "PositionChanged/SelectionChanged" */
          
            otherwise 
            do: 
              System.Windows.Forms.MessageBox:Show(subst(
                "Warning: '&1' has no support for suspending event types of '&2'.", 
                program-name(1), 
                ttEventsSuspend.cEventType)).
            end.
           
          end case.
        
          delete ttEventsSuspend.
           
        end. /* For each */
        
      end. /* No blockade present; fire events */
      
    end. /* Strong scoping */
    
  end method. /* EventsResume */
  

  method public static void AddEventOption(
    /* Add specific options to registered events */
    
    iPackIDIP#                as int64,
    iFrmLogicIDIP#            as int64,
    cWidgetNameIP#            as character,
    cEventTypeIP#             as character,
    cSvEventOptionIP#         as character
    ):
  
    define buffer ttUiEvent for ttUiEvent.
    
    define variable iIndex#  as integer no-undo.
    define variable iStart#  as integer no-undo.
    define variable iLength# as integer no-undo.
    
    do for ttUiEvent on error undo, throw:
      
      b_EachUiEvent:
      for each ttUiEvent 
        where ttUiEvent.iPackID     = iPackIDIP#
        and   ttUiEvent.iFrmLogicID = iFrmLogicIDIP#
        and   ttUiEvent.cWidgetName = cWidgetNameIP#
        and   ttUiEvent.cEventType  = cEventTypeIP#
        on error undo,throw:
        
        if "|" + cSvEventOptionIP# + "|" matches "*|bAllPacks=true|*" then 
        do:
          ttUiEvent.bAllPacks = true.
        end.
        
        if "|" + cSvEventOptionIP# + "|" matches "*|cSvFilterKeyCode=*" then 
        do:
          assign
            iIndex#                    = index("|" + cSvEventOptionIP#, "|cSvFilterKeyCode=")
            iStart#                    = iIndex# + length("|cSvFilterKeyCode=") - 1
            iLength#                   = index("|" + cSvEventOptionIP# + "|", "|", iStart#) - iStart# - 1
            ttUiEvent.cSvFilterKeyCode = substring(cSvEventOptionIP#, iStart#, iLength#).
        end.
          
        if "|" + cSvEventOptionIP# + "|" matches "*|cSvFilterKeyCodeNoFocus=*" then 
        do:
          assign
            iIndex#                           = index("|" + cSvEventOptionIP#, "|cSvFilterKeyCodeNoFocus=")
            iStart#                           = iIndex# + length("|cSvFilterKeyCodeNoFocus=") - 1
            iLength#                          = index("|" + cSvEventOptionIP# + "|", "|", iStart#) - iStart# - 1
            ttUiEvent.cSvFilterKeyCodeNoFocus = substring(cSvEventOptionIP#, iStart#, iLength#).
        end.
          
      end.
            
    end.
    
  end method. /* AddEventOption */
  
    
  method public static void DebugShowData():

    if panaedra.msroot.msutil.logic.sc_html:TempTableToHTML(buffer ttUiEvent:handle, panaedra.msroot.msutil.logic.sc_path:cTempDir + "ttUiEventData.html") then 
      panaedra.msroot.msutil.logic.sc_win32:ShellExecute(panaedra.msroot.msutil.logic.sc_path:cTempDir + "ttUiEventData.html"). /* Open file */
    
    if can-find(first ttEventsSuspend) then 
    do:
      if panaedra.msroot.msutil.logic.sc_html:TempTableToHTML(buffer ttEventsSuspend:handle, panaedra.msroot.msutil.logic.sc_path:cTempDir + "ttSuspendedEvents.html") then 
        panaedra.msroot.msutil.logic.sc_win32:ShellExecute(panaedra.msroot.msutil.logic.sc_path:cTempDir + "ttSuspendedEvents.html"). /* Open file */
    end.

  end method. /* DebugShowData */    

end class.

/* EOF */ 
