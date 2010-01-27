{panaedra/msroot/msutil/logic/top_i/ctop_interface.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

interface panaedra.msroot.msutil.interfaces.i_eventbroadcastclient:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_eventbroadcastclient.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:17+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:13+01:00 $ 

      Description: Interface for classes that use sc_eventbroadcaster.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata).

end interface.

/* EOF */
