{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msas.logic.sc_asconnect implements i_eventbroadcastclient: 

  /****************************** Source Header ********************************\

      Description: Methods to be used client-side as well as server-side for creating an appserver connection server handle.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define protected static variable bInitialized                   as logical                              no-undo.
  define protected static variable oSingleton                     as panaedra.msroot.msas.logic.sc_asconnect no-undo.
  define protected static variable dtmLastConfig                  as datetime-tz                          no-undo.
  define protected static variable bAllConnectionsToSessionHandle as logical                              no-undo.
  
  
  define static property bOffLine as logical no-undo 
    public    get.
    protected set.

  define static property bInitializationError as logical no-undo 
    public    get.
    protected set.
  
  define protected static temp-table ttAsConnect no-undo rcode-info
    field cEnv       as char   xml-node-type "attribute"
    field cMirror    as char   xml-node-type "attribute"
    field cSuffix    as char   xml-node-type "attribute"
    field cConnect   as char   xml-node-type "attribute"
    field hAppserver as handle xml-node-type "hidden"
    index cEnv_cMirror is primary unique cEnv cMirror cSuffix
    .
  
  constructor protected sc_asconnect():
    
    sc_eventbroadcaster:SubscribeEvent(this-object, "evt@OfflineStatusChange").
    sc_eventbroadcaster:SubscribeEvent(this-object, "evt@SessionClose").

  end constructor.

  
  method public static void Initialize():
    
    do on error undo, throw:
    
      if oSingleton = ? then oSingleton = new panaedra.msroot.msas.logic.sc_asconnect().
      
      ReloadConfig().

      catch oError# as Progress.Lang.Error :
        assign
          bInitializationError = true
          bInitialized         = false.
        undo, throw oError#.  
      end catch.
      
    end.
    
  end method. /* Initialize */
  
  
  method public static character GetConnectionString(cEnvIP# as char, cMirrorIP# as char, /* Empty = default */ cSuffixIP# as char ):
    
    define variable cReturn# as character no-undo.
    
    define buffer b-ttAsConnect for ttAsConnect.
    
    find first b-ttAsConnect 
      where b-ttAsConnect.cEnv    = cEnvIP#
      and   b-ttAsConnect.cMirror = cMirrorIP#
      and   b-ttAsConnect.cSuffix = cSuffixIP#
      no-error.
    
    if avail b-ttAsConnect then 
    do:
      cReturn# = b-ttAsConnect.cConnect. 
    end.
      
    return cReturn#.
  
  end method. /* GetConnectionString */
  

  method protected static logical ConnectToServer(cEnvIP# as char, cMirrorIP# as char, /* Empty = default */ cSuffixIP# as char ):
    
    define buffer b-cre-ttAsConnect for ttAsConnect.
    
    do on error undo, throw:
    
      if not bInitialized then
        undo, throw new c_panaedraexception(
          99968912,
          sc_lang:oEnglish,
          "Incorrect program flow").
    
      find first ttAsConnect 
        where ttAsConnect.cEnv    = cEnvIP#
        and   ttAsConnect.cMirror = cMirrorIP#
        and   ttAsConnect.cSuffix = cSuffixIP#
        no-error.

      if not avail ttAsConnect then 
      do:
        
        if bAllConnectionsToSessionHandle then 
        do:
          
          /* Create a dummy tt record */
          create b-cre-ttAsConnect.
          assign 
            b-cre-ttAsConnect.cEnv    = cEnvIP#
            b-cre-ttAsConnect.cMirror = cMirrorIP#
            b-cre-ttAsConnect.cSuffix = cSuffixIP#.
          release b-cre-ttAsConnect.
          
          /* Re-find */
          find first ttAsConnect 
            where ttAsConnect.cEnv    = cEnvIP#
            and   ttAsConnect.cMirror = cMirrorIP#
            and   ttAsConnect.cSuffix = cSuffixIP#.
            
        end. /* bAllConnectionsToSessionHandle */
        
        else 
        do:
          undo, throw new c_panaedraexception(
            99909002,
            sc_lang:oEnglish,
            subst("Error: AppServer configuration on &1 (sc_asconnect&5.config) has no entry for:~nEnv: '&2'~nMirror: '&3'~nSuffix: '&4'",
            sc_path:cIniDir,
            cEnvIP#,
            cMirrorIP#,
            cSuffixIP#,
            trim(string(sc_environment:bLiveEnv,"_live/_nonlive")))).
        end.
        
      end. 
      else 
      do: /* avail ttAsConnect */
      
        /* If *everything* or a specific ttAsConnect line has to be run inline, inside the current session */
        if bAllConnectionsToSessionHandle or ttAsConnect.cConnect = "[session:handle]" or ttAsConnect.hAppserver = session:handle /* Keep save for intermediate changes */ then
        do:
          ttAsConnect.hAppserver = session:handle.
        end.
      
        /* Appserver connect (a real one) */  
        else
        do on error undo, throw:

          if not valid-handle(ttAsConnect.hAppserver) then
            create server ttAsConnect.hAppserver.
          
          sc_prop:SetProp(ttAsConnect.hAppserver,"AsConnectString",ttAsConnect.cConnect).  
        
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
          else undo, throw new c_apiproxyexception(
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
    
    end. /* on error */
    
  end method. /* ConnectToServer */


  method public static logical DisconnectServer(cMirrorIP# as char):
    
    define variable cSuffix# as character no-undo.
    
    if bInitialized then 
    do:
      
      cSuffix# = GetSuffix().

      find first ttAsConnect 
        where ttAsConnect.cEnv    = sc_environment:cEnv
        and   ttAsConnect.cMirror = cMirrorIP#
        and   ttAsConnect.cSuffix = cSuffix#
        no-error.
    
      if not avail ttAsConnect then 
      do:
      
        undo, throw new c_panaedraexception(
          99909002,
          sc_lang:oEnglish,
          subst("Error: AppServer configuration on &1 (sc_asconnect&5.config) has no entry for:~nEnv: '&2'~nMirror: '&3'~nSuffix: '&4'",
          sc_path:cIniDir,
          sc_environment:cEnv,
          cMirrorIP#,
          cSuffix#,
          trim(string(sc_environment:bLiveEnv,"_live/_nonlive")))).
        
      end. 
      else 
      do: /* avail ttAsConnect */
      
        if valid-handle(ttAsConnect.hAppserver) and ttAsConnect.hAppserver <> session:handle and ttAsConnect.hAppserver:connected() then 
        do:
          
          ttAsConnect.hAppserver:disconnect() no-error.

          if error-status:num-messages = 0 and (not ttAsConnect.hAppserver:connected()) then 
            return true.
          else undo, throw new c_apiproxyexception(
              99909011,
              subst("AppServer connection '&1' disconnect failed.~nEnv: '&2'~nMirror: '&3'~nSuffix: '&4'~n~n&5", 
              ttAsConnect.cConnect, 
              ttAsConnect.cEnv,
              ttAsConnect.cMirror,
              ttAsConnect.cSuffix,
              error-status:get-message(1))).

        end.
      
      end. /* avail ttAsConnect */
    
    end.
    
    return true.
    
  end method. /* DisconnectServer */
  
  
  method public static void DisconnectAllServers(
  
    /* Disconnect all appserver and webserver connections, without error feedback.
       To be used on session close.
    */
    
    ):

    define variable hServer#     as handle no-undo.
    define variable hServerNext# as handle no-undo.

    hServer# = session:first-server.
    do while valid-handle(hServer#):
      hServerNext# = hServer#:next-sibling.
      if hServer#:connected() then hServer#:disconnect() no-error.
      delete object hServer# no-error.  
      hServer# = hServerNext#.
    end.
    
  end method. /* DisconnectAllServers */
  

  method public static handle GetAppServer(input cMirrorIP# as char):
    
    return _sys_GetAppServer(input sc_environment:cEnv, input cMirrorIP#).
        
  end method. /* GetAppServer */
    
    
  method public static handle _sys_GetAppServer(input cEnvIP# as char, input cMirrorIP# as char):
    
    define variable cSuffix# as character no-undo.
    
    cSuffix# = GetSuffix().
    
    return _sys_GetAppServer(input cEnvIP#, input cMirrorIP#, input cSuffix#).
     
  end method. /* _sys_GetAppServer */    
    
  method public static handle _sys_GetAppServer(input cEnvIP# as char, input cMirrorIP# as char, cSuffixIP# as char):
    
    /* This method returns an appserverhandle of the default appserver (cMirrorIP# = empty) or 
       a mirror appserver.
    */
    
    define variable hReturn# as handle no-undo.
    
    do on error undo, throw:
    
      if not bInitialized then 
      do on error undo, throw:
        bInitialized = yes.
        Initialize().
      end.
      else
        ReloadConfig().

      find ttAsConnect where ttAsConnect.cEnv = cEnvIP#
        and ttAsConnect.cMirror = cMirrorIP#
        and ttAsConnect.cSuffix = cSuffixIP#
        no-error.
        
      if not avail ttAsConnect then 
        undo, throw new c_panaedraexception(
          99909002,
          sc_lang:oEnglish,
          subst("Error: AppServer configuration on &1 (sc_asconnect&5.config) has no entry for:~nEnv: '&2'~nMirror: '&3'~nSuffix: '&4'",
          sc_path:cIniDir,
          cEnvIP#,
          cMirrorIP#,
          cSuffixIP#,
          trim(string(sc_environment:bLiveEnv,"_live/_nonlive")))).

      if ttAsConnect.hAppserver <> session:handle then 
      do:
        if not valid-handle(ttAsConnect.hAppserver) 
          then ConnectToServer(cEnvIP#, cMirrorIP#, cSuffixIP#).
        /* Note: Take extra care with :connected() method. 
           Exception is hidden for a loooong time and thrown at close of the session.
           10.2A02 TW
        */
        else if not ttAsConnect.hAppserver:connected() 
            then ConnectToServer(cEnvIP#, cMirrorIP#, cSuffixIP#).
      end.
      
      hReturn# = ttAsConnect.hAppserver.
    
      return hReturn#.
      
    end.
    
  end method. /* _sys_GetAppServer */
  
  
  method protected static void ReloadConfig():
    
    define variable cConfigFile#   as character   no-undo.
    define variable dtmConfigFile# as datetime-tz no-undo.
    define variable bReload#       as logical     no-undo.
    
    assign
      cConfigFile#   = sc_config:GetConfigOsfilename(sc_path:StandardIniFilePath("sc_asconnect.config"))
      dtmConfigFile# = sc_osfile:GetFileModDatetime(cConfigFile#).
    
    if dtmLastConfig = ?
      then bReload# = true.

    if (not bReload#) and (dtmLastConfig <> dtmConfigFile#)
      then bReload# = true.

    if bReload# then
    do:
      sc_config:ReadXml(temp-table ttAsConnect:handle, cConfigFile#).
      dtmLastConfig = dtmConfigFile#.
    end.
  
  end method. /* ReloadConfig */

  
  method public static char GetSuffix ():
    
    define variable cSuffix# as character no-undo.
    define variable cReturn# as character no-undo.
    define variable iEntry#  as integer   no-undo.
    define variable cEntry#  as character no-undo.   
       
    cSuffix# = sc_boot:SessionParameter("AsMode").
    
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
    
    cAsName# = sc_boot:SessionParameter("AsName").
    
    if cAsName# > "" then 
      return cAsName#.
    else 
      return (if session:batch-mode then "BatchSession" else "InLine").

  end method. /* GetAppserverID */  

  
  method public static void AllConnectionsToSessionHandle(
    input bAllConnectionsToSessionHandleIP# as logical
    ):

    bAllConnectionsToSessionHandle = bAllConnectionsToSessionHandleIP#. 
  
  end method. /* AllConnectionsToSessionHandle */


  method void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
    case oBroadcastDataIP#:cEventName:
      
      when "evt@OfflineStatusChange" then 
        case oBroadcastDataIP#:cData:
          when "OnLine" then 
            bOffLine = false.
          when "OffLine" then 
            bOffLine = true.
        end case.
      
      when "evt@SessionClose" then 
        do:
          DisconnectAllServers().
        end.  
     
    end case. /* oBroadcastDataIP#:cEventName */
    
  end method. /* OnEventBroadcast */

end class.

/* EOF */
