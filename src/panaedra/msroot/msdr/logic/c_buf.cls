{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msdr.logic.c_buf implements panaedra.msroot.msdr.interfaces.i_buf: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msdr/logic/c_buf.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-10 13:50:22+02:00 $ 
    Date Modified: $Modtime: 2009-10-10 12:15:52+02:00 $ 

      Description: ABL Query Wrapper Class for strong-typed query handle passing.
                   
                   This class is not dependent on sc_datasetpool (but does support 
                   the datasetpool by loose coupling through a broadcastedevent).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_buf(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected variable hBufferPrivate       as handle no-undo.
  define protected variable hBufferOnHoldPrivate as handle no-undo.


  define public property hBuffer as handle no-undo
    get:
      return hBufferPrivate.
    end get.
    set(hBufferIP# as handle): 
      hBufferPrivate = hBufferIP#.
    end set.
  
  define public property oBindingSource as paninui.view.init.display.c_bindingsource no-undo get. set.

  define public property hBufferOnHold as handle no-undo
    get:
      return hBufferOnHoldPrivate.
    end get.
    set(hBufferIP# as handle): 
      hBufferOnHoldPrivate = hBufferIP#.
    end set.
  

  constructor public c_buf(hBufferIP# as handle):
    
    hBuffer = hBufferIP#.

  end constructor.


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

  
  method public override character ToString():
    
    define variable cReturn# as character no-undo.
    
    cReturn# = super:ToString().
    
    if valid-handle(hBuffer) then
      cReturn# = cReturn# + subst("_&1", hBuffer:name).
      
    return cReturn#.
      
  end method. /* ToString */

end class.

/* EOF */ 
