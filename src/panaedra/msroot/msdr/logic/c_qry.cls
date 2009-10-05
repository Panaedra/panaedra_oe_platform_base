{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msdr.logic.c_qry implements panaedra.msroot.msdr.interfaces.i_qry: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msdr/logic/c_qry.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-05 09:49:09+02:00 $ 
    Date Modified: $Modtime: 2009-10-04 23:41:10+02:00 $ 

      Description: Simple class for strong-typed query handle passing

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_qry(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected variable hQueryPrivate       as handle no-undo.
  define protected variable hQueryOnHoldPrivate as handle no-undo.

  define public property hQuery as handle no-undo
    get:
      return hQueryPrivate.
    end get.
    set(hQueryIP# as handle): 
      hQueryPrivate = hQueryIP#.
    end set.
  
  define public property hQueryOnHold as handle no-undo
    get:
      return hQueryOnHoldPrivate.
    end get.
    set(hQueryIP# as handle): 
      hQueryOnHoldPrivate = hQueryIP#.
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

  define public property PrepareString as character no-undo 
    get:
      return if valid-handle(hQuery) then hQuery:prepare-string else "[no_valid_query]".
    end get. /* PrepareString */

  method public logical SetWhere (iBufferIP# as integer, cWhereIP# as character):
    
    define variable cPrep#      as character no-undo.
    define variable iStartPos#  as integer   no-undo.
    define variable iEndPos#    as integer   no-undo.
    define variable cTag#       as character no-undo.
    define variable iTagLength# as integer   no-undo.
    
    /*for each b-qryfull-tt_DATA_ /*[qWhere_001]*/ no-lock, first b-qryfull-tt_DATA_ /*[qWhere_002]*/ of b-qryfull-tt_DATA_ no-lock, first b-qryfull-tt_DATA_Type /*[qWhere_003]*/ of b-qryfull-tt_DATA_ no-lock*/
    if valid-handle(hQuery) then 
    do:

      cPrep# = hQuery:prepare-string.
      if iBufferIP# = ? or iBufferIP# <=0 then iBufferIP# = 1.

      assign
        cTag#       = "/*[qWhere_" + trim(string(iBufferIP#,"999")) + "]*/"
        iTagLength# = length(cTag#)
        iStartPos#  = index(cPrep#, cTag#).
      
      if iStartPos# > 0 then 
      do:
        iEndPos# = 
          index(cPrep#, ",", iStartPos#).
        if iEndPos# = 0 then iEndPos# = length(cPrep#).
        else iEndPos# = iEndPos# - 1.
        
        if substring(cPrep#, iEndPos# - 6, 7) = "no-lock" then iEndPos# = iEndPos# - 7.
        if substring(cPrep#, iEndPos# - 13, 14) = "exclusive-lock" then iEndPos# = iEndPos# - 14.
        
        iStartPos# = iStartPos# + iTagLength#.
        
        /* Put space before and/or after submitted where phrase if necessary */
        if (not cWhereIP# begins " ") and substring(cPrep#, iStartPos# - 1, 1) <> " " then cWhereIP# = " " + cWhereIP#.
        if (not substring(cWhereIP#, length(cWhereIP#),1) = " ") and substring(cPrep#, iEndPos# + 1, 1) <> " " then cWhereIP# = cWhereIP# + " ".

        substring(cPrep#, iStartPos#, max(1,iEndPos# - iStartPos#)) = cWhereIP#.
        
      end.
      
      if cPrep# <> hQuery:prepare-string then 
      do:
        do on error undo, throw:
          hQuery:query-prepare(cPrep#).
          hQuery:query-open().
          /*          hQuery:get-first().*/
          catch e as Progress.Lang.Error :
            undo, throw new panaedra.msex.logic.c__FCMPNY_exception(999500007,substitute("Query where '&1' is invalid.~n&2~n&3", cWhereIP#, cPrep#, e:GetMessage(1))).
          end catch.
        end.
      end.
      
    end.

  end method. /* SetWhere */


  method public void Resync():
    
    /* Resync syncs the local buffers of the OnHold query to the rowid's of the query that's in use.
       Normally these are static buffers, so this method facilitates strong typed source code. 
    */
    
    define variable iTell#  as integer no-undo.
    define variable rRowid# as rowid   no-undo.
    
    if 
      this-object:hQueryOnHold <> ? and 
      this-object:hQueryOnHold <> this-object:hQuery then 
    do:
      
      do iTell# = 1 to this-object:hQueryOnHold:num-buffers:
        
        rRowid# = this-object:hQuery:get-buffer-handle(iTell#):rowid.
        
        if rRowid# = ? then
          this-object:hQueryOnHold:get-buffer-handle(iTell#):buffer-release().
        else
          this-object:hQueryOnHold:get-buffer-handle(iTell#):find-by-rowid(rRowid#, no-lock).
        
      end.
      
    end.

  end method. /* Resync */
  

end class.

/* EOF */ 
