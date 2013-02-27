using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msas.logic.*.
using panaedra.msroot.msdeploy.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
{paninui/logic/includes/preproc_dotnetclasses.i &class=class}

class panaedra.msroot.msutil.logic.sc_environment:

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_environment.cls $ 
          Version: $Revision: 13 $ 
       Programmer: $Author: $
     Date Checkin: $Date: 2010-07-13 10:55:04+02:00 $ 
    Date Modified: $Modtime: 2010-07-13 10:51:58+02:00 $ 

      Description: Get session and environment information, like pid (process id).

  \*****************************  Include Files ********************************/
{panaedra/msroot/msutil/logic/ds/msenvironment_ds.i &class=class &protected=protected &static=static}

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
        cSessionParameterString = sc_string_substitute:ExpandOsEnv(if sc_boot:cBootSessionParameter > "" then sc_boot:cBootSessionParameter else session:parameter).
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
        cOsUserID = sc_string_substitute:ExpandOsEnv(if opsys = "unix" then "%LOGIN%" else "%USERNAME%").
      end.
      return cOsUserID.
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
 
    repeat on error undo, throw:
      import unformatted cLine#.
      if cLine# matches "*grep $$ " + cTempID# + "*" then
      do:
        /* Get the parent process id from the temporary shell/fork */
        cParent# = substring(cLine#,18,7).
        leave.
      end.
    end.
    
    &else
    
    /* ShouldHave: processid for win32 tty */
    
    &endif /* unix only */
   
    return integer(cParent#).

    &else /* win32 gui */
    
    return sc_msprocess_win32:GetProcessID().
    
    &endif
    
  end method. /* GetProcessID */


  method public static integer GetProcessMemSize():
    
    &if opsys = "unix" &then
    
    define variable iPID#    as integer   no-undo.
    define variable cLine#   as character no-undo.
    define variable iReturn# as integer   no-undo.
    
    iPID# = GetProcessID().
    
    input through value(subst("ps vx | grep &1", iPID#)).
    
    repeat on error undo, throw:
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
 
    repeat on error undo, throw:
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
 
    repeat on error undo, throw:
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
 
    repeat on error undo, throw:
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
      import stream str-in unformatted cLine#.
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
      
      import unformatted cLine#.
      
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
    import unformatted cIpAdres#.
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
      import unformatted cReturn#.
      input close.
      
      if length(cReturn#) > 42 then 
      do:
        cReturn# = substring(cReturn#, 42).
      end.
      
    end.  
    
    return cReturn#.
  
  end method. /* GetWorkstationDescription */
  
  
end class.

/* EOF */
