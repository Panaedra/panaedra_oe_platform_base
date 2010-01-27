{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 

interface panaedra.msroot.msutil.interfaces.i_help_runtime:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_help_runtime.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:17+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:13+01:00 $ 

      Description: Interface for runtime user help and developer help.
                   Makes it possible to ask classes for their runtime help.
                   Makes use of the source control constructor for static classes.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define property bHelpInstance as logical no-undo get. set. 

  method public panaedra.msroot.msutil.logic.c_array_char GetRuntimeHelp().
  
end interface.

/* EOF */ 
