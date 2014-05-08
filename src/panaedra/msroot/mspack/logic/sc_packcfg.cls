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
{paninui/logic/includes/preproc_dotnetclasses.i &class=class}
{panaedra/msroot/mspack/logic/ds/mspack_ds.i &class=class &protected=protected &static=static &reference-only=reference-only}

  /************************  Source control constructor ************************/
  constructor public sc_packcfg(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  &if {&paninui_tty} = false &then
  method public static void BootFromPack(cPackAblNameIP# as character):

    define variable cPackCfg# as character no-undo.
    
    cPackCfg# = replace(cPackAblNameIP#,".","/") + ".config".
    
    sc_config:ReadXml(dataset dsPackConfig:handle, cPackCfg#).
    
    find ttMsPack.
    
    find ttMsMdiMaster no-error.
    
    if not avail ttMsMdiMaster then 
    do:
      create ttMsMdiMaster.
    end.

    if ttMsMdiMaster.cObject = "" 
      /* Provide a default for the lazy programmer */
      then ttMsMdiMaster.cObject = "panaedra.msroot.mspack.view_abl_dotnet.c_mdi_mspack".

    /* Set the initial pack */

    if sc_sgt_masterwindow_eventhandler:oSgt:cInitialPack = "" then 
    do:
      
      if not ttMsPack.bAllowAsBootPack then 
      do:
        if sc_environment:IsIdeRunning()
          then panaedra.msroot.msutil.logic.sc_developerfeedback:DevMsg(subst("Info boot-time enduser: pack '&1' is currently not allowed as bootpack. If you want to allow this to endusers: adjust pack configuration.",cPackAblNameIP#)).
        else 
          undo, throw new c_panaedraexception(
            99944811,
            sc_lang:oEnglish,
            substitute("Error: Invalid boot configuration for '&1'", cPackAblNameIP#)
            ).
          
      end.
      
      assign
        sc_sgt_masterwindow_eventhandler:oSgt:cInitialPack    = ttMsPack.cObject
        sc_sgt_masterwindow_eventhandler:oSgt:cInitialPackCfg = cPackCfg#.
      /* Start the master MDI window, which will display the initial pack. 
         This (void!) method contains the wait-for. */
      sc_mdiwindow:StartNewMdiWindow(
        if length(ttMsMdiMaster.cDotnetDLL) > 0 then ttMsMdiMaster.cDotnetDLL else "[no dll]" ,
        ttMsMdiMaster.cObject).
    end.
    
    catch oException# as System.Exception:
      sc_showexception:ShowException(oException#).
    end catch.
    
    catch oError# as Progress.Lang.Error:
      sc_showexception:ShowException(oError#).
    end catch.
    
    finally:
      dataset dsPackConfig:empty-dataset().
    end finally.
    
  end method. /* BootFromPack */
  &endif


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
  

  method public static character GetCsvCompilables(cPackCfgIP# as character):
    
    define variable cReturn#     as character no-undo.
    define variable cCodeBehind# as character no-undo.
    
    if sc_config:FileExists(cPackCfgIP#) then 
    do:
      
      sc_config:ReadXml(dataset dsPackConfig:handle, cPackCfgIP#).

      find ttMsPack.
      
      if length(ttMsPack.cObject) > 0 then
        cReturn# = cReturn# + chr(10) + ClassToPath(ttMsPack.cObject).
        
      if length(ttMsPack.cPackRegisterAs) > 0 then 
      do:
        cCodeBehind# = ClassToPath(ttMsPack.cPackRegisterAs).
        if search(cCodeBehind#) <> ?
          or sc_config:FileExists(replace(ttMsPack.cPackRegisterAs,".","/") + ".config") <> ?
          then 
        do:
          cReturn# = cReturn# + chr(10) + cCodeBehind#.
        end.
      end.

      find ttMsMdiMaster no-error.
      if avail ttMsMdiMaster 
        and ttMsMdiMaster.cDotnetDLL = "" /* Meaning: no dotnet, but ABL */ 
        and length(ttMsMdiMaster.cObject) > 0 
        and ttMsMdiMaster.cObject   <> "[none]" then
        cReturn# = cReturn# + chr(10) + ClassToPath(ttMsMdiMaster.cObject).
        
      find ttMsMainFrame no-error.
      if avail ttMsMainFrame 
        and ttMsMainFrame.cDotnetDLL = "" 
        and length(ttMsMainFrame.cObject) > 0 
        and ttMsMainFrame.cObject   <> "[none]" then
        cReturn# = cReturn# + chr(10) + ClassToPath(ttMsMainFrame.cObject).

      for each ttMsPreloadPack 
        where ttMsPreloadPack.bActive
        and length(ttMsPreloadPack.cObject) > 0 
        and ttMsPreloadPack.cObject <> "[none]" on error undo, throw:
        cReturn# = cReturn# + chr(10) + ClassToPath(ttMsPreloadPack.cObject).
      end.
  
      for each ttMsScopetable 
        where ttMsScopetable.bActive 
        and length(ttMsScopetable.cObject) > 0
        and ttMsScopetable.cObject <> "[none]"
        on error undo, throw:
        cReturn# = cReturn# + chr(10) + ClassToPath(ttMsScopetable.cObject).
      end.
  
      for each ttMsDatasetConstructorItem 
        where ttMsDatasetConstructorItem.bActive 
        and length(ttMsDatasetConstructorItem.cClass) > 0
        and ttMsDatasetConstructorItem.cClass <> "[none]"
        on error undo, throw:
        cReturn# = cReturn# + chr(10) + ClassToPath(ttMsDatasetConstructorItem.cClass).
      end.

      for each ttMsDatasetController 
        where ttMsDatasetController.bActive
        and length(ttMsDatasetController.cClass) > 0 
        and ttMsDatasetController.cClass <> "[none]" 
        on error undo, throw:
        cReturn# = cReturn# + chr(10) + ClassToPath(ttMsDatasetController.cClass).
      end.

      for each ttMsFrameLogic 
        where ttMsFrameLogic.bActive
        and length(ttMsFrameLogic.cObject) > 0 
        and ttMsFrameLogic.cObject <> "[none]" 
        on error undo, throw:
        cReturn# = cReturn# + chr(10) + ClassToPath(ttMsFrameLogic.cObject).
      end.

      for each ttMsSubframePackOvly 
        where ttMsSubframePackOvly.bActive
        and length(ttMsSubframePackOvly.cObject) > 0 
        and ttMsSubframePackOvly.cObject <> "[none]" 
        on error undo, throw:
        cReturn# = cReturn# + chr(10) + ClassToPath(ttMsSubframePackOvly.cObject).
      end.
  
      for each ttMsChildPack 
        where ttMsChildPack.bActive
        and   length(ttMsChildPack.cObject) > 0 
        and   ttMsChildPack.cObject <> "[none]" 
        on error undo, throw:
        cReturn# = cReturn# + chr(10) + ClassToPath(ttMsChildPack.cObject).
      end.
  
      for each ttMsPackParamValue 
        where ttMsPackParamValue.bActive 
        and   ttMsPackParamValue.bCompilable
        and   length(ttMsPackParamValue.cValue) > 0
        on error undo, throw:
        cReturn# = cReturn# + chr(10) + ClassToPath(trim(ttMsPackParamValue.cValue)).
      end.
  
    end.
    
    return substring(cReturn#,2).
    
  end method. /* GetCompilables */


  method protected static character ClassToPath(cClassIP# as character):
    
    define variable cReturn# as character no-undo.
    
    cReturn# = replace(cClassIP#,".","/") + ".cls".
    
    return cReturn#.

  end method. /* ClassToPath */
  
end class.

/* EOF */ 
