{panaedra/msi/logic/ctop_class.i}
using panaedra.msroot.msutil.logic.*.

class panaedra.msroot.msutil.logic.c_eventbroadcastdata  implements i_eventbroadcastdata : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/c_eventbroadcastdata.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-23 12:21:00+02:00 $ 
    Date Modified: $Modtime: 2009-09-22 08:17:40+02:00 $ 

      Description: Data to be transmitted by a broadcasted event.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_eventbroadcastdata(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  constructor public c_eventbroadcastdata(cEventNameIP# as character):
    assign
      this-object:cEventName = cEventNameIP#.
  end constructor.
  
  
  constructor public c_eventbroadcastdata(cEventNameIP# as character, cDataIP# as character):
    assign
      this-object:cEventName = cEventNameIP#
      this-object:cData      = cDataIP#.
  end constructor.
  
  
  define public property cEventName   as character no-undo get. protected set. /* Name of the broadcasted event. */
  define public property cData        as character no-undo get. protected set. /* For custom use. */
  define public property iAbort       as integer   no-undo get. set.           /* 9990000+ ; 0 means no abort. Put errorno in msg record in live environment. */
  define public property cAbortReason as character no-undo get. set.           /* i.e. "User &1 is not authorized for &2. [cUser,cPermissionDesc]" */


end class.

/* EOF */
