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
  define protected static variable cBootProcedure  as character no-undo.
  define public static    variable bDebugLogAsync  as logical   no-undo.
  define public static    variable oLog            as i_log     no-undo.
    
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
    public get:
      if cUserID = "" then return sc_boot:SessionParameter("DefaultUser").
      else return cUserID.
    end.
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

  define static property cDeployID as character no-undo 
    public get:
      if cDeployID = "" then 
      do:
        cDeployID = sc_boot:SessionParameter("DeployID").
      end.
      return cDeployID.
    end get.
    protected set.
  
  define static property cLayer as character no-undo 
    public get:
      if cLayer = "" then 
      do:
        cLayer = sc_boot:SessionParameter("Layer").
      end.
      return cLayer.
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
        bLiveEnv = cEnv matches "*live*" or cEnv = "any_env" or cEnv = "bas".
      end.
      return bLiveEnv.
    end get.
    protected set.

  
  define static property bBatchMode as logical no-undo init ?
    public get:
      define variable cUiMode# as character no-undo.
      if bBatchMode = ? then 
      do:
        cUiMode# = sc_boot:SessionParameter("UiMode").
        bBatchMode = 
          session:batch-mode 
          or (cUiMode# matches "*service*") /* For example: GuiAsService */
          or (cUiMode# matches "*batch*")   
          .
      end.
      return bBatchMode.
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
        
    if session:first-form <> ? or paninui.mdiwindow.sc_mdiwindow:oFirstMdiWindow = ? 
      /* Workaround for 10.2B04. .NET Form from dll isn't reachable anymore after set-wait-state. Worked fine in 10.2B03.
         Note: first-form gives "?" for paninui .NET forms from dll.
         20111008: There is a better workaround now, paninui supports ABL mdi windows. 
      */
      then 
    do:
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
    
    cTempID# = "$A" + replace(guid,"-","").
 
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


  method public static integer GetNumProcessesByWildcard(
    
    /* Returns the number of processes whose command line matches
       the supplied wildcards
       
       Can be used to check if a process is already running. 
    */
  
    input bCasesensitiveIP# as logical,
    input cWildcardOneIP#   as character,
    input cWildcardTwoIP#   as character,
    input cWildcardThreeIP# as character):
      
    define variable iReturn# as integer   no-undo.
    define variable cLine#   as character no-undo.
    define variable cCmd#    as character no-undo.
    
    &if opsys = "unix" &then
    
    assign
      cWildcardOneIP#   = replace(cWildcardOneIP#,"[","~\[")
      cWildcardOneIP#   = replace(cWildcardOneIP#,"]","~\]")
      cWildcardTwoIP#   = replace(cWildcardTwoIP#,"[","~\[")
      cWildcardTwoIP#   = replace(cWildcardTwoIP#,"]","~\]")
      cWildcardThreeIP# = replace(cWildcardThreeIP#,"[","~\[")
      cWildcardThreeIP# = replace(cWildcardThreeIP#,"]","~\]")
      .
    
    cCmd# = "ps -ef" 
      + (if cWildcardOneIP#   > "" then subst("| grep &1 '&2'", trim(string(bCasesensitiveIP#,"/-i")), cWildcardOneIP#  ) else "" )
      + (if cWildcardTwoIP#   > "" then subst("| grep &1 '&2'", trim(string(bCasesensitiveIP#,"/-i")), cWildcardTwoIP#  ) else "" )
      + (if cWildcardThreeIP# > "" then subst("| grep &1 '&2'", trim(string(bCasesensitiveIP#,"/-i")), cWildcardThreeIP#) else "" ).
    
    input stream str-in through value(cCmd#).
 
    repeat:
      import stream str-in unformatted cLine#.
      if cLine# > "" 
        and (not (substring(cLine#,51, 6) = " grep "       ))
        and (not (substring(cLine#,65,13) = "ps -ef| grep ")) 
        then
        iReturn# = iReturn# + 1.
    end.
    
    input stream str-in close.

    return iReturn#.  
  
    &else /* non unix */

    &if {&paninui_tty} &then

    undo, throw new c_panaedraexception(
      99958223,
      sc_lang:oEnglish,
      subst("Error: &1 is not yet implemented for this platform.'", program-name(1))
      ).
    
    &else
      
    define variable oManagementObjectSearcher#   as System.Management.ManagementObjectSearcher                              no-undo.
    define variable oManagementObjectCollection# as System.Management.ManagementObjectCollection                            no-undo.
    define variable oManagementObject#           as System.Management.ManagementObjectCollection+ManagementObjectEnumerator no-undo.
    define variable iProces#                     as integer                                                                 no-undo.
    
    if bCasesensitiveIP# then
      undo, throw new c_panaedraexception(
        99958224,
        sc_lang:oEnglish,
        "Error: bCasesensitiveIP# = true; not yet implemented for this platform.'"
        ).

    assign
      oManagementObjectSearcher#   = new System.Management.ManagementObjectSearcher("select CommandLine from Win32_Process")
      oManagementObjectCollection# = oManagementObjectSearcher#:Get()
      oManagementObject#           = oManagementObjectCollection#:GetEnumerator().
        
    do while oManagementObject#:MoveNext():  
      
      cLine# = oManagementObject#:Current:Item["CommandLine"].
      
      if cLine# > ""  
        and (cWildcardOneIP# = ""   or cLine# matches "*" + cWildcardOneIP# + "*") 
        and (cWildcardTwoIP# = ""   or cLine# matches "*" + cWildcardTwoIP# + "*") 
        and (cWildcardThreeIP# = "" or cLine# matches "*" + cWildcardThreeIP# + "*") then       
        iReturn# = iReturn# + 1.
        
    end.
    
    return iReturn#.

    &endif  /* not paninui_tty */
      
    &endif  /* not unix */
    
  end method. /* GetNumProcessesByWildcard */


  method public static character GetCommandLine():
    
    define variable cParent#    as character no-undo.
    define variable cTempID#    as character no-undo.
    define variable cLine#      as character no-undo.
    define variable cReturn#    as character no-undo.
    define variable iPidByGuid# as integer   no-undo.
    define variable iPidLine#   as integer   no-undo.

    &if opsys = "unix" &then
    
    cTempID# = "$A" + replace(guid,"-","").
 
    input stream str-in through value("ps -ef | grep $$ " + cTempID#).
 
    repeat:
      import stream str-in unformatted cLine#.
      if cLine# matches "*grep $$ " + cTempID# + "*" then
      do:
        /* Get the parent process id from the temporary shell/fork */
        assign
          cParent#    = substring(cLine#,18,7)
          iPidByGuid# = int(cParent#) no-error.
        leave.
      end.
    end.
    
    input stream str-in close.

    input stream str-in through value("ps -ef | grep " + cParent#).
 
    repeat:
      import stream str-in unformatted cLine#.
      iPidLine# = int(substring(cLine#,10,7)).
      if iPidLine# > 0 
        /* Only the line that has the pid of this session */
        and iPidLine# = iPidByGuid# 
        /* Be extra sure if session:parameter is filled  */
        and (if session:parameter > "" then (cLine# matches substitute("*&1*", session:parameter)) 
      else true) 
        then
      do:
        cReturn# = cLine#.
        leave.
      end.
    end.
    
    input stream str-in close.

    return cReturn#.
    
    &else /* non unix */
    
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
    
  &endif /* non unix */
    
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
