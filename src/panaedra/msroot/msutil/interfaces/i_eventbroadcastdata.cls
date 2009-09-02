{panaedra/msi/logic/ctop_interface.i}
interface panaedra.msroot.msutil.logic.i_eventbroadcastdata:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/i_eventbroadcastdata.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-02 16:13:06+02:00 $ 
    Date Modified: $Modtime: 2009-09-02 16:12:51+02:00 $ 

      Description: Interface for custom eventbroadcastdata.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property bAbort     as logical   no-undo get. set.
  define property cEventName as character no-undo get.
  define property cData      as character no-undo get.

  
end interface.

/* EOF */
