{panaedra/msi/logic/ctop_class.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.c_eventbroadcastdata  implements i_eventbroadcastdata : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/c_eventbroadcastdata.cls $ 
          Version: $Revision: 7 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-11 10:21:07+01:00 $ 
    Date Modified: $Modtime: 2010-01-10 22:31:35+01:00 $ 

      Description: Data to be transmitted by a broadcasted event.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_eventbroadcastdata(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 7 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define public property cEventName   as character            no-undo get. protected set. /* Name of the broadcasted event. */
  define public property cData        as character            no-undo get. protected set. /* For custom use. */
  define public property oData        as Progress.Lang.Object no-undo get. protected set. /* For custom use. */
  define public property cReturnData  as character            no-undo get. public set.    /* For custom use. */
  define public property oReturnData  as Progress.Lang.Object no-undo get. public set.    /* For custom use. */
  define public property iAbort       as integer              no-undo get. set.           /* 9990000+ ; 0 means no abort. Put errorno in msg record in live environment. */
  define public property cAbortReason as character            no-undo get. set.           /* i.e. "User &1 is not authorized for &2. [cUser,cPermissionDesc]" */


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
  
  
  constructor public c_eventbroadcastdata(cEventNameIP# as character, oDataIP# as Progress.Lang.Object, cDataIP# as character):
    assign
      this-object:cEventName = cEventNameIP#
      this-object:oData      = oDataIP#
      this-object:cData      = cDataIP#.
  end constructor.
  
end class.

/* EOF */
