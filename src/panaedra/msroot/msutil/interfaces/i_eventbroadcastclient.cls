{panaedra/msi/logic/ctop_interface.i}
using panaedra.msroot.msutil.logic.*.

interface panaedra.msroot.msutil.logic.i_eventbroadcastclient:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/i_eventbroadcastclient.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-02 16:13:06+02:00 $ 
    Date Modified: $Modtime: 2009-09-02 16:12:51+02:00 $ 

      Description: Interface for classes that use sc_eventbroadcaster.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata).

end interface.

/* EOF */
