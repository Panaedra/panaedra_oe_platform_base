{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msdr.logic.c_buf 
  implements 
  panaedra.msroot.msdr.interfaces.i_buf,
  panaedra.msroot.msutil.interfaces.i_eventbroadcastclient: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msdr/logic/c_buf.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-15 10:00:46+02:00 $ 
    Date Modified: $Modtime: 2009-10-14 12:09:09+02:00 $ 

      Description: ABL Query Wrapper Class for strong-typed query handle passing.
                   
                   This class is not dependent on sc_datasetpool (but does support 
                   the datasetpool by loose coupling through a broadcastedevent).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_buf(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 4 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected variable hBufferPrivate       as handle no-undo.
  define protected variable hBufferOnHoldPrivate as handle no-undo.
  
  define protected static temp-table ttUsedBindingsources no-undo rcode-info
    field oBuf           as Progress.Lang.Object
    field oBindingSource as Progress.Lang.Object
    index oBuf is primary unique oBuf
    index oBindingSource         oBindingSource.

  define public property hBuffer as handle no-undo
    get:
      return hBufferPrivate.
    end get.
    set(hBufferIP# as handle): 
      hBufferPrivate = hBufferIP#.
    end set.
  
  define public property oBindingSource as paninui.view.init.display.c_bindingsource no-undo get. 
    set (oBindingSourceIP# as paninui.view.init.display.c_bindingsource ):
      define variable bEclipseFix# as logical no-undo.
      define buffer b-ttUsedBindingsources for ttUsedBindingsources.
      if oBindingSource = ? then 
      do:
        oBindingSource = oBindingSourceIP#.
        create b-ttUsedBindingsources.
        assign 
          b-ttUsedBindingsources.oBuf           = this-object
          b-ttUsedBindingsources.oBindingSource = oBindingSourceIP#.
      end.
    end set.

  define public property hBufferOnHold as handle no-undo
    get:
      return hBufferOnHoldPrivate.
    end get.
    set(hBufferIP# as handle): 
      hBufferOnHoldPrivate = hBufferIP#.
    end set.
  

  constructor public c_buf(hBufferIP# as handle):
    
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@CleanAllBindingSources").
    hBuffer = hBufferIP#.

  end constructor.
  

  destructor c_buf():
    
    DoCleanupBindingSource ().
      
  end destructor.


  method public void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
    case oBroadcastDataIP#:cEventName:
      
      when "evt@CleanAllBindingSources" then 
        do:
          DoCleanupBindingSource().
        end.
        
    end case.
    
  end method. /* OnEventBroadcast */
  

  method public void DoCleanupBindingSource():

    define variable bEclipseFix# as logical no-undo.
    define buffer b-ttUsedBindingsources       for ttUsedBindingsources.
    define buffer b-other-ttUsedBindingsources for ttUsedBindingsources.

    find first b-ttUsedBindingsources
      where b-ttUsedBindingsources.oBuf = this-object
      no-error.
      
    if avail b-ttUsedBindingsources then 
    do:
      if valid-object(b-ttUsedBindingsources.oBindingSource) then 
      do:
        find first b-other-ttUsedBindingsources where rowid(b-other-ttUsedBindingsources) <> rowid(b-ttUsedBindingsources)
          and b-other-ttUsedBindingsources.oBindingSource = b-ttUsedBindingsources.oBindingSource
          no-error.
        if not avail b-other-ttUsedBindingsources then 
        do:
          /* This buffer is the last one to use this bindingsource, so clean it up. */
          delete object b-ttUsedBindingsources.oBindingSource.
        end.
      end.
      delete b-ttUsedBindingsources.
    end.

  end method. /* DoCleanupBindingSource */  
  

  method public void Resync():
    
    /* Call the static version of this method */
    panaedra.msroot.msdr.logic.c_buf:Resync(this-object).
    
  end method. /* Resync */


  method public static void Resync(oBuffIP# as panaedra.msroot.msdr.logic.c_buf):
    
    /* Resync syncs the local OnHold buffer to the rowid  of the buffer that's in use.
       Normally these are static buffers, so this method facilitates strong typed source code. 
    */
    
    define variable rRowid# as rowid no-undo.
    
    if 
      oBuffIP#:hBufferOnHold <> ? and 
      oBuffIP#:hBufferOnHold <> oBuffIP#:hBuffer then 
    do:
      
      rRowid# = oBuffIP#:hBuffer:rowid.
        
      if rRowid# = ? then
        oBuffIP#:hBufferOnHold:buffer-release().
      else
        oBuffIP#:hBufferOnHold:find-by-rowid(rRowid#, no-lock).
      
    end.

  end method. /* Resync */

  
  method public void RefreshBindings():
    
    if valid-object(oBindingSource) then 
    do:
      oBindingSource:Refresh().
    end.
    
  end method. /* RefreshBindings */


  method public override character ToString():
    
    define variable cReturn# as character no-undo.
    
    cReturn# = super:ToString().
    
    if valid-handle(hBuffer) then
      cReturn# = cReturn# + subst("_&1", hBuffer:name).
      
    return cReturn#.
      
  end method. /* ToString */


end class.

/* EOF */ 
