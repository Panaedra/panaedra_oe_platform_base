{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_path: 
  
  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_path.cls $ 
          Version: $Revision: 22 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-08-10 12:23:28+02:00 $ 
    Date Modified: $Modtime: 2010-08-10 12:20:49+02:00 $ 
  
      Description: Methods and properties for common os paths and directories like
                   cIniDir en cSystemDir.
      
                   For path cIniDir hard coded paths are used, to avoid chicken/egg
                   problems.
                   
  \*****************************  Include Files ********************************/
  
  /************************  Source control constructor ************************/
  constructor public sc_path(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, "$Revision: 22 $", "{&sourcecontrolversions}").
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/  
  
  define protected static variable bIniInitialized    as logical                                 no-undo.
  define protected static variable bLocalInitialized  as logical                                 no-undo.
  define protected static variable bTtPathInitialized as logical                                 no-undo.
  define protected static variable bPropathDirty      as logical                                 no-undo init true.
  define protected static variable cPropathFull       as character                               no-undo.
  define protected static variable oPathHelper        as panaedra.msroot.msutil.logic.c_path_helper no-undo.
  
  define protected static temp-table ttPath no-undo rcode-info
    field cEnv      as char xml-node-type "attribute"
    field cHostname as char xml-node-type "attribute" /* First look for specific hostname, then default for OS, then default */
    field cToken    as char xml-node-type "attribute" /* Everything except for cIniDir, you have to start somewhere */
    field cPath     as char xml-node-type "attribute"
    index cEnv_cHostname_cToken is primary unique cEnv cHostname cToken
    .
  
  /* Properties */
  define public static property cSlash as character no-undo
    &if opsys = "unix" &then
    initial "/"
    &else
    initial "~\"
    &endif 
    get. 
  
  /* Work directory */
  define public static property cWorkDir as character no-undo 
    get():
      if cWorkDir = "" then 
      do:
        file-info:file-name = ".".
        cWorkDir = file-info:full-pathname.
        cWorkDir = replace(cWorkDir,"~\","/").
        if substring(cWorkDir,length(cWorkDir)) <> "/"
          then cWorkDir = cWorkDir + "/".
      end.
      return cWorkDir.
    end get.
    protected set.
  
  
  /* Temporary directory */
  define public static property cTempDir as character no-undo 
    get():
      if cTempDir = "" then 
      do:
        cTempDir = session:temp-dir.
        cTempDir = replace(cTempDir,"~\","/").
        if substring(cTempDir,length(cTempDir)) <> "/"
          then cTempDir = cTempDir + "/".
      end.
      return cTempDir.
    end get.
    protected set.
  
  
  /* Ini directory */
  define public static property cIniDir as character no-undo 
    get():
      if not bIniInitialized then 
        IniInitialize().
      return cIniDir.
    end get.
    protected set.
  
  
  /* Local ini directory */
  define public static property cLocalIniDir as character no-undo 
    get():
      if not bIniInitialized then 
        IniInitialize().
      if not bLocalInitialized then 
      do:
        bLocalInitialized = true.
        cLocalIniDir = cWorkDir + "ini_local/".
        file-info:file-name = cLocalIniDir. 
        if file-info:full-pathname = ? then 
        do:
          os-create-dir value(cLocalIniDir).
          if os-error > 0 then undo, throw new Progress.Lang.AppError(subst("Directory &1 could not be created.", cLocalIniDir),99950019).
          CorrectDirRights(cLocalIniDir).
        end.
      end.
      return cLocalIniDir.
    end get.
    protected set.
  
  
  /* "Systeem" directory */
  define public static property cSysteemDir as character no-undo 
    get():
      if not bTtPathInitialized then 
        TtPathInitialize().
      return cSysteemDir.
    end get.
    protected set.
  
  
  /* Log directory */
  define public static property cLogDir as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      return cLogDir.
    end get.
    protected set.
  
  /* Log directory */
  define public static property cLogDirDbg as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      cLogDir     = FillPathProperty(GetScPathEnv(), "cLogDir").
      return cLogDir.
    end get.
    protected set.
  
  /* Voorgang log directory */
  define public static property cLogVoortgangDir as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      return cLogVoortgangDir.
    end get.
    protected set.

  /* _SRVR_ directory */
  define public static property cNoSweatDir as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      return cNoSweatDir.
    end get.
    protected set.
  
  /* _SRVR_ directory */
  define public static property c_SRVR_Dir as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      return c_SRVR_Dir.
    end get.
    protected set.
  
  /* Nonstatic directory */
  define public static property cNonstaticDir as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      return cNonstaticDir.
    end get.
    protected set.
  
  /* Deploy binaries directory */
  define public static property cDeployBinariesDir as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      return cDeployBinariesDir.
    end get.
    protected set.
  
  /* Deploy client target root directory */
  define public static property cDeployTargetRootDir as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      return cDeployTargetRootDir.
    end get.
    protected set.
  
  /* VanWan directory */
  define public static property cVanWanDir as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      return cVanWanDir.
    end get.
    protected set.
  
  /* NaarWan directory */
  define public static property cNaarWanDir as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      return cNaarWanDir.
    end get.
    protected set.
  
  define protected static variable bNaarWebDirInitialized as logical no-undo.
  
  /* Systeem naarweb directory */
  define public static property cNaarWebDir as character no-undo 
    get():
      
      define variable cIniFile#    as character no-undo.
      define variable cNaarWebDir# as character no-undo.
      
      if not bNaarWebDirInitialized then 
      do:
        
        if not bTtPathInitialized then TtPathInitialize(). /* for cSysteemDir */
        
        /* First look for [Env]ironment specific ini file, otherwise just use _CLOUD_.ini */
        cIniFile# = subst("&1_CLOUD__&2_&3.ini", sc_path:cIniDir, sc_boot:SessionParameter("Env"), sc_boot:SessionParameter("Layer")).
        if search(cIniFile#) = ? then cIniFile# = subst("&1_CLOUD__&2.ini", sc_path:cIniDir, sc_boot:SessionParameter("Env")).
        if search(cIniFile#) = ? then cIniFile# = subst("&1_CLOUD_.ini", sc_path:cIniDir).
        
        
        /* Read value from ini file */
        cNaarWebDir# = sc_osfile:GetIniValue(cIniFile#, "Directories" , "NaarWebDir").

        if cNaarWebDir# = ? or cNaarWebDir# = "" then 
        do:
          undo, throw new Progress.Lang.AppError(subst("&1 INI parameters incorrect", cIniFile#), 99990584).
        end.
        
        assign
          bNaarWebDirInitialized = true
          cNaarWebDir            = cSysteemDir + cNaarWebDir# + "/".
        
      end.
      
      return cNaarWebDir.
      
    end get.       /* cNaarWebDir */
    protected set. /* cNaarWebDir */
  
  /* DataRecovery directory */
  define public static property cDataRecoveryDir as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      return cDataRecoveryDir.
    end get.
    protected set.
  
  /* DataExchange directory */
  define public static property cDataExchangeDir as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      return cDataExchangeDir.
    end get.
    protected set.
  
  /* _TERM_UNDISCLOSED_queue directory */
  define public static property c_TERM_UNDISCLOSED_queueDir as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      return c_TERM_UNDISCLOSED_queueDir.
    end get.
    protected set.
  
  /* Assembly directory */
  define public static property cAssemblyDir as character no-undo init ?
    get():
      define variable cParams#     as character no-undo.
      define variable cAssemblies# as character no-undo.
      define variable iTell#       as integer   no-undo.
      define variable cEntry#      as character no-undo.
      if cAssemblyDir = ? then 
      do:
        cParams# = session:startup-parameters.
        b_param:
        do iTell# = 1 to num-entries(cParams#):
          cEntry# = trim(entry(iTell#, cParams#)).
          if cEntry# begins "-assemblies" then
          do:
            assign
              cAssemblies#              = cEntry#
              entry(1,cAssemblies#," ") = ""
              cAssemblies#              = trim(cAssemblies#) 
              cAssemblies#              = right-trim(replace(cAssemblies#,"~\","/"),"/") + "/". 
            leave b_param.
          end.
        end.
        if cAssemblies# > "" 
          then 
        do:
          if length(cAssemblies#) > 2 
            and substring(cAssemblies#,2,1) <> ":"
            and index(cAssemblies#,"~\~\") = 0
            then /* Relative path */
            cAssemblyDir = cWorkDir + cAssemblies#.
          else
            cAssemblyDir = cAssemblies#.
        end.
        else
          cAssemblyDir = cWorkDir.
      end.
      return cAssemblyDir.
    end get.
    protected set.

  /* Xobj directory, for rcode extra's like resx and png files. 
     Also in Xobj dir: 
      - assemblies_dyn.[x]config (if not in Xobj dir: assembly dir is used)
      - datarel_xml files
      - dynamically loaded dotnet dll's (paninui ui frames). 
  */
  define public static property cXobjDir as character no-undo init "|init|" 
    get():
      if cXobjDir = "|init|" then 
      do:
        cXobjDir = sc_boot:SessionParameter("Xobj").
        cXobjDir = replace(cXobjDir,"~\","/").
        if substring(cXobjDir,length(cXobjDir)) <> "/" then cXobjDir = cXobjDir + "/".
      end.
      return cXobjDir.
    end get.
    protected set.

  /* Xcfg directory, seperate dir for deploy_version.xconfig 
    (because it's a seperate deploy package). 
  */
  define public static property cXcfgDir as character no-undo init "|init|" 
    get():
      if cXcfgDir = "|init|" then 
      do:
        cXcfgDir = sc_boot:SessionParameter("Xcfg").
        cXcfgDir = replace(cXcfgDir,"~\","/").
        if substring(cXcfgDir,length(cXcfgDir)) <> "/" then cXcfgDir = cXcfgDir + "/".
      end.
      return cXcfgDir.
    end get.
    protected set.

  /* ---Methods--- */
  
  method protected static void IniInitialize():
    
    if not bIniInitialized then 
    do:
      bIniInitialized = yes.
      if sc_boot:SessionParameter("SharedIniDir") > "" then 
      do:
        cIniDir = sc_boot:SessionParameter("SharedIniDir").
        cIniDir = replace(cIniDir,"~\","/").
        if substring(cIniDir,length(cIniDir)) <> "/" then cIniDir = cIniDir + "/".
      end.
      else 
      do:
      &if opsys = "win32" &then
        if sc_boot:SessionParameter("Env") <> "live" then cIniDir = "Q:/test/ini/".
        else cIniDir = "P:/live/ini/".
      &else
        if panaedra.msroot.msutil.logic.sc_boot:SessionParameter("Env") <> "live" then cIniDir = "/ota/_PRODUCT_/_FCMPNY_/ini/". /* codeQok#7110 */
        else cIniDir = "/progress/_PRODUCT_/_FCMPNY_/ini/".                                                                   /* codeQok#7110 */
      &endif
      end.
    end.
    
  end method. /* IniInitialize */
  

  method protected static void TtPathInitialize():
    
    if not bTtPathInitialized then 
    do:
      bTtPathInitialized = yes.
      sc_config:ReadXml(temp-table ttPath:handle,
        /* Note: the getter of cIniDir initializes cIniDir automatically */ 
        cIniDir + "sc_path" + (if sc_environment:bLiveEnv then "_live" else "_nonlive") + ".config").
      cSysteemDir          = FillPathProperty(GetScPathEnv(), "cSysteemDir").
      cLogDir              = FillPathProperty(GetScPathEnv(), "cLogDir").
      cLogVoortgangDir     = FillPathProperty(GetScPathEnv(), "cLogVoortgangDir").
      cNoSweatDir          = FillPathProperty(GetScPathEnv(), "cNoSweatDir").
      c_SRVR_Dir          = FillPathProperty(GetScPathEnv(), "c_SRVR_Dir").
      cNonstaticDir        = FillPathProperty(GetScPathEnv(), "cNonstaticDir").
      cDeployBinariesDir   = FillPathProperty(GetScPathEnv(), "cDeployBinariesDir").
      cDeployTargetRootDir = FillPathProperty(GetScPathEnv(), "cDeployTargetRootDir").
      cDataRecoveryDir     = FillPathProperty(GetScPathEnv(), "cDataRecoveryDir").
      cDataExchangeDir     = FillPathProperty(GetScPathEnv(), "cDataExchangeDir").
      cVanWanDir           = FillPathProperty(GetScPathEnv(), "cVanWanDir").
      cNaarWanDir          = FillPathProperty(GetScPathEnv(), "cNaarWanDir").
      c_TERM_UNDISCLOSED_queueDir  = FillPathProperty(GetScPathEnv(), "c_TERM_UNDISCLOSED_queueDir").
    end.
    
  end method. /* TtPathInitialize */

  
  method public static character GetDir(cTokenIP# as character):
    
    /* Use to get your own paths from the config file,
       for items that have no dedicated property.
     */
    define variable cReturn# as character no-undo.
    
    if not bTtPathInitialized then TtPathInitialize(). 

    cReturn# = FillPathProperty(GetScPathEnv(), cTokenIP#).
    
    return cReturn#.
    
  end method. /* GetDir */
  
  
  method public static character GetDirOfOtherEnv(cEnvIP# as character, cTokenIP# as character):
    
    /* Use to get paths from the config file,
       for any environment.
     */
    define variable cReturn# as character no-undo.
    
    if not bTtPathInitialized then TtPathInitialize(). 

    cReturn# = FillPathProperty(cEnvIP#, cTokenIP#).
    
    return cReturn#.
    
  end method. /* GetDir */
  
  
  method protected static character FillPathProperty(cEnvIP# as character, cTokenIP# as character):

    define variable cHostName#     as character no-undo.
    define variable cDefaultOpsys# as character no-undo.
    define variable iEclipseFix#   as integer   no-undo.
    define buffer b-ttPath for ttPath.
    
    cHostName#     = panaedra.msroot.msutil.logic.sc_environment:GetHostName().
    cDefaultOpsys# = subst("default_&1",opsys).
    
    find first b-ttPath 
      where b-ttPath.cEnv      = cEnvIP# 
      and   b-ttPath.cToken    = cTokenIP#
      and   b-ttPath.cHostname = cHostName#
      no-error.
       
    if not avail b-ttPath then find first b-ttPath 
        where b-ttPath.cEnv      = cEnvIP# 
        and   b-ttPath.cToken    = cTokenIP#
        and   b-ttPath.cHostname = cDefaultOpsys#
        no-error.
    
    if not avail b-ttPath then find first b-ttPath 
        where b-ttPath.cEnv      = cEnvIP# 
        and   b-ttPath.cToken    = cTokenIP#
        and   b-ttPath.cHostname = "default"
        no-error.
      
    return if avail b-ttPath then b-ttPath.cPath else cWorkDir.
    
  end method. /* FillPathProperty */


  method public static void CreateDirOrSubdir(cPathIP# as character):
    
    /* Create a directory or subdirectory, create the whole path if it doesn't exist */
    
    define variable iTell#       as integer   no-undo.
    define variable iTellBreak#  as integer   no-undo.
    define variable iNumEntries# as integer   no-undo.
    define variable cPathNow#    as character no-undo.
    
    assign
      cPathIP#     = replace(cPathIP#, "~\", "/")
      cPathIP#     = (if substring(cPathIP#,length(cPathIP#)) = "/" then substring(cPathIP#, 1, length(cPathIP#) - 1) else cPathIP#)
      cPathNow#    = cPathIP#
      iNumEntries# = num-entries(cPathNow#,"/").
    
    /* First check which part of the path already exists */
    b_checkpathexists:
    do iTell# = iNumEntries# to 1 by -1:
      file-information:file-name = cPathNow#.
      if file-information:full-pathname <> ? then 
      do:
        iTellBreak# = iTell#.
        leave b_checkpathexists.
      end. 
      assign
        entry(iTell#,cPathNow#,"/") = ""
        cPathNow#                   = right-trim(cPathNow#,"/").
    end.
    
    /* Note: if iTellBreak# = iNumEntries#, then the directory 
             already existed and this do block isn't entered 
    */
    do iTell# = iTellBreak# + 1 to iNumEntries#:
      cPathNow# = cPathNow# + "/" + entry(iTell#, cPathIP#, "/").
      os-create-dir value(cPathNow#).
      if os-error > 0 then undo, throw new Progress.Lang.AppError(substitute("Path '&1' could not be created for requested path '&2'", cPathNow#, cPathIP#),99951994).
      CorrectDirRights(cPathNow#).
    end.
        
  end method. /* CreateDirOrSubdir */


  method public static void CorrectDirRights(cDirIP# as character):
    
    /* Adjust directory rights on unix.
       Group and mask is hardcoded for now.
     */
    
    &if opsys = "unix" &then
      
    os-command silent value(subst("chgrp dlc_user '&1'", cDirIP#)).
    os-command silent value(subst("chmod ug+rwx '&1'",   cDirIP#)).
      
    &endif

  end method. /* CorrectDirRights */

  
  method public static void SetPropathDirty ():
    /*------------------------------------------------------------------------------
      Purpose:     If the propath is changed, the cache needs to be reset.
                   Call this method when that happens.
    ------------------------------------------------------------------------------*/
  
    bPropathDirty = true.

  end method. /* SetPropathDirty */
  

  method public static character Full2PartialPath (cFullPathIP# as character):
    
    return Full2PartialPath(cFullPathIP#, false).
    
  end method. /* Full2PartialPath ; simple overload */
  

  method public static character Full2PartialPath(cFullPathIP# as character, bReturnFullPathWhenFailedIP# as logical):
    
    /*------------------------------------------------------------------------------
      Purpose:  Translate a full file path to a partial path with subdirectories
                relative to (an entry in) the propath.
                PL libraries are supported.
    ------------------------------------------------------------------------------*/

    define variable cReturn#     as character no-undo.
    define variable cReturnTemp# as character no-undo.
    define variable iTell#       as integer   no-undo.
    define variable cEntry#      as character no-undo.
    define variable cFullPath#   as logical   no-undo.
    
    cFullPathIP# = lc(trim(replace(cFullPathIP#,"~\","~/"))).
    
    if oPathHelper = ? then oPathHelper = new panaedra.msroot.msutil.logic.c_path_helper().

    /* Is it really a full path? */
    if opsys = "win32" then
      cFullPath# = (cFullPathIP# begins "~/~/" or index(cFullPathIP#,":") > 0).
    else
      cFullPath# = (cFullPathIP# begins "~/").

    if not cFullPath# then 
    do:
      if cFullPathIP# begins ".~/" then
        cFullPathIP# = substring(cFullPathIP#,3).
      return cFullPathIP#.
    end.

    if bPropathDirty then 
    do:
      cPropathFull = "".

      do iTell# = 1 to num-entries(propath):

        file-info:file-name = entry(iTell#,propath).

        cEntry# = lc(replace(file-info:full-pathname,"~\","~/")).

        if cEntry# > "" then 
        do:
          cPropathFull = cPropathFull + "," + cEntry#.
        end.

      end.

      cPropathFull = substring(cPropathFull,2).

      bPropathDirty = false.

    end.

    do iTell# = 1 to num-entries(cPropathFull):

      cEntry#     = entry(iTell#,cPropathFull).
      cReturnTemp# = "".

      if cFullPathIP# begins cEntry# then 
      do:

        cReturnTemp# = substring(cFullPathIP#,length(cEntry#) + 2).

        if cEntry# matches "*~~.pl":u then
          cReturnTemp# = trim(cReturnTemp#,"<>":u).

        if cReturn# = "" or (length(cReturn#) > length(cReturnTemp#)) then
          cReturn# = cReturnTemp#.

      end.

    end.

    if cReturn# = "" then 
    do:

      if library(cFullPathIP#) <> ? then 
      do:
        cReturn# = member(cReturn#).
        if cReturn# = "" or cReturn# = ? 
          then cReturn# = cFullPathIP#.
      end.

    end.
    
    if bReturnFullPathWhenFailedIP# and (cReturn# = ? or cReturn# = "") 
      then cReturn# = cFullPathIP#.
    
    return cReturn#.
    
  end method. /* Full2PartialPath */


  method public static character SplitGetFullFileName (cPathIP# as character):
    
    /* Pure string calculation.
       A string like "one/two/three.i" or "one\two\three.i" returns "three.i". 
     */
   
    if cPathIP# = ? or 
      cPathIP# = "" then 
      return "".
   
    cPathIP# = replace(cPathIP#,"~\","/").
   
    return entry(num-entries(cPathIP#,"/"),cPathIP#,"/").

  end method. /* SplitGetFullFileName */  


  method public static character SplitGetFileName (cPathIP# as character):
    
    /* Pure string calculation.
       A string like "one/two/three.i" or "one\two\three.i" returns "three". 
     */
     
    define variable iIndex# as integer no-undo.
   
    cPathIP# = SplitGetFullFileName(cPathIP#).
   
    iIndex# = r-index(cPathIP#,".").
    if iIndex# = 0 then return cPathIP#.
    else return substring(cPathIP#,1,iIndex# - 1).

  end method. /* SplitGetFileName */  


  method public static character SplitGetFileDir(cPathIP# as character):
    
    /* Pure string calculation.
       A string like "one/two/three.i" or "one\two\three.i" returns "one/two/". 
     */
     
    define variable iIndex# as integer no-undo.
     
    cPathIP# = replace(cPathIP#,"~\","/").

    iIndex# = r-index(cPathIP#,"/").
    if iIndex# = 0 then return "".
    else return substring(cPathIP#,1,iIndex#).

  end method. /* SplitGetFileDir */  


  method public static character SplitGetFileExt (cPathIP# as character):
    
    /* Pure string calculation.
       A string like "one/two/three.i" or "one\two\three.i" returns "i". 
     */

    define variable iIndex# as integer no-undo.
   
    cPathIP# = SplitGetFullFileName(cPathIP#).
   
    iIndex# = r-index(cPathIP#,".").
    if iIndex# = 0 then return "".
    else return substring(cPathIP#,iIndex# + 1).

  end method. /* SplitGetFileExt */  

   
  method public static character SplitGetClassName (cPathIP# as character):
    
    /* Pure string calculation.
       Get full class name.
       A string like "panaedra/msf/logic/sc_path.cls" returns "panaedra.msroot.msutil.logic.sc_path". 
       A string like "panaedra/msf/logic/sc_path.r"   returns "panaedra.msroot.msutil.logic.sc_path". 
     */
    
    cPathIP# = replace(cPathIP#, "/", ".").
    cPathIP# = replace(cPathIP#, "~\", ".").
    
    if cPathIP# matches "*~~.r*"
      or cPathIP# matches "*~~.cls*" then
      cPathIP# = substring(cPathIP#, 1, r-index(cPathIP#, ".") - 1).
    
    return cPathIP#.

  end method. /* SplitGetClassName */
  

  method public static character SplitPutTag(
    
    /* Pure string calculation.
       Puts a tag in the file path, before the extention.
       A string like "panaedra/msf/logic/somefile.log" , "_tag" returns "panaedra/msf/logic/somefile_tag.log". 
     */
     
    cPathIP# as character, 
    cTagIP#  as character): 
    
    define variable cExt# as character no-undo.
     
    if cPathIP# > "" and cTagIP# > "" then 
    do:
      cExt# = SplitGetFileExt(cPathIP#).
      cExt# = if cExt# > "" then "." + cExt# else "".
      return
        SplitGetFileDir(cPathIP#) + 
        SplitGetFileName(cPathIP#) + 
        cTagIP# + 
        cExt#.
    end.
    else 
      return cPathIP#.

  end method. /* SplitPutTag */
  
  
  method public static void DelTree(cDirIP# as character):
    
    sc_osfile:DeleteAllFilesInDir(cDirIP#,"*",true).
    
    os-delete value(cDirIP#). 
    if os-error > 0 then 
    do:
      if opsys = "win32" then
        os-command silent value(subst('rmdir /Q /S "&1"', cDirIP#)).
    end.
    
  end method. /* DelTree */
  
  
  method protected static character GetScPathEnv():
    
    define variable cReturn# as character no-undo.
    
    cReturn# = sc_environment:cEnv.
    
    case cReturn#:
      when "any_env"     then 
        cReturn# = "live".
      when "tst_any_env" then 
        cReturn# = "tst".
    end case.
    
    return cReturn#.
    
  end method. /* GetScPathEnv */
  
  method public static void ReplacePathTokens(
  
    /* Replace "[:cSomeDir:]" with the value returned by the corresponding sc_path property  */
  
    input-output cPathStringIOP# as character):

    if index(cPathStringIOP#,"[:cSysteemDir:]"      ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cSysteemDir:]"      ,sc_path:cSysteemDir      ).
    if index(cPathStringIOP#,"[:c_SRVR_Dir:]"      ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:c_SRVR_Dir:]"      ,sc_path:c_SRVR_Dir      ).
    if index(cPathStringIOP#,"[:cDataExchangeDir:]" ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cDataExchangeDir:]" ,sc_path:cDataExchangeDir ).
    if index(cPathStringIOP#,"[:cDataRecoveryDir:]" ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cDataRecoveryDir:]" ,sc_path:cDataRecoveryDir ).
    if index(cPathStringIOP#,"[:cIniDir:]"          ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cIniDir:]"          ,sc_path:cIniDir          ).
    if index(cPathStringIOP#,"[:cLocalIniDir:]"     ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cLocalIniDir:]"     ,sc_path:cLocalIniDir     ).
    if index(cPathStringIOP#,"[:cLogDir:]"          ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cLogDir:]"          ,sc_path:cLogDir          ).
    if index(cPathStringIOP#,"[:cLogVoortgangDir:]" ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cLogVoortgangDir:]" ,sc_path:cLogVoortgangDir ).
    if index(cPathStringIOP#,"[:cNaarWanDir:]"      ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cNaarWanDir:]"      ,sc_path:cNaarWanDir      ).
    if index(cPathStringIOP#,"[:cNaarWebDir:]"      ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cNaarWebDir:]"      ,sc_path:cNaarWebDir      ).
    if index(cPathStringIOP#,"[:cNonstaticDir:]"    ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cNonstaticDir:]"    ,sc_path:cNonstaticDir    ).
    if index(cPathStringIOP#,"[:cNoSweatDir:]"      ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cNoSweatDir:]"      ,sc_path:cNoSweatDir      ).
    if index(cPathStringIOP#,"[:cTempDir:]"         ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cTempDir:]"         ,sc_path:cTempDir         ).
    if index(cPathStringIOP#,"[:cVanWanDir:]"       ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cVanWanDir:]"       ,sc_path:cVanWanDir       ).
    if index(cPathStringIOP#,"[:cWorkDir:]"         ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:cWorkDir:]"         ,sc_path:cWorkDir         ).
    if index(cPathStringIOP#,"[:bLiveEnv:]"         ) > 0 then cPathStringIOP# = replace(cPathStringIOP#,"[:bLiveEnv:]"         ,if sc_environment:bLiveEnv then "live" else "nonlive").

  end method. /* ReplacePathTokens */
  
  
  method public static character StandardIniFilePath(
  
    /* Supply a string like "myfile.ini", and:
       1) the ini dir is prepended
       2) the "_live" / "_nonlive" tag is inserted before last dot.
       
       If you need more flexibility, do something like:
       sc_path:ReplacePathTokens("[:cIniDir:]myfile_[:bLiveEnv:].ini"). 
       This precise input is actually the same as StandardIniFilePath does.
          
    */
    
    cIniFileIP# as character 
    ):
    
    define variable iIndex# as integer no-undo.
    
    iIndex# = r-index(cIniFileIP#,".").
    
    if iIndex# = 0 or index(replace(cIniFileIP#,"~\","/"),"/") > 0 then
      undo, throw new c_panaedraexception(
        99948922,
        sc_lang:oEnglish,
        substitute("Ini file '&1' has no valid name", cIniFileIP#)
        ).
    
    return sc_path:cIniDir + substring(cIniFileIP#,1,iIndex# - 1) + (if sc_environment:bLiveEnv then "_live" else "_nonlive") + substring(cIniFileIP#,iIndex#).     
  
  end method. /* StandardIniFilePath */
  

  method public static character StandardIniDynFilePath(
  
    /* Supply a string like "myfile.dynamic.ini", and:
       1) the ini dir is prepended
       2) Only in a *non-live* environment: a "_[:cEnv:]" tag is inserted before ".dynamic.ini".
       
       If you need more flexibility, do something like:
       sc_path:ReplacePathTokens("[:cIniDir:]myfile_[:cEnv:].dynamic.ini").
       Watch out: 
       This precise input is a little bit different than the output from 
       this method; 'live' tags are empty in the return value of this method.
          
    */
    
    cIniFileIP# as character 
    ):
    
    define variable iIndex# as integer no-undo.
    
    iIndex# = r-index(cIniFileIP#,".").
    iIndex# = r-index(cIniFileIP#,".",iIndex# - 1) no-error.
    
    if iIndex# = ? or iIndex# = 0 or index(replace(cIniFileIP#,"~\","/"),"/") > 0 then
      undo, throw new c_panaedraexception(
        99948923,
        sc_lang:oEnglish,
        substitute("Ini (dynamic!) file '&1' has no valid name", cIniFileIP#)
        ).
    
    return sc_path:cIniDir + substring(cIniFileIP#,1,iIndex# - 1) + (if sc_environment:bLiveEnv then "" else subst("_&1", lc(sc_environment:cEnv))) + substring(cIniFileIP#,iIndex#).     
  
  end method. /* StandardIniDynFilePath */


  method public static logical PathExists(
    
    /* Check if a path exists */
    
    input cPathnameIP# as character):
    
    file-info:file-name = cPathnameIP#.
    
    return 
      (file-info:full-pathname <> ?) and 
      (file-info:file-type matches "*D*").
        
  end method. /* PathExists */

end class.

/* EOF */
