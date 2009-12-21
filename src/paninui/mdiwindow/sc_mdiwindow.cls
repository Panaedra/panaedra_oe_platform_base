using paninui.*.
using paninui.view.interfaces.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msb.logic.*.

{panaedra/msi/logic/ctop_class.i} 

class paninui.mdiwindow.sc_mdiwindow: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/mdiwindow/sc_mdiwindow.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-12-20 19:59:48+01:00 $ 
    Date Modified: $Modtime: 2009-12-20 19:59:48+01:00 $ 

      Description: Static methods to start up and maintain an MDI window.
                   Needed in the ABL -p startup procedure.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_mdiwindow(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  method public static void StartNewMdiWindow(cMdiDllNameIP# as character, cMdiClassNameIP# as character):

    define variable oMdiNew#   as i_masterwindow             no-undo.
    define variable cMdiNew#   as character                  no-undo.
    define variable oAssembly# as System.Reflection.Assembly no-undo.
    define variable oForm#     as System.Windows.Forms.Form  no-undo.

    /* TODO: MDI window dll and/or class via [Mdi] session parameter, or config file */

    file-info:file-name = cMdiDllNameIP#.
    cMdiNew# = file-info:full-pathname.

    if cMdiNew# <> ? then 
    do:
      oAssembly# =
        System.Reflection.Assembly:LoadFile(cMdiNew#).
      if oAssembly# <> ? then
        oMdiNew# = cast(oAssembly#:CreateInstance(cMdiClassNameIP#), i_masterwindow).
    end.

    oForm# = cast(cast(oMdiNew#,Progress.Lang.Object), System.Windows.Forms.Form).
    
    /* TODO: SetAliases doesn't really belong here. */
    if lookup(sc_boot:SessionParameter("Layer"),"all,db,db_r,db_u") > 0 then
      panaedra.msroot.msas.logic.sc_dbconnect:SetAliases().

    paninui.view.use.sc_coll_eventdata:Initialize().
    
    /* TODO: Support for multiple MDI windows in one session */
    paninui.view.init.events.sc_sgt_masterwindow_eventhandler:oMdiWindow        = oMdiNew#.

    if os-getenv("ECLIPSE_PROJECT") > "" then
      /* This means the eclipse debugger is running; use only Shown event for less crashes (but uglier screen at startup) */
      oForm#:Shown:subscribe(paninui.view.init.events.sc_sgt_masterwindow_eventhandler:oSgt:MdiOnShown).
    else 
    do:
      oForm#:Load:subscribe(paninui.view.init.events.sc_sgt_masterwindow_eventhandler:oSgt:MdiOnLoad).
      oForm#:Shown:subscribe(paninui.view.init.events.sc_sgt_masterwindow_eventhandler:oSgt:MdiOnShown).
    end.

    wait-for System.Windows.Forms.Application:Run(oForm#). 

  end method. /* StartNewMdiWindow */


end class.

/* EOF */ 