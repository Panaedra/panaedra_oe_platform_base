{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msas.logic.sc_asconnect implements i_eventbroadcastclient: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msas/logic/sc_asconnect.cls $ 
          Version: $Revision: 13 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-08-18 11:19:02+02:00 $ 
    Date Modified: $Modtime: 2010-08-18 11:04:46+02:00 $ 

      Description: Methods aan te roepen vanaf de client om een 
                   appserver connectie te maken.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_asconnect(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 13 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected static variable bInitialized as logical                              no-undo.
  define protected static variable oSingleton   as panaedra.msroot.msas.logic.sc_asconnect no-undo.
  
  define static property bOffLine as logical no-undo 
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

  end constructor.

  
  method public static void Initialize():
    
    if oSingleton = ? then oSingleton = new panaedra.msroot.msas.logic.sc_asconnect().
    
    if sc_environment:bLiveEnv
      then
      temp-table ttAsConnect:read-xml("file", sc_path:cIniDir + "sc_asconnect_live.config", "empty", ?, false).
    else
      temp-table ttAsConnect:read-xml("file", sc_path:cIniDir + "sc_asconnect_nonlive.config", "empty", ?, false).
    
  end method. /* Initialize */


  method protected static logical ConnectToServer(cEnvIP# as char, cMirrorIP# as char, /* Leeg = default */ cSuffixIP# as char ):
    
    if not bInitialized then 
    do:
      bInitialized = yes.
      Initialize().
    end.
    
    find first ttAsConnect 
      where ttAsConnect.cEnv    = cEnvIP#
      and   ttAsConnect.cMirror = cMirrorIP#
      and   ttAsConnect.cSuffix = cSuffixIP#
      no-error.
    
    if not avail ttAsConnect then 
    do:
      
      undo, throw new c__FCMPNY_exception(
        99909002,
        subst("Error: AppServer configuration (sc_asconnect&4.config) has no entry for:~nEnv: '&1'~nMirror: '&2'~nSuffix: '&3'", 
        cEnvIP#,
        cMirrorIP#,
        cSuffixIP#,
        trim(string(sc_environment:bLiveEnv,"_live/_nonlive")))).
        
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
        else undo, throw new c__FCMPNY_exception(
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
      
        undo, throw new c__FCMPNY_exception(
          99909002,
          subst("Error: AppServer configuration (sc_asconnect&4.config) has no entry for:~nEnv: '&1'~nMirror: '&2'~nSuffix: '&3'", 
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
          else undo, throw new c__FCMPNY_exception(
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
    
    if not bInitialized then 
    do:
      bInitialized = yes.
      Initialize().
    end.

    find ttAsConnect where ttAsConnect.cEnv = cEnvIP#
      and ttAsConnect.cMirror = cMirrorIP#
      and ttAsConnect.cSuffix = cSuffixIP#
      no-error.
        
    if not avail ttAsConnect then 
      undo, throw new c__FCMPNY_exception(
        99909002,
        subst("Error: AppServer configuration (sc_asconnect&4.config) has no entry for:~nEnv: '&1'~nMirror: '&2'~nSuffix: '&3'", 
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

  end method. /* _sys_GetAppServer */
  
  
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
