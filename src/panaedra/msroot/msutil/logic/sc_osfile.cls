using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_osfile
  implements 
  i_eventbroadcastclient:

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_osfile.cls $ 
          Version: $Revision: 11 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-08-22 16:58:32+02:00 $ 
    Date Modified: $Modtime: 2010-08-22 16:58:11+02:00 $ 

      Description: Os-file functionality, replaces lib/osfilelib.p eventually.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor protected sc_osfile(
    input oParamIP# as i_unittest_param):
  end constructor.  

  constructor public sc_osfile(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 11 $', '{&sourcecontrolversions}').
  end constructor.
  
  /******************************* $NoKeywords:  $ *****************************/

  define stream s-alg-in.
  define stream s-alg-out.
  define stream s-del-in.
  define stream s-del-out.

  define protected static temp-table ttFile no-undo rcode-info
    field cFullPath as character.

  define protected static temp-table ttTempFile no-undo rcode-info
    field cFullPath as char.

  define protected static temp-table ttFileExpire no-undo rcode-info
    field cFullPath as char.

  define protected static temp-table ttLineExpire no-undo rcode-info
    field cFullPath as char
    field dtmExpire as datetime-tz
    index dtmExpire dtmExpire.

  define protected static temp-table ttUnittestINIfile /* wel undo */
    field cIniFile   as character 
    field cSection   as character 
    field cParameter as character 
    field cValue     as character
    index prim is primary unique cIniFile cSection cParameter
    .  

  define protected static temp-table ttIniValue no-undo 
    field cParameter as character
    field cValue     as character.

  define protected static variable oSingleton    as sc_osfile no-undo.
  define protected static variable hTtFileNative as handle    no-undo.

  constructor protected sc_osfile():
    
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@SessionClose").
         
  end constructor.


  constructor static sc_osfile():
    
    /* This statement can only be in the static constructor. Reason: the first called method could be a by-reference call. */
    hTtFileNative = temp-table ttFile:handle.
         
  end constructor.


  destructor sc_osfile():
    
    sc_eventbroadcaster:UnSubscribeAllEvents(this-object).
    
  end destructor.


  method public static void DeleteAllFilesInDir(
    cDirIP#       as character, 
    cMatchesIP#   as character,
    bRecursiveIP# as logical):
      
    define variable dtmDummy# as datetime-tz no-undo.
    
    if temp-table ttFile:handle = hTtFileNative then
      empty temp-table ttFile.
    
    GetFileNamesInDirectorySub(cDirIP#, cMatchesIP#, dtmDummy#, dtmDummy#, bRecursiveIP#).
    
    DeleteFiles(table ttFile by-reference).
            
  end method. /* DeleteAllFilesInDir */

  
  method public static void DeleteFiles(
    /* Note on directories: Deletes only empty directories */
    table for ttFile /* by-ref */ ):
    
    define variable oAppError# as Progress.Lang.AppError no-undo.
    define variable cFullPath# as character              no-undo.
    
    for each ttFile on error undo, throw:
      
      cFullPath# = ttFile.cFullPath.
      
      &if opsys = "win32" &then
      cFullPath# = replace(cFullPath#,"/","~\").
      &endif
      
      os-delete value(cFullPath#) no-error.
      
      /* Determine if delete succeeded. Note: os-error isn't reliable here, OE10.2A02 */
      file-info:file-name = ttFile.cFullPath.      
      if file-info:full-pathname <> ? then 
      do:
        if oAppError# = ? then oAppError# = new Progress.Lang.AppError("Some files couldn't be deleted",99950938).
        oAppError#:AddMessage(subst("&1 os-error &2 &3", ttFile.cFullPath, os-error, OsErrorDescription(os-error)), 99950939).
      end.
      
    end. /* For each ttFile */  
    
    if oAppError# <> ? then 
      undo, throw oAppError#.
            
  end method. /* DeleteFiles */
  
  
  method public static void DeleteFile(
    cFileIP# as character):

    define variable oAppError as Progress.Lang.AppError no-undo.
    
    os-delete value(cFileIP#) no-error.
      
    /* Determine if delete succeeded. Note: os-error isn't reliable here, OE10.2A02 */
    file-info:file-name = cFileIP#.      
    if file-info:full-pathname <> ? then 
    do:
      oAppError = new Progress.Lang.AppError(subst("&1 couldn't be deleted",cFileIP#),99950938).
    end.
    
    if oAppError <> ? then 
      undo, throw oAppError.

  end method. /* DeleteFile */


  method public static void RenameFile(
    cFileFromIP# as character,
    cFileToIP# as character
    ):
    
    os-rename value(cFileFromIP#) value(cFileToIP#).
      
    file-info:file-name = cFileFromIP#.      
    if file-info:full-pathname <> ? then 
    do:
      undo, throw new c_panaedraexception(
        99978542,
        sc_lang:oEnglish,
        substitute("Error renaming &1 -> &2", cFileFromIP#, cFileToIP#)
        ).
      
    end.

  end method. /* RenameFile */


  @panaedraannotation file(unittest="yes").
  method public static void CreateEmptyFile(cFileIP# as character):
    
    CreateEmptyFile(cFileIP#, false).
          
  end method. /* CreateEmptyFile */


  @panaedraannotation file(unittest="yes").
  method public static void CreateEmptyFile(
    cFileIP#      as character, 
    bOverwriteIP# as logical
    ):
    
    if bOverwriteIP# and FileExists(cFileIP#) then
      DeleteFile(cFileIP#).

    if not FileExists(cFileIP#) then 
    do:

      if sc_path:PathExists(sc_path:SplitGetFileDir(cFileIP#)) then
      do:

        output stream s-alg-out to value(cFileIP#).
        output stream s-alg-out close.  
  
        if search(cFileIP#) = ? then
          undo, throw new Progress.Lang.AppError(subst("&1 couldn't be created", cFileIP#), 99951938).

      end.
      else
        undo, throw new Progress.Lang.AppError(subst("&1 couldn't be created", cFileIP#), 99953938).
          
    end.
    else
      undo, throw new Progress.Lang.AppError(subst("&1 already exists", cFileIP#), 99952938).
    
    finally:
      output stream s-alg-out close.  
    end finally.
          
  end method. /* CreateEmptyFile */
  
  
  method public static logical FileHasOneLineWithCRLF(cFileIP# as character):
    
    define variable bFileHasOneLineWithCRLF# as logical   no-undo.
    define variable cLineWithCRLF#           as character no-undo.
    define variable iSaveLastkey#            as integer   no-undo.

    iSaveLastkey# = keycode(keyfunction(lastkey)). /* Remember the lastkey code */

    if opsys = "unix" then 
    do:
    
      input stream s-alg-in thru value("grep -r $'~\r' " + cFileIP#) no-echo.

      repeat on error undo, throw:
        import stream s-alg-in unformatted cLineWithCRLF#. /* codeQok#7126  */
      end.

      if length(cLineWithCRLF#) > 0 then
        bFileHasOneLineWithCRLF# = true.

    end.
    else
      undo, throw new c_panaedraexception(
        50458933,
        sc_lang:oEnglish,
        substitute("Not implemented yet")
        ).
    
    return bFileHasOneLineWithCRLF#.
    
    finally:

      input stream s-alg-in close.

      /* The first argument is to determine the event-type (0) to read the last pressed set keypress event.
       * last-event:set-lastkey is set back to the remembered keycode in iSaveLastkey# */
      last-event:set-lastkey(0, iSaveLastkey#).

    end finally.
      
  end method. /* FileHasOneLineWithCRLF */


  method static public void GetFileNamesInDirectory(    
    input  cDirIP#       as character, 
    input  cMatchesIP#   as character,
    input  bRecursiveIP# as logical,
    output table for ttFile
    ):
    
    /* Simply get all filenames in a directory (optionally with subdirectories)
       
       The matches parameter is a normal ABL matches statement.
       Remember to escape a dot with a tilde ("*~~.txt").
       The matches only matches the file-name-part of the complete path.
       
       Example:
         
       define temp-table ttFile no-undo rcode-info
         field cFullPath as char.
          
       sc_osfile:GetFileNamesInDirectory(
         "/o t a/wrktst/",
         "*~~.txt",
         yes,
         output table ttFile).     
           
       N.B.1 cFullPath always contains forward slashes
       N.B.2 The temp-table is not indexed, since it will normally be parsed top-through-bottom anyway. It does not contain duplicate entries.
       N.B.3 Stream-handles are used internally  
       N.B.4 Windows and unix platform support
    
     */
    
    define variable dtmDummy# as datetime-tz no-undo.
    
    if temp-table ttFile:handle = hTtFileNative then
      empty temp-table ttFile.
    
    GetFileNamesInDirectorySub(cDirIP#, cMatchesIP#, dtmDummy#, dtmDummy#, bRecursiveIP#).
    
  end method. /* GetFileNamesInDirectory */


  method static public void GetFileNamesInDirectory(    
    input  cDirIP#       as character, 
    input  cMatchesIP#   as character,
    input  dtmFromIP#    as datetime-tz,
    input  dtmToIP#      as datetime-tz,
    input  bRecursiveIP# as logical,
    output table for ttFile
    ):
    
    if temp-table ttFile:handle = hTtFileNative then
      empty temp-table ttFile.
    
    GetFileNamesInDirectorySub(cDirIP#, cMatchesIP#, dtmFromIP#, dtmToIP#, bRecursiveIP#).
    
  end method. /* Overload: filter on mod-date range */


  method protected static void GetFileNamesInDirectorySub(
    input cDirIP#       as character, 
    input cMatchesIP#   as character,
    input dtmFromIP#    as datetime-tz,
    input dtmToIP#      as datetime-tz,
    input bRecursiveIP# as logical
    ):

    define variable cLine#        as char          no-undo extent 3.
    define variable oStream#      as c_file_stream no-undo.
    define variable dtmFile#      as datetime-tz   no-undo.
    define variable iTell#        as integer       no-undo.
    define variable cMatch#       as character     no-undo.
    define variable iSaveLastkey# as integer       no-undo.
     
    iSaveLastkey# = lastkey. /* Remember the lastkey code */ 
    
    oStream# = new c_file_stream().
    
    input stream-handle oStream#:hStream from os-dir(cDirIP#).
    
    b_repeat_osdir:
    repeat on error undo, throw:
      import stream-handle oStream#:hStream cLine#. /* codeQok#7126 */
      cLine#[2] = replace(cLine#[2],"~\","/").
      if cLine#[1] = "."  then next b_repeat_osdir.
      if cLine#[1] = ".." then next b_repeat_osdir.
      if cLine#[3] begins "F" then 
      do:
        if dtmFromIP# <> ? or dtmToIP# <> ? then 
        do:
          file-info:file-name = cLine#[2].
          if file-info:file-mod-date = ? then next b_repeat_osdir.
          dtmFile# = datetime-tz(substitute("&1 &2", string(file-info:file-mod-date,"99-99-9999"), string(file-info:file-mod-time,"HH:MM:SS"))).
          if dtmFromIP# <> ? and dtmFile# < dtmFromIP# then next b_repeat_osdir.
          if dtmToIP#   <> ? and dtmFile# > dtmToIP#   then next b_repeat_osdir.
        end.
        if num-entries(cMatchesIP#) > 1 then 
        do iTell# = 1 to num-entries(cMatchesIP#):
          cMatch# = entry(iTell#,cMatchesIP#).
          if entry(num-entries(cLine#[2],"/"),cLine#[2],"/") matches cMatch# then 
          do:
            create ttFile.
            assign 
              ttFile.cFullPath = cLine#[2].
          end.
        end.
        else 
        do:
          if cMatchesIP# = ? or cMatchesIP# = "" or entry(num-entries(cLine#[2],"/"),cLine#[2],"/") matches cMatchesIP# then 
          do:
            create ttFile.
            assign 
              ttFile.cFullPath = cLine#[2].
          end.
        end.
      end.
      else if cLine#[3] begins "D" then 
        do:
          if bRecursiveIP# then 
            GetFileNamesInDirectorySub(cLine#[2], cMatchesIP#, dtmFromIP#, dtmToIP#, bRecursiveIP#).
        end.
    end.
   
    finally:
      
      /* The first argument is to determine the event-type (0) to read the last pressed set keypress event.
       * last-event:set-lastkey is set back to the remembered keycode in iSaveLastkey# */
                         
      last-event:set-lastkey(0, iSaveLastkey#).
      
      if valid-object(oStream#) then 
      do:
        do 
          on error undo, leave
          on stop undo, leave:
          input stream-handle oStream#:hStream close.
        end.
        delete object oStream#.    
      end.
    end finally.

  end method. /* GetFileNamesInDirectorySub */


  method public static void CorrectFileRights(input cFileIP# as character):
  
    /* Correct the os file rights (especially important for batch processes that run as root).
    */
  
    file-info:file-name = cFileIP#.
   
    if file-info:full-pathname > "" and opsys = "unix" then 
    do:
      if file-info:file-type begins "F" then
      do:
        os-command silent value("chmod 664 "      + file-info:full-pathname + " 1> /dev/null 2> /dev/null") no-error.
        os-command silent value("chgrp dlc_user " + file-info:full-pathname + " 1> /dev/null 2> /dev/null") no-error.
      end.
      else
        undo, throw new c_panaedraexception(
          50458934,
          sc_lang:oEnglish,
          substitute("Correct file rights not possible, input is not a file: &1", cFileIP#)
          ).
    end.

  end method. /* CorrectFileRights */


  method public static void RegisterTempFile( 
    /* If you have your own temp file that can't be deleted immediately, register it with this method.
       At the end of the session, it will be removed (if it isn't locked by another process).
       
       Important note: consider using DeleteFileExpire, that approach is cross-session and more robust.
    */
     
    cFullPathIP# as char ):
  
    create ttTempFile.
    ttTempFile.cFullPath = cFullPathIP#.
  
  end method. /* RegisterTempFile */ 


  method public static void DeleteTempFiles():
    
    for each ttTempFile on error undo, throw:
      os-delete value (ttTempFile.cFullPath) no-error.
    end.
    
  end method. /* DeleteTempFiles */


  method public static character StripInvalidChars(

    /* Always be careful for slashes and periods (samba share etc.) */

    cNameIP#            as character,
    cReplaceExtraChars# as character):
    
    define variable cChar# as character no-undo.
    define variable iChar# as integer   no-undo.
    
    cNameIP# = replace(cNameIP#,">","_").
    cNameIP# = replace(cNameIP#,"<","_").
    cNameIP# = replace(cNameIP#,"|","_").
    cNameIP# = replace(cNameIP#,"?","_").
    cNameIP# = replace(cNameIP#,"*","_").
    cNameIP# = replace(cNameIP#,"~"","_").
    cNameIP# = replace(cNameIP#,"'","_").
    cNameIP# = replace(cNameIP#,"%","_").

    if cReplaceExtraChars# > "" then
    do iChar# = 1 to length(cReplaceExtraChars#):
      cChar# = substring(cReplaceExtraChars#,iChar#,1).
      cNameIP# = replace(cNameIP#, cChar#, "_"). 
    end.

    return cNameIP#.
      
  end method. /* StripInvalidChars */

    
  method public static character StripInvalidChars (
  
    /* Always be careful for slashes and periods (samba share etc.) */
    
    cNameIP#     as character,
    bStripAllIP# as logical):
    
    return StripInvalidChars(cNameIP#, if bStripAllIP# then "/~\: " else "").
        
  end method. /* StripInvalidChars */
  

  method public static character GetIniValue(

    /* Read values from INI files.
     * Note: the INI file must end with a linefeed.
     */
    
    cIniIP#     as character, 
    cSectionIP# as character, 
    cVarIP#     as character):
  
    define variable cLine#        as character no-undo.
    define variable iIndex#       as integer   no-undo.
    define variable cSection#     as character no-undo.
    define variable cRet#         as character no-undo init ?.
    define variable iSaveLastkey# as integer   no-undo.
    
    define buffer b-ttUnittestINIfile for ttUnittestINIfile.
    
    /* unittests?  in that case lookup the INI entry in a temp-table. */
    if sc_environment:bUnittestRunning then
    do:
      
      find first b-ttUnittestINIfile where
        b-ttUnittestINIfile.cIniFile = cIniIP#
        and b-ttUnittestINIfile.cSection = cSectionIP#
        and b-ttUnittestINIfile.cParameter = cVarIP#
        no-lock no-error.
        
      if available b-ttUnittestINIfile then
        cRet# = b-ttUnittestINIfile.cValue. 
      
    end.
    else 
    do: /* default flow from INI file */
    
      do on error undo, throw:
            
        iSaveLastkey# = lastkey. /* Remember the lastkey code */ 
       
        file-info:file-name = cIniIP#.
      
        if file-info:full-pathname = ? then return ?.
       
        input stream s-alg-in from value(file-info:full-pathname).
      
        searchLine:
        repeat on error undo, throw:
          import stream s-alg-in unformatted cLine#. /* codeQok#7126 */
          cLine# = left-trim(cLine#).
          if cLine# begins ";" or cLine# = "" then next.
          if cLine# begins "[" then 
          do:
            iIndex# = 
            index(cLine#,"]").
            if iIndex# > 0 then 
            do:
              cSection# = substring(cLine#,2,iIndex# - 2).
            end.
          end.
          if cSection# = cSectionIP# then 
          do:
            if entry(1,cLine#,"=") = cVarIP# then 
            do:
              cRet# = substring(cLine#,
              index(cLine#,"=") + 1,-1). 
              leave searchLine.
            end.
          end.
          
        end.
            
        finally:
          
          input stream s-alg-in close.
        
          /* The first argument is to determine the event-type (0) to read the last pressed set keypress event.
           * last-event:set-lastkey is set back to the remembered keycode in iSaveLastkey# */
                             
          last-event:set-lastkey(0, iSaveLastkey#).  
                                                    
        end finally.
        
      end. /* do */
      
    end. /* else */
    
    return cRet#.
  
  end method. /* GetIniValue */
    
    
  @panaedraannotation file(unittest="yes").    
  method public static character GetIniAllSections(

    /* returns cSv section headers from INI files.
     * Note: the INI file must end with a linefeed.
     */
    cIniIP#     as character 
    ):
  
    define variable cLine#        as character no-undo.
    define variable iIndex#       as integer   no-undo.
    define variable cSection#     as character no-undo.
    define variable cReturn#      as character no-undo.
    define variable iSaveLastkey# as integer   no-undo.
    
    define buffer b-ttUnittestINIfile for ttUnittestINIfile.
    
    /* unittests?  in that case lookup the INI entry in a temp-table. */
    if sc_environment:bUnittestRunning then
    do:
      
      for each b-ttUnittestINIfile no-lock where
        b-ttUnittestINIfile.cIniFile = cIniIP#
        on error undo, throw:
        cReturn# = cReturn# + "," + b-ttUnittestINIfile.cSection.
      end.
      
    end.
    else 
    do: /* default flow from INI file */
    
      do on error undo, throw:
            
        iSaveLastkey# = lastkey. /* Remember the lastkey code */ 
       
        file-info:file-name = cIniIP#.
      
        if file-info:full-pathname = ? then return ?.
       
        input stream s-alg-in from value(file-info:full-pathname).
      
        searchLine:
        repeat on error undo, throw:
          import stream s-alg-in unformatted cLine#. /* codeQok#7126 */
          cLine# = left-trim(cLine#).
          if cLine# begins ";" or cLine# = "" then next.
          if cLine# begins "[" then 
          do:
            iIndex# = 
            index(cLine#,"]").
            if iIndex# > 0 then 
            do:
              cSection# = substring(cLine#,2,iIndex# - 2).
              cReturn# = cReturn# + "," + cSection#.
            end.
          end.
        end.
            
        finally:
          
          input stream s-alg-in close.
        
          /* The first argument is to determine the event-type (0) to read the last pressed set keypress event.
           * last-event:set-lastkey is set back to the remembered keycode in iSaveLastkey# */
                             
          last-event:set-lastkey(0, iSaveLastkey#).  
                                                    
        end finally.
        
      end. /* do */
      
    end. /* else */
    
    return left-trim(cReturn#, ",").
  
  end method. /* GetIniAllSections */
    
    

  method public static logical IsIniSectionAvailable(

    /* Is the given section available in the ini. */
    
    cIniIP#     as character, 
    cSectionIP# as character):
  
    define variable cLine#        as character no-undo.
    define variable bAvailable#   as logical   no-undo.
    define variable iSaveLastkey# as integer   no-undo.
    
    define buffer b-ttUnittestINIfile for ttUnittestINIfile.
    
    /* unittests?  in that case lookup the INI entry in a temp-table. */
    if sc_environment:bUnittestRunning then
    do:

      bAvailable# = can-find(first b-ttUnittestINIfile where
        b-ttUnittestINIfile.cIniFile = cIniIP#
        and b-ttUnittestINIfile.cSection = cSectionIP#
        ).        
      
    end.
    else 
    do on error undo, throw:  /* default flow from INI file */

      iSaveLastkey# = lastkey. /* Remember the lastkey code */ 

      file-info:file-name = cIniIP#.
    
      if file-info:full-pathname = ? then return ?.
     
      input stream s-alg-in from value(file-info:full-pathname).
    
      searchLine:
      repeat while not bAvailable# on error undo, throw: 

        import stream s-alg-in unformatted cLine#.  /* codeQok#7126 */

        bAvailable# = (trim(cLine#) begins "[" + cSectionIP# + "]"). 
        
      end.

      finally:     
        input stream s-alg-in close.                                                
        last-event:set-lastkey(0, iSaveLastkey#).  
      end finally.

    end. /* else */
    
    return bAvailable#.
  
  end method. /* IsIniSectionAvailable */
  

  method public static void ClearIniValuesUnittest(
    /* Clear the in-memory INI value cache used by unittests */
    oUnittestClientIP# as i_unittest_client):
    
    if (not valid-object(oUnittestClientIP#)) then
      undo, throw new c_panaedraexception(
        99927885,
        sc_lang:oEnglish,
        "Emptying ttUnittestINIfile is only allowed for unit tests.").
    
    empty temp-table ttUnittestINIfile.
  
  end method. /* ClearIniValuesUnittest */
  

  method public static void LogIniValuesUnittest(
    /* Log the in-memory INI value cache used by unittests to file */
    oUnittestClientIP# as i_unittest_client):
    
    if (not valid-object(oUnittestClientIP#)) then
      undo, throw new c_panaedraexception(
        99927886,
        sc_lang:oEnglish,
        "Logging ttUnittestINIfile is only allowed for unit tests.").
    
    output to value(sc_path:cLogDir + substitute("unittest-ini_&1_&2.log", guid, sc_date_timestamp:cTimeStamp_Short_DateAndTime)).
    for each ttUnittestINIfile on error undo, throw:
      export ttUnittestINIfile.
    end.
    output close.
  
  end method. /* LogIniValuesUnittest */
  

  method public static logical PutIniValueUnittest(
    /* PutIniValue for use in unittest.p procedures */
    hProcedureIP#     as handle,
    cIniFileIP#       as char, 
    cSectionIP#       as char, 
    cParameterIP#     as char, 
    cValueIP#         as char
    ):
      
    define variable bReturn# as logical no-undo.  
    
    /* check if were called from a unittest procedure,
       forced by procedure filenaming conventions */  
    if sc_environment:bUnittestRunning then
      bReturn# = _sys_PutIniValueUnittest(
        cIniFileIP#, 
        cSectionIP#, 
        cParameterIP#, 
        cValueIP#
        ).
    else
      undo, throw new c_panaedraexception(
        55502504,
        sc_lang:oEnglish,
        "PutIniValueUnittest() is not used in a unittest."
        ).
    
    return bReturn#.      
      
  end method. /* PutIniValueUnittest */


  method public static logical PutIniValueUnittest(
    /* PutIniValue for use from unittests.cls classes */
    oUnittestClientIP# as i_unittest_client,
    cIniFileIP#        as char, 
    cSectionIP#        as char, 
    cParameterIP#      as char, 
    cValueIP#          as char
    ):
      
    define variable bReturn# as logical no-undo.  

    if sc_environment:bUnittestRunning 
      and valid-object(oUnittestClientIP#) then
      bReturn# = _sys_PutIniValueUnittest(
        cIniFileIP#, 
        cSectionIP#, 
        cParameterIP#, 
        cValueIP#
        ).
    else   
      undo, throw new c_panaedraexception(
        55502505,
        sc_lang:oEnglish,
        substitute("Unit tests should be run on a *tst* environment. TestID='&1'", sc_environment:cEnv)
        ).
        
    return bReturn#.    
  
  end method. /* PutIniValueUnittest */
  
  
  method protected static logical _sys_PutIniValueUnittest(
    cIniFileIP#       as char, 
    cSectionIP#       as char, 
    cParameterIP#     as char, 
    cValueIP#         as char
    ):

    define variable bReturn# as logical no-undo.

    define buffer b-ttUnittestINIfile for ttUnittestINIfile.

    do for b-ttUnittestINIfile:
      
      find first b-ttUnittestINIfile where
        b-ttUnittestINIfile.cIniFile = cIniFileIP#
        and b-ttUnittestINIfile.cSection = cSectionIP#
        and b-ttUnittestINIfile.cParameter = cParameterIP#
        no-error.
        
      if not available b-ttUnittestINIfile then 
      do:
        create b-ttUnittestINIfile.
        assign 
          b-ttUnittestINIfile.cIniFile   = cIniFileIP#
          b-ttUnittestINIfile.cSection   = cSectionIP#
          b-ttUnittestINIfile.cParameter = cParameterIP#
          .
      end.  
      
      assign
        b-ttUnittestINIfile.cValue = cValueIP#
        bReturn#                   = true
        .
      release b-ttUnittestINIfile.
    end.      
  
    return bReturn#.
  
  end method. /* _sys_PutIniValueUnittest */


  method public static logical PutIniValue (

    /* Change a INI file setting.
       Note:  the INI file will end with a linefeed.
       Note2: the complete INI file will be rewritten (but old values are of course respected).
    */
    
    cIniIP#     as char, 
    cSectionIP# as char, 
    cVarIP#     as char, 
    cValueIP#   as char):
  
    def    var      cLine#        as char    no-undo.
    def    var      cSection#     as char    no-undo.
    def    var      cPrevSection# as char    no-undo.
    def    var      iIndex#       as int     no-undo.
    def    var      cTempFile#    as char    no-undo.
    def    var      bWritten#     as log     no-undo.
  
    define variable iSaveLastkey# as integer no-undo.
     
    iSaveLastkey# = lastkey. /* Remember the lastkey code */ 
    
    file-info:file-name = cIniIP#.
  
    if file-info:full-pathname = ? then 
    do:
      output stream s-alg-out to value(cIniIP#).
      put stream s-alg-out unformatted 
        "[" cSectionIP# "]" skip.
      put stream s-alg-out unformatted     cVarIP# "=" cValueIP# skip.
      output stream s-alg-out close.
      return yes.
    end.
   
    cTempFile# = file-info:full-pathname + "~~".
    
    input  stream s-alg-in  from value(file-info:full-pathname).
    output stream s-alg-out to   value(cTempFile#).
  
    copyLines:
    repeat on error undo, throw:
   
      import stream s-alg-in unformatted cLine#. /* codeQok#7126 */
    
      if left-trim(cLine#) begins ";" or left-trim(cLine#) = "" then 
      do:
        put stream s-alg-out unformatted cLine# skip. 
        next copyLines.
      end.

      cLine# = left-trim(cLine#).

      if cLine# begins "[" then 
      do:
        iIndex# = 
        index(cLine#,"]").
        if iIndex# > 0 then 
        do:
          cSection# = substring(cLine#,2,iIndex# - 2).
        end.
        if not bWritten# 
          and cPrevSection# = cSectionIP# 
          and cPrevSection# <> cSection# 
          then 
        do:
          put stream s-alg-out unformatted cVarIP# "=" cValueIP# skip.
          bWritten# = yes.
        end. 
        cPrevSection# = cSection#.
        put stream s-alg-out unformatted cLine# skip.
      end.
      else 
      do:
        if cSection# = cSectionIP# then 
        do:
          if not bWritten# and entry(1,cLine#,"=") = cVarIP# then 
          do:
            put stream s-alg-out unformatted cVarIP# "=" cValueIP# skip.
            bWritten# = yes.
          end.
          else put stream s-alg-out unformatted cLine# skip.
        end.
        else put stream s-alg-out unformatted cLine# skip.
      end.    
    end.
  
    if not bWritten# then 
    do:
      if cSection# <> cSectionIP# then 
        put stream s-alg-out unformatted "[" cSectionIP# "]" skip.
      put stream s-alg-out unformatted     cVarIP# "=" cValueIP# skip.
    end.
  
    input  stream s-alg-in  close.
    output stream s-alg-out close.
  
    os-copy value(cTempFile#) value(file-info:full-pathname).
   
    if os-error > 0 then return no. 
  
    os-delete value(cTempFile#).
  
    return true.
  
    finally:
    
      /* The first argument is to determine the event-type (0) to read the last pressed set keypress event.
       * last-event:set-lastkey is set back to the remembered keycode in iSaveLastkey# */
                         
      last-event:set-lastkey(0, iSaveLastkey#).  
                                                
    end finally.
  
  end method. /* PutIniValue */


  method public static integer SafeFileMoveAndArchive(

    /* This method copies a file to two places and then it deletes the original file */
    
    input cFileFromIP#   as character,
    input cFileToIP#     as character,
    input cFileArchive#  as character,
    input bAppendCopyIP# as logical, /* append for fileto */
    input bAppendMoveIP# as logical  /* append for archive */
    ):
   
    define variable iReturn# as integer no-undo.
   
    iReturn# = SafeFileCopy(cFileFromIP#,cFileToIP#,bAppendCopyIP#).
   
    if iReturn# = 0 then
      iReturn# = SafeFileMove(cFileFromIP#,cFileArchive#,bAppendMoveIP#).
   
    return iReturn#.
   
  end method. /* SafeFileMoveAndArchive */
  
  
  method public static integer SafeFileCopy(

    /* Copy file from cFileFromIP# to cFileToIP# and use CorrectFileRights,
       returns error number when error occured */

    input cFileFromIP# as character,
    input cFileToIP#   as character,
    input bAppendIP#   as logical
    ):
    
    return SafeFileCopyOrMove_Implement(cFileFromIP#,cFileToIP#,bAppendIP#,false,false,false).
    
  end method. /* SafeFileMove */
  
  
  @panaedraannotation file(unittest="yes").
  method public static integer SafeFileCopyWithTempfile(

    /* Copy file from cFileFromIP# to cFileToIP# and use CorrectFileRights,
       returns error number when error occured 
       use tempfile at destination to avoid reading corrupt data
       note: append mode not possible here. */

    input cFileFromIP# as character,
    input cFileToIP#   as character
    ):
    
    return SafeFileCopyOrMove_Implement(cFileFromIP#,cFileToIP#,false,false,false,true).
    
  end method. /* SafeFileMove */
  

  
  method public static integer SafeFileCopyThrow(

    /* Copy file from cFileFromIP# to cFileToIP# and use CorrectFileRights,
       returns error number when error occured */

    input cFileFromIP# as character,
    input cFileToIP#   as character,
    input bAppendIP#   as logical
    ):
    
    return SafeFileCopyOrMove_Implement(cFileFromIP#,cFileToIP#,bAppendIP#,false,true,false).
    
  end method. /* SafeFileCopyThrow */
  
  
  method public static integer SafeFileMove(

    /* Copy file from cFileFromIP# to cFileToIP# and use CorrectFileRights,
       returns error number when error occured */

    input cFileFromIP# as character,
    input cFileToIP#   as character,
    input bAppendIP#   as logical
    ):
    
    return SafeFileCopyOrMove_Implement(cFileFromIP#,cFileToIP#,bAppendIP#,true,false,false).
    
  end method. /* SafeFileMove */
  
  
  method public static integer SafeFileMoveThrow(

    /* Copy file from cFileFromIP# to cFileToIP# and use CorrectFileRights,
       returns error number when error occured */

    input cFileFromIP# as character,
    input cFileToIP#   as character,
    input bAppendIP#   as logical
    ):
    
    return SafeFileCopyOrMove_Implement(cFileFromIP#,cFileToIP#,bAppendIP#,true,true,false).
    
  end method. /* SafeFileMoveThrow */
  
  
  
  method protected static integer SafeFileCopyOrMove_Implement(

    /* Copy file from cFileFromIP# to cFileToIP# and use CorrectFileRights,
       returns error number when error occured */

    input cFileFromIP#       as character,
    input cFileToIP#         as character,
    input bAppendIP#         as logical,
    input bMoveIP#           as logical,
    input bThowOnErrorIP#    as logical,
    input bCopyToTempfileAndRenameIP# as logical
    ):

    define variable iErrorNrOP# as integer   no-undo initial 0.
    define variable cTempfile#  as character no-undo.
    define variable iOsError#   as integer   no-undo.
    
    cTempfile# = subst("&1_tmp.&2", cFileToIP#, guid).
  
    /* Copy/append file */
    if bAppendIP# then 
    do:
      os-append value(cFileFromIP#) value(cFileToIP#).
      iOsError# = os-error.
    end.  
    else 
    do:
      /* copy */
      os-copy value(cFileFromIP#) value(if bCopyToTempfileAndRenameIP# then cTempfile# else cFileToIP#).
      iOsError# = os-error.
      
      /* rename */
      if bCopyToTempfileAndRenameIP# and iOsError# = 0 then 
      do:
        os-rename value(cTempfile#) value(cFileToIP#).
        iOsError# = os-error.
      end. 
    end.  
                   
    /* If copy failed */                 
    if iOsError# <> 0 then
    do:
      iErrorNrOP# = 50370.
      
      if bCopyToTempfileAndRenameIP# then
        os-delete value(cTempfile#).
      
      if bThowOnErrorIP# then
        undo, throw new c_panaedraexception(
          28241214,
          sc_lang:oEnglish,
          subst("Error with &1 &2 to &3, os-error: &4 &5",
          if bMoveIP# then "moving" else "copying",
          cFileFromIP#,
          cFileToIP#,
          iOsError#,
          OsErrorDescription(iOsError#)
          )
          ).
            
    end.
    else  
    /* If copy succeeded */
    do:
      CorrectFileRights (input cFileToIP#).
      
      if bMoveIP# then
      do:
        os-delete value(cFileFromIP#).
        /* If delete failed */
        if os-error <> 0 then
        do:
          iErrorNrOP# = 50371.
          
          if bThowOnErrorIP# then
            undo, throw new c_panaedraexception(
              28241214,
              sc_lang:oEnglish,
              subst("Error with &1 &2 to &3, os-error: &4 &5",
              if bMoveIP# then "moving" else "copying",
              cFileFromIP#,
              cFileToIP#,
              os-error,
              OsErrorDescription(os-error))
              ).
          
        end.
      end. /* bMove# */
        
    end.
  
    return iErrorNrOP#.

  end method. /* SafeFileCopyOrMove_Implement */

  
  method public static logical FileExists(
  
    input cFilenameIP# as character 
    ):
    
    file-info:file-name = cFilenameIP#.
    return file-info:full-pathname <> ?.
        
  end method. /* FileExists */
  

  method public static datetime-tz GetFileModDatetime(cFileIP# as character):
    
    define variable dtmReturn# as datetime-tz no-undo.
    
    file-info:file-name = cFileIP#.
    
    if file-info:full-pathname > "" then 
    do:
      dtmReturn# = datetime-tz(file-info:file-mod-date, file-info:file-mod-time * 1000).
    end.
    else
      undo, throw new c_panaedraexception(
        99958002,
        sc_lang:oEnglish,
        substitute("File '&1' does not exist", cFileIP#)
        ).
      
    return dtmReturn#.
  
  end method. /* GetFileModDatetime */
  
  method public static integer GetFileByteSize(cFileIP# as character):
    
    define variable iReturn# as integer no-undo.
    
    file-info:file-name = cFileIP#.
    
    if file-info:full-pathname > "" then 
    do:
      iReturn# = file-info:file-size.
    end.
    else
      undo, throw new c_panaedraexception(
        99958003,
        sc_lang:oEnglish,
        substitute("File '&1' does not exist", cFileIP#)
        ).
      
    return iReturn#.
  
  end method. /* GetFileByteSize */
  
  
  method public static void FileDeleteExpire(
    
    /* Mark a file to delete after the supplied datetime expires.
       Filename is written (full-path) to export file "expire_*.d" in "cLocalIniDir/sysref/del/".
       Deletion of files is (if in use) retried in subsequent sessions.
       
       At session-close, delete is attempted.
       If succesfull (or file is missing), record line of tempfile is deleted.
       
       If not succesfull, record line stays.
       On next session-close (other session with same cLocalIniDir), delete is attempted again.
       
       Details:
       ========
       
       Concurrency is handled like this:
       
       FileDeleteExpire always writes to "expire_YYYYMMDD_hhmmssfff_<sessionguid>_lock.d".
       Timestamp in filename is "now", not dtmExpireIP#.
       The cumulative file is renamed with current "now" on each write.
       (dtmExpireIP# is inside file, first entry per line)
       
       At session-close, the session tries to delete its own temporary files.
       If (partly) unsuccessfull, the _lock part is stripped from the filename.
       All files of other sessions, older than 10 seconds, without _lock part, are also processed.
       
       In final catch (unexpected errors), the _lock part of this session's own file is stripped (with empty sub-catch).
       
     */
     
    cFileNameIP# as character,    /* example:  /mypath/myfile , or C:\MyPath\myfile.tmp */
    dtmExpireIP# as datetime-tz): /* example:  add-interval(now, 5, "minutes")          */
    
    undo, throw new c_panaedraexception(
      99948188,
      sc_lang:oEnglish,
      "Not implemented yet." /* ShouldHave: 20121004 - implement FileDeleteExpire */
      ).
    
    &if false &then
    
    define variable cMyGuid#      as character   no-undo.
    define variable cMyGuidMatch# as character   no-undo.
    define variable cFullPath#    as character   no-undo.
    define variable dtmExpire#    as datetime-tz no-undo.
    define variable iSaveLastkey# as integer     no-undo.

    iSaveLastkey# = lastkey. /* Remember the lastkey code */ 
    
    
    if oSingleton = ? then
      oSingleton = new sc_osfile(). /* Subscribe ourselves to sessionclose broadcasted event */
    
    if native handle thingy then... 
    empty temp-table ttFileExpire.
    
    sc_osfile:GetFileNamesInDirectory(
      sc_path:cLocalIniDir + "sysref/del/", 
      "expire_*~~.d", 
      false, 
      output table ttFileExpire by-reference).
    
    assign
      cMyGuid#      = sc_environment:cSessionGuidShort
      cMyGuidMatch# = subst("expire_*&1*~~.d", cMyGuid#).
    
    /* Collect my own temp-files */
    b_each_ttFileExpire:
    for each ttFileExpire on error undo, throw:
      
      if ttFileExpire.cFullPath matches cMyGuidMatch# then 
      do:
        
        input stream s-del-in from value(ttFileExpire.cFullPath) convert source "1252". 
        
        repeat on error undo, throw:
          import stream s-del-in dtmExpire# cFullPath#. /* codeQok#7126 */
          create ttLineExpire.
          assign
            ttLineExpire.cFullPath = cFullPath# 
            ttLineExpire.dtmExpire = dtmExpire#.
          release ttLineExpire. 
        end.
        
        input stream s-del-in close.
        
        leave b_each_ttFileExpire.
         
      end.
      
    end. /* b_each_ttFileExpire ; Collect my own temp-files*/
        
    finally:
    
      /* The first argument is to determine the event-type (0) to read the last pressed set keypress event.
       * last-event:set-lastkey is set back to the remembered keycode in iSaveLastkey# */
                         
      last-event:set-lastkey(0, iSaveLastkey#).  
                                                
    end finally.
    
    
    &endif
    
  end method. /* FileDeleteExpire */
  
  
  method protected static void FileDeleteExpireSessionClose(
  
    /* Comment: see FileDeleteExpire */
    
    ):
  
  end method. /* FileDeleteExpireSessionClose */


  method public void OnEventBroadcast(
  
    oBroadcastDataIP# as i_eventbroadcastdata):
    
    case oBroadcastDataIP#:cEventName:
      
      when "evt@SessionClose" then 
        do:
          FileDeleteExpireSessionClose().
          if valid-object(oSingleton) then 
            delete object oSingleton. /* Note: we could let the GC handle this, no preference yet. */
        end.
      
    end case.

  end method. /* OnEventBroadcast */
  
  
  method public static void FlipFileToWin(
    input cInputfileIP# as character
    ):
      
    if opsys = "unix" then 
    do:
      os-command silent value( "flip -mb " + cInputfileIP#).
      pause 1 no-message.
    end.
    else
      undo, throw new c_panaedraexception(
        50458932,
        sc_lang:oEnglish,
        substitute("Not implemented yet")
        ).
  end method. /* FlipFileToWin */
  
  
  method public static logical IsFileModWithinDays(
  
    /* Check if the file modification age in days is within the specified amount of days */  
    input  cFilepathIP#  as character, 
    input  iMaxDaysIP#   as integer,
    output iAgeInDaysOP# as integer):
     
    define variable bOk# as logical no-undo.    
     
    file-info:file-name = cFilepathIP#.    

    /* Calculate the age in days */ 
    iAgeInDaysOP# = interval(today,file-info:file-mod-date, "days").
    
    /* Check if the age is within iMaxDaysIP# */ 
    if iAgeInDaysOP# <= iMaxDaysIP# then 
      bOk# = true. 
  
    return bOk#. 
    
  end method. /* FileWithinDays */ 
  
  
  method public static character OsErrorDescription(
    iOsErrorIP# as integer
    ):
      
    define variable cReturn# as character no-undo.  
      
    case iOsErrorIP#:
      when 0 then
        cReturn# = "no error".
      when 1 then
        cReturn# = "not owner".
      when 2 then
        cReturn# = "no such file or directory".
      when 3 then
        cReturn# = "interrupted system call".
      when 4 then
        cReturn# = "I/O error".
      when 5 then
        cReturn# = "bad file number".
      when 6 then
        cReturn# = "no more processes".
      when 7 then
        cReturn# = "not enough core memory".
      when 8 then
        cReturn# = "permission denied".
      when 9 then
        cReturn# = "bad address".
      when 10 then
        cReturn# = "file exists".
      when 11 then
        cReturn# = "no such device".
      when 12 then
        cReturn# = "not a directory".
      when 13 then
        cReturn# = "is a directory".
      when 14 then
        cReturn# = "file table overflow".
      when 15 then
        cReturn# = "too many open files".
      when 16 then
        cReturn# = "file too large".
      when 17 then
        cReturn# = "no space left on device".
      when 18 then
        cReturn# = "directory not empty".
      when 999 then
        cReturn# = "unmapped error (abl default)".
      otherwise
      cReturn# = subst("unmapped error &1", iOsErrorIP#).
      
    end case.

    return cReturn#. 
  
  end method. /* OsErrorDescription */


  @panaedraannotation file(unittest="yes").
  method public static void WriteAllLines(
    input cFileIP#      as character, 
    input bOverwriteIP# as logical,
    input cLinesIP#     as character extent
    ): 

    define variable iLine# as integer no-undo.
  
    CreateEmptyFile(cFileIP#, bOverwriteIP#).
  
    output stream s-alg-out to value(cFileIP#).

    do iLine# = 1 to extent(cLinesIP#):     

      if length(cLinesIP#[iLine#]) > 0 then
        put stream s-alg-out unformatted cLinesIP#[iLine#] skip.
      else
        put stream s-alg-out unformatted skip(1).
        
    end.
    
    finally:
      output stream s-alg-out close.             
    end finally.
  
  end method.  /* WriteAllLines */


  method public static void WriteAllLines(
    input cFileIP#      as character, 
    input bOverwriteIP# as logical,
    input cLinesIP#     as longchar extent
    ): 

    define variable iLine# as integer   no-undo.
    define variable cLine# as character no-undo.
  
    CreateEmptyFile(cFileIP#, bOverwriteIP#).
  
    output stream s-alg-out to value(cFileIP#).

    do iLine# = 1 to extent(cLinesIP#):     

      if length(cLinesIP#[iLine#]) > 0 then
      do:
        cLine# = cLinesIP#[iLine#].
        put stream s-alg-out unformatted cLine# skip.
      end.
      else
        put stream s-alg-out unformatted skip(1).

    end.
    
    finally:
      output stream s-alg-out close.             
    end finally.
  
  end method.  /* WriteAllLines */
    

  @panaedraannotation file(unittest="yes").
  method public static void ReadLines(

    /* Read the first .. lines of a file into an array */
    /* WARNING: use the longchar overload if you're not sure how much data will be returned */

    input  cFileIP#   as character,
    input  iMaxLines# as integer,
    output cLinesOP#  as character extent
    ): 

    define variable cLines# as longchar no-undo extent.
    define variable iTell#  as integer  no-undo.

    ReadLines(cFileIP#, iMaxLines#, cLines#).

    if extent(cLines#) > 0 then
    do:
      
      extent(cLinesOP#) = extent(cLines#).
      
      do iTell# = 1 to extent(cLines#):
        cLinesOP#[iTell#] = cLines#[iTell#].      
      end.
      
    end.

  end.    


  @panaedraannotation file(unittest="yes").
  method public static void ReadLines(

    /* Read the first .. lines of a file into an array */

    input  cFileIP#   as character,
    input  iMaxLines# as integer,          /* -999 is all lines (use ReadAllLines) */ 
    output cLinesOP#  as longchar extent
    ): 

    define variable iLine#        as integer   no-undo.
    define variable cLine#        as character no-undo.
    define variable iLines#       as integer   no-undo.
    define variable iSaveLastkey# as integer   no-undo.

    if FileExists(cFileIP#) and (iMaxLines# > 0 or iMaxLines# = -999) then
    do on error undo, throw:

      iSaveLastkey# = keycode(keyfunction(lastkey)). /* Remember the lastkey code */

      input stream s-alg-in from value(cFileIP#).

      repeat on error undo, throw:      
        import stream s-alg-in unformatted cLine#. /* codeQok#7126  */
        iLines# = iLines# + 1.        
        if iMaxLines# <> -999 and iLines# > iMaxLines# then leave.     
      end.

      if iLines# > 0 then /* setting extent to 0 throws an error */
        extent (cLinesOP#) = iLines#.

      input stream s-alg-in close.  
      input stream s-alg-in from value(cFileIP#).

      repeat iLine# = 1 to iLines#  on error undo, throw:
        import stream s-alg-in unformatted cLine#. /* codeQok#7126  */
        cLinesOP#[iLine#] = cLine#.
      end.

      finally:
  
        input stream s-alg-in close.  
  
        /* The first argument is to determine the event-type (0) to read the last pressed set keypress event.
         * last-event:set-lastkey is set back to the remembered keycode in iSaveLastkey# */
        last-event:set-lastkey(0, iSaveLastkey#).
  
      end finally.
      
    end. /* FileExists */  
  
  end method.  /* ReadLines */

    
  @panaedraannotation file(unittest="yes").
  method public static void ReadAllLines(
  
    /* Read all the lines of a file into an array */
  
    input  cFileIP#  as character, 
    output cLinesOP# as longchar extent
    ): 

    ReadLines(cFileIP#, -999 /* all lines */, output cLinesOP#). 
  
  end method.  /* ReadAllLines */


  @panaedraannotation file(unittest="yes").
  method public static void GetLastLine(

    /* Read the first .. lines of a file into an array */
    /* Returns ? if the file is empty or does not exist */

    input  cFileIP#     as character,
    output cLastLineOP# as character
    ): 

    define variable cLine#        as character no-undo.
    define variable iSaveLastkey# as integer   no-undo.

    assign
      cLastLineOP# = ?.
    cLine#       = ?
      .

    if FileExists(cFileIP#) then
    do on error undo, throw:

      iSaveLastkey# = keycode(keyfunction(lastkey)). /* Remember the lastkey code */

      input stream s-alg-in from value(cFileIP#).

      repeat on error undo, throw:      
        import stream s-alg-in unformatted cLine#. /* codeQok#7126  */
      end.

      cLastLineOP# = cLine#.

      finally:
  
        input stream s-alg-in close.  
  
        /* The first argument is to determine the event-type (0) to read the last pressed set keypress event.
         * last-event:set-lastkey is set back to the remembered keycode in iSaveLastkey# */
        last-event:set-lastkey(0, iSaveLastkey#).
  
      end finally.
      
    end. /* FileExists */  
  
  end method.  /* GetLastLine */


  method public static void GetIniValues(
    input  cIniFileIP# as character, 
    input  cSectionIP# as character, 
    output table for ttIniValue
    ):
  
    define variable cLines# as longchar  no-undo extent.
    define variable cLine#  as character no-undo.
    define variable iLine#  as integer   no-undo.
    define variable bAdd#   as logical   no-undo.
  
    define buffer b-ttIniValue        for ttIniValue.    
    define buffer b-ttUnittestINIfile for ttUnittestINIfile.

    empty temp-table ttIniValue.

    if sc_environment:bUnittestRunning then
    do:
    
      for each b-ttUnittestINIfile 
        where b-ttUnittestINIfile.cIniFile = cIniFileIP#
        and   b-ttUnittestINIfile.cSection = cSectionIP#
        on error undo, throw:

        create b-ttIniValue.
        assign
          b-ttIniValue.cParameter = b-ttUnittestINIfile.cParameter
          b-ttIniValue.cValue     = b-ttUnittestINIfile.cValue
          . 
        release b-ttIniValue. 

      end.        
      
    end. /* bUnittestRunning */

    else 
    do: /* default flow from INI file */
  
      ReadAllLines(cIniFileIP#, output cLines#).
    
      do iLine# = 1 to extent(cLines#): 
  
        cLine# = trim(cLines#[iLine#]).
  
        if cLine# = substitute("[&1]", cSectionIP#) then
          bAdd# = true.
        else if cLine# begins ";" then
            next.
          else if bAdd# and cLine# begins "[" then
              leave.
            else if bAdd# and cLine# matches "*=*" then
              do:
        
                create b-ttIniValue.
                assign
                  b-ttIniValue.cParameter = entry(1, cLine#, "=")
                  b-ttIniValue.cValue     = substring(cLine#, index(cLine#, "=") + 1)
                  . 
                release b-ttIniValue. 
        
              end.
        
      end.
    
    end. /* not bUnittestRunning */
      
  end method. /* GetIniValues */


  method public static character ChangeExtension
    (input cFilenameIOP#     as character,
    input cNewExtentsionIP# as character
    ):
  
    return substring(cFilenameIOP#, 1, r-index(cFilenameIOP#, ".")) + left-trim(cNewExtentsionIP#, ".").
      
  end method. /* ChangeExtension */


  method public static logical HasGenericBinaryExtension(
    
    /* Check if the file has a commonly used binary extension, like "zip" or "jpg".
       The file does not have to exist.
       
       Note: This function can never cover all scenario's, only use as a presumption.
     */
    
    input cFilenameIP# as character):
    
    define variable bRet# as logical   no-undo.
    define variable cExt# as character no-undo.
  
    cExt# = sc_path:SplitGetFileExt(cFilenameIP#).
    
    if (cExt# = "zip"
      or cExt# = "7z"
      or cExt# = "rar"
      or cExt# = "lz4"
      or cExt# = "jar"
      or cExt# = "class"
      or cExt# = "rpm"
      or cExt# = "cpio"
      or cExt# = "pdb"
      or cExt# = "so"
      or cExt# = "o"
      or cExt# = "a"
      or cExt# = "r"
      or cExt# = "pyc"
      or cExt# = "pyo"
      or cExt# = "pyd"
      or cExt# = "exe"
      or cExt# = "dll"
      or cExt# = "resx"
      or cExt# = "_3DP_"
      or cExt# = "png"
      or cExt# = "jpg"
      or cExt# = "jpeg"
      or cExt# = "gif"
      or cExt# = "ico"
      or cExt# = "tif"
      or cExt# = "tiff"
      or cExt# = "bmp"
      or cExt# = "xls"
      or cExt# = "xlsx"
      or cExt# = "doc"
      or cExt# = "docx"
      or cExt# = "dot"
      or cExt# = "dotx"
      or cExt# = "ppt"
      or cExt# = "pptx"
      or cExt# = "db"
      or cExt# = "sqlite"
      ) then bRet# = true.
            
    return bRet#.       
      
  end method. /* HasGenericBinaryExtension */

end class.

/* EOF */ 
