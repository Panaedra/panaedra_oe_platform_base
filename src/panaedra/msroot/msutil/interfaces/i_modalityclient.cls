{panaedra/msi/logic/ctop_interface.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

interface panaedra.msroot.msutil.interfaces.i_modalityclient:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_modalityclient.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-12-20 16:26:01+01:00 $ 
    Date Modified: $Modtime: 2009-12-18 23:53:05+01:00 $ 

      Description: Interface for classes who want to implement modal states.
                   In a modal state, normally the whole frame is disabled, except
                   for the widgets you allow for the user in this mode. 

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method void ModalityResponse(oModalityDataIP# as i_modalitydata).
  
end interface.

/* EOF */ 
