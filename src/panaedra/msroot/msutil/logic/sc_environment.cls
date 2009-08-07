{panaedra/msi/logic/ctop_class.i}

class panaedra.msb.logic.sc_environment: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msb/logic/sc_environment.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-08-07 21:22:38+02:00 $ 
    Date Modified: $Modtime: 2009-08-07 21:22:38+02:00 $ 

      Description: Haal informatie uit de omgeving op zoals het pid (process id).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_environment(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define stream str-in.
  
  method public static integer GetProcessID():
    
    &if opsys = "unix" &then
 
    define variable cParent# as character no-undo.
    define variable cTempID# as character no-undo.
    define variable cLine#   as character no-undo.
        
    cTempID# = "$A" + string(mtime,"999999999").
 
    input through value("ps -ef | grep $$ " + cTempID#).
 
    repeat:
      import unformatted cLine#.
      if cLine# matches "*grep $$ " + cTempID# + "*" then
      do:
        /* Get the parent process id from the temporary shell/fork */
        cParent# = substring(cLine#,18,7).
        leave.
      end.
    end.
   
    return integer(cParent#).

    &else
    
    define variable iReturn#  as integer                    no-undo.
    define variable oCurProc# as System.Diagnostics.Process no-undo.
    
    /* Use .NET Runtime */
    oCurProc# = System.Diagnostics.Process:GetCurrentProcess().
    iReturn# = oCurProc#:Id. 
    /* oCurProc#:Dispose(). Don't know for sure if this is needed/better here */
    
    return iReturn#.
    
    &endif
    
  end method. /* getProcessID */


  method public static char GetHostName():
    
    define variable cReturn# as character no-undo.
    
    &if opsys = "unix" &then
    
    input through hostname.
    import cReturn#.
    input close.
    
    &else
    
    cReturn# = os-getenv("COMPUTERNAME").
    
    &endif
    
    if cReturn# = ? or cReturn# = "" then cReturn# = "NoHostName".
    
    return cReturn#.
    
  end method. /* GetHostName */

end class.

/* EOF */
