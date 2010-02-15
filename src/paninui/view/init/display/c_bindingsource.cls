{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
{paninui/logic/includes/preproc_dotnetclasses.i &class=class}       
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class paninui.view.init.display.c_bindingsource
  inherits
  &if {&paninui_tty} &then
  Progress.Lang.Object
  &else 
  Progress.Data.BindingSource
  &endif
    : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/init/display/c_bindingsource.cls $ 
          Version: $Revision: 19 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-02-15 13:12:48+01:00 $ 
    Date Modified: $Modtime: 2010-02-15 13:12:22+01:00 $ 

      Description:  _CMPNY_ inheritance van de progress DataSource. 
                    Bedoeld om onvolkomenheden van de progress DataSource
                    in te vullen. Geen data access.
                    
                    TODO: c_bindingsource moet verhuizen naar logic (vrij belang_REGION_! .r mist nu in de productie pl)

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_bindingsource(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 19 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected variable hCustomBuffer as handle    no-undo.
  define protected variable hCustomQuery  as handle    no-undo.
  define protected variable cLocalName    as character no-undo.

  define property sys__hCustomQuery  as handle    no-undo 
    public get:
      return hCustomQuery.
    end get.

  &if {&paninui_tty} &then
  
  define public property Position as integer no-undo 
    get.
    set.
    
  define public property NewRow as logical no-undo 
    get.
    set.
    
  &endif  

  constructor protected c_bindingsource():
    
    super().
    
    &if {&paninui_tty} &then
    &else
    /* TODO: Don't know the exact effects of the following three settings. */
    this-object:AutoSort = true.
    this-object:AutoSync = true.
   /*    this-object:Batching = true.*/
    &endif
    
    cLocalName = "[blank]".

  end constructor.
        

  constructor protected c_bindingsource(hQueryIP# as handle):
    
    &if {&paninui_tty} &then
    super().
    &else
    super(hQueryIP#).
    &endif

    &if {&paninui_tty} &then
    &else
    /* TODO: Don't know the exact effects of the following three settings. */
    this-object:AutoSort = true.
    this-object:AutoSync = true.
/*    this-object:Batching = true.*/
    &endif

    cLocalName = hQueryIP#:name.
    if (cLocalName = "" or cLocalName = ?)   and hQueryIP#:type = "query" then cLocalName = hQueryIP#:get-buffer-handle(1):name no-error.
    if (cLocalName = "" or cLocalName = ?)  then cLocalName = hQueryIP#:type.

    /* ToDo: cache this search */
    if search("panaedra/msroot/msutil/logic/sc_eventbroadcaster_loose.p") <> ?
      or search("panaedra/msroot/msutil/logic/sc_eventbroadcaster_loose.r") <> ?
      then run panaedra/msroot/msutil/logic/sc_eventbroadcaster_loose.p("evt@c_bindingsource@queryopen", "", this-object).
    
  end constructor.

  
  constructor public c_bindingsource(oBufferOVIP# as paninui.view.init.display.i_bindingsourcetype_buffer, hBufferIP# as handle ):
    
    define variable rWorkaroundCreate# as rowid no-undo.

    this-object().

    do on error undo, throw:

      cLocalName = hBufferIP#:name.
      if (cLocalName = "" or cLocalName = ?)  then cLocalName = hBufferIP#:type.

      if not hBufferIP#:available then
      do:
        /* Nasty Progress limitation in 10.2A01: a buffer needs to be available at the moment you make a bindingsource for it. */
        /* Since it's temp-tables in paninUi, a buffer-create seems safe for now.                                              */
        /* The "transaction" keyword is not used, so on a db buffer an exception will be thrown.                               */
        hBufferIP#:buffer-create().
        rWorkaroundCreate# = hBufferIP#:rowid.
      end.

      SetHandle(hBufferIP#).

      if rWorkaroundCreate# <> ? then
      do:
        hBufferIP#:find-by-rowid(rWorkaroundCreate#, no-lock).
        hBufferIP#:buffer-delete().
      end.

      catch ex as Progress.Lang.Error:
        undo, throw new Progress.Lang.AppError(subst(
          "Error in s_bindingsource constructor:i_bindingsourcetype_buffer '&1'~n&2",
          this-object:ToString(),
          ex:GetMessage(1)),
          ex:GetMessageNum(1)).
      end catch.

    end.
    
  end constructor.      


  constructor public c_bindingsource(oQueryOVIP# as paninui.view.init.display.i_bindingsourcetype_query, hBufferOrQueryIP# as handle ):

    this-object().

    define variable hQuery# as handle no-undo.

    if hBufferOrQueryIP#:type = "buffer" then
    do:
      create buffer hCustomBuffer for table hBufferOrQueryIP#:table-handle buffer-name hBufferOrQueryIP#:name.
      create query hCustomQuery.
      hCustomQuery:set-buffers(hCustomBuffer).
      hCustomQuery:query-prepare(subst("preselect each &1", hCustomBuffer:name)).
      hCustomQuery:query-open.
      hQuery# = hCustomQuery.
    end.
    else
      hQuery# = hBufferOrQueryIP#.

    SetHandle(hQuery#).

    cLocalName = hBufferOrQueryIP#:name.
    if (cLocalName = "" or cLocalName = ?) and hBufferOrQueryIP#:type = "query" then cLocalName = hBufferOrQueryIP#:get-buffer-handle(1):name no-error.
    if (cLocalName = "" or cLocalName = ?) then cLocalName = hBufferOrQueryIP#:type.

    if search("panaedra/msroot/msutil/logic/sc_eventbroadcaster_loose.p") <> ?
      or search("panaedra/msroot/msutil/logic/sc_eventbroadcaster_loose.r") <> ?
      then run panaedra/msroot/msutil/logic/sc_eventbroadcaster_loose.p("evt@c_bindingsource@queryopen", "", this-object).

  end constructor.


  method protected void SetHandle(hDataObjectIP# as handle):
    
    define variable iTell# as integer   no-undo.
    define variable cTemp# as character no-undo.
    define variable cSkip# as character no-undo.
    
    &if not {&paninui_tty} &then

    /* TODO: Don't know the exact effects of the following three settings. */
    this-object:AutoSort = true.
    this-object:AutoSync = true.
    /*    this-object:Batching = true.*/
    
    sc_prop:SetDataObjectPropsFromHelpString(hDataObjectIP#).

    case hDataObjectIP#:type:
      
      when "buffer" then 
        do:
          cSkip# = GetFieldsNoDataBindingString(hDataObjectIP#).
        end.
        
      when "query" or 
      when "dataset" then 
        /* TODO: Check of num-buffers hier op een dataset ook werkt, of dat je top-buffers en data-relations moet gebruiken */
        do:
          do iTell# = 1 to hDataObjectIP#:num-buffers:
            cTemp# = GetFieldsNoDataBindingString(hDataObjectIP#:get-buffer-handle(iTell#)).
            if cTemp# > "" then cSkip# = cSkip# + "," + cTemp#.
          end.
          cSkip# = substring(cSkip#, 2).
        end.

    end case.
    
    if cSkip# > "" then 
    do:
      this-object:SetFields("*",cSkip#,"").
    end. 

    this-object:Handle = hDataObjectIP#.

    &endif

  end method. /* SetHandle */


  method protected static character GetFieldsNoDataBindingString(hBuffIP# as handle):
    
    define variable cReturn# as character no-undo.
    define variable iTell#   as integer   no-undo.
    define variable hField#  as handle    no-undo.
    define variable cSkip#   as character no-undo.
    
    do iTell# = 1 to hBuffIP#:num-fields:
      hField# = hBuffIP#:buffer-field(iTell#).
      cSkip# = sc_prop:GetProp(hField#, "NoDataBinding").
      if logical(cSkip#) then 
      do:
        /* 10.2A02: Strangely, for a skip phrase you must use the table name and not the buffer 
                    name... this might be a 10.2A02 bug, seems odd to me, since several 
                    buffers of the same table can be in one query. */
        cReturn# = cReturn# + "," + subst("&1.&2", hBuffIP#:table-handle:name, hField#:name).
      end.
    end.
    
    cReturn# = substring(cReturn#, 2).
    
    return cReturn#.

  end method. /* GetFieldsNoDataBindingString */  
  
  
  method public override character ToString():
    
    define variable cReturn# as character no-undo.
    
    cReturn# = subst("&1@&2@&3",cLocalName, 
      
      &if {&paninui_tty} &then
      
      "NoHandle",
      
      &else
      
      if this-object:Handle = ? then "NoHandle" else this-object:Handle:type,
      
      &endif
       
      super:ToString()).
    
    return cReturn#.
    
  end method.


  &if {&paninui_tty} &then


  method public void AddNew():

  end method. /* AddNew */  
  
  
  method public void CancelEdit():

  end method. /* CancelEdit */
    
  
  method public void Refresh():

  end method. /* Refresh */
    
  
  method public void Refresh(iRefreshRowIP# as integer):

  end method. /* Refresh */
    
  
  method public void RefreshAll():

  end method. /* RefreshAll */  
  

  method public void ResetCurrentItem():
  
  end method. /* ResetCurrentItem */
    
    
  &endif /* unix/tty support */
  

  destructor public c_bindingsource ( ):
    
    &if not {&paninui_tty} &then
    
    this-object:Handle = ?.
    
    &endif
    
    if hCustomQuery <> ? then delete object hCustomQuery  no-error.
    if hCustomBuffer <> ? then delete object hCustomBuffer no-error.
    
    &if not {&paninui_tty} &then
    
    if valid-object(this-object) and type-of(this-object,System.IDisposable) then 
    do:
      cast(this-object, System.IDisposable):Dispose().
    end.
        
    &endif
    
  end destructor.

end class. /* c_bindingsource */

/* EOF  */

