{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msdr.logic.c_buf implements panaedra.msroot.msdr.interfaces.i_buf: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msdr/logic/c_buf.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-09 23:01:41+02:00 $ 
    Date Modified: $Modtime: 2009-10-09 15:27:58+02:00 $ 

      Description: ABL Query Wrapper Class for strong-typed query handle passing.
                   
                   This class is not dependent on sc_datasetpool (but does support 
                   the datasetpool by loose coupling through a broadcastedevent).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_buf(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
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


end class.

/* EOF */ 
