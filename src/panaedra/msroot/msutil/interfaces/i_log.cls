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
  
  /* direct errors to the log-manager */
  define public property bErrorOnLogManager as logical no-undo get. set.
  
  /* write a status message */
  method public void StatusMsg(cMessage# as character).
  
  /* write a error message */
  method public void ErrorMsg(cMessage# as character).
  
  /* signal the end of the logging */
  method public void Dispose(). 
  
end interface.

/* EOF */ 

