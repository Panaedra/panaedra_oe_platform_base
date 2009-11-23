{panaedra/msi/logic/ctop_class.i}        

class paninui.view.init.display.c_bindingsource
  inherits
  &if opsys = "unix" &then
  Progress.Lang.Object
  &else 
  Progress.Data.BindingSource
  &endif
    : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/init/display/c_bindingsource.cls $ 
          Version: $Revision: 12 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-11-23 20:47:41+01:00 $ 
    Date Modified: $Modtime: 2009-11-23 20:31:00+01:00 $ 

      Description:  _CMPNY_ inheritance van de progress DataSource. 
                    Bedoeld om onvolkomenheden van de progress DataSource
                    in te vullen. Geen data access.
                    
                    TODO: c_bindingsource moet verhuizen naar logic (vrij belang_REGION_! .r mist nu in de productie pl)

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_bindingsource(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 12 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected variable hCustomBuffer as handle    no-undo.
  define protected variable hCustomQuery  as handle    no-undo.
  define protected variable cLocalName    as character no-undo.
  
  
  constructor protected c_bindingsource():
    
    super().
    
    &if opsys = "unix" &then
    &else
    /* TODO: Don't know the exact effects of the following three settings. */
    this-object:AutoSort = true.
    this-object:AutoSync = true.
    this-object:Batching = true.
    &endif
    
    cLocalName = "[blank]".

  end constructor.
        

  constructor protected c_bindingsource(hQueryIP# as handle):
    
    &if opsys = "unix" &then
    super().
    &else
    super(hQueryIP#).
    &endif

    &if opsys = "unix" &then
    &else
    /* TODO: Don't know the exact effects of the following three settings. */
    this-object:AutoSort = true.
    this-object:AutoSync = true.
    this-object:Batching = true.
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

      &if opsys = "unix" &then
      &else
      /* TODO: Don't know the exact effects of the following three settings. */
      this-object:AutoSort = true.
      this-object:AutoSync = true.
      this-object:Batching = true.
      &endif

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

      &if opsys = "unix" &then
      &else
      this-object:Handle = hBufferIP#.
      &endif

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

    &if opsys = "unix" &then
    &else
    /* TODO: Don't know the exact effects of the following three settings. */
    this-object:AutoSort = true.
    this-object:AutoSync = true.
    this-object:Batching = true.
    this-object:Handle = hQuery#.
    &endif

    cLocalName = hBufferOrQueryIP#:name.
    if (cLocalName = "" or cLocalName = ?) and hBufferOrQueryIP#:type = "query" then cLocalName = hBufferOrQueryIP#:get-buffer-handle(1):name no-error.
    if (cLocalName = "" or cLocalName = ?) then cLocalName = hBufferOrQueryIP#:type.

    if search("panaedra/msroot/msutil/logic/sc_eventbroadcaster_loose.p") <> ?
      or search("panaedra/msroot/msutil/logic/sc_eventbroadcaster_loose.r") <> ?
      then run panaedra/msroot/msutil/logic/sc_eventbroadcaster_loose.p("evt@c_bindingsource@queryopen", "", this-object).

  end constructor.
  
  
  method public override character ToString():
    
    define variable cReturn# as character no-undo.
    
    cReturn# = subst("&1@&2",cLocalName, super:ToString()).
    
    return cReturn#.
    
  end method.


  destructor public c_bindingsource ( ):
    
    &if opsys = "unix" &then
    &else
    this-object:Handle = ?.
    &endif
    
    if hCustomQuery <> ? then delete object hCustomQuery  no-error.
    if hCustomBuffer <> ? then delete object hCustomBuffer no-error.
    
    &if opsys <> "unix" and "{&window-system}" <> "tty" &then
    if valid-object(this-object) and type-of(this-object,System.IDisposable) then 
    do:
      cast(this-object, System.IDisposable):Dispose().
    end.    
    &endif
    
  end destructor.

  &if opsys = "unix" &then

  method public void Refresh():

  end method. /* Refresh */  
  
  method public void Refresh(iRefreshRowIP# as integer):

  end method. /* Refresh */  
  
  method public void RefreshAll():

  end method. /* RefreshAll */  
  
  &endif

  
end class. /* c_bindingsource */

/* EOF  */

