using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
{paninui/logic/includes/preproc_dotnetclasses.i &class=class}

class panaedra.msroot.msutil.logic.sc_environment: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_environment.cls $ 
          Version: $Revision: 13 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-07-13 10:55:04+02:00 $ 
    Date Modified: $Modtime: 2010-07-13 10:51:58+02:00 $ 

      Description: Haal informatie uit de omgeving op zoals het pid (process id).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_environment(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 13 $', '{&sourcecontrolversions}').
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
          cSessionGuid    = sc_dbtrig:NewGUID().
      return cSessionGuid.
    end get.
    protected set.

  define static property cSessionGuidRemote as character no-undo 
    public get.
    public set.
  
  define static property cUserID as character no-undo 
    public get.
    public set.
  
  define static property dtmStarted as datetime-tz no-undo 
    public get.
    protected set.
  
  define static property cEnv as character no-undo 
    public get:
      if cEnv = "" then 
      do:
        cEnv = sc_boot:SessionParameter("Env").
      end.
      return cEnv.
    end get.
    protected set.

  
  define static property bDbReadonly as logical no-undo init ?
    public get:
      if bDbReadonly = ? then 
      do:
        /* (1) Sessions with db-read Layer, 
             and sessions with no allowed db connections; 
           (2) webclient user sessions and 
           (3) appservers with no db connections. */
        bDbReadOnly = lookup(sc_boot:SessionParameter("Layer"),"db_r,webclient,as_nodb") > 0. 
        if bDbReadOnly = ? then bDbReadOnly = false.
      end.
      return bDbReadonly.
    end get.
    protected set.

  
  define static property bLiveEnv as logical no-undo init ?
    public get:
      if bLiveEnv = ? then 
      do:
        bLiveEnv = cEnv matches "*live*" or cEnv = "bas" .
      end.
      return bLiveEnv.
    end get.
    protected set.

  
  define static property iServerSocketPort as integer no-undo 
    public get.
    public set.
    
  constructor static sc_environment():
    
    /* This is technically not the exact time the session is started, but the first time sc_environment is used. */
    
    dtmStarted = now.
    
  end constructor. /* static constructor */
  

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
    
       Can be made FIFO with a protected static temp-table, or ignored alltogether.

       session:set-wait-state shouldn't be set directly.
       
     */
  
    oObjectIP# as Progress.Lang.Object, 
    bValueIP#  as logical):
    
    SetWaitStateImplement(bValueIP#).
    
  end method. /* SetWaitState */


  method public static void SetWaitState(
    
    /* This method is for controlling session:wait-state.
    
       Can be made FIFO with a protected static temp-table, or ignored alltogether.

       session:set-wait-state shouldn't be set directly.
       
     */
  
    hProcIP#   as handle, 
    bValueIP#  as logical):
      
    SetWaitStateImplement(bValueIP#).

  end method. /* SetWaitState (handle instead of object) */  


  method public static void SetWaitState(
    
    /* This method is for controlling session:wait-state.
    
       Can be made FIFO with a protected static temp-table, or ignored alltogether.

       session:set-wait-state shouldn't be set directly.
       
     */
  
    cClassIP#  as character, 
    bValueIP#  as logical):
      
    SetWaitStateImplement(bValueIP#).

  end method. /* SetWaitState (handle instead of object) */  


  method protected static void SetWaitStateImplement(
    
    /* This method is for controlling session:wait-state.
    
       Can be made FIFO with a protected static temp-table, or ignored alltogether.

       session:set-wait-state shouldn't be set directly.
       
     */
  
    bValueIP#  as logical):
    
    &if opsys = "unix" &then
    
    session:set-wait-state(if bValueIP# then "general" else "").
    
    &else
        
    if paninui.mdiwindow.sc_mdiwindow:oFirstMdiWindow = ? 
      /* Workaround for 10.2B04. Form isn't reachable anymore after set-wait-state. Worked fine in 10.2B03.
         Note: first-form gives "?" for paninui forms. 
      */
      then do:
      session:set-wait-state(if bValueIP# then "general" else "").
    end.
    
    &endif
    
  end method. /* SetWaitStateImplement */


  method public static logical GetWaitState(
    
    /* This method is for getting session:wait-state.
    
       Is now only an entry point.
       Can be made FIFO with a protected static temp-table, or ignored alltogether.

       session:get-wait-state shouldn't be called directly.
       
     */
  
    oObjectIP# as Progress.Lang.Object):
      
    return session:get-wait-state() = "general".

  end method. /* GetWaitState */
 
  
  method public static integer GetProcessID():
    
    &if {&paninui_tty} &then
 
    define variable cParent# as character no-undo.
    define variable cTempID# as character no-undo.
    define variable cLine#   as character no-undo.
        
    &if opsys = "unix" &then
    
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
    
    &else
    
    /* TODO: processid for win32 tty */
    
    &endif /* unix only */
   
    return integer(cParent#).

    &else /* win32 gui */
    
    define variable iReturn#  as integer                    no-undo.
    define variable oCurProc# as System.Diagnostics.Process no-undo.
    
    /* Use .NET Runtime */
    oCurProc# = System.Diagnostics.Process:GetCurrentProcess().
    iReturn# = oCurProc#:Id. 
    /* oCurProc#:Dispose(). Don't know for sure if this is needed/better here */
    
    return iReturn#.
    
    &endif
    
  end method. /* GetProcessID */


  method public static integer GetProcessMemSize():
    
    &if opsys = "unix" &then
    
    define variable iPID#    as integer   no-undo.
    define variable cLine#   as character no-undo.
    define variable iReturn# as integer   no-undo.
    
    iPID# = GetProcessID().
    
    input through value(subst("ps vx | grep &1", iPID#)).
    
    repeat:
      import unformatted cLine#.
      if " " + cLine# matches subst("* &1*", iPID#) then 
      do:
        cLine# = trim(substring(cLine#,28,-1)).
        cLine# = replace(cLine#,"~t"," ").
        do while 
          index(cLine#, "  ") > 0:
          cLine# = replace(cLine#, "  ", " ").
        end.
        /* Give back the RSS size */
        iReturn# = int(entry(3,cLine#," ")) no-error.
        leave.
      end.
    end.
    
    return iReturn#.
    
    &else
    
    /*** Not supported ***/
      
    return 0.  
    
  &endif /* unix only */
    
  end method. /* GetProcessMemSize */


  method public static character GetCommandLine():
    
    &if {&paninui_tty} &then

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
    
    /* win32, tty + gui/.net */
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
