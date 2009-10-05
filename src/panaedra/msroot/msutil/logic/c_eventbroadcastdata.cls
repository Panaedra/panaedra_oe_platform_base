{panaedra/msi/logic/ctop_class.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.c_eventbroadcastdata  implements i_eventbroadcastdata : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/c_eventbroadcastdata.cls $ 
          Version: $Revision: 5 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-05 14:48:49+02:00 $ 
    Date Modified: $Modtime: 2009-10-05 10:55:14+02:00 $ 

      Description: Data to be transmitted by a broadcasted event.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_eventbroadcastdata(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 5 $', '{&sourcecontrolversions}').
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

  
  constructor public c_eventbroadcastdata(cEventNameIP# as character, oDataIP# as Progress.Lang.Object):
    assign
      this-object:cEventName = cEventNameIP#
      this-object:oData      = oDataIP#.
  end constructor.
  
  
  define public property cEventName   as character            no-undo get. protected set. /* Name of the broadcasted event. */
  define public property cData        as character            no-undo get. protected set. /* For custom use. */
  define public property oData        as Progress.Lang.Object no-undo get. protected set. /* For custom use. */
  define public property iAbort       as integer              no-undo get. set.           /* 9990000+ ; 0 means no abort. Put errorno in msg record in live environment. */
  define public property cAbortReason as character            no-undo get. set.           /* i.e. "User &1 is not authorized for &2. [cUser,cPermissionDesc]" */


end class.

/* EOF */
