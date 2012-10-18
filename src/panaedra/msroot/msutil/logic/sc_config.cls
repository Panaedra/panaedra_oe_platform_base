using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_config: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Read or write config files. Support for encryption.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_config(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static temp-table ttConfigFileName no-undo
    field cConfigFileName as character
    field cFullpath       as character
    field bUseXconfig     as logical
    index cConfigFileName cConfigFileName.
  

  define protected static property rawConfigKey as raw no-undo
  
    /* We provide a hard-coded key for encryption and decryption of config files. 
       It shouldn't be a security issue, since server-side authentication with
       client-principal and ssl is used.
       We encrypt config files to avoid tampering, but the contents should never
       be "atomic-bomb-launch-code-style" security sensitive. 
    */
    
    get:
      
      define variable rawKey# as raw    no-undo.
      define variable mKey#   as memptr no-undo.
      if length(rawConfigKey) = 0 then 
      do:
        
        /* Note: because progress doesn't support set-byte-order on a raw field,
           we have to implement a workaround for endianess via a memptr.
           If we don't do this, we get cross platform issues (win32/aix).
        */
        
        set-byte-order(mKey#) = big-endian.
        set-size(mKey#) = 16.
        
        put-unsigned-short(mKey#,01) = 64532.
        put-unsigned-short(mKey#,02) = 298.
        put-unsigned-short(mKey#,03) = 48271.
        put-unsigned-short(mKey#,04) = 9283.
        put-unsigned-short(mKey#,05) = 29381.
        put-unsigned-short(mKey#,06) = 9977.
        put-unsigned-short(mKey#,07) = 19129.
        put-unsigned-short(mKey#,08) = 19385.
        put-unsigned-short(mKey#,09) = 59182.
        put-unsigned-short(mKey#,10) = 19375.
        put-unsigned-short(mKey#,11) = 33764.
        put-unsigned-short(mKey#,12) = 8635.
        put-unsigned-short(mKey#,13) = 7412.
        put-unsigned-short(mKey#,14) = 13518.
        put-unsigned-short(mKey#,15) = 55152.

        put-bytes(rawKey#, 1) = mKey#.
        
        set-size(mKey#) = 0.
        
        rawConfigKey = rawKey#.
        
      end.
      
      return rawConfigKey.
      
    end get.
    set.

    
  method public static character EncryptConfigToXConfig(
  
    /* A .config file gets a neighbor .xconfig file */
    
    cFileIP# as character):
      
    define variable cFileTarget# as character no-undo.
    define variable clobConfig#  as longchar  no-undo.
    define variable mConfig#     as memptr    no-undo.
    
    cFileTarget# = sc_path:SplitGetFileDir(cFileIP#) 
      + sc_path:SplitGetFileName(cFileIP#) 
      + ".xconfig".
      
    copy-lob file cFileIP# to clobConfig# no-convert.
    mConfig# = encrypt(clobConfig#, rawConfigKey).
    copy-lob mConfig# to file cFileTarget# no-convert.
    set-size(mConfig#) = 0.
    
    return cFileTarget#.
  
  end method. /* EncryptConfigToXConfig */
  
  
  method public static void DecryptXConfigToFile(
  
    /* A .xconfig file is decrypted to file */
    
    cFileXconfigIP# as character, 
    cFileTargetIP# as character):
      
    define variable clobConfig# as longchar no-undo.
    define variable mConfig#    as memptr   no-undo.
    
    file-info:file-name = cFileXconfigIP#.
    if file-info:full-pathname > "" then 
    do:
      copy-lob file cFileXconfigIP# to mConfig# no-convert.
      mConfig# = decrypt(mConfig#, rawConfigKey).
      copy-lob mConfig# to file cFileTargetIP# no-convert.
      set-size(mConfig#) = 0.
    end.
    else
      undo, throw new c_panaedraexception(
        99943981,
        sc_lang:oEnglish,
        substitute("Error: File '&1' not found", cFileXconfigIP#)
        ).
  
  end method. /* DecryptXConfigToFile */
  
  
  method public static memptr DecryptXConfigToMemptr(
  
    /* A .xconfig file is decrypted to memptr.
       Set the size of the memptr to 0 after use.
     */
    
    cFileXconfigIP# as character):
      
    define variable clobConfig# as longchar no-undo.
    define variable mConfig#    as memptr   no-undo.
    
    file-info:file-name = cFileXconfigIP#.
    if file-info:full-pathname > "" then 
    do:
      copy-lob file file-info:full-pathname to mConfig# no-convert.
      mConfig# = decrypt(mConfig#, rawConfigKey).
    end.
    else
      undo, throw new c_panaedraexception(
        99943982,
        sc_lang:oEnglish,
        substitute("Error: File '&1' not found", cFileXconfigIP#)
        ).
      
    return mConfig#.
  
  end method. /* DecryptXConfigToMemptr */
  
  
  method public static void ReadXml(
  
    /* Use to read a .config file. 
       If a .xconfig file (also) exists, it takes the most recent file.
     */
    
    hTtOrDsIP# as handle,
    cFileIP# as character):
    
    ReadXml(hTtOrDsIP#, cFileIP#, "empty").
    
  end method. /* ReadXml ; simple overload with "empty" */
  
  
  method public static void ReadXml(
  
    /* Use to read a .config file. 
       If a .xconfig file (also) exists, it takes the most recent file.
     */
    
    hTtOrDsIP#   as handle,
    cFileIP#     as character,
    cReadmodeIP# as character):
    
    define variable cConfigFilepath# as character no-undo.
    define variable bUseXconfig#     as logical   no-undo.
    define variable mConfig#         as memptr    no-undo.
    
    cConfigFilepath# = GetConfigOsfilename(cFileIP#, output bUseXconfig#).
    
    if bUseXconfig# then
      mConfig# = DecryptXConfigToMemptr(cConfigFilepath#).
    
    /* Mind no-error and throw in next statements when editing */
    if bUseXconfig# then
      hTtOrDsIP#:read-xml("memptr", mConfig#, cReadmodeIP#, ?, false) no-error.
    else 
    do:
      file-info:file-name = cConfigFilepath#.
      hTtOrDsIP#:read-xml("file", file-info:full-pathname, cReadmodeIP#, ?, false) no-error.
    end.
    
    if error-status:num-messages > 0 then 
      undo, throw new c_panaedraexception(
        99942219,
        sc_lang:oEnglish,
        substitute("Error: Config file '&1' (search:'&2') could not be read.~n&3", 
        cConfigFilepath#,
        search(cConfigFilepath#),
        error-status:get-message(1)
        )).
        
    finally:
      if bUseXconfig# then
        set-size(mConfig#) = 0.
    end finally.   
    
  end method. /* ReadXml */


  method public static character GetConfigOsfilename(

    /* Use to get the filename of a .config file. 
       If a .xconfig file (also) exists, it takes the most recent file.
     */

    cFileIP# as character):
      
    define variable bUseXconfig# as logical no-undo. 
    
    return GetConfigOsfilename(cFileIP#, output bUseXconfig#). 
      
  end method. /* GetConfigOsfilename ; simple overload */
  
  
  method public static character GetConfigOsfilename(

    /* Use to get the filename of a .config file. 
       If a .xconfig file (also) exists, it takes the most recent file.
     */

    cFileIP# as character,
    output bUseXconfigOP# as logical):

    define variable cXconfigfile# as character   no-undo.
    define variable dtmConfig#    as datetime-tz no-undo.
    define variable dtmXconfig#   as datetime-tz no-undo.
    
    define buffer b-ttConfigFileName for ttConfigFileName.
    
    find first b-ttConfigFileName
      where b-ttConfigFileName.cConfigFileName = cFileIP#
      no-error.
      
    if not avail b-ttConfigFileName then 
    do:
      
      /* Create caching temp-table record */
      create b-ttConfigFileName.
      assign 
        b-ttConfigFileName.cConfigFileName = cFileIP#.
      
      /* Use sc_path to get xconfig path from a config path */
      cXconfigfile# = sc_path:SplitGetFileDir(cFileIP#)
        + sc_path:SplitGetFileName(cFileIP#)
        + ".xconfig".
      
      if search(cXconfigfile#) <> ? then 
      do:
        if search(cFileIP#) = ? 
          then bUseXconfigOP# = true.
        else 
        do:
          assign /* If both .config and .xconfig exist, take the latest */
            dtmConfig#  = sc_osfile:GetFileModDatetime(cFileIP#)
            dtmXconfig# = sc_osfile:GetFileModDatetime(cXconfigfile#).
          if dtmXconfig# > dtmConfig# 
            then bUseXconfigOP# = true.
        end.
      end.
      
      /* Save everything to tt record */
      assign 
        b-ttConfigFileName.bUseXconfig = bUseXconfigOP#
        b-ttConfigFileName.cFullpath   = (if bUseXconfigOP# then cXconfigfile# else cFileIP#).
        
    end.
    
    /* Return data: all from tt record */
    assign
      bUseXconfigOP# = b-ttConfigFileName.bUseXconfig.
      
    return b-ttConfigFileName.cFullpath.
   
  end method. /* GetConfigOsfilename */

    
  method public static logical FileExists(cFileIP# as character):

    define variable cXconfigfile# as character no-undo.
    
    if search(cFileIP#) <> ? then return true.
    
    cXconfigfile# = sc_path:SplitGetFileDir(cFileIP#)
      + sc_path:SplitGetFileName(cFileIP#)
      + ".xconfig".  
      
    return (if search(cXconfigfile#) <> ? then true else false).
      
  end method. /* FileExists */
  
end class.

/* EOF */ 
