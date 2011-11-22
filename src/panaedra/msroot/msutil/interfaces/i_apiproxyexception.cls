{panaedra/msroot/msutil/logic/top_i/ctop_interface.i}

interface panaedra.msroot.msutil.interfaces.i_apiproxyexception:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_apiproxyexception.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:17+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:33:52+01:00 $ 

      Description: Provides callback interface for dsException.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  method public void CallbackDsContext(dataset-handle hAsContext# /* by-ref */).
  
end interface.

/* EOF */
