using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msas.logic.*.
using panaedra.msroot.msdeploy.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
{paninui/logic/includes/preproc_dotnetclasses.i &class=class}

class panaedra.msroot.msutil.logic.sc_environment:

  /****************************** Source Header ********************************\

      Description: Get session and environment information, like pid (process id).

  \*****************************  Include Files ********************************/
{panaedra/msroot/msutil/logic/ds/msenvironment_ds.i &class=class &protected=protected &static=static}
{panaedra/msroot/msutil/logic/sc_environment_sub.i &class=class}
  /******************************* $NoKeywords:  $ *****************************/

  constructor protected sc_environment(
    input oParamIP# as i_unittest_param):
  end constructor.  

  define stream str-in.
  define stream str-os. 
  
  define protected static variable bSessionGuidSet   as logical   no-undo.
  define protected static variable cBootProcedure    as character no-undo.
  define protected static variable iProcessID        as integer   no-undo initial ?.
  define protected static variable bAutoRestartIsSet as logical   no-undo.
  define public static    variable bDebugLogAsync    as logical   no-undo.
  define public static    variable oLog              as i_log     no-undo.
  define public static    variable cRemoteUserID     as character no-undo.
  

  define static property cCodepageNative as character no-undo init ?
    public get:
      if cCodepageNative = ? then assign
          cCodepageNative = (if opsys = "unix" then "ibm850" else "1252").
      return cCodepageNative.
    end get.
    protected set.
  
    
  define static property cSessionGuid as character no-undo 
    public get:
      if not bSessionGuidSet then assign
          bSessionGuidSet = true
          cSessionGuid    = sc_dbtrig:NewGUID().
      return cSessionGuid.
    end get.
    protected set.
    
  define static property cSessionGuidShort as character no-undo init ?
    public get:
      if cSessionGuidShort = ? then cSessionGuidShort = substring(cSessionGuid,15,18).
      return cSessionGuidShort.
    end get.
    protected set.
    
  define static property cHostName as character no-undo init ? 
    public get:
      if cHostName = ? then cHostName = GetHostName().
      return cHostName.
    end get.
    protected set.
    
  define static property cSessionGuidRemote as character no-undo 
    public get.
    public set.
  
  define static property cSessionParameterString as character no-undo init ? 
    public get:
      if cSessionParameterString = ? then 
      do:
        cSessionParameterString = sc_string_substitute:ExpandOsEnv(if length(sc_boot:cBootSessionParameter) > 0 then sc_boot:cBootSessionParameter else session:parameter).
      end.
      return cSessionParameterString.
    end get.
    protected set.
  
  define static property cIpAddress as character no-undo init ?
    public get:
      if cIpAddress = ? then cIpAddress = GetIpAddress().
      return cIpAddress.
    end get.
    protected set.
       
  define static property cUserID as character no-undo 
    public get:
      define variable cDefaultUser# as character no-undo.
      if cUserID = "" then 
      do:
        cDefaultUser# = sc_boot:SessionParameter("DefaultUser").
        if cDefaultUser# = ? then cDefaultUser# = "".
        return cDefaultUser#.
      end.
      else return cUserID.
    end.
    public set(cInputIP# as character):
      /* Reset the default appserver context dataset */
      if cUserID <> cInputIP# then
        sc_proxycontext:EmptyDefaultDsContext().
      cUserID = cInputIP#.
    end set.


  define static property cOsUserID as character no-undo /* Operating User ID, not session User ID */ initial ?
    public get:
      if cOsUserID = ? then 
      do:
        cOsUserID = sc_string_substitute:ExpandOsEnv(if opsys = "unix" then "%LOGIN%" else "%USERNAME%", true).
      end.
      return cOsUserID.
    end get.
    protected set.
  
  
  define static property cUiMode as character no-undo /* [UiMode] parameter. Some possible values: "AppServer" , "GUI" , "CHUI" */ initial ?
    public get:
      if cUiMode = ? then
      do:
        cUiMode = sc_boot:SessionParameter("UiMode").
        if cUiMode = ? then cUiMode = "".
      end.
      return cUiMode.
    end get.
    protected set.
  
  
  define static property cDevTokenID as character no-undo /* DevToken user ID, for developers */ initial ?
    public get:
      if cDevTokenID = ? then 
      do:
        cDevTokenID = sc_string_substitute:ExpandOsEnv("%DevToken%", true).
        if not sc_data:HasValue(cDevTokenID) then cDevTokenID = "".
      end.
      return cDevTokenID.
    end get.
    protected set.
    
  
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
  
  define static property cOpSys as character no-undo initial ? 
    public get: 
      if cOpSys = ? then 
      do:
        cOpSys = opsys. 
      end. 
      return cOpSys.
    end get.    
    protected set. 

  define static property cLang as character no-undo 
    public get:
      if cLang = "" then 
      do:
        cLang = lc(sc_boot:SessionParameter("Lang")).
      end.
      return cLang.
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
  
  define static property iDeployVersion as integer no-undo init ?
    public get:
      if iDeployVersion = ? then 
      do:
        define variable dtmVersion# as datetime-tz no-undo.
        sc_msdeploy_info:GetCurrentMaxVersion(output iDeployVersion, output dtmVersion#).
        if iDeployVersion = ? then iDeployVersion = 0.
      end.
      return iDeployVersion.
    end get.
    protected set.

  define static property dtmDeployVersion as datetime-tz no-undo init ?
    public get:
      if dtmDeployVersion = ? then 
      do:
        define variable iDeployVersion# as integer no-undo.
        sc_msdeploy_info:GetCurrentMaxVersion(output iDeployVersion#, output dtmDeployVersion).
        if dtmDeployVersion = ? then dtmDeployVersion = 1/1/2000.
      end.
      return dtmDeployVersion.
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


  define static property bUnittestEnv as logical no-undo init ?
    /* Note: also see bUnittestRunning (below). bUnittestRunning can change during the session, bUnittestEnv can not. */
    public get:
      define variable cUnittestMoreEnv# as character no-undo.
      if bUnittestEnv = ? then 
      do:
        if cEnv matches "*tst*" then
          bUnittestEnv = true.
        else 
        do:
          /* For developers who temporarily want to unittest in a different test or stage environment */
          cUnittestMoreEnv# = os-getenv("UNITTEST_MORE_ENV"). 
          if length(cUnittestMoreEnv#) > 0 and logical(cUnittestMoreEnv#) then 
            bUnittestEnv = true.
        end.    
      end.
      return bUnittestEnv.
    end get.
    protected set.

  
  define static property bUnittestRunning as logical no-undo
    /* Note: also see bUnittestEnv (above). bUnittestRunning can change during the session, bUnittestEnv can not.  */
    public get.
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
    
    define variable iReturn# as integer no-undo.
    
    if not sc_data:HasValue(iProcessID) then 
    do:
    
      &if opsys = "win32" &then
      
      iReturn# = sc_msprocess_win32:GetProcessID().
      if sc_data:HasValue(iReturn#) then iProcessID = iReturn#.
      
      &else
      
      &if {&paninui_tty} &then
   
      define variable cParent# as character no-undo.
      define variable cTempID# as character no-undo.
      define variable cLine#   as character no-undo.
          
      &if opsys = "unix" &then
      
      {panaedra/msroot/msutil/logic/sc_unix_set_libpath.i}
      
      if
        /* Do it the old way on the 'old' _SRVR_ server.   New server is called '_SRVR_'.  codeQok#7110 */ 
        GetHostName() = "_SRVR_" or                                                       /* codeQok#7110 */
        /* Do it the old way on the 'old' _PRODUCT_ server. New server is called 'srv-_PRODUCT_' codeQok#7110 */ 
        GetHostName() = "_PRODUCT_" or                                                     /* codeQok#7110 */
        /* Do it the old way if our python library is not present                          codeQok#7110 */
        search({&UnixGetPidLib}) = ? 
        then 
      do:
        
        /* Do it the old way that does not work 100 percent OK all the time */
        
        cTempID# = "$A" + replace(guid,"-","").
     
        input through value("ps -ef | grep $$ " + cTempID#).
     
        repeat on error undo, throw:
          import unformatted cLine#. /* codeQok#7126 -> fail */
          if cLine# matches "*grep $$ " + cTempID# + "*" then
          do:
            /* Get the parent process id from the temporary shell/fork */
            cParent# = substring(cLine#,18,7).
            leave.
          end.
        end.
        
        iReturn# = integer(cParent#).
        if sc_data:HasValue(iReturn#) then iProcessID = iReturn#.
        
      end.
      else 
      do:
        
        /* Do it the new way that does work 100 percent OK, but is dependent on a custom dll/shared object. */
        
        run panaedra/msroot/msutil/logic/sc_environment_sub_unix_getpid.p (output iReturn#).
        if sc_data:HasValue(iReturn#) then iProcessID = iReturn#.
        
      end.
      
      &else
      
      /* ShouldHave: processid for win32 tty */
      
      &endif /* unix only */
     
      &endif
      
      &endif
    
    end.
    
    return iProcessID.
    
  end method. /* GetProcessID */


  method public static integer GetProcessMemSize():
    
    &if opsys = "unix" &then
    
    define variable iPID#    as integer   no-undo.
    define variable cLine#   as character no-undo.
    define variable iReturn# as integer   no-undo.
    
    iPID# = GetProcessID().
    
    input through value(subst("ps vx | grep &1", iPID#)).
    
    repeat on error undo, throw:
      import unformatted cLine#. /* codeQok#7126 -> fail */
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
      + (if length(cWildcardOneIP#  ) > 0 then subst("| grep &1 '&2'", trim(string(bCasesensitiveIP#,"/-i")), cWildcardOneIP#  ) else "" )
      + (if length(cWildcardTwoIP#  ) > 0 then subst("| grep &1 '&2'", trim(string(bCasesensitiveIP#,"/-i")), cWildcardTwoIP#  ) else "" )
      + (if length(cWildcardThreeIP#) > 0 then subst("| grep &1 '&2'", trim(string(bCasesensitiveIP#,"/-i")), cWildcardThreeIP#) else "" ).
    
    input stream str-in through value(cCmd#).
 
    repeat on error undo, throw:
      import stream str-in unformatted cLine#. /* codeQok#7126 -> fail */
      if length(cLine#) > 0 
        and (not (substring(cLine#,65,13) = "ps -ef| grep ")) 
        then
        iReturn# = iReturn# + 1.
    end.
    
    input stream str-in close.

    return iReturn#.  
  
    &else /* non unix */

    &if {&paninui_tty} and int(entry(1,proversion,".")) <= 10 &then

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
      
      if length(cLine#) > 0  
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
 
    repeat on error undo, throw:
      import stream str-in unformatted cLine#. /* codeQok#7126 -> fail */
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
 
    repeat on error undo, throw:
      import stream str-in unformatted cLine#. /* codeQok#7126 -> fail */
      iPidLine# = int(substring(cLine#,10,7)).
      if iPidLine# > 0 
        /* Only the line that has the pid of this session */
        and iPidLine# = iPidByGuid# 
        /* Be extra sure if session:parameter is filled  */
        and (if length(session:parameter) > 0 then (cLine# matches substitute("*&1*", session:parameter)) 
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
    
    return sc_msprocess_win32:GetCommandLine().
    
  &endif /* non unix */
    
  end method. /* GetCommandLine */


  method public static character GetCommandLine(iPidIP# as integer):
    
    define variable cParent#  as character no-undo.
    define variable cLine#    as character no-undo.
    define variable cReturn#  as character no-undo.
    define variable iPidLine# as integer   no-undo.
    define variable cCmd#     as character no-undo.
    define variable cGrep#    as character no-undo.

    &if opsys = "unix" &then
    
    assign
      cGrep# = substitute(" grep &1", trim(string(iPidIP#,">>>>>>>>9")))
      cCmd#  = "ps -ef |" + cGrep#.
    
    input stream str-in through value(cCmd#).
 
    repeat on error undo, throw:
      import stream str-in unformatted cLine#. /* codeQok#7126 -> fail */
      if not cLine# matches "*" + cGrep# + "*" then
        cReturn# = cReturn# + subst(chr(10) + "&1", cLine#).
    end.
    
    input stream str-in close.

    return substring(cReturn#,2).
    
    &else /* non unix */
    
    undo, throw new c_panaedraexception(
      99958228,
      sc_lang:oEnglish,
      "Error:  GetCommandLine with iPidIP# as input parameter is not yet implemented for this platform."
      ).
    
  &endif /* non unix */
    
  end method. /* GetCommandLine ; with iPidIP# as input parameter */


  method public static char GetHostName():
    
    define variable cReturn# as character no-undo.
    
    &if opsys = "unix" &then
    
    input through "_TOOLING_".
    import cReturn#. /* codeQok#7126 -> fail */
    input close.
    
    &else 
    
    /* win32, tty + gui/.net */
    cReturn# = os-getenv("COMPUTERNAME").
    
    &endif
    
    /* Note: we search for ":" because bash/shell will always return a colon somewhere in stdout if  */
    /*       in error, and a hostname should not contain this character.                             */
    /*       Added this exception after deep debugging something seemingly unrelated.                */
    if cReturn# = ? or cReturn# = "" or index(cReturn#, ":") > 0 then do:
      undo, throw new c_panaedraexception(
        9993671,
        sc_lang:oEnglish,
        substitute("GetHostName could not resolve a default hostname. Value:'&1'", cReturn#)
        ).
    end.
    
    return cReturn#.
    
  end method. /* GetHostName */
  
  
  method public static logical IsIdeRunning():
  
    /* Checks if an IDE (like Eclipse) is running this session. */

    /* If it's a seperate Eclipse session, we can use an environment variable */
    if length(os-getenv("ECLIPSE_PROJECT")) > 0 then return true.

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
      do while program-name(iLastProgram#) > "": /* codeQok#7122 */
        iLastProgram# = iLastProgram# + 1.
      end.
      cBootProcedure = replace(program-name(iLastProgram# - 1),"~\","/").
    end.
    
    return cBootProcedure.
      
  end method. /* GetBootProcedure */  

  
  method protected static character GetIpAddress():
    
    define variable cLine#                     as character no-undo.
    define variable cIpAdres#                  as character no-undo.
    define variable iTell#                     as integer   no-undo.
    define variable bLocalAreaConnectionFound# as logical   no-undo.
    define variable bDefaultGatewayFound#      as logical   no-undo.
    
    define buffer b-ttMsIpDetection for ttMsIpDetection.
    
    &if opsys = "win32" &then 
    
    define variable oHostEntry#  as System.Net.IPHostEntry         no-undo.
    define variable oIpAddress#  as System.Net.IPAddress           no-undo.
    define variable oEnumerator# as System.Collections.IEnumerator no-undo.
    define variable cLocalIp#    as character                      no-undo.
    define variable cIpAddress#  as character                      no-undo.
    define variable iIpAddress#  as integer                        no-undo.
    
    if not can-find(first b-ttMsIpDetection) then
      sc_config:ReadXml(dataset dsMsEnvironment:handle,sc_path:StandardIniFilePath("sc_environment.config")).
      
    find b-ttMsIpDetection where b-ttMsIpDetection.cOpsys = opsys.
    
    assign
      oHostEntry#  = System.Net.Dns:GetHostEntry(System.Net.Dns:GetHostName())
      oEnumerator# = oHostEntry#:AddressList:GetEnumerator().

    do while oEnumerator#:MoveNext():
      if type-of(oEnumerator#:Current, System.Net.IPAddress) then 
      do:
        oIpAddress# = cast(oEnumerator#:Current, System.Net.IPAddress).
        if oIpAddress#:AddressFamily:ToString()  = "InterNetwork" 
          and 
          oIpAddress#:ToString() begins b-ttMsIpDetection.cPreferredIpV4Prefix
          then
          cIpAdres# = oIpAddress#:ToString().
      end.
    end.
    
    if cIpAdres# = "" then cIpAdres# = "127.0.0.1".
    
    &if false &then /* Old-style windows, not dotnet */
    
    input through value("ipconfig") no-echo.
    
    b_read_file:
    repeat on error undo, throw:
      
      import unformatted cLine#. /* codeQok#7126 -> fail */
      
      if cLine# matches ("*Local Area Connection:*") then 
        bLocalAreaConnectionFound# = yes.
        
      if trim(cLine#) begins "IP Address" 
        or trim(cLine#) begins "IP-adres"     /* For dutch OS versions codeQok#7104 */
        or trim(cLine#) begins "IPv4 Address"
        or trim(cLine#) begins "IPv4-adres"   /* For dutch OS versions codeQok#7104 */
        then 
      do:
        cIpAdres# = cLine#.
        if bLocalAreaConnectionFound# then 
          leave b_read_file.
      end.
      
      if   trim(cLine#) begins "Default Gateway"
        or trim(cLine#) begins "Standaardgateway" /* For dutch OS versions codeQok#7104 */
        then 
      do:
        if num-entries(cLine#,":") > 1 and trim(entry(2,cLine#,":")) > "" and cIpAdres# > "" then 
        do:
          /* When we have Default Gateway we assume this ipaddress is the right one */
          leave b_read_file.
        end.
      end.
    end. /* repeat */
    
    input close.
    
    cIpAdres# = trim(entry(1,substring(cIpAdres#,index(cIpAdres#,":") + 1),"(")).
    
    &endif /* Old-style windows, not dotnet */
    
    &else
    
    input through value("resolv") no-echo.
    import unformatted cIpAdres#. /* codeQok#7126 -> fail */
    input close.
    
    &endif
    
    return cIpAdres#.
    
  end method. /* GetIpAddress */
  
  
  method public static character GetWorkstationDescription(
    input cTerminalIdIP# as character
    ):
    
    define variable cReturn# as character no-undo.  
    
    if opsys = 'unix' then
    do:
    
      cTerminalIdIP# = replace(cTerminalIdIP#, '/dev/', '').
      
      input through value(subst('who| grep "&1 "', cTerminalIdIP#)) no-echo.
      import unformatted cReturn#. /* codeQok#7126 -> fail */
      input close.
      
      if length(cReturn#) > 42 then 
      do:
        cReturn# = substring(cReturn#, 42).
      end.
      
    end.  
    
    return cReturn#.
  
  end method. /* GetWorkstationDescription */
  
  
  method public static character GetOsEnv(
    
    /* Returns the same as os-getenv, but returns an empty string if the environment variable is not set. */
    
    cOsEnvIP# as character):
    
    define variable cRet# as character no-undo.
    
    cRet# = os-getenv(cOsEnvIP#).
    if cRet# = ? then cRet# = "".
    
    return cRet#.
    
  end method. /* GetOsEnv */
  
  
  method public static character GetUserIdStrong(
    
    /* Get the current userid in various ways.
       If cRemoteUserID is set, use it.
       If a db is connected, use the userid() function.
       If no db connected, or connected but not logged in, continue.
       Find by os username.
    */
    
    ):

    define variable cRet# as character no-undo.
    
    if length(cRemoteUserID) > 0 then 
      /* This is used in batches like _TOOLING_, because we want the original user in lograw.uspid (_TERM_UNDISCLOSED_ mutatie historie) */
      cRet# = cRemoteUserID. 
      
    if cRet# = ? or length(cRet#) = 0  and num-dbs > 0 then
      cRet# = userid(ldbname(1)).
      
    if cRet# = ? or length(cRet#) = 0 then
      cRet# = cUserID.  
        
    if cRet# = ? or length(cRet#) = 0 then
      cRet# = cOsUserID.
        
    return cRet#.
        
  end method. /* GetUserIdStrong */
  
  
  method public static void SetUnittestRunning(
  
    /* Set bUnittestRunning to a new value. Changes (a.o.) INI value read to in-memory instead of from os-file. */
    
    oUnittestClientIP# as i_unittest_client,
    bValueIP#          as logical):
      
    if sc_environment:bLiveEnv then
      undo, throw new c_panaedraexception(
        99927886,
        sc_lang:oEnglish,
        "Calling this method is not allowed in live environments.").
      
    if bValueIP# = true and (not valid-object(oUnittestClientIP#)) then
      undo, throw new c_panaedraexception(
        99927887,
        sc_lang:oEnglish,
        "Setting UnittestRunning to true is only allowed for unit tests.").
    
    bUnittestRunning = bValueIP#.
    
  end method. /* SetUnittestRunning */
  
  
  method public static void _sys_SetUnittestRunning(
  
    /* Set bUnittestRunning to a new value. Changes (a.o.) INI value read to in-memory instead of from os-file.
     * Note: this _sys_ method should not be called from custom logic.
     */
    
    bValueIP#          as logical):
      
    if sc_environment:bLiveEnv then
      undo, throw new c_panaedraexception(
        99927886,
        sc_lang:oEnglish,
        "Calling this method is not allowed in live environments.").
    
    bUnittestRunning = bValueIP#.
    
  end method. /* _sys_SetUnittestRunning */
  
  
  @panaedraannotation file(unittest="yes").
  method public static void CallPythonpathSet(
  
    /* FREF@77475c73b: When changes are made to PythonpathSet review the unittest and logic of CallPythonpathSet */
  
    input cWorkPathIP# as character   
    ):
    
    define variable cCommand#     as character no-undo.
    define variable cLine#        as character no-undo.
    define variable cPythonpath#  as character no-undo.
    define variable iSaveLastkey# as integer   no-undo.
    
    cCommand# = substitute('$SCRIPTS/EchoPythonpathSet.sh &1', cWorkPathIP#). 
    
    if IsUnix() then 
    do on error undo, leave: 

      iSaveLastkey# = keycode(keyfunction(lastkey)). /* Remember the lastkey code */

      input stream str-os through value(cCommand#).

      repeat on error undo, throw: 
        import stream str-os unformatted cLine#. /* codeQok#7126 */
        if trim(cLine#) > "" then cPythonpath# = cPythonpath# + " " + cLine#.
      end.
      
      if length(cPythonpath#) > 0 then  
        sc_unix:SetEnvironmentValue("PYTHONPATH",cPythonpath#).
      
      finally:
        
        input stream str-os close.
        
        /* The first argument is to determine the event-type (0) to read the last pressed set keypress event.
         * last-event:set-lastkey is set back to the remembered keycode in iSaveLastkey# */
        last-event:set-lastkey(0, iSaveLastkey#).
        
      end finally.
          
    end. /* do */
    else
      undo, throw new c_panaedraexception(
        99984819,
        sc_lang:oEnglish,
        substitute("See: '&1'", "CallPythonpathSet is not supported on non UNIX operating systems.")
        ).
  
  end method. /* CallPythonpathSet */
  
  
  method public static logical IsUnix():
    
    return sc_environment:cOpSys = "unix". 
    
  end method. /* IsUnix */
  
  
  method public static void AutoRestartPrevention():
    
    /* Prevent an auto-restart of the OpenEdge ABL session when kill -s SIGEMT (kill -7) is used.
     * Call sc_environment:AutoRestartPrevention() in all panaedra environment boot procedures (appserver, tty, gui, etc etc). 
     */
    
    if bAutoRestartIsSet = false then 
    do:
      
      bAutoRestartIsSet = true.
    
      if session:proxy-password = "AutoRestartPrevention" then 
      do:
        quit.
      end.

      if sc_data:HasValue(session:proxy-password) or sc_data:HasValue(session:proxy-userid)  then 
      do:
        sc_showexception:ShowException(new c_panaedraexception(
          99982743,
          sc_lang:oEnglish,
          "The use of session:proxy-password or session:proxy-userid is not supported at this time, by the panaedra framework. Update the panaedra framework to use a different auto-restart-prevention variable.")).  
        quit.
      end.

      session:proxy-password = "AutoRestartPrevention". /* We misuse the session:proxy-password for this reason: we need a session-wide variable that is NOT reset during KILL -7 (SIGEMT) to prevent auto-restart of an ABL Session. */
      
    end. /* bAutoRestartIsSet = false */
    
  end method. /* AutoRestartPrevention */
  
end class.

/* EOF */
