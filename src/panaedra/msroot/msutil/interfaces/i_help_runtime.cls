{panaedra/msi/logic/ctop_interface.i} 

interface panaedra.msroot.msutil.interfaces.i_help_runtime:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_help_runtime.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-22 20:14:40+02:00 $ 
    Date Modified: $Modtime: 2009-10-22 20:12:55+02:00 $ 

      Description: Interface for runtime user help and developer help.
                   Makes it possible to ask classes for their runtime help.
                   Makes use of the source control constructor for static classes.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define property bHelpInstance as logical no-undo get. set. 

  method public panaedra.msroot.msutil.logic.c_array_char GetRuntimeHelp().
  
end interface.

/* EOF */ 
