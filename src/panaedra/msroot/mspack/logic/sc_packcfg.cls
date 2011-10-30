using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using paninui.view.init.events.*.
using paninui.mdiwindow.*.
using paninui.pack.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.mspack.logic.sc_packcfg: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Start runtime configurations (from .config or .xconfig)

  \*****************************  Include Files ********************************/
  
  {panaedra/msroot/mspack/logic/ds/mspack_ds.i &class=class &protected=protected &static=static &reference-only=reference-only}

  /************************  Source control constructor ************************/
  constructor public sc_packcfg(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  method public static void BootFromPack(cPackAblNameIP# as character):
 
    define variable cPackCfg# as character no-undo.
    
    cPackCfg# = replace(cPackAblNameIP#,".","/") + ".config".
    
    sc_config:ReadXml(dataset dsPackConfig:handle, cPackCfg#).
    
    find ttMsPack.
    
    find ttMsMdiMaster.

    /* Set the initial pack */
    if sc_sgt_masterwindow_eventhandler:oSgt:cInitialPack = "" then 
    do:
      assign
        sc_sgt_masterwindow_eventhandler:oSgt:cInitialPack    = ttMsPack.cObject
        sc_sgt_masterwindow_eventhandler:oSgt:cInitialPackCfg = cPackCfg#.
      /* Start the master MDI window, which will display the initial pack. 
         This (void!) method contains the wait-for. */
      sc_mdiwindow:StartNewMdiWindow(
        if ttMsMdiMaster.cDotnetDLL > "" then ttMsMdiMaster.cDotnetDLL else "[no dll]" ,
        ttMsMdiMaster.cObject).
    end.
    
    finally:
      dataset dsPackConfig:empty-dataset().
    end finally.
    
  end method. /* BootFromPack */


  method public static i_pack NewPack(cPackAblNameIP# as character):
    
    define variable oPack#    as i_pack    no-undo.
    define variable cPackCfg# as character no-undo.
    
    cPackCfg# = replace(cPackAblNameIP#,".","/") + ".config".
    
    if sc_config:FileExists(cPackCfg#) then 
    do:
      sc_config:ReadXml(dataset dsPackConfig:handle, cPackCfg#).
      find ttMsPack.
      oPack# = dynamic-new ttMsPack.cObject(cPackCfg#).
    end.
    else 
    do:
      oPack# = dynamic-new cPackAblNameIP#().
    end.
    
    return oPack#.
    
  end method. /* NewPack */
  
end class.

/* EOF */ 
