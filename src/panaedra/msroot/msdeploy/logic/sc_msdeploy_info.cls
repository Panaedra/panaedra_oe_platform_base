using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msdeploy.logic.sc_msdeploy_info: 

  /****************************** Source Header ********************************\

      Description: Logic layer (client-side) msdeploy info. Will not use sc_msdeploy_[non]live.config.

  \*****************************  Include Files ********************************/

  {panaedra/msroot/msdeploy/logic/tt/msdeployversion_tt.i &class=class &protected=protected &static=static}
  
  /******************************* $NoKeywords:  $ *****************************/
  
  /* Exceptions with this error number should trigger a reïnstall */
  define public static property cSvReinstallExceptions as character no-undo init "99927301,99927302,99927303" get.
  
  method public static void GetCurrentMaxVersion(
    output iMaxVersionOP#   as integer,
    output dtmMaxVersionOP# as datetime-tz):
    
    empty temp-table ttMsDeployVersion.
    
    if sc_config:FileExists(sc_path:cXcfgDir + "deploy_version.config")
      then 
    do:
      sc_config:ReadXml(
        temp-table ttMsDeployVersion:handle, 
        sc_path:cXcfgDir + "deploy_version.config").
    end.
    
    for each ttMsDeployVersion on error undo, throw:
      iMaxVersionOP# = max(iMaxVersionOP#,ttMsDeployVersion.iRepoVersion).
      if dtmMaxVersionOP# = ? then dtmMaxVersionOP# = ttMsDeployVersion.dtmRepoVersion.
      dtmMaxVersionOP# = max(dtmMaxVersionOP#, ttMsDeployVersion.dtmRepoVersion).
    end.
  
  end method. /* GetCurrentMaxVersion */

end class.

/* EOF */ 
