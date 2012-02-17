using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msdeploy.logic.sc_msdeploy_info: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Logic layer msdeploy info

  \*****************************  Include Files ********************************/

{panaedra/msroot/msdeploy/logic/tt/msdeployversion_tt.i &class=true &protected=protected &static=static}

  /************************  Source control constructor ************************/
  constructor public sc_msdeploy_info(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

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
