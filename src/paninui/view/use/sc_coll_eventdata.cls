{panaedra/msi/logic/ctop_class.i} 
using paninui.view.init.display.*.
using paninui.view.interfaces.*.
using paninui.view.use.*.
using paninui.view.use.delegates.*.
using paninui.view.use.events.*.
using paninui.pack.interfaces.*.
using panaedra.msdr.logic.*.
using panaedra.msex.logic.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class paninui.view.use.sc_coll_eventdata
  implements 
  panaedra.msroot.msutil.interfaces.i_eventbroadcastclient: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/sc_coll_eventdata.cls $ 
          Version: $Revision: 15 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-30 09:28:34+01:00 $ 
    Date Modified: $Modtime: 2009-10-30 02:13:02+01:00 $ 

      Description: Collection of UI event data. "Collection" (_coll_) is used to 
                   indicate local storage of runtime data, normally in a temp-table.

  \*****************************  Include Files ********************************/

  {paninui/view/use/sc_coll_eventdata_tt.i &protected=protected &static=static &class=class}
  
  /************************  Source control constructor ************************/
  constructor public sc_coll_eventdata(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 15 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected static variable oSingleton as sc_coll_eventdata no-undo.


  constructor protected sc_coll_eventdata():
    
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@c_qry@queryopen").
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@c_bindingsource@queryopen").

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
    oFrmLogicObjectIP#     as panaedra.msroot.msdr.interfaces.i_qry,
    cWidgetNameIP#         as character,
    cEventTypeIP#          as character):
    
    define variable oBindingSource#       as Progress.Lang.Object no-undo.
    define variable oBindingSourceStrong# as c_bindingsource      no-undo.
    def buffer ttUiEvent for ttUiEvent.

    if oSingleton = ? then oSingleton = new sc_coll_eventdata().
    
    if lookup(cEventTypeIP#,"QueryOpen,QueryClose,DeleteObject") > 0 then 
    do:
      
      return ItemAddImplement(iPackIDIP#, iFrmLogicIDIP#, iDelegateIDIP#, oFrmLogicObjectIP#, oFrmLogicObjectIP#:sys__hQuery, cWidgetNameIP#, "query", cEventTypeIP#).
    
    end.    
    else
    do for ttUiEvent:
          
      oBindingSource# = sc_coll_widgetdata:GetBindingSource(iPackIDIP#,"grid",?,cWidgetNameIP#).
    
      if oBindingSource# <> ? and type-of(oBindingSource#,c_bindingsource) then 
      do:
        oBindingSourceStrong# = cast(oBindingSource#,c_bindingsource).
        if not can-find(first ttUiEvent where ttUiEvent.oWidget = oBindingSource# and ttUiEvent.cEventType = "PositionChanged") then
          oBindingSourceStrong#:PositionChanged:Subscribe(oSingleton:OnEventArgsHandler_PositionChanged).
      end.
      
      return ItemAddImplement(iPackIDIP#, iFrmLogicIDIP#, iDelegateIDIP#, oBindingSource#, oFrmLogicObjectIP#:sys__hQuery, cWidgetNameIP#, "query", cEventTypeIP#).
    
    end.
    
  end method. /* ItemAdd ; Query */
  

  method public static int64 ItemAdd(
  
    oWidgetType_ButtonOVID# as i_widgettype_button, 
    iPackIDIP#              as int64,
    iFrmLogicIDIP#          as int64,
    iDelegateIDIP#          as int64,
    oFrmLogicBufferIP#      as panaedra.msroot.msdr.logic.c_buf,
    cWidgetNameIP#          as character,
    cEventTypeIP#           as character):

    define variable oWidget#              as Progress.Lang.Object           no-undo.
    define variable oBindingSource#       as Progress.Lang.Object           no-undo.
    define variable oBindingSourceStrong# as c_bindingsource                no-undo.
    define variable bDummy#               as logical                        no-undo.
    define variable oFormsButton#         as System.Windows.Forms.Button    no-undo.
    define variable oFormsCheckBox#       as System.Windows.Forms.CheckBox  no-undo.
    define variable oWpfButton#           as System.Windows.Controls.Button no-undo.
    
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
        
        if type-of(oWidget#,System.Windows.Forms.Button) then 
        do:
          
          oFormsButton# = cast(oWidget#,System.Windows.Forms.Button).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
            case cEventTypeIP#:
              when "Press" then oFormsButton#:Click:Subscribe(oSingleton:OnEventArgsHandler_Press).
            end case.
            
        end.
        
        if type-of(oWidget#,System.Windows.Controls.Button) then 
        do:
          
          oWpfButton# = cast(oWidget#,System.Windows.Controls.Button).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
            case cEventTypeIP#:
              when "Press" then oWpfButton#:Click:Subscribe(oSingleton:OnEventArgsHandler_Press).
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
          cEventTypeIP#).
      
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

    define variable oWidget#              as Progress.Lang.Object          no-undo.
    define variable oBindingSource#       as Progress.Lang.Object          no-undo.
    define variable oBindingSourceStrong# as c_bindingsource               no-undo.
    define variable bDummy#               as logical                       no-undo.
    define variable oFormsCombobox#       as System.Windows.Forms.ComboBox no-undo.
    
    define buffer ttUiEvent for ttUiEvent.

    if oSingleton = ? then oSingleton = new sc_coll_eventdata().
    
    do for ttUiEvent:
          
      assign
        cWidgetNameIP# = replace(cWidgetNameIP#,"_",".")
        oWidget#       = sc_coll_widgetdata:GetWidget(iPackIDIP#,"combobox",?,cWidgetNameIP#, output bDummy#).
        
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
        
        if type-of(oWidget#,System.Windows.Forms.ComboBox) then 
        do:
          
          oFormsCombobox# = cast(oWidget#,System.Windows.Forms.ComboBox).
          if not can-find(first ttUiEvent where ttUiEvent.oWidget = oWidget# and ttUiEvent.cEventType = cEventTypeIP#) then 
            case cEventTypeIP#:
              when "TextChanged" then oFormsCombobox#:TextChanged:Subscribe(oSingleton:OnEventArgsHandler_TextChanged).
            end case.
            
        end.
        
        return ItemAddImplement(
          iPackIDIP#, 
          iFrmLogicIDIP#, 
          iDelegateIDIP#, 
          oWidget#, 
          (if oFrmLogicBufferIP# = ? then ? else oFrmLogicBufferIP#:hBuffer), 
          cWidgetNameIP#, 
          "combobox", 
          cEventTypeIP#).
      
      end.
      
    end. /* oWidget# is found */

    return 0.
    
  end method. /* ItemAdd ; ComboBox */


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
        
      if oWidget# <> ? then 
      do:
        
        if oFrmLogicBufferIP# <> ? then 
        do:
          undo, throw new AppError(subst("The paninUi event 'form' shouldn't be passed a c_buf object '&1'.", oFrmLogicBufferIP#:ToString()), 99950121).
        end. /* A c_buf object is given. This is optional, you can also solely use the screen values (i_uivalue). */
        
        if type-of(oWidget#,System.Windows.Forms.Form) then 
        do:
          
          oFormsForm# = cast(oWidget#,System.Windows.Forms.Form).
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
          cEventTypeIP#).
      
      end.
      
    end. /* oWidget# is found */

    return 0.
    
  end method. /* ItemAdd ; Form */


  method private void OnEventArgsHandler_PositionChanged(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix# as logical                           no-undo.
    define variable oUiValue#    as paninui.view.interfaces.i_uivalue no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "PositionChanged"
        on error undo,throw:
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_PositionChanged */
  
  
  method private void OnEventArgsHandler_Press(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#     as logical                           no-undo.
    define variable oCheckBox#       as System.Windows.Forms.CheckBox     no-undo.
    define variable oFormsButton#    as System.Windows.Forms.Button       no-undo.
    define variable oWpfButton#      as System.Windows.Controls.Button    no-undo.
    define variable oUiValue#        as paninui.view.interfaces.i_uivalue no-undo.
    define variable bInvokePrepared# as logical                           no-undo.
    
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
            oUiValue#        = new c_uivalue_button(oCheckBox#:Name, oCheckBox#:Enabled, oCheckBox#:Visible, oCheckBox#:Checked).
        end.
        
        if not bInvokePrepared# and type-of(oSender#, System.Windows.Forms.Button) then 
        do:
          assign
            bInvokePrepared# = true
            oFormsButton#    = cast(oSender#, System.Windows.Forms.Button)
            oUiValue#        = new c_uivalue_button(oFormsButton#:Name, oFormsButton#:Enabled, oFormsButton#:Visible, false).
        end.
        
        if not bInvokePrepared# and type-of(oSender#, System.Windows.Controls.Button) then 
        do:
          assign
            bInvokePrepared# = true
            oWpfButton#      = cast(oSender#, System.Windows.Controls.Button)
            oUiValue#        = new c_uivalue_button(oWpfButton#:Name, oWpfButton#:IsEnabled, oWpfButton#:IsVisible, false).
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
        
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,?)).
        
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_Press */
  
  
  method private void OnEventArgsHandler_TextChanged(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix# as logical                           no-undo.
    define variable oComboBox#   as System.Windows.Forms.ComboBox     no-undo.
    define variable oUiValue#    as paninui.view.interfaces.i_uivalue no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "TextChanged"
        on error undo,throw:
        if type-of(oSender#, System.Windows.Forms.ComboBox) then 
        do:
          assign
            oComboBox# = cast(oSender#, System.Windows.Forms.ComboBox)
            oUiValue#  = new c_uivalue_combobox(oComboBox#:Name, oComboBox#:Enabled, oComboBox#:Visible, oComboBox#:Text).
        end.
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID,oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_TextChanged */
  
  
  method private void OnEventArgsHandler_KeyPress(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix#        as logical                                        no-undo.
    define variable oFormsForm#         as System.Windows.Forms.Form                      no-undo.
    define variable oFormsKeyPressArgs# as System.Windows.Forms.KeyPressEventArgs         no-undo.
    define variable oUiValue#           as paninui.view.interfaces.i_uivalue              no-undo.
    define variable oUiEventData#       as paninui.view.use.events.c_uieventdata_keypress no-undo.
    define variable bFirst#             as logical                                        no-undo init true.
    define variable oFocus#             as Progress.Lang.Object                           no-undo.
    define variable iFocusPackID#       as int64                                          no-undo.
    define variable cFocusLinkName#     as character                                      no-undo.
    define variable iAscii#             as integer                                        no-undo.
    define variable bHandled#           as logical                                        no-undo.
    
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
        
        if ttUiEvent.iPackID <> iFocusPackID# then next b_EachUiEvent.
          
        if type-of(oSender#, System.Windows.Forms.Form) then 
        do:
          assign
            oFormsForm# = cast(oSender#, System.Windows.Forms.Form)
            oUiValue#   = new c_uivalue_form(oFormsForm#:Name, oFormsForm#:Enabled, oFormsForm#:Visible, oFormsForm#:Text, cFocusLinkName#).
        end.
        if type-of(oArgs#, System.Windows.Forms.KeyPressEventArgs) then 
        do:
          assign
            oFormsKeyPressArgs# = cast(oArgs#, System.Windows.Forms.KeyPressEventArgs).
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
            oUiEventData# = new c_uieventdata_keypress("","",?,?, 
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
          
/*          panaedra.msroot.msutil.logic.sc_messagebox:Show(           */
/*          panaedra.msroot.msutil.interfaces.sc_messageboxtype:oDebug,*/
/*          string(iAscii#)                                         */
/*          ).                                                      */
          
/*          define variable oUtf8 as System.Text.Encoding no-undo.*/
/*          oUtf8 = System.Text.Encoding:UTF8.                    */


          if iAscii# > 1114111 then iAscii# = 42. /* Character '*' */ 
          
          oFormsKeyPressArgs#:KeyChar = System.Char:ConvertFromUtf32(iAscii#). 

        end.
        
        if bHandled# then leave b_EachUiEvent.
        
      end. /* b_EachUiEvent */
      
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
          paninui.view.use.sc_coll_widgetdata:GetWidgetByHandle(oFocus#, output iFocusPackID#, output cFocusLinkName#).
        end.  
        
        if ttUiEvent.iPackID <> iFocusPackID# then next b_EachUiEvent.
          
        if type-of(oSender#, System.Windows.Forms.Form) then 
        do:
          assign
            oFormsForm# = cast(oSender#, System.Windows.Forms.Form)
            oUiValue#   = new c_uivalue_form(oFormsForm#:Name, oFormsForm#:Enabled, oFormsForm#:Visible, oFormsForm#:Text, cFocusLinkName#).
        end.
        if type-of(oArgs#, System.Windows.Forms.KeyEventArgs) then 
        do:
          assign
            oFormsKeyArgs# = cast(oArgs#, System.Windows.Forms.KeyEventArgs)
            cCasedLetter#  = string(oFormsKeyArgs#:KeyCode).
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
            oUiEventData# = new c_uieventdata_key("","",?,?, 
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
    
    define variable bEclipseFix# as logical                           no-undo.
    define variable oFormsForm#  as System.Windows.Forms.Form         no-undo.
    define variable oUiValue#    as paninui.view.interfaces.i_uivalue no-undo.
    
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "KeyUp"
        on error undo,throw:
        if type-of(oSender#, System.Windows.Forms.Form) then 
        do:
          assign
            oFormsForm# = cast(oSender#, System.Windows.Forms.Form)
            oUiValue#   = new c_uivalue_combobox(oFormsForm#:Name, oFormsForm#:Enabled, oFormsForm#:Visible, oFormsForm#:Text).
        end.
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, oUiValue#, new paninui.view.use.events.c_uieventdata("","",?,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        sc_showexception:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnEventArgsHandler_KeyUp */
  
  
  method public static int64 ItemAddXXX(
    oWidgetTypeDataSourceOVID# as i_widgettype_datasource, /* OVID# is not a real parameter, but an interface overload ID */
    iPackIDIP#                 as int64,
    iFrmLogicIDIP#             as int64,
    iDelegateIDIP#             as int64,
    oWidgetIP#                 as Progress.Lang.Object,   
    cWidgetNameIP#             as character,
    cEventNameIP#              as character,
    cEventTypeIP#              as character):
    
  /*    return ItemAdd(iIDUIFrameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "grid").*/
    
  end method. /* ItemAdd */


  method protected static int64 ItemAddImplement(
    iPackIDIP#     as int64,
    iFrmLogicIDIP# as int64,
    iDelegateIDIP# as int64,
    oWidgetIP#     as Progress.Lang.Object,   
    hWidgetIP#     as handle,   
    cWidgetNameIP# as character,
    cEventNameIP#  as character,
    cEventTypeIP#  as character):
    
    /* This method returns the new iID of the created ttUiEvent. */ 
    
    define buffer ttUiEvent for ttUiEvent.
    
    if oSingleton = ? then oSingleton = new sc_coll_eventdata().
    
    do for ttUiEvent:
    
      create ttUiEvent.
      sc_dbtrig:OnWriteOrCreate(buffer ttUiEvent:handle ).
      assign 
        ttUiEvent.iPackID     = iPackIDIP#
        ttUiEvent.iFrmLogicID = iFrmLogicIDIP#
        ttUiEvent.iDelegateID = iDelegateIDIP#
        ttUiEvent.oWidget     = oWidgetIP#
        ttUiEvent.hWidget     = hWidgetIP#
        ttUiEvent.cWidgetName = cWidgetNameIP#
        ttUiEvent.cEventName  = cEventNameIP#
        ttUiEvent.cEventType  = cEventTypeIP#.
        
      return ttUiEvent.iIDUiEvent.
      
    end.
    
  end method. /* ItemAddImplement */


  method public void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
    case oBroadcastDataIP#:cEventName:
      
      when "evt@c_qry@queryopen" then 
        do:
          OnQueryOpen(cast(oBroadcastDataIP#:oData, panaedra.msroot.msdr.logic.c_qry)).
        end.
        
      when "evt@c_bindingsource@queryopen" then 
        do:
          OnBindingSourceQueryOpen(cast(oBroadcastDataIP#:oData, paninui.view.init.display.c_bindingsource)).
        end.
        
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
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, ?,new paninui.view.use.events.c_uieventdata("","",?,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events 
           Note: QueryOpen in fact isn't a real .NET event, but a broadcasted event.
                 For consistancy, we handle it the same way.
         */
        panaedra.msex.logic.sc_showexception:ShowException(ex).
      end catch.
    
    end.
    

  end method. /* OnQueryOpen */
  

  method protected static void OnBindingSourceQueryOpen(oBindIP# as paninui.view.init.display.c_bindingsource):
    
    define variable iSuspendedPackID# as int64 no-undo.
    define buffer ttUiEvent for ttUiEvent.
    
    iSuspendedPackID# = SuspendedEvent("query", "QueryOpen", oBindIP#).

    if iSuspendedPackID# = 0 then 
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.hWidget = oBindIP#:Handle and ttUiEvent.cEventType = "QueryOpen"
        on error undo,throw:
        sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID, ?, new paninui.view.use.events.c_uieventdata("","",?,?)).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events 
           Note: QueryOpen in fact isn't a real .NET event, but a broadcasted event.
                 For consistancy, we handle it the same way.
         */
        panaedra.msex.logic.sc_showexception:ShowException(ex).
      end catch.
    
    end. /* Strong scoping */

  end method. /* OnBindingSourceQueryOpen */

 
  method protected static int64 SuspendedEvent(
    cEventNameIP# as character,
    cEventTypeIP# as character,
    oWidgetIP# as Progress.Lang.Object):

    define variable iReturn# as int64 no-undo.
    define buffer ttEventsSuspend for ttEventsSuspend.
    
    do for ttEventsSuspend:
      
      find first ttEventsSuspend
        where   ttEventsSuspend.cEventName = cEventNameIP#
        and     ttEventsSuspend.cEventType = cEventTypeIP#
        and     ttEventsSuspend.bSuspendAll
        no-error.
      
      if avail ttEventsSuspend then 
      do:
        
        iReturn# = ttEventsSuspend.iPackID.
        
        create ttEventsSuspend.
        sc_dbtrig:OnWriteOrCreate(buffer ttEventsSuspend:handle).
        assign 
          ttEventsSuspend.cEventName = cEventNameIP#
          ttEventsSuspend.cEventType = cEventTypeIP#
          ttEventsSuspend.oWidget    = oWidgetIP#.
          
        if type-of(oWidgetIP#,paninui.view.init.display.c_bindingsource) then
          ttEventsSuspend.hWidget     = cast(oWidgetIP#,paninui.view.init.display.c_bindingsource):Handle.
        else
          if type-of(oWidgetIP#,panaedra.msroot.msdr.interfaces.i_qry) then
            ttEventsSuspend.hWidget   = cast(oWidgetIP#,panaedra.msroot.msdr.interfaces.i_qry):sys__hQuery.

        return iReturn#.
        
      end.  
      
    end.
    
    return iReturn#.

  end method. /* SuspendedEvent */ 
 

  method public static void EventsSuspend(
    iPackIDIP#    as int64,
    cEventNameIP# as character,
    cEventTypeIP# as character):
    
    /* Puts events in a seperate temp-table instead of firing them */
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventsSuspend for ttEventsSuspend.
    
    do for ttEventsSuspend:
      
      create ttEventsSuspend.
      sc_dbtrig:OnWriteOrCreate(buffer ttEventsSuspend:handle).
      assign 
        ttEventsSuspend.iPackID     = iPackIDIP#
        ttEventsSuspend.cEventName  = cEventNameIP#
        ttEventsSuspend.cEventType  = cEventTypeIP#
        ttEventsSuspend.bSuspendAll = true
        .
        
    end.
    
  end method. /* EventsSuspend */


  method public static void EventsResume(iPackIDIP# as int64):
    
    /* Fires the suspended events and removes them from the temp-table */
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventsSuspend for ttEventsSuspend.
    
    do for ttEventsSuspend:
      
      for each ttEventsSuspend
        where ttEventsSuspend.iPackID = iPackIDIP#
        and   ttEventsSuspend.bSuspendAll:
          
        delete ttEventsSuspend.
        
      end.
      
      if not can-find(first ttEventsSuspend where ttEventsSuspend.bSuspendAll) then 
      do:
        for each ttEventsSuspend 
          /* Note: negative ID's, so sort descending */
          by ttEventsSuspend.iIDEventsSuspend descending:
          
          case ttEventsSuspend.cEventType:
          
            when "QueryOpen" then 
              do:
                OnBindingSourceQueryOpen(cast(ttEventsSuspend.oWidget,paninui.view.init.display.c_bindingsource)).
              end.
          
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

    
  method public static void DebugShowData():

    if panaedra.msroot.msutil.logic.sc_html:TempTableToHTML(buffer ttUiEvent:handle, panaedra.msf.logic.sc_path:cTempDir + "ttUiEventData.html") then 
      panaedra.msroot.msutil.logic.sc_win32:ShellExecute(panaedra.msf.logic.sc_path:cTempDir + "ttUiEventData.html"). /* Open file */
    
    if can-find(first ttEventsSuspend) then 
    do:
      if panaedra.msroot.msutil.logic.sc_html:TempTableToHTML(buffer ttEventsSuspend:handle, panaedra.msf.logic.sc_path:cTempDir + "ttSuspendedEvents.html") then 
        panaedra.msroot.msutil.logic.sc_win32:ShellExecute(panaedra.msf.logic.sc_path:cTempDir + "ttSuspendedEvents.html"). /* Open file */
    end.

  end method. /* DebugShowData */    

end class.

/* EOF */ 
