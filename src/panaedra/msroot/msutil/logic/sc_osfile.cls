using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_osfile:

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_osfile.cls $ 
          Version: $Revision: 11 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-08-22 16:58:32+02:00 $ 
    Date Modified: $Modtime: 2010-08-22 16:58:11+02:00 $ 

      Description: Os-file functionality, replaces lib/osfilelib.p eventually.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_osfile(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 11 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define stream s-alg-in.
  define stream s-alg-out.

  define protected static temp-table ttFile no-undo rcode-info
    field cFullPath as character.

  define protected static temp-table ttTempFile no-undo rcode-info
    field cFullPath as char.


  method public static void DeleteAllFilesInDir(
    cDirIP#       as character, 
    cMatchesIP#   as character,
    bRecursiveIP# as logical):
      
    define variable dtmDummy# as datetime-tz no-undo.
    
    empty temp-table ttFile.
    
    GetFileNamesInDirectorySub(cDirIP#, cMatchesIP#, dtmDummy#, dtmDummy#, bRecursiveIP#).
    
    DeleteFiles(table ttFile by-reference).
            
  end method. /* DeleteAllFilesInDir */

  
  method public static void DeleteFiles(
    /* Note on directories: Deletes only empty directories */
    table for ttFile /* by-ref */ ):
    
    
    define variable oAppError as Progress.Lang.AppError no-undo.
    
    for each ttFile on error undo, throw:
      
      os-delete value(ttFile.cFullPath) no-error.
      
      /* Determine if delete succeeded. Note: os-error isn't reliable here, OE10.2A02 */
      file-info:file-name = ttFile.cFullPath.      
      if file-info:full-pathname <> ? then 
      do:
        if oAppError = ? then oAppError = new Progress.Lang.AppError("Some files couldn't be deleted",99950938).
        oAppError:AddMessage(subst("&1 os-error &2", ttFile.cFullPath, os-error), 99950939).
      end.
      
    end. /* For each ttFile */  
    
    if oAppError <> ? then 
      undo, throw oAppError.
            
  end method. /* DeleteAllFilesInDir */
  
  
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


  method public static void CreateFile(cFileIP# as character):
    
    define variable oAppError as Progress.Lang.AppError no-undo.
    
    os-create-dir value(cFileIP#) no-error.
      
    /* Determine if delete succeeded. Note: os-error isn't reliable here, OE10.2A02 */
    file-info:file-name = cFileIP#.      
    if file-info:full-pathname = ? then 
    do:
      oAppError = new Progress.Lang.AppError(subst("&1 couldn't be created",cFileIP#),99950938).
    end.
    
    if oAppError <> ? then 
      undo, throw oAppError.
      
  end method. /* CreateFile */


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
         "/ota/wrktst/",
         "*~~.txt",
         yes,
         output table ttFile).     
           
       N.B.1 cFullPath always contains forward slashes
       N.B.2 The temp-table is not indexed, since it will normally be parsed top-through-bottom anyway. It does not contain duplicate entries.
       N.B.3 Stream-handles are used internally  
       N.B.4 Windows and unix platform support
    
     */
    
    define variable dtmDummy# as datetime-tz no-undo.
    
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
    
    GetFileNamesInDirectorySub(cDirIP#, cMatchesIP#, dtmFromIP#, dtmToIP#, bRecursiveIP#).
    
  end method. /* Overload: filter on mod-date range */


  method protected static void GetFileNamesInDirectorySub(
    input cDirIP#       as character, 
    input cMatchesIP#   as character,
    input dtmFromIP#    as datetime-tz,
    input dtmToIP#      as datetime-tz,
    input bRecursiveIP# as logical
    ):

    define variable cLine#   as char          no-undo extent 3.
    define variable oStream# as c_file_stream no-undo.
    define variable dtmFile# as datetime-tz   no-undo.
    define variable iTell#   as integer       no-undo.
    define variable cMatch#  as character     no-undo.
    
    oStream# = new c_file_stream().
    
    input stream-handle oStream#:hStream from os-dir(cDirIP#).
    
    b_repeat_osdir:
    repeat on error undo, throw:
      import stream-handle oStream#:hStream cLine#.
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
        else do:
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
      os-command silent value("chmod 664 "      + file-info:full-pathname + " 1> /dev/null 2> /dev/null") no-error.
      os-command silent value("chgrp dlc_user " + file-info:full-pathname + " 1> /dev/null 2> /dev/null") no-error.
    end.

  end method. /* CorrectFileRights */


  method public static void RegisterTempFile( 
    /* If you have your own temp file that can't be deleted immediately, register it with this method.
       At the end of the session, it will be removed (if it isn't locked by another process).
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
       Note: the INI file must end with a linefeed.
    */
    
    cIniIP#     as char, 
    cSectionIP# as char, 
    cVarIP#     as char):
  
    def var cLine#    as char no-undo.
    def var cSection# as char no-undo.
    def var iIndex#   as int  no-undo.
    def var cRet#     as char no-undo init ?.
  
    file-info:file-name = cIniIP#.
  
    if file-info:full-pathname = ? then return ?.
   
    input stream s-alg-in from value(file-info:full-pathname).
  
    searchLine:
    repeat on error undo, throw:
      import stream s-alg-in unformatted cLine#.
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
  
    input stream s-alg-in close.
  
    return cRet#.
  
  end method. /* GetIniValue */
  

  method public static logical PutIniValue (

    /* Change a INI file setting.
       Note:  the INI file will end with a linefeed.
       Note2: the complete INI file will be rewritten (but old values are of course respected).
    */
    
    cIniIP#     as char, 
    cSectionIP# as char, 
    cVarIP#     as char, 
    cValueIP#   as char):
  
    def var cLine#        as char no-undo.
    def var cSection#     as char no-undo.
    def var cPrevSection# as char no-undo.
    def var iIndex#       as int  no-undo.
    def var cTempFile#    as char no-undo.
    def var bWritten#     as log  no-undo.
  
    file-info:file-name = cIniIP#.
  
    if file-info:full-pathname = ? then 
    do:
      output stream s-alg-out to value(cIniIP#).
      put stream s-alg-out unformatted "[" cSectionIP# "]" skip.
      put stream s-alg-out unformatted     cVarIP# "=" cValueIP# skip.
      output stream s-alg-out close.
      return yes.
    end.
   
    cTempFile# = file-info:full-pathname + "~~".
    
    input  stream s-alg-in  from value(file-info:full-pathname).
    output stream s-alg-out to   value(cTempFile#).
  
    copyLines:
    repeat on error undo, throw:
   
      import stream s-alg-in unformatted cLine#.
    
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
    
    return SafeFileCopyOrMove_Implement(cFileFromIP#,cFileToIP#,bAppendIP#,false).
    
  end method. /* SafeFileMove */
  
  
  method public static integer SafeFileMove(

    /* Copy file from cFileFromIP# to cFileToIP# and use CorrectFileRights,
       returns error number when error occured */

    input cFileFromIP# as character,
    input cFileToIP#   as character,
    input bAppendIP#   as logical
    ):
    
    return SafeFileCopyOrMove_Implement(cFileFromIP#,cFileToIP#,bAppendIP#,true).
    
  end method. /* SafeFileMove */
  
  
  method protected static integer SafeFileCopyOrMove_Implement(

    /* Copy file from cFileFromIP# to cFileToIP# and use CorrectFileRights,
       returns error number when error occured */

    input cFileFromIP# as character,
    input cFileToIP#   as character,
    input bAppendIP#   as logical,
    input bMoveIP#     as logical
    ):

    define variable iErrorNrOP# as integer no-undo initial 0.
  
    /* Copy/append file */
    if bAppendIP# then 
      os-append value(cFileFromIP#) value(cFileToIP#).
    else
      os-copy value(cFileFromIP#) value(cFileToIP#).
                   
    /* If copy failed */                 
    if os-error <> 0 then
    do:
      iErrorNrOP# = 50370.
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
        end.
      end. /* bMove# */
        
    end.
  
    return iErrorNrOP#.

  end method. /* SafeFileCopyOrMove_Implement */

  
  method public static logical FileExists (
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
        sc_lang:oDutch,
        substitute("Error, '&1' does not exist", cFileIP#)
        ).
      
    return dtmReturn#.
  
  end method. /* GetFileModDatetime */
  
end class.

/* EOF */ 
