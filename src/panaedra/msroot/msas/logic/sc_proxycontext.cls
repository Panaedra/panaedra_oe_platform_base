using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msas.logic.*.
using panaedra.msroot.msdeploy.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msas.logic.sc_proxycontext : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msas/logic/sc_proxycontext.cls $ 
          Version: $Revision: 11 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:17+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:53:29+01:00 $ 

      Description: Api-proxy functionality: generic methods die client-side (proxy)
                   worden aangeroepen.

  \*****************************  Include Files ********************************/
  
  {paninui/logic/includes/preproc_dotnetclasses.i &class=class}
  
  {panaedra/msroot/msas/logic/ds/ascontext_ds.i &protected=protected &static=static &class=class}
  &undefine TtAllDefined

  {panaedra/msroot/msdeploy/logic/tt/msdeployversion_tt.i &class=true &protected=protected &static=static}
  &undefine TtAllDefined
   
  /************************  Source control constructor ************************/
  constructor public sc_proxycontext(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 11 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable hDsContext  as handle  no-undo.
  define public static    variable bExceptions as logical no-undo.
  
  &if opsys = "win32" and not {&paninui_tty} = true &then
  define public static variable oMsDeployAskPack as paninui.pack.interfaces.i_pack no-undo.
  &endif
  
  
  method public static logical BeginProxyCall(dataset dsContext /* by ref */, cMirrorIP# as character):
    
    define variable iMaxVersion#   as integer     no-undo.
    define variable dtmMaxVersion# as datetime-tz no-undo.
    
    /* Remove previous exception messages */
    empty temp-table ttExceptions.
    empty temp-table ttCallStack.

    /* Read the ttMsDeployVersion file only at the first appserver call of the session. 
       If config changes (install) it's still not valid until reboot of the session */
    if (not can-find(first ttMsDeployVersion)) and
    sc_config:FileExists(sc_path:cXcfgDir + "deploy_version.config")
      then 
    do:
      sc_config:ReadXml(
        temp-table ttMsDeployVersion:handle, 
        sc_path:cXcfgDir + "deploy_version.config").
    end.
    
    empty temp-table ttMsAsVersion.
    
    for each ttMsDeployVersion on error undo, throw:
      create ttMsAsVersion.
      assign 
        ttMsAsVersion.cDeployID      = ttMsDeployVersion.cDeployID
        ttMsAsVersion.iRepoVersion   = ttMsDeployVersion.iRepoVersion
        ttMsAsVersion.dtmRepoVersion = ttMsDeployVersion.dtmRepoVersion
        ttMsAsVersion.cModuleID      = ttMsDeployVersion.cModuleID.
      iMaxVersion# = max(iMaxVersion#,ttMsDeployVersion.iRepoVersion).
      if dtmMaxVersion# = ? then dtmMaxVersion# = ttMsDeployVersion.dtmRepoVersion.
      dtmMaxVersion# = max(dtmMaxVersion#, ttMsDeployVersion.dtmRepoVersion).
    end.
    
    /* Create an extra "from environment" ttMsAsVersion. */
    create ttMsAsVersion.
    assign 
      ttMsAsVersion.cDeployID      = sc_environment:cDeployID
      ttMsAsVersion.iRepoVersion   = iMaxVersion#
      ttMsAsVersion.dtmRepoVersion = dtmMaxVersion#
      ttMsAsVersion.cModuleID      = "[From_Environment]".
        
    return true.
    
  end method. /* BeginProxyCall */


  method public static void ExceptionsProxyCall(oExceptionIP# as Progress.Lang.Error, dataset dsContext /* by ref */, cMirrorIP# as character):
    
    bExceptions = true.
    
    sc_exception:FillTtExceptionTtCallstack(oExceptionIP#, dataset dsContext by-reference, cMirrorIP#).
    
  end method. /* ExceptionsProxyCall */


  method public static void FinallyProxyCall(dataset dsContext /* by ref */, cMirrorIP# as character):
    
    define variable bEclipseFix# as logical no-undo.
    define variable bThrow#      as logical no-undo init true.
    
    define buffer b-ttExceptions for ttExceptions.
    
    /* If an exception has occurred locally (bExceptions) or on an AppServer (b-ttExceptions), 
       always throw a new Exception */
    if bExceptions or can-find(first b-ttExceptions) then 
    do:
      
      find first b-ttExceptions no-error.
      
      /* If an exception has occurred in the proxy itself */
      if not avail b-ttExceptions then
        sc_exception:FillTtExceptionTtCallstack(?, dataset dsContext by-reference, cMirrorIP#).
      else
      /* If an exception has occurred on an appserver, append callstack */
      do:
        if sc_boot:SessionParameter("UiMode") <> "AppServer"
          and sc_asconnect:GetAppserver(cMirrorIP#) <> session:handle then
        do:
          sc_exception:FillTtExceptionTtCallstack(?, dataset dsContext by-reference, cMirrorIP#).
        end. /* if sc_boot:SessionParameter("UiMode") <> "AppServer" */   
      end. /* else do */    
        
      find first b-ttExceptions no-error.

      define variable oApiProxyException# as c_apiproxyexception no-undo.
      define variable cMessage#           as character           no-undo.
      define variable cMessageDebug#      as character           no-undo.  
      
      cMessageDebug# = subst("&1 [Api/proxy exception for: '&2' -> '&3']",
        if not avail b-ttExceptions then "Error:" else b-ttExceptions.cError,
        program-name(4), program-name(3)).
              
      if avail b-ttExceptions then  
        cMessage# = b-ttExceptions.cError.
      else 
        assign
          cMessage#      = cMessageDebug#
          cMessageDebug# = "". 
      
      oApiProxyException# = new c_apiproxyexception(
        if (not avail b-ttExceptions) or 
          (b-ttExceptions.iError = ?) or 
          (b-ttExceptions.iError = 0) then 99909008 
          else b-ttExceptions.iError,
        cMessage#, 
        dataset dsContext /* ->not<- by-reference */ ).

      if cMessageDebug# > "" then
        oApiProxyException#:AddMessage(cMessageDebug#, 99909009).
      
      if (not sc_environment:bBatchMode) and lookup(string( 
        oApiProxyException#:GetMessageNum(1),"99999999"), 
        sc_msdeploy_info:cSvReinstallExceptions) > 0 then 
      do:
        
        &if opsys = "win32" and not {&paninui_tty} = true &then
        
        if valid-object(paninui.view.init.events.sc_sgt_masterwindow_eventhandler:oMdiWindow) then do:
          
          oMsDeployAskPack = panaedra.msroot.mspack.logic.sc_packcfg:NewPack("panaedra.msroot.msdeploy.pack.c_pack_msdeploy_ask").
          oMsDeployAskPack:LoadPack(paninui.view.init.events.sc_sgt_masterwindow_eventhandler:oMdiWindow).
          oMsDeployAskPack:ShowPack().
          bThrow# = false.
          
          message 123 "we zouden wat moeten zien nu."
            view-as alert-box.
          
        end.
        
        &endif
        
        
      end.
      
      if bThrow# then undo, throw oApiProxyException#.
        
    end.
     
  end method. /* FinallyProxyCall */


  method public static handle GetDefaultDsContext():
    
    if hDsContext = ? or not valid-handle(hDsContext) then 
      hDsContext = GetNewDsContext().
    
    return hDsContext.

  end method. /* GetDefaultDsContext */
  

  method public static void EmptyDefaultDsContext():
    
    if valid-handle(hDsContext) then 
      delete object hDsContext.
    
    hDsContext = ?.

  end method. /* EmptyDefaultDsContext */


  method public static handle GetNewDsContext():
    
    define variable hDsContextLocal# as handle no-undo.
    
    create dataset hDsContextLocal#.
    
    hDsContextLocal#:create-like(dataset dsContext:handle).
    
    FillDefaultDsContext(dataset-handle hDsContextLocal# by-reference).
    
    return hDsContextLocal#.
    
  end method. /* GetNewDsContext */


  method public static void FillDefaultDsContext(dataset dsContext /* by-reference */):

    define variable bEclipseFix# as logical no-undo.
    define buffer b-ttSession for ttSession.
    
    if not can-find(b-ttSession) then
      create b-ttSession. /* Single record. */
    else 
      find b-ttSession.
    
    assign
      b-ttSession.cUserID          = sc_environment:cUserID
      b-ttSession.cSessionGuid     = sc_environment:cSessionGuid
      b-ttSession.cEnv             = sc_boot:SessionParameter("Env")
      b-ttSession.cLang            = sc_boot:SessionParameter("Lang")
      b-ttSession.cOpsys           = opsys
      b-ttSession.cLayer           = sc_environment:cLayer
      b-ttSession.cDeployID        = sc_environment:cDeployID
      b-ttSession.iDeployVersion   = sc_environment:iDeployVersion
      b-ttSession.dtmDeployVersion = sc_environment:dtmDeployVersion
      .
    
  end method. /* FillDefaultDsContext */

end class.

/* EOF */ 
