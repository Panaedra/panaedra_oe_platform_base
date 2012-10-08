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
     the normal header will be placed underneath this one */
  define public property cOwnHeader as character no-undo get. set.
  
  /* direct errors to the log-manager */
  define public property bErrorOnLogManager as logical no-undo get. set.
  
  /* error log file name */
  define public property cErrorLogFileName as character no-undo get.
  
  /* status log file name */
  define public property cStatusLogFileName as character no-undo get.
  
  /* timestamp toevoegen aan WriteStatusLn regels */
  define public property bIncludeTimeStamp as logical no-undo get. set.
  
  /* timestamp */
  define public property cTimeStamp as character no-undo get.
  
  /* write a status message */
  method public void WriteStatus(cMessage# as character).
  method public void WriteStatusLn(cMessage# as character).
  method public void WriteStatusEmptyLn().
  
  /* formatted with columns with buffer/query , field-handles possible */
  method public void WriteStatusInit(hBufferReportIP# as handle).
  method public void WriteStatusInit(hQueryIP# as handle, hBufferReportIP# as handle).
  method public void WriteStatusHeader(hBufferReportIP# as handle).
  method public void WriteStatusLnBuf(hBufferReportIP# as handle).
  
  /* write a error message */
  method public void WriteError(cMessage# as character).
  method public void WriteErrorLn(cMessage# as character).
  method public void WriteException(oExepctionIP# as Progress.Lang.Error).
  method public void WriteException(oExepctionIP# as Progress.Lang.Error,cExtraTextIP# as character).
  
  method public void WriteMissingData(hBufferIP# as handle,  cSvKeyValuesIP# as character).
  
  /* signal the end of the logging */
  method public void Dispose(). 
  
end interface.

/* EOF */ 

