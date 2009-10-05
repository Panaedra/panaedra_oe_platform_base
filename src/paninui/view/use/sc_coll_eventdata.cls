{panaedra/msi/logic/ctop_class.i} 
using paninui.view.init.display.*.
using paninui.view.interfaces.*.
using paninui.pack.interfaces.*.
using panaedra.msdr.logic.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class paninui.view.use.sc_coll_eventdata
  implements 
  panaedra.msroot.msutil.interfaces.i_eventbroadcastclient: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/sc_coll_eventdata.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-05 14:48:49+02:00 $ 
    Date Modified: $Modtime: 2009-10-05 14:39:05+02:00 $ 

      Description: Collection of UI event data. "Collection" (_coll_) is used to 
                   indicate local storage of runtime data, normally in a temp-table.

  \*****************************  Include Files ********************************/

  {paninui/view/use/sc_coll_eventdata_tt.i &protected=protected &static=static &class=class}
  
  /************************  Source control constructor ************************/
  constructor public sc_coll_eventdata(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected static variable oSingleton as paninui.view.use.sc_coll_eventdata no-undo.


  constructor protected sc_coll_eventdata():
    
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@c_qry@queryopen").

  end constructor.

  
  method public static void Initialize():
    
    if oSingleton = ? then oSingleton = new paninui.view.use.sc_coll_eventdata().
      
  end method. /* Initialize */
  

  method public static int64 ItemAdd (
  
    oWidgetTypeDataSourceOVID# as i_widgettype_query, /* *OVID# is not a real parameter, but an interface overload ID */
    iPackIDIP#                 as int64,
    iFrmLogicIDIP#             as int64,
    iDelegateIDIP#             as int64,
    oFrmLogicObjectIP#         as panaedra.msroot.msdr.logic.c_qry,
    cWidgetNameIP#             as character,
    cEventTypeIP#              as character):
    
    define variable oBindingSource#       as Progress.Lang.Object no-undo.
    define variable oBindingSourceStrong# as c_bindingsource      no-undo.
    def buffer ttUiEvent for ttUiEvent.

    if oSingleton = ? then oSingleton = new paninui.view.use.sc_coll_eventdata().
    
    if lookup(cEventTypeIP#,"QueryOpen,QueryClose,DeleteObject") > 0 then 
    do:
      
      return ItemAdd(iPackIDIP#, iFrmLogicIDIP#, iDelegateIDIP#, oFrmLogicObjectIP#, oFrmLogicObjectIP#:hQuery, cWidgetNameIP#, "query", cEventTypeIP#).
    
    end.    
    else
    do for ttUiEvent:
          
      oBindingSource# = paninui.view.use.sc_coll_widgetdata:GetBindingSource(iPackIDIP#,"grid",?,cWidgetNameIP#).
    
      if oBindingSource# <> ? and type-of(oBindingSource#,c_bindingsource) then 
      do:
        oBindingSourceStrong# = cast(oBindingSource#,c_bindingsource).
        if not can-find(first ttUiEvent where ttUiEvent.oWidget = oBindingSource# and ttUiEvent.cEventType = "PositionChanged") then
          oBindingSourceStrong#:PositionChanged:Subscribe(oSingleton:OnPositionChanged).
      end.
      
      return ItemAdd(iPackIDIP#, iFrmLogicIDIP#, iDelegateIDIP#, oBindingSource#, oFrmLogicObjectIP#:hQuery, cWidgetNameIP#, "query", cEventTypeIP#).
    
    end.
    
  end method. /* ItemAdd ; Query */


  method private void OnPositionChanged(oSender# as System.Object, oArgs# as System.EventArgs):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      for each ttUiEvent where ttUiEvent.oWidget = oSender# and ttUiEvent.cEventType = "PositionChanged"
        on error undo,throw:
        paninui.view.use.delegates.sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events */
        panaedra.msex.logic.sc_showexception-win32:ShowException(ex).
      end catch.
    
    end.
    
  end. /* OnPositionChanged */
  
  
  method public static int64 ItemAdd (
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


  method protected static int64 ItemAdd (
    iPackIDIP#     as int64,
    iFrmLogicIDIP# as int64,
    iDelegateIDIP# as int64,
    oWidgetIP#     as Progress.Lang.Object,   
    hWidgetIP#     as handle,   
    cWidgetNameIP# as character,
    cEventNameIP#  as character,
    cEventTypeIP#  as character):
    
    /* This method returns the new iID of the created ttUiEvent. */ 
    
    def buffer ttUiEvent for ttUiEvent.
    
    if oSingleton = ? then oSingleton = new paninui.view.use.sc_coll_eventdata().
    
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
    
  end method. /* ItemAdd */


  method public void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
    case oBroadcastDataIP#:cEventName:
      
      when "evt@c_qry@queryopen" then 
        do:
          OnQueryOpen(cast(oBroadcastDataIP#:oData, panaedra.msroot.msdr.logic.c_qry)).
        end.
        
    end case.
    
  end method. /* OnEventBroadcast */


  method protected static void OnQueryOpen (oQryIP# as panaedra.msroot.msdr.logic.c_qry):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttUiEvent for ttUiEvent.
    
    do for ttUiEvent on error undo, throw:
      
      /* For queries (a normal ABL query, packed in a c_qry object) we 
         use hWidget (the ABL query handle) and not oWidget. 
      */      
      for each ttUiEvent where ttUiEvent.hWidget = oQryIP#:hQuery and ttUiEvent.cEventType = "QueryOpen"
        on error undo,throw:
        paninui.view.use.delegates.sc_coll_delegatedata:InvokeEventHandler(ttUiEvent.iDelegateID).
      end.
      
      catch ex as Progress.Lang.Error:
        /* Catch needed in all .NET events 
           Note: QueryOpen in fact isn't a real .NET event, but a broadcasted event.
                 For consistancy, we handle it the same way.
         */
        panaedra.msex.logic.sc_showexception-win32:ShowException(ex).
      end catch.
    
    end.
    

  end method. /* OnQueryOpen */
  

  method public static void DebugShowData():

    if panaedra.msroot.msutil.logic.sc_html:TempTableToHTML(buffer ttUiEvent:handle, panaedra.msf.logic.sc_path:cTempDir + "ttuieventdata.html") then 
      panaedra.msroot.msutil.logic.sc_win32:ShellExecute(panaedra.msf.logic.sc_path:cTempDir + "ttuieventdata.html"). /* Open file */

  end method. /* DebugShowData */    

          
end class.

/* EOF */ 
