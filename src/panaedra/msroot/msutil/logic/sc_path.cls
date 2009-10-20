{panaedra/msi/logic/ctop_class.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msb.logic.*.

class panaedra.msf.logic.sc_path: 
  
  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msf/logic/sc_path.cls $ 
          Version: $Revision: 10 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-20 08:18:47+02:00 $ 
    Date Modified: $Modtime: 2009-10-19 15:19:27+02:00 $ 
  
      Description: Method om o.a. cIniDir en cSystemDir voor huidige sessie op te vragen.
      
                   Gebruikt voor cIniDir hard coded paths omdat anders kip-ei problemen
                   ontstaan.
                   
  \*****************************  Include Files ********************************/
  
  /************************  Source control constructor ************************/
  constructor public sc_path(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, "$Revision: 10 $", "{&sourcecontrolversions}").
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/  
  
  define protected static variable bIniInitialized    as logical                       no-undo.
  define protected static variable bTtPathInitialized as logical                       no-undo.
  define protected static variable bPropathDirty      as logical                       no-undo init true.
  define protected static variable cPropathFull       as character                     no-undo.
  define protected static variable oPathHelper        as panaedra.msf.logic.c_path_helper no-undo.
  
  def protected static temp-table ttPath no-undo rcode-info
    field cEnv      as char xml-node-type "attribute"
    field cHostname as char xml-node-type "attribute" /* We zoeken eerst naar specifieke hostname, daarna naar blanco hostname */
    field cToken    as char xml-node-type "attribute" /* Alle pad identifiers behalve cIniDir, anders kip-ei probleem */
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
  
  
  /* systeem directory */
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
      cLogDir     = FillPathProperty("cLogDir").
      return cLogDir.
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
  
  
  /* ---Methods--- */
  method protected static void IniInitialize():
    
    if not bIniInitialized then 
    do:
      bIniInitialized = yes.
      &if opsys = "win32" &then
      if panaedra.msb.logic.sc_boot:SessionParameter("Env") <> "live" then cIniDir = "Q:/test/ini/".
      else cIniDir = "P:/live/ini/".
      &else
      if panaedra.msb.logic.sc_boot:SessionParameter("Env") <> "live" then cIniDir = "/ota/_PRODUCT_/_FCMPNY_/ini/".
      else cIniDir = "/progress/_PRODUCT_/_FCMPNY_/ini/".
      &endif
    end.
    
  end method. /* IniInitialize */

  method protected static void TtPathInitialize():
    
    if not bTtPathInitialized then 
    do:
      bTtPathInitialized = yes.
      temp-table ttPath:read-xml("file", cIniDir + "sc-path.config", "empty", ?, false). /* Note: the getter of cIniDir initializes cIniDir automatically */
      cSysteemDir = FillPathProperty("cSysteemDir").
      cLogDir     = FillPathProperty("cLogDir").
      cNoSweatDir = FillPathProperty("cNoSweatDir").
      c_SRVR_Dir  = FillPathProperty("c_SRVR_Dir").
      c_SRVR_Dir = FillPathProperty("c_SRVR_Dir").
    end.
    
  end method. /* TtPathInitialize */

  
  method public static character GetDir(cTokenIP# as character):
    
    /* Te gebruiken om paden uit de config file op te vragen,
       waar geen property voor is gedefinieerd.
     */
    define variable cReturn# as character no-undo.
    
    if not bTtPathInitialized then TtPathInitialize(). 

    cReturn# = FillPathProperty(cTokenIP#).
    
    return cReturn#.
    
  end method. /* GetDir */
  
  
  method protected static character FillPathProperty(cTokenIP# as character):

    define variable cEnv#          as character no-undo.
    define variable cHostName#     as character no-undo.
    define variable cDefaultOpsys# as character no-undo.
    define variable iEclipseFix#   as integer   no-undo.
    define buffer b-ttPath for ttPath.
    
    cEnv#          = panaedra.msb.logic.sc_boot:SessionParameter("Env").
    cHostName#     = panaedra.msb.logic.sc_environment:GetHostName().
    cDefaultOpsys# = subst("default_&1",opsys).
    
    find first b-ttPath 
      where b-ttPath.cEnv      = cEnv# 
      and   b-ttPath.cToken    = cTokenIP#
      and   b-ttPath.cHostname = cHostName#
      no-error.
       
    if not avail b-ttPath then find first b-ttPath 
        where b-ttPath.cEnv      = cEnv# 
        and   b-ttPath.cToken    = cTokenIP#
        and   b-ttPath.cHostname = cDefaultOpsys#
        no-error.
    
    if not avail b-ttPath then find first b-ttPath 
        where b-ttPath.cEnv      = cEnv# 
        and   b-ttPath.cToken    = cTokenIP#
        and   b-ttPath.cHostname = "default"
        no-error.
      
    return if avail b-ttPath then b-ttPath.cPath else cWorkDir.
    
  end method. /* FillPathProperty */

  
  method public static void SetPropathDirty ():
    /*------------------------------------------------------------------------------
      Purpose:     Indien het propath is gewijzigd, moet de cache worden herbouwd.
                   Roep daarvoor deze procedure aan.
    ------------------------------------------------------------------------------*/
  
    bPropathDirty = true.

  end method. /* SetPropathDirty */
  

  method public static character Full2PartialPath (nfullpath# as character):
    
    /*------------------------------------------------------------------------------
      Purpose:  Translate a full path to a file to a partial path with subdirectories
                in the PROPATH
    ------------------------------------------------------------------------------*/

    define variable nretu#     as character no-undo.
    define variable nretutemp# as character no-undo.
    define variable atell#     as integer   no-undo.
    define variable nentr#     as character no-undo.
    define variable lfullpath# as logical   no-undo.
    
    nfullpath# = lc(trim(replace(nfullpath#,"~\","~/"))).
    
    if oPathHelper = ? then oPathHelper = new panaedra.msf.logic.c_path_helper().

    /* Is het wel een full path? */
    if opsys = "win32" then
      lfullpath# = (nfullpath# begins "~/~/" or index(nfullpath#,":") > 0).
    else
      lfullpath# = (nfullpath# begins "~/").

    if not lfullpath# then 
    do:
      if nfullpath# begins ".~/" then
        nfullpath# = substring(nfullpath#,3).
      return nfullpath#.
    end.

    if bPropathDirty then 
    do:
      cPropathFull = "".

      do atell# = 1 to num-entries(propath):

        file-info:file-name = entry(atell#,propath).

        nentr# = lc(replace(file-info:full-pathname,"~\","~/")).

        if nentr# > "" then 
        do:
          cPropathFull = cPropathFull + "," + nentr#.
        end.

      end.

      cPropathFull = substring(cPropathFull,2).

      bPropathDirty = false.

    end.

    do atell# = 1 to num-entries(cPropathFull):

      nentr#     = entry(atell#,cPropathFull).
      nretutemp# = "".

      if nfullpath# begins nentr# then 
      do:

        nretutemp# = substring(nfullpath#,length(nentr#) + 2).

        if nentr# matches "*~~.pl":u then
          nretutemp# = trim(nretutemp#,"<>":u).

        if nretu# = "" or (length(nretu#) > length(nretutemp#)) then
          nretu# = nretutemp#.

      end.

    end.

    if nretu# = "" then 
    do:

      if library(nfullpath#) <> ? then 
      do:
        nretu# = member(nretu#).
        if nretu# = "" or nretu# = ? 
          then nretu# = nfullpath#.
      end.

    end.

    return nretu#.
    
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
       A string like "panaedra/msf/logic/sc_path.cls" returns "panaedra.msf.logic.sc_path". 
       A string like "panaedra/msf/logic/sc_path.r"   returns "panaedra.msf.logic.sc_path". 
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
