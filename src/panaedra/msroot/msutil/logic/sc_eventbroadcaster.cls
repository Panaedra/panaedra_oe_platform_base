{panaedra/msi/logic/ctop_class.i}
using panaedra.msroot.msutil.logic.*.
class panaedra.msroot.msutil.logic.sc_eventbroadcaster   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_eventbroadcaster.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-02 16:13:06+02:00 $ 
    Date Modified: $Modtime: 2009-09-02 16:12:51+02:00 $ 

      Description: Broadcasts events.
      
                   Can be used by any class (just implement i_eventbroadcastclient 
                   if you want to subscribe to events; anyone can publish).
                   
                   Preferred over ABL publish/subscribe, waiting
                   for real ABL event support (as of 10.2A01).
                   
                   Suggested event name convention:
                   Prefix the eventname with "evt@" for easy grepping.
                   This convention is technically not required.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_eventbroadcaster(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static temp-table ttEventClient no-undo rcode-information
    field oClient    as Progress.Lang.Object /* always i_eventbroadcastclient*/
    field cEventName as character
    index cEventName_oClient is primary unique cEventName oClient.
  
  define protected static variable hBroadcastLibPS# as handle no-undo.
  
  
  method public static void SubscribeEvent (oClientIP# as i_eventbroadcastclient , cEventNameIP# as char):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    do for ttEventClient:
      create ttEventClient.
      assign 
        ttEventClient.oClient    = oClientIP#
        ttEventClient.cEventName = cEventNameIP#.
    end.
    
  end method. /* SubscribeToEvent */  
  
  
  method public static void UnSubscribeEvent (oClientIP# as i_eventbroadcastclient , cEventNameIP# as char):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    do for ttEventClient:
      
      find ttEventClient 
        where ttEventClient.oClient    = oClientIP#
        and   ttEventClient.cEventName = cEventNameIP#
        no-error.
        
      if avail ttEventClient then delete ttEventClient.
      
    end.
    
  end method. /* UnSubscribeEvent */  
  
  
  method public static void UnSubscribeAllEvents (oClientIP# as i_eventbroadcastclient):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    do for ttEventClient:
      
      for each ttEventClient 
        where ttEventClient.oClient = oClientIP#:
        
        delete ttEventClient.
        
      end.
      
    end.
    
  end method. /* UnSubscribeAllEvents */  
  
  
  method public static void FireEvent (cEventNameIP# as char):
    
    FireEvent(cEventNameIP#, new c_eventbroadcastdata(cEventNameIP#)).

  end method. /* FireEvent */  
  
  
  method public static logical FireEvent (cEventNameIP# as char, oDataIP# as i_eventbroadcastdata ):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    do for ttEventClient:
      for each ttEventClient where ttEventClient.cEventName = cEventNameIP#:
        cast(ttEventClient.oClient, i_eventbroadcastclient):OnEventBroadcast(oDataIP#).
        if oDataIP#:bAbort then return false.
      end.
    end.
    
    return true.

  end method. /* FireEvent */  
  

end class.

/* EOF */
