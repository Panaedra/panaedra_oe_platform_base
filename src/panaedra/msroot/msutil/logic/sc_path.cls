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
  
      Description: Methods and properties voor common os paths and directories like
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
  
  def protected static temp-table ttPath no-undo rcode-info
    field cEnv      as char xml-node-type "attribute"
    field cHostname as char xml-node-type "attribute" /* First look for specific hostname, then default for OS, then default */
    field cToken    as char xml-node-type "attribute" /* Everything except for cIniDir, you have to start somewhere */
    field cPath     as char xml-node-type "attribute"
    index cEnv_cHostname_cToken is primary unique cEnv cHostname cToken
    .
  
  /* Properties */
  
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
      cLogDir     = FillPathProperty(sc_environment:cEnv, "cLogDir").
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
  
  /* _SRVR_ directory */
  define public static property c_SRVR_Dir as character no-undo 
    get():
      if not bTtPathInitialized then TtPathInitialize().
      return c_SRVR_Dir.
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
        cIniFile# = subst("&1_CLOUD__&2.ini", sc_path:cIniDir, sc_boot:SessionParameter("Env")).
        if search(cIniFile#) = ? then cIniFile# = subst("&1_CLOUD_.ini", sc_path:cIniDir).
        
        /* Read value from ini file */
        cNaarWebDir# = dynamic-function( "GetIniValue", cIniFile#, "Directories" , "NaarWebDir").

        if cNaarWebDir# = ? or cNaarWebDir# = "" then 
        do:
          undo, throw new Progress.Lang.AppError("INI parameters incorrect", 99990584).
        end.
        
        assign
          bNaarWebDirInitialized = true
          cNaarWebDir            = cSysteemDir + cNaarWebDir# + "/".
        
      end.
      
      return cNaarWebDir.
      
    end get.       /* cNaarWebDir */
    protected set. /* cNaarWebDir */
  
  
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
        if panaedra.msroot.msutil.logic.sc_boot:SessionParameter("Env") <> "live" then cIniDir = "/ota/_PRODUCT_/_FCMPNY_/ini/".
        else cIniDir = "/progress/_PRODUCT_/_FCMPNY_/ini/".
      &endif
      end.
    end.
    
  end method. /* IniInitialize */

  method protected static void TtPathInitialize():
    
    if not bTtPathInitialized then 
    do:
      bTtPathInitialized = yes.
      temp-table ttPath:read-xml("file", cIniDir + "sc_path.config", "empty", ?, false). /* Note: the getter of cIniDir initializes cIniDir automatically */
      cSysteemDir      = FillPathProperty(sc_environment:cEnv, "cSysteemDir").
      cLogDir          = FillPathProperty(sc_environment:cEnv, "cLogDir").
      cLogVoortgangDir = FillPathProperty(sc_environment:cEnv, "cLogVoortgangDir").
      cNoSweatDir      = FillPathProperty(sc_environment:cEnv, "cNoSweatDir").
      c_SRVR_Dir       = FillPathProperty(sc_environment:cEnv, "c_SRVR_Dir").
      c_SRVR_Dir      = FillPathProperty(sc_environment:cEnv, "c_SRVR_Dir").
    end.
    
  end method. /* TtPathInitialize */

  
  method public static character GetDir(cTokenIP# as character):
    
    /* Use to get your own paths from the config file,
       for items that have no dedicated property.
     */
    define variable cReturn# as character no-undo.
    
    if not bTtPathInitialized then TtPathInitialize(). 

    cReturn# = FillPathProperty(sc_environment:cEnv, cTokenIP#).
    
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

    return cReturn#.
    
  end method. /* Full2PartialPath */


  method public static character SplitGetFullFileName (cPathIP# as character):
    
    /* Pure string calculation.
       A string like "one/two/three.i" or "one\two\three.i" returns "three.i". 
     */
   
    if cPathIP# = ? then return "".
   
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

   
end class.

/* EOF */
