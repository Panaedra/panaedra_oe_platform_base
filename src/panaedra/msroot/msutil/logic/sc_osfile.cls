using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_osfile: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_osfile.cls $ 
          Version: $Revision: 10 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-08-22 16:56:23+02:00 $ 
    Date Modified: $Modtime: 2010-08-22 16:43:04+02:00 $ 

      Description: Os-file functionality, replaces lib/osfilelib.p eventually.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_osfile(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 10 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define static temp-table ttFile no-undo rcode-info
    field cFullPath as character.


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
    table for ttFile /* by-ref */ ):
    
    /* Delete only lege directory's */
    
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
    
    /* Haal eenvoudig alle bestandsnamen op in een
     directory, met optioneel alle subdirectories.
	     
     De matches string is een normale matches, denk
     eraan dat de punt een wildcard is die
     ge-escaped moet/kan worden.
	     
     De matches string vergelijkt met de 
     bestandsnaam-zonder-pad.
	     
     Voorbeeld:
	     
     def temp-table ttFile no-undo rcode-info
       field cFullPath as char.
	      
     run GetFileNamesInDirectory(
       "/ota/wrktst/",
       "*~~.txt",
       yes,
       output table ttFile).     
	       
     N.B.1 cFullPath bevat altijd forward slashes
     N.B.2 Er zit geen index op de temp-table, maar er zullen geen dubbele entries in zitten
     N.B.3 Maakt intern gebruik van stream-handle, dus DLC10.1C+  
     N.B.4 Werkt zowel op windows als unix
	  
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

    define variable cLine#   as char     no-undo extent 3.
    define variable oStream# as c_file_stream no-undo.
    define variable dtmFile# as datetime-tz   no-undo.
    
    oStream# = new c_file_stream().
    
    input stream-handle oStream#:hStream from os-dir(cDirIP#).
    
    b_repeat_osdir:
    repeat:
      import stream-handle oStream#:hStream cLine#.
      cLine#[2] = replace(cLine#[2],"~\","/").
      if cLine#[1] = "."  then next b_repeat_osdir.
      if cLine#[1] = ".." then next b_repeat_osdir.
      if cLine#[3] begins "F" then 
      do:
        if dtmFromIP# <> ? or dtmToIP# <> ? then 
        do:
          if cLine#[2] matches "*_tty*" then. /* message 1 cLine#[2]
              view-as alert-box.*/
          file-info:file-name = cLine#[2].
/*          if cLine#[2] matches "*_tty*" then message 2 file-info:file-mod-date*/
/*              view-as alert-box.                                              */
          if file-info:file-mod-date = ? then next b_repeat_osdir.
          dtmFile# = datetime-tz(substitute("&1 &2", string(file-info:file-mod-date,"99-99-9999"), string(file-info:file-mod-time,"HH:MM:SS"))).
          if dtmFromIP# <> ? and dtmFile# < dtmFromIP# then next b_repeat_osdir.
          if dtmToIP#   <> ? and dtmFile# > dtmToIP#   then next b_repeat_osdir.
        end.
        if cMatchesIP# = ? or cMatchesIP# = "" or entry(num-entries(cLine#[2],"/"),cLine#[2],"/") matches cMatchesIP# then 
        do:
          create ttFile.
          assign 
            ttFile.cFullPath = cLine#[2].
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
  
    /* Zet de bestandsrechten goed onder unix, indien bestand als root aangemaakt.
    */
  
    file-info:file-name = cFileIP#.
   
    if file-info:full-pathname > "" and opsys = "unix" then 
    do:
      os-command silent value("chmod 664 "      + file-info:full-pathname + " 1> /dev/null 2> /dev/null") no-error.
      os-command silent value("chgrp dlc_user " + file-info:full-pathname + " 1> /dev/null 2> /dev/null") no-error.
    end.

  end method. /* CorrectFileRights */

  
end.

/* EOF */ 
