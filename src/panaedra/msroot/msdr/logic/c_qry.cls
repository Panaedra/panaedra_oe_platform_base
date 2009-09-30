{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msdr.logic.c_qry implements panaedra.msroot.msdr.interfaces.i_qry: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msdr/logic/c_qry.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-30 13:41:55+02:00 $ 
    Date Modified: $Modtime: 2009-09-30 13:40:17+02:00 $ 

      Description: Simple class for strong-typed query handle passing

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_qry(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected variable hQueryPrivate as handle no-undo.

  define public property hQuery as handle no-undo
    get:
      return hQueryPrivate.
    end get.
    set(hQueryIP# as handle): 
      hQueryPrivate = hQueryIP#.
    end set.
  
  constructor public c_qry(hQueryIP# as handle):
    
    hQuery = hQueryIP#.

  end constructor.


  method public void PrepareStringSimpleGen():
    
    panaedra.msroot.msdr.logic.c_qry:PrepareStringSimpleGen(hQueryPrivate).

  end method. /* PrepareStringSimpleGen */
  

  method public static void PrepareStringSimpleGen (hQueryIP# as handle):

    /* Generate a simple prepare string using "of" and "first" or "each" statements */
    
    define variable cPrep#    as character no-undo.
    define variable iBuff#    as integer   no-undo.
    define variable iBuffSub# as integer   no-undo.
    define variable cBuff#    as character no-undo.
    define variable hBuff#    as handle    no-undo.
    define variable hBuffSub# as handle    no-undo.
    define variable cIDfield# as character no-undo.
    define variable cFiach#   as character no-undo.
    define variable hField#   as handle    no-undo.
    
    do iBuff# = 1 to hQueryIP#:num-buffers:
      
      hBuff# = hQueryIP#:get-buffer-handle(iBuff#).
      
      assign
        cBuff# = hBuff#:name.
      
      /* Determine first/each */  
      if iBuff# = 1 then cFiach# = "each".
      else 
      do:
        /* If parent iID is present in previous buffer(s), use first. Else use each. */
        assign
          cFiach#   = ""
          cIDfield# = "iID" + panaedra.msdr.logic.sc_dbtrig:GetCased(hBuff#).
        if cIDfield# > "" then
        b_BuffSub:
        do iBuffSub# = 1 to iBuff# - 1:
          hBuffSub# = hQueryIP#:get-buffer-handle(iBuffSub#).
          hField# =  hBuffSub#:buffer-field(cIDfield#) no-error.
          if hField# <> ? then 
          do:
            cFiach# = "first".
            leave b_BuffSub.
          end.
        end.
        if cFiach# = "" then cFiach# = "each".
      end.
      
      /* Generate the prepare string */
      cPrep# = 
        cPrep# + (if iBuff# = 1 then "for " else ", ") + cFiach# + " " +
        cBuff# + " /*[qWhere_" + trim(string(iBuff#,"999")) + "]*/"  + 
        (if iBuff# = 1 then "" else " of " + hQueryIP#:get-buffer-handle(iBuff# - 1):name) + 
        " no-lock". 
        
    end.
    
    do on error undo, throw:
    
      hQueryIP#:query-prepare(cPrep#).
    
      catch e as Progress.Lang.Error :
        panaedra.msex.logic.sc_showexception-win32:ShowException(e).
        undo, throw e.
      end catch.
      
    end.

  end method. /* PrepareStringSimpleGen */
  

end class.

/* EOF */ 
