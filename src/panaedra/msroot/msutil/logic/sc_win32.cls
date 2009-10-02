{panaedra/msi/logic/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_win32: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_win32.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-02 11:47:19+02:00 $ 
    Date Modified: $Modtime: 2009-10-02 11:46:49+02:00 $ 

      Description: Algemene Windows API calls

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_win32(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable hExternalProcs# as handle no-undo.
  
  method public static void ShellExecute(cFileIP# as char):
    
    /* 'dubbelklik' een bestandje vanaf Windows Explorer. */
    
    if not valid-handle(hExternalProcs#) then 
      run PersistentProcedure ( "panaedra/msroot/msutil/logic/sc_win32_sub.p", output hExternalProcs#).
    
    file-info:file-name = cFileIP#.
    cFileIP# = replace(file-info:full-pathname, "/", "~\").
    
    run ShellExecuteA in hExternalProcs# (0, "open", cFileIP#, "", ".", 0).
    
  end method. /* ShellExecute */



end class.

/* EOF */

