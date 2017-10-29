{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_msprocess_win32: 

  /****************************** Source Header ********************************\

      Description: Process handling (process info, restart process, etc) on win32

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method public static integer GetProcessID():
    
    define variable iReturn#  as integer                    no-undo.
    define variable oCurProc# as System.Diagnostics.Process no-undo.
    
    /* Use .NET Runtime */
    oCurProc# = System.Diagnostics.Process:GetCurrentProcess().
    iReturn# = oCurProc#:Id. 
    /* oCurProc#:Dispose(). Don't know for sure if this is needed/better here */
    
    return iReturn#.  
    
  end method. /* GetProcessID */
  
  
  method public static character GetCommandLine():

   &if {&paninui_tty} &then

      /*      return sc_win32:GetCommandLine().*/
            
      /* Not functional yet */ 
                 
      /*    define variable cReturn#  as character no-undo.                             */
      /*    define variable oCurProc# as System.Diagnostics.Process no-undo.            */
      /*                                                                                */
      /*    /* Use .NET Runtime */                                                      */
      /*    oCurProc# = System.Diagnostics.Process:GetCurrentProcess().                 */
      /*                                                                                */
      /*    cReturn# = string(oCurProc#:StartInfo:WorkingDirectory).                    */
      /*    /* oCurProc#:Dispose(). Don't know for sure if this is needed/better here */*/
      /*                                                                                */
      /*    return cReturn#.                                                            */
    
    &endif /* paninui_tty */
      
  end method. /* GetCommandLine */
  
end class.

/* EOF */ 
