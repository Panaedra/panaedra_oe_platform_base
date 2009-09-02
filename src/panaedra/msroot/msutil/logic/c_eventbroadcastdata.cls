{panaedra/msi/logic/ctop_class.i}
using panaedra.msroot.msutil.logic.*.

class panaedra.msroot.msutil.logic.c_eventbroadcastdata  implements i_eventbroadcastdata : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/c_eventbroadcastdata.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-02 16:13:06+02:00 $ 
    Date Modified: $Modtime: 2009-09-02 16:12:51+02:00 $ 

      Description: Data to be transmitted by a broadcasted event.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_eventbroadcastdata(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
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
  
  define public property bAbort as logical   no-undo get. set.
  define public property cEventName as character no-undo get. protected set.
  define public property cData  as character no-undo get. protected set.


end class.

/* EOF */
