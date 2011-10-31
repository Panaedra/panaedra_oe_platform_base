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

  define protected static property rawConfigKey as raw no-undo
    get:
      define variable rawKey# as raw no-undo.
      if length(rawConfigKey) = 0 then 
      do:
        /* We provide a hard-coded key for encryption and decryption of config files. 
           It shouldn't be a security issue, since server-side authentication with
           client-principal and ssl is used.
           We encrypt config files to avoid tampering, but the contents should never
           be "atomic-bomb-launch-code-style" security sensitive. 
        */
        put-unsigned-short(rawKey#,01) = 64532.
        put-unsigned-short(rawKey#,02) = 298.
        put-unsigned-short(rawKey#,03) = 48271.
        put-unsigned-short(rawKey#,04) = 9283.
        put-unsigned-short(rawKey#,05) = 29381.
        put-unsigned-short(rawKey#,06) = 9977.
        put-unsigned-short(rawKey#,07) = 19129.
        put-unsigned-short(rawKey#,08) = 19385.
        put-unsigned-short(rawKey#,09) = 59182.
        put-unsigned-short(rawKey#,10) = 19375.
        put-unsigned-short(rawKey#,11) = 33764.
        put-unsigned-short(rawKey#,12) = 8635.
        put-unsigned-short(rawKey#,13) = 7412.
        put-unsigned-short(rawKey#,14) = 13518.
        put-unsigned-short(rawKey#,15) = 55152.
        rawConfigKey = rawKey#.
      end.
      return rawConfigKey.
    end get.
    set.

    
  method public static void EncryptConfigToXConfig(
  
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
    
  end method.
  
  method public static void ReadXml(
  
    /* Use to read a .config file. 
       If a .xconfig file (also) exists, it takes the most recent file.
     */
    
    hTtOrDsIP# as handle,
    cFileIP# as character,
    cReadmodeIP# as character):
    
    define variable cXconfigfile# as character   no-undo.
    define variable dtmConfig#    as datetime-tz no-undo.
    define variable dtmXconfig#   as datetime-tz no-undo.
    define variable bUseXconfig#  as logical     no-undo.
    define variable mConfig#      as memptr      no-undo.
    
    cXconfigfile# = sc_path:SplitGetFileDir(cFileIP#)
      + sc_path:SplitGetFileName(cFileIP#)
      + ".xconfig".
      
    if search(cXconfigfile#) <> ? then 
    do:
      if search(cFileIP#) = ? 
        then bUseXconfig# = true.
      else 
      do:
        assign
          dtmConfig#  = sc_osfile:GetFileModDatetime(cFileIP#)
          dtmXconfig# = sc_osfile:GetFileModDatetime(cXconfigfile#).
        if dtmXconfig# > dtmConfig# 
          then bUseXconfig# = true.
      end.
      if bUseXconfig# then
        mConfig# = DecryptXConfigToMemptr(cXconfigfile#).
    end.  
    
    /* Mind no-error and throw in next statements when editing */
    if bUseXconfig# then
      hTtOrDsIP#:read-xml("memptr", mConfig#, cReadmodeIP#, ?, false) no-error.
    else 
    do:
      file-info:file-name = cFileIP#.
      hTtOrDsIP#:read-xml("file", file-info:full-pathname, cReadmodeIP#, ?, false) no-error.
    end.
    
    if error-status:num-messages > 0 then 
      undo, throw new c_panaedraexception(
        99942219,
        sc_lang:oEnglish,
        substitute("Error: Config file '&1' / '&2' (search:'&3') could not be read.~n&4", 
        cFileIP#,
        cXconfigfile#,
        search(if bUseXconfig# then cXconfigfile# else cFileIP#),
        error-status:get-message(1)
        )).
        
    finally:
      if bUseXconfig# then
        set-size(mConfig#) = 0.
    end finally.   
    
  end method. /* ReadXml */
  
  
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
