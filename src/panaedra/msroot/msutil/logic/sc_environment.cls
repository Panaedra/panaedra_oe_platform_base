{panaedra/msi/logic/ctop_class.i}

class panaedra.msb.logic.sc_environment: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msb/logic/sc_environment.cls $ 
          Version: $Revision: 8 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-18 08:31:49+01:00 $ 
    Date Modified: $Modtime: 2010-01-17 23:11:02+01:00 $ 

      Description: Haal informatie uit de omgeving op zoals het pid (process id).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_environment(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 8 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define stream str-in.
  
  define protected static variable bSessionGuidSet as logical   no-undo.
  define public static    variable bDebugLogAsync  as logical   no-undo.
  define protected static variable cBootProcedure  as character no-undo.
  
  define static property cSessionGuid as character no-undo 
    public get:
      if not bSessionGuidSet then assign
          bSessionGuidSet = true
          cSessionGuid    = panaedra.msdr.logic.sc_dbtrig:NewGUID().
      return cSessionGuid.
    end get.
    protected set.

  define static property cSessionGuidRemote as character no-undo 
    public get.
    public set.
  
  define static property cUserID as character no-undo 
    public get.
    public set.
  

  method public static void SetImmediateDisplay(
    
    /* This method is for controlling session:immediate-display.
    
       Is now only an entry point.
       Can be made FIFO with a protected static temp-table, or ignored alltogether.

       session:immediate-display shouldn't be set directly.
       
     */
  
    oObjectIP# as Progress.Lang.Object, 
    bValueIP#  as logical):
      
    session:immediate-display = bValueIP#.

  end method. /* SetImmediateDisplay */
  
  
  method public static logical GetImmediateDisplay(
    
    /* This method is for getting session:immediate-display.
    
       Is now only an entry point.
       Can be made FIFO with a protected static temp-table, or ignored alltogether.

       session:immediate-display shouldn't be called directly.
       
     */
  
    oObjectIP# as Progress.Lang.Object):
      
    return session:immediate-display.

  end method. /* GetImmediateDisplay */
  
  
  method public static void SetWaitState(
    
    /* This method is for controlling session:wait-state.
    
       Is now only an entry point.
       Can be made FIFO with a protected static temp-table, or ignored alltogether.

       session:set-wait-state shouldn't be set directly.
       
     */
  
    oObjectIP# as Progress.Lang.Object, 
    bValueIP#  as logical):
    
    session:set-wait-state(if bValueIP# then "general" else "").

  end method. /* SetWaitState */
  
  
  method public static logical GetWaitState(
    
    /* This method is for getting session:wait-state.
    
       Is now only an entry point.
       Can be made FIFO with a protected static temp-table, or ignored alltogether.

       session:get-wait-state shouldn't be called directly.
       
     */
  
    oObjectIP# as Progress.Lang.Object):
      
    return session:get-wait-state() = "general".

  end method. /* GetWaitState */
  
  
  method public static void ProcessEvents(oObjectIP# as Progress.Lang.Object):
    
    /* This void (!) method is for safely doing a "process events.".
    
       Is now only an entry point.
       Can be "stalled" when the environment is in a state where process events 
       is prohibited, or ignored alltogether.

       The "process events" statement shouldn't be used directly.
       
     */
  
    process events.

  end method. /* ProcessEvents */
  

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
    
  end method. /* GetProcessID */


  method public static character GetCommandLine():
    
    &if opsys = "unix" &then
/*                                                                     */
/*    define variable cParent# as character no-undo.                   */
/*    define variable cTempID# as character no-undo.                   */
/*    define variable cLine#   as character no-undo.                   */
/*                                                                     */
/*    cTempID# = "$A" + string(mtime,"999999999").                     */
/*                                                                     */
/*    input through value("ps -ef | grep $$ " + cTempID#).             */
/*                                                                     */
/*    repeat:                                                          */
/*      import unformatted cLine#.                                     */
/*      message cLine#                                                 */
/*        view-as alert-box.                                           */
/*                                                                     */
/*      if cLine# matches "*grep $$ " + cTempID# + "*" then            */
/*      do:                                                            */
/*        /* Get the parent process id from the temporary shell/fork */*/
/*        return cLine#.                                               */
/*      end.                                                           */
/*    end.                                                             */
/*                                                                     */
/*    return "[unknown]".                                              */

    &else
      
/*      return sc_win32:GetCommandLine().*/
      
      
      /* Werkt nog niet */ 
           
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
    
    &endif
    
  end method. /* GetCommandLine */


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
  
  
  method public static logical IsIdeRunning():
  
    /* Checks if an IDE (like Eclipse) is running this session. */
  
    /* If it's a seperate Eclipse session, we can use an environment variable */
    if os-getenv("ECLIPSE_PROJECT") > "" then return true.
    
    /* Otherwise check the boot procedure */    
    
    return GetBootProcedure() matches "*/eclipse/*".
      
  end method. /* IsIdeRunning */  


  method public static character GetBootProcedure():
  
    /* Gives back program-name(highest), with forward slashes. 
       
       Note:
       Evaluated only once, for efficiency.
    */
  
    define variable iLastProgram# as integer no-undo init 1.
    
    if cBootProcedure = "" then 
    do:    
      do while program-name(iLastProgram#) > "":
        iLastProgram# = iLastProgram# + 1.
      end.
      cBootProcedure = replace(program-name(iLastProgram# - 1),"~\","/").
    end.
    
    return cBootProcedure.
      
  end method. /* IsIdeRunning */  

end class.

/* EOF */
