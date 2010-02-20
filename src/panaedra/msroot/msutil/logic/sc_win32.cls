{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_win32: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_win32.cls $ 
          Version: $Revision: 8 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-02-20 11:51:44+01:00 $ 
    Date Modified: $Modtime: 2010-02-20 11:34:06+01:00 $ 

      Description: Algemene Windows API calls

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_win32(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 8 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable hExternalProcs# as handle  no-undo.
  
  define protected static variable VK_CAPITAL      as integer no-undo init 20. /* 0x14 */
  

  method public static void ShellExecute(cFileIP# as char):
    
    /* 'dubbelklik' een bestandje vanaf Windows Explorer. */
    
    ShellExecute(cFileIP#, "open").
    
  end method. /* ShellExecute ; Action = "open" */
  

  method public static void ShellExecute(cFileIP# as char, cActionIP# as char):
    
    define variable cFileFull# as character            no-undo.
    define variable oDummy#    as Progress.Lang.Object no-undo.
    
    /* 'dubbelklik' een bestandje vanaf Windows Explorer. */
    
    if not valid-handle(hExternalProcs#) then
      sc_procedurehandles:PersistentProcedure(oDummy#, "panaedra/msroot/msutil/logic/sc_win32_sub.p", output hExternalProcs#). 
    
    file-info:file-name = cFileIP#.
    cFileFull# = replace(file-info:full-pathname, "/", "~\").
    
    run ShellExecuteA in hExternalProcs# (0, cActionIP#, if cFileFull# > "" then cFileFull# else cFileIP#, "", ".", 0).
    
  end method. /* ShellExecute ; Op te geven action */


  method public static void MessageBox(cMsgIP# as char, cTitleIP# as char):
    
    /* MessageBox via de api */

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


end class.

/* EOF */

