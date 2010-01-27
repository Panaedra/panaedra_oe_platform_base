{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.c_path_helper   implements i_eventbroadcastclient : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/c_path_helper.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:40:12+01:00 $ 

      Description: add_your_comments_here

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_path_helper(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  constructor public c_path_helper():
    
    panaedra.msroot.msutil.logic.sc_eventbroadcaster:SubscribeEvent(this-object,"evt@PropathChanged").

  end constructor.


  method public void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
    if oBroadcastDataIP#:cEventName = "evt@PropathChanged" then
      panaedra.msroot.msutil.logic.sc_path:SetPropathDirty().
    
  end method.
    
end class.

/* EOF */ 
