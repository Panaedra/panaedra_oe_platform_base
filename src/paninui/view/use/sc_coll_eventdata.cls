{panaedra/msi/logic/ctop_class.i} 
using paninui.view.init.display.*.
using paninui.view.interfaces.*.
using paninui.pack.interfaces.*.
using panaedra.msdr.logic.*.

class paninui.view.use.sc_coll_eventdata: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/sc_coll_eventdata.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-05 09:49:09+02:00 $ 
    Date Modified: $Modtime: 2009-10-04 22:33:11+02:00 $ 

      Description: Collection of UI event data. "Collection" (_coll_) is used to 
                   indicate local storage of runtime data, normally in a temp-table.

  \*****************************  Include Files ********************************/

  {paninui/view/use/sc_coll_eventdata_tt.i &protected=protected &static=static &class=class}
  
  /************************  Source control constructor ************************/
  constructor public sc_coll_eventdata(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  constructor protected sc_coll_eventdata():
    
  end constructor.

  
  define protected static variable oSingleton as paninui.view.use.sc_coll_eventdata no-undo.


  method protected static paninui.view.use.sc_coll_eventdata GetSingleton():
    
    if oSingleton = ? then 
      oSingleton = new paninui.view.use.sc_coll_eventdata().
      
    return oSingleton.
    
  end method. /* GetSingleton */

  method public static int64 ItemAdd (
    oWidgetTypeDataSourceOVID# as i_widgettype_query, /* *OVID# is not a real parameter, but an interface overload ID */
    iPackIDIP#                 as int64,
    iFrmLogicIDIP#             as int64,
    iDelegateIDIP#             as int64,
    cWidgetNameIP#             as character,
    cEventTypeIP#              as character):
    
    define variable oBindingSource#       as Progress.Lang.Object no-undo.
    define variable oBindingSourceStrong# as c_bindingsource      no-undo.
    def buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent:
          
      oBindingSource# = paninui.view.use.sc_coll_widgetdata:GetBindingSource(iPackIDIP#,"grid",?,cWidgetNameIP#).
    
      if oBindingSource# <> ? and type-of(oBindingSource#,c_bindingsource) then 
      do:
        oBindingSourceStrong# = cast(oBindingSource#,c_bindingsource).
        GetSingleton().
        if not can-find(first ttUiEvent where ttUiEvent.oWidget = oBindingSource# and ttUiEvent.cEventType = "PositionChanged") then
          oBindingSourceStrong#:PositionChanged:Subscribe(oSingleton:OnPositionChanged).
      end.
      
    end.
    
    return ItemAdd(iPackIDIP#, iFrmLogicIDIP#, iDelegateIDIP#, oBindingSource#, cWidgetNameIP#, "query", cEventTypeIP#).
    
  end method. /* ItemAdd ; Query */


  method private void OnPositionChanged(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "PositionChanged"
        on error undo,throw:
        paninui.view.use.delegates.sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID).
      end.
      
      catch e as Progress.Lang.Error :
        System.Windows.Forms.MessageBox:Show(e:GetMessage(1)).
      end catch.
    
    end.
    
  /* The ABL 'message view-as alert-box' doesn't work from inside .NET events. */
    
        
  end.
  
  
  method public static int64 ItemAdd (
    oWidgetTypeDataSourceOVID# as i_widgettype_datasource, /* *OVID# is not a real parameter, but an interface overload ID */
    iPackIDIP#                 as int64,
    iFrmLogicIDIP#             as int64,
    iDelegateIDIP#             as int64,
    oWidgetIP#                 as Progress.Lang.Object,   
    cWidgetNameIP#             as character,
    cEventNameIP#              as character,
    cEventTypeIP#              as character):
    
  /*    return ItemAdd(iIDUIFrameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "grid").*/
    
  end method. /* ItemAdd */


  method protected static int64 ItemAdd (
    iPackIDIP#     as int64,
    iFrmLogicIDIP# as int64,
    iDelegateIDIP# as int64,
    oWidgetIP#     as Progress.Lang.Object,   
    cWidgetNameIP# as character,
    cEventNameIP#  as character,
    cEventTypeIP#  as character):
    
    /* This method returns the new iID of the created ttUiEvent. */ 
    
    def buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent:
    
      create ttUiEvent.
      sc_dbtrig:OnWriteOrCreate(buffer ttUiEvent:handle ).
      assign 
        ttUiEvent.iPackID     = iPackIDIP#
        ttUiEvent.iFrmLogicID = iFrmLogicIDIP#
        ttUiEvent.iDelegateID = iDelegateIDIP#
        ttUiEvent.oWidget     = oWidgetIP#
        ttUiEvent.cWidgetName = cWidgetNameIP#
        ttUiEvent.cEventName  = cEventNameIP#
        ttUiEvent.cEventType  = cEventTypeIP#.
        
      return ttUiEvent.iIDUiEvent.
      
    end.
    
  end method. /* ItemAdd */


  method public static void DebugShowData():

    if panaedra.msroot.msutil.logic.sc_html:TempTableToHTML(buffer ttUiEvent:handle, panaedra.msf.logic.sc_path:cTempDir + "ttuieventdata.html") then 
      panaedra.msroot.msutil.logic.sc_win32:ShellExecute(panaedra.msf.logic.sc_path:cTempDir + "ttuieventdata.html"). /* Open file */

  end method. /* DebugShowData */    

          
end class.

/* EOF */ 
