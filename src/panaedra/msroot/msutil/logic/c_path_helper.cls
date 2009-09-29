{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msf.logic.c_path_helper   implements i_eventbroadcastclient : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msf/logic/c_path_helper.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-29 11:39:51+02:00 $ 
    Date Modified: $Modtime: 2009-09-29 11:38:38+02:00 $ 

      Description: add_your_comments_here

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_path_helper(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  constructor public c_path_helper():
    
    panaedra.msroot.msutil.logic.sc_eventbroadcaster:SubscribeEvent(this-object,"evt@PropathChanged").

  end constructor.


  method public void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
    if oBroadcastDataIP#:cEventName = "evt@PropathChanged" then
      panaedra.msf.logic.sc_path:SetPropathDirty().
    
  end method.
    
end class.

/* EOF */ 
