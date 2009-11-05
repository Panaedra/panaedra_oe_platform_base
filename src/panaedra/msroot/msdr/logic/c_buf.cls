{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msdr.logic.c_buf 
  implements 
  panaedra.msroot.msdr.interfaces.i_buf,
  panaedra.msroot.msutil.interfaces.i_eventbroadcastclient: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msdr/logic/c_buf.cls $ 
          Version: $Revision: 8 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-11-05 18:07:59+01:00 $ 
    Date Modified: $Modtime: 2009-11-05 17:46:52+01:00 $ 

      Description: ABL Query Wrapper Class for strong-typed query handle passing.
                   
                   This class is not dependent on sc_datasetpool (but does support 
                   the datasetpool by loose coupling through a broadcastedevent).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_buf(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 8 $', '{&sourcecontrolversions}').
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
  
  /* Unix compatibility isn't complete yet, this is a stub. */  
  &scop BindingSourceType  &if opsys="unix" &then Progress.Lang.Object &else paninui.view.init.display.c_bindingsource &endif 
  
  define public property oBindingSource as {&BindingSourceType} no-undo 
    get. 
    set (oBindingSourceIP# as {&BindingSourceType}):
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

  
  method public void UiRefreshBuffer():
    
    /* Call this method after you've modified data that is displayed
       in the user interface.
           
       This method forces a refresh.
    */
    
    define variable rBuffTempCreate# as rowid no-undo.
    
    if valid-object(oBindingSource) then 
    do:

      &if opsys <> "unix" &then
      if not hBuffer:available then 
      do:
        /* We have to clear the screen values, and we *need* a
           record for that.
           So a dummy record is created, displayed, and deleted.
        */
        hBuffer:buffer-create().
        rBuffTempCreate# = hBuffer:rowid.
      end.
      
      oBindingSource:Refresh().
      &endif

    end.
    
    finally:
      
      /* Remove the dummy temp-table record */
      &if opsys <> "unix" &then
      if rBuffTempCreate# <> ? then 
      do:
        hBuffer:find-by-rowid(rBuffTempCreate#, no-lock).
        hBuffer:buffer-delete().
        hBuffer:buffer-release().
      end.
      &endif
      
    end. /* finally */
    
  end method. /* UiRefreshBuffer */


  method public override character ToString():
    
    define variable cReturn# as character no-undo.
    
    cReturn# = super:ToString().
    
    if valid-handle(hBuffer) then
      cReturn# = cReturn# + subst("_&1", hBuffer:name).
      
    return cReturn#.
      
  end method. /* ToString */


end class.

/* EOF */ 
