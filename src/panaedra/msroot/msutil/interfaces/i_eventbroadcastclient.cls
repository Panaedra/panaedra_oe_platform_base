{panaedra/msi/logic/ctop_interface.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

interface panaedra.msroot.msutil.interfaces.i_eventbroadcastclient:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_eventbroadcastclient.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-24 13:41:24+02:00 $ 
    Date Modified: $Modtime: 2009-09-24 13:40:00+02:00 $ 

      Description: Interface for classes that use sc_eventbroadcaster.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata).

end interface.

/* EOF */
