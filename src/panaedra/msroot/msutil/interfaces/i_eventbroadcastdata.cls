{panaedra/msroot/msutil/logic/top_i/ctop_interface.i}
interface panaedra.msroot.msutil.interfaces.i_eventbroadcastdata:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_eventbroadcastdata.cls $ 
          Version: $Revision: 6 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:17+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:11+01:00 $ 

      Description: Interface for custom eventbroadcastdata.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property cEventName   as character            no-undo get.      /* Name of the broadcasted event. */
  define property cData        as character            no-undo get.      /* For custom use. */
  define property oData        as Progress.Lang.Object no-undo get.      /* For custom use. */
  define property cReturnData  as character            no-undo get. set. /* For custom use. */
  define property oReturnData  as Progress.Lang.Object no-undo get. set. /* For custom use. */
  define property iAbort       as integer              no-undo get. set. /* 9990000+ ; 0 means no abort. Put errorno in msg record in live environment. */
  define property cAbortReason as character            no-undo get. set. /* i.e. "User &1 is not authorized for &2. [cUser,cPermissionDesc]" */

end interface.

/* EOF */
