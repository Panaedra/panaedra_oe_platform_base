{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msas.logic.sc_asconnect implements i_eventbroadcastclient: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msas/logic/sc_asconnect.cls $ 
          Version: $Revision: 10 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:17+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:53:29+01:00 $ 

      Description: Methods aan te roepen vanaf de client om een 
                   appserver connectie te maken.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_asconnect(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 10 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected static variable bInitialized as logical                      no-undo.
  define protected static variable oSingleton   as panaedra.msroot.msas.logic.sc_asconnect no-undo.
  
  define static property bOffLine as logical no-undo 
    public    get.
    protected set.
  
  define protected static temp-table ttAsConnect no-undo rcode-info
    field cEnv       as char xml-node-type "attribute"
    field cMirror    as char xml-node-type "attribute"
    field cSuffix    as char xml-node-type "attribute"
    field cConnect   as char xml-node-type "attribute"
    field hAppserver as handle    xml-node-type "hidden"
    index cEnv_cMirror is primary unique cEnv cMirror cSuffix
    .
  
  
  constructor protected sc_asconnect():
    
    panaedra.msroot.msutil.logic.sc_eventbroadcaster:SubscribeEvent(this-object, "evt@OfflineStatusChange").

  end constructor.

  
  method public static void Initialize():
    
    if oSingleton = ? then oSingleton = new panaedra.msroot.msas.logic.sc_asconnect().
    
    temp-table ttAsConnect:read-xml("file", panaedra.msroot.msutil.logic.sc_path:cIniDir + "sc_asconnect.config", "empty", ?, false).
    
  end method. /* Initialize */


  method protected static logical ConnectToServer(cMirrorIP# as char /* Leeg = default */ ):
    
    define variable cEnv#    as character no-undo.
    define variable cSuffix# as character no-undo.
    
    if not bInitialized then 
    do:
      bInitialized = yes.
      Initialize().
    end.
    
    cEnv#    = panaedra.msroot.msutil.logic.sc_boot:SessionParameter("Env").
    cSuffix# = GetSuffix().
    
    find first ttAsConnect 
      where ttAsConnect.cEnv    = cEnv#
      and   ttAsConnect.cMirror = cMirrorIP#
      and   ttAsConnect.cSuffix = cSuffix#
      no-error.
    
    if not avail ttAsConnect then 
    do:
      
      undo, throw new panaedra.msroot.msutil.logic.c__FCMPNY_exception(
        99909002,
        subst("AppServer configuration (sc_asconnect.config) has no entry for:~nEnv: '&1'~nMirror: '&2'~nSuffix: '&3'", 
        cEnv#,
        cMirrorIP#,
        cSuffix#)).
        
    end. 
    else 
    do: /* avail ttAsConnect */
      
      /* Als er inline gerunned moet worden, voor b.v. debuggen */
      if ttAsConnect.cConnect = "[session:handle]" or ttAsConnect.hAppserver = session:handle /* Keep save for intermediate changes */ then
      do:
        ttAsConnect.hAppserver = session:handle.
      end.
      
      /* Appserver connect with actual appserver */  
      else
      do on error undo, throw:

        if not valid-handle(ttAsConnect.hAppserver) then
          create server ttAsConnect.hAppserver.
        
        /* Note: Take extra care with :connected() method. 
           Exception is hidden for a loooong time and thrown at close of the session.
           10.2A02 TW
        */
        if not ttAsConnect.hAppserver:connected() then
          ttAsConnect.hAppserver:connect(ttAsConnect.cConnect) no-error.
          
        /* Note: Take extra care with :connected() method. 
           Exception is hidden for a loooong time and thrown at close of the session.
           10.2A02 TW
        */
        if error-status:num-messages = 0 and ttAsConnect.hAppserver:connected() then 
          return true.
        else undo, throw new panaedra.msroot.msutil.logic.c__FCMPNY_exception(
            99909001,
            subst("AppServer connection '&1' failed.~nEnv: '&2'~nMirror: '&3'~nSuffix: '&4'~n~n&5", 
            ttAsConnect.cConnect, 
            ttAsConnect.cEnv,
            ttAsConnect.cMirror,
            ttAsConnect.cSuffix,
            error-status:get-message(1))).
          
      end. /* Appserver connect with actual appserver */ 

    end. /* avail ttAsConnect */
    
    return true.
    
  end method. /* ConnectToServer */


  method public static handle GetAppServer(input cMirrorIP# as char):
    
    /* This method returns an appserverhandle of the default appserver (cMirrorIP# = empty) or 
       a mirror appserver.
    */
    
    define variable hReturn# as handle    no-undo.
    define variable cEnv#    as character no-undo.
    define variable cSuffix# as character no-undo.
    
    if not bInitialized then 
    do:
      bInitialized = yes.
      Initialize().
    end.
    
    cEnv#    = panaedra.msroot.msutil.logic.sc_boot:SessionParameter("Env").
    cSuffix# = GetSuffix().

    find ttAsConnect where ttAsConnect.cEnv = cEnv#
      and ttAsConnect.cMirror = cMirrorIP#
      and ttAsConnect.cSuffix = cSuffix#
      no-error.
        
    if not avail ttAsConnect then 
      undo, throw new panaedra.msroot.msutil.logic.c__FCMPNY_exception(
        99909002,
        subst("AppServer configuration (sc_asconnect.config) has no entry for:~nEnv: '&1'~nMirror: '&2'~nSuffix: '&3'", 
        cEnv#,
        cMirrorIP#,
        cSuffix#)).

    if ttAsConnect.hAppserver <> session:handle then 
    do:
      if not valid-handle(ttAsConnect.hAppserver) 
        then ConnectToServer(cMirrorIP#).
      /* Note: Take extra care with :connected() method. 
         Exception is hidden for a loooong time and thrown at close of the session.
         10.2A02 TW
      */
      else if not ttAsConnect.hAppserver:connected() 
          then ConnectToServer(cMirrorIP#).
    end.
      
    hReturn# = ttAsConnect.hAppserver.
    
    return hReturn#.

  end method. /* GetAppServer */
  
  
  method protected static char GetSuffix ():
    
    define variable cSuffix# as character no-undo.
    define variable cReturn# as character no-undo.
    define variable iEntry#  as integer   no-undo.
    define variable cEntry#  as character no-undo.   
       
    cSuffix# = panaedra.msroot.msutil.logic.sc_boot:SessionParameter("AsMode").
    
    if cSuffix# > "" then
    do iEntry# = 1 to num-entries(cSuffix#, ","):
      cEntry# = entry(iEntry#, cSuffix#, ",").
  
      if trim(cEntry#) begins "suffix" then 
      do:
        cReturn# = trim(entry(2, cSuffix#, "=")).
        leave. 
      end.
    end. /* iTell# = 1 to num-entries(cSuffix#) */ 
    
    if cReturn# = ? then
      cReturn# = "".
    
    return cReturn#.

  end method. /* GetSuffix */  


  method public static character GetAppserverID ():
    
    define variable cAsName# as character no-undo.
    
    cAsName# = panaedra.msroot.msutil.logic.sc_boot:SessionParameter("AsName").
    
    if cAsName# > "" then 
      return cAsName#.
    else 
      return (if session:batch-mode then "BatchSession" else "InLine").

  end method. /* GetAppserverID */  


  method void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
    case oBroadcastDataIP#:cEventName:
      
      when "evt@OfflineStatusChange" then 
        case oBroadcastDataIP#:cData:
          when "OnLine" then 
            bOffLine = false.
          when "OffLine" then 
            bOffLine = true.
        end case.
     
    end case.
    
  end method. /* OnEventBroadcast */

end class.

/* EOF */
