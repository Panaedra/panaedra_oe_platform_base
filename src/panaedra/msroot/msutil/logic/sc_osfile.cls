using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_osfile: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_osfile.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-02-20 11:51:44+01:00 $ 
    Date Modified: $Modtime: 2010-02-20 11:42:11+01:00 $ 

      Description: Os-file functionality, replaces lib/osfilelib.p eventually.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_osfile(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define static temp-table ttFile no-undo rcode-info
    field cFullPath as character.


  method public static void DeleteAllFilesInDir(
    cDirIP#       as character, 
    cMatchesIP#   as character,
    bRecursiveIP# as logical):
    
    empty temp-table ttFile.
    
    define variable oAppError as Progress.Lang.AppError no-undo.
      
    GetFileNamesInDirectorySub(cDirIP#, cMatchesIP#, bRecursiveIP#).
    
    for each ttFile:
      
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
    do:
      undo, throw oAppError.
    end.
            
  end method. /* DeleteAllFilesInDir */
  

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
    
    empty temp-table ttFile.
    
    GetFileNamesInDirectorySub(cDirIP#, cMatchesIP#, bRecursiveIP#).
    
  end method. /* GetFileNamesInDirectory */


  method protected static void GetFileNamesInDirectorySub(
    input cDirIP#       as character, 
    input cMatchesIP#   as character,
    input bRecursiveIP# as logical
    ):

    define variable cLine#   as char     no-undo extent 3.
    define variable oStream# as c_file_stream no-undo.
    
    oStream# = new c_file_stream().
    
    input stream-handle oStream#:hStream from os-dir(cDirIP#).
  
    repeat:
      import stream-handle oStream#:hStream cLine#.
      cLine#[2] = replace(cLine#[2],"~\","/").
      if cLine#[1] = "."  then next.
      if cLine#[1] = ".." then next.
      if cLine#[3] begins "F" then 
      do:
        if cMatchesIP# = "" or entry(num-entries(cLine#[2],"/"),cLine#[2],"/") matches cMatchesIP# then 
        do:
          create ttFile.
          assign 
            ttFile.cFullPath = cLine#[2].
        end.
      end.
      else if cLine#[3] begins "D" then 
        do:
          if bRecursiveIP# then 
            GetFileNamesInDirectorySub(cLine#[2], cMatchesIP#, bRecursiveIP#).
        end.
    end.
   
    finally:
      if valid-object(oStream#) then 
      do:
        input stream-handle oStream#:hStream close.
        delete object oStream#.    
      end.
    end finally.

  end method. /* GetFileNamesInDirectorySub */
  
end.

/* EOF */ 
