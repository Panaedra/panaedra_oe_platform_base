{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

interface panaedra.msroot.msutil.interfaces.i_modalityclient:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_modalityclient.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:17+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:13+01:00 $ 

      Description: Interface for classes who want to implement modal states.
                   In a modal state, normally the whole frame is disabled, except
                   for the widgets you allow for the user in this mode. 

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method void ModalityResponse(oModalityDataIP# as i_modalitydata).
  
end interface.

/* EOF */ 
