{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_win32: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_win32.cls $ 
          Version: $Revision: 10 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-08-09 12:16:03+02:00 $ 
    Date Modified: $Modtime: 2010-08-08 21:42:23+02:00 $ 

      Description: Common Windows API calls

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_win32(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 10 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable hExternalProcs# as handle  no-undo.
  
  define protected static variable VK_CAPITAL      as integer no-undo init 20. /* 0x14 */
  

  method public static void ShellExecute(cFileIP# as char):
    
    /* 'Doubleclick' a file from Windows Explorer. */
    
    ShellExecute(cFileIP#, "open", "").
    
  end method. /* ShellExecute ; Action = "open" */
  

  method public static void ShellExecute(cFileIP# as char, cActionIP# as char):
    
    ShellExecute(cFileIP#, cActionIP#, "").
    
  end method. /* ShellExecute ; Specific action like "open" */


  method public static void ShellExecute(cFileIP# as char, cActionIP# as char, cRuntimeParamsIP# as char):
    
    define variable cFileFull# as character            no-undo.
    define variable oDummy#    as Progress.Lang.Object no-undo.
    
    /* 'Doubleclick' a file from Windows Explorer. */
    
    if opsys <> "unix" then 
    do:
    
      if not valid-handle(hExternalProcs#) then
        sc_procedurehandles:PersistentProcedure(oDummy#, "panaedra/msroot/msutil/logic/sc_win32_sub.p", output hExternalProcs#).
        
      if num-entries(cFileIP#,":") >= 1 and length(entry(1, cFileIP#,":")) = 1 then 
      do:   
        file-info:file-name = cFileIP#.
        if file-info:full-pathname = ? then
          undo, throw new Progress.Lang.AppError(substitute("The file '&1' does not exist", cFileIP#), 99958221).
        cFileFull# = replace(file-info:full-pathname, "/", "~\").
      end.
      
      if num-entries(trim(cRuntimeParamsIP#,'"'),":") >= 1 and length(entry(1, trim(cRuntimeParamsIP#,'"'),":")) = 1 then 
      do:   
        cRuntimeParamsIP# = replace(cRuntimeParamsIP#, "/", "~\").
      end.
    
      run ShellExecuteA in hExternalProcs# (0, cActionIP#, if cFileFull# > "" then cFileFull# else cFileIP#, cRuntimeParamsIP#, ".", 0).
    
    end.
    else 
    do:
      
      if session:batch-mode then put unformatted now " ShellExecute: " cActionIP# " " cFileIP# skip. 
      
    end.
    
  end method. /* ShellExecute ; Specific action like "open", and specific parameters */


  method public static void MessageBox(cMsgIP# as char, cTitleIP# as char):
    
    /* MessageBox through Windows api */

    define variable oDummy# as Progress.Lang.Object no-undo.
    
    if not valid-handle(hExternalProcs#) then
      sc_procedurehandles:PersistentProcedure(oDummy#, "panaedra/msroot/msutil/logic/sc_win32_sub.p", output hExternalProcs#). 
    
    define variable iReturn# as integer no-undo.

    run MessageBoxA in hExternalProcs# (0, cMsgIP#, cTitleIP#, 0, output iReturn#).
    
  end method. /* MessageBox */


  method protected static integer GetKeyState(iKeyIP# as int):
    
    define variable oDummy# as Progress.Lang.Object no-undo.

    /* GetKeyState via api */
    
    if not valid-handle(hExternalProcs#) then
      sc_procedurehandles:PersistentProcedure(oDummy#, "panaedra/msroot/msutil/logic/sc_win32_sub.p", output hExternalProcs#). 
    
    define variable iReturn# as integer no-undo.

    run GetKeyState in hExternalProcs# (iKeyIP#, output iReturn#).
    
    return iReturn#.
    
  end method. /* GetKeyState */


  method public static logical GetCapsLockOn():
    
    /* GetKeyState via api */
    
    define variable bReturn#   as logical no-undo.
    define variable iKeystate# as integer no-undo.
    
    iKeystate# = GetKeyState(VK_CAPITAL).
    
    /* TODO: should be bit-wise, but will do for now. */
    if iKeystate# >= 1 then bReturn# = true.
    
    return bReturn#.
    
  end method. /* GetCapsLockOn */
  
  method public static void MicroSleep(input iMillisecondsIP# as integer):

    define variable oDummy# as Progress.Lang.Object no-undo.

    if not valid-handle(hExternalProcs#) then
      sc_procedurehandles:PersistentProcedure(oDummy#, "panaedra/msroot/msutil/logic/sc_win32_sub.p", output hExternalProcs#). 

    run Sleep in hExternalProcs#(iMillisecondsIP#).

  end method. /* MicroSleep */  

  method public static int GetProcessID():

    define variable iProcessID# as integer no-undo.
    
    run GetCurrentProcessId in hExternalProcs# (output iProcessID#).

    iProcessID# = (2147483648.0 + iProcessID#) mod 65536.
    /* 2^31 + iProcessID# to have unsigned PID, MOD 65536 to have 16 bits part */
    
    if iProcessID# > 32748 then
      /* the 16 bits part stored in _connect is signed */
      iProcessID# = iProcessID# - 65536.
    
  end method. /* GetProcessID */

end class.

/* EOF */

