{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 

interface panaedra.msroot.msutil.interfaces.i_log:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: interface for objects that can be used to write log messages.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  /* direct errors to standaard output */
  define public property bErrorOnOutput as logical no-undo get. set.
  
  /* Set this property to add an own header to the status log, 
     the normal header will be places underneath this one */
  define public property cOwnHeader as character no-undo get. set.
  
  /* direct errors to the log-manager */
  define public property bErrorOnLogManager as logical no-undo get. set.
  
  /* error log file name */
  define public property cErrorLogFileName as character no-undo get.
  
  /* error stream */
  define public property hErrorStream as handle no-undo get.
  
  /* status log file name */
  define public property cStatusLogFileName as character no-undo get.
  
  /* status log file stream */
  define public property hStatusStream as handle no-undo get.
  
  /* timestamp toevoegen aan WriteStatusLn regels */
  define public property bIncludeTimeStamp as logical no-undo get. set.
  
  /* timestamp */
  define public property cTimeStamp as character no-undo get.
  
  /* write a status message */
  method public void WriteStatus(cMessage# as character).
  method public void WriteStatusLn(cMessage# as character).
  method public void WriteStatusEmptyLn().
  
  /* Methods used to support WriteStatusFormatted */  
  method public void AddStatusColumn(input cLabelIP#    as character,input cFormatIP#   as character,input cDatatypeIP# as character).
  method public void ClearStatuscolumns().
    
  /* At this moment a total of 8 columns is supported, expand if necessary */
  method public void WriteStatusFormatted(cVar1# as char).
  method public void WriteStatusFormatted(cVar1# as char,cVar2# as char).
  method public void WriteStatusFormatted(cVar1# as char,cVar2# as char,cVar3# as char).
  method public void WriteStatusFormatted(cVar1# as char,cVar2# as char,cVar3# as char,cVar4# as char).
  method public void WriteStatusFormatted(cVar1# as char,cVar2# as char,cVar3# as char,cVar4# as char,cVar5# as char).
  method public void WriteStatusFormatted(cVar1# as char,cVar2# as char,cVar3# as char,cVar4# as char,cVar5# as char,cVar6# as char).
  method public void WriteStatusFormatted(cVar1# as char,cVar2# as char,cVar3# as char,cVar4# as char,cVar5# as char,cVar6# as char,cVar7# as char).
  method public void WriteStatusFormatted(cVar1# as char,cVar2# as char,cVar3# as char,cVar4# as char,cVar5# as char,cVar6# as char,cVar7# as char,cVar8# as char).

  /* write a error message */
  method public void WriteError(cMessage# as character).
  method public void WriteErrorLn(cMessage# as character).
  
  /* signal the end of the logging */
  method public void Dispose(). 
  
end interface.

/* EOF */ 

