{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.c_path_helper   implements i_eventbroadcastclient : 

  /****************************** Source Header ********************************\

      Description: Helper class for propath changed

  \*****************************  Include Files ********************************/

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
