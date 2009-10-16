{panaedra/msi/logic/ctop_class.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_eventbroadcaster   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_eventbroadcaster.cls $ 
          Version: $Revision: 6 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-16 09:03:31+02:00 $ 
    Date Modified: $Modtime: 2009-10-16 00:08:29+02:00 $ 

      Description: Broadcasts events; 
                   loose-coupled event mechanism for session-wide events.
      
                   Can be used on windows as well as unix platforms.
      
                   Can be used by any class (just implement i_eventbroadcastclient 
                   if you want to subscribe to events; anyone can publish, even 
                   static methods and procedures).
                   
                   Preferred over ABL publish/subscribe, waiting
                   for real ABL event support (as of 10.2A02).
                   
                   For the data transmitted in the event, you can use one
                   of the following techniques:
                   1) Use FireEvent(text, text) and pass a simple string.
                   2) Use FireEvent(text, Object) and do a cast of oData on the recieving end.
                   3) Make your own i_eventbroadcastdata class, and extend it
                      to your liking. Use FireCustomEvent for firing the event.
                   
                   Suggested event name convention:
                   Prefix the eventname with "evt@" for easy grepping.
                   This convention is technically not required.
                   
                   Outside of Panaedra:
                   External platforms (like OE Eclipse boot procedures) can use 
                   sc_eventbroadcaster_loose.p.
                   Do a search for the .p or the .r, and run it if found.
                   This is a loose coupling to the whole broadcasted event mechanism,
                   and prevents syntax errors if the Panaedra platform is not present.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_eventbroadcaster(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 6 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static temp-table ttEventClient no-undo rcode-information
    field oClient    as Progress.Lang.Object /* always i_eventbroadcastclient*/
    field cEventName as character
    index cEventName_oClient is primary unique cEventName oClient.
  
  method public static void SubscribeEvent(oClientIP# as i_eventbroadcastclient , cEventNameIP# as char):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    do for ttEventClient:
      create ttEventClient.
      assign 
        ttEventClient.oClient    = oClientIP#
        ttEventClient.cEventName = cEventNameIP#.
    end.
    
  end method. /* SubscribeEvent */  
  
  
  method public static void UnSubscribeEvent(oClientIP# as i_eventbroadcastclient , cEventNameIP# as char):
    
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
  
  
  method public static void UnSubscribeAllEvents(oClientIP# as i_eventbroadcastclient):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    do for ttEventClient:
      
      for each ttEventClient 
        where ttEventClient.oClient = oClientIP#
        on error undo, throw:
        
        delete ttEventClient.
        
      end.
      
    end.
    
  end method. /* UnSubscribeAllEvents */  
  
  
  method public static void FireEvent(cEventNameIP# as char):
    
    FireEventImplement(cEventNameIP#, new c_eventbroadcastdata(cEventNameIP#)).

  end method. /* FireEvent ; char */  
  
  
  method public static void FireEvent(cEventNameIP# as char, cEventDataIP# as char):
    
    FireEventImplement(cEventNameIP#, new c_eventbroadcastdata(cEventNameIP#, cEventDataIP#)).

  end method. /* FireEvent ; char + char */  
  
  
  method public static void FireEvent(cEventNameIP# as char, oEventDataIP# as Progress.Lang.Object):
    
    FireEventImplement(cEventNameIP#, new c_eventbroadcastdata(cEventNameIP#, oEventDataIP#)).

  end method. /* FireEvent ; char + Object */  
  

  method public static logical FireCustomEvent(cEventNameIP# as char, oDataIP# as i_eventbroadcastdata):
    
    FireEventImplement(cEventNameIP#, oDataIP#).

  end method. /* FireCustomEvent */  

  
  method protected static logical FireEventImplement(cEventNameIP# as char, oDataIP# as i_eventbroadcastdata):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    do for ttEventClient:
      for each ttEventClient where ttEventClient.cEventName = cEventNameIP#
        on error undo, throw:
        cast(ttEventClient.oClient, i_eventbroadcastclient):OnEventBroadcast(oDataIP#).
        if oDataIP#:iAbort > 0 then return false.
      end.
    end.
    
    return true.

  end method. /* FireEventImplement */  

end class.

/* EOF */
