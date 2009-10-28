{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msdr.logic.c_qry implements panaedra.msroot.msdr.interfaces.i_qry: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msdr/logic/c_qry.cls $ 
          Version: $Revision: 7 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-28 14:15:58+01:00 $ 
    Date Modified: $Modtime: 2009-10-28 13:19:07+01:00 $ 

      Description: ABL Query Wrapper Class for strong-typed query handle passing.
                   
                   This class is not dependent on sc_datasetpool (but does support 
                   the datasetpool by loose coupling through a broadcastedevent).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_qry(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 7 $', '{&sourcecontrolversions}').
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
  

  define public property PrepareString as character no-undo 
    get:
      return if valid-handle(hQuery) then hQuery:prepare-string else "[no_valid_query]".
    end get. /* PrepareString */


  constructor public c_qry(hQueryIP# as handle):
    
    hQuery = hQueryIP#.

  end constructor.


  method public void PrepareStringSimpleGen():
    
    /* Call the static version of this method */
    panaedra.msroot.msdr.logic.c_qry:PrepareStringSimpleGenImplement(hQueryPrivate).

  end method. /* PrepareStringSimpleGen */
  

  method public static void PrepareStringSimpleGenImplement(hQueryIP# as handle):

    /* Generate a simple prepare string using "of" and "first" or "each" statements */
    
    define variable cPrep#     as character no-undo.
    define variable iBuff#     as integer   no-undo.
    define variable iBuffSub#  as integer   no-undo.
    define variable cBuff#     as character no-undo.
    define variable hBuff#     as handle    no-undo.
    define variable hBuffSub#  as handle    no-undo.
    define variable cIDfield#  as character no-undo.
    define variable cFiach#    as character no-undo. /* first or each */
    define variable hField#    as handle    no-undo.
    define variable iOfBuffer# as integer   no-undo.
    
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
          cFiach#    = ""
          cIDfield#  = "iID" + panaedra.msdr.logic.sc_dbtrig:GetCased(hBuff#)
          iOfBuffer# = iBuff# - 1.
        if cIDfield# > "" then
        b_BuffSub:
        do iBuffSub# = 1 to iBuff# - 1:
          hBuffSub# = hQueryIP#:get-buffer-handle(iBuffSub#).
          hField# =  hBuffSub#:buffer-field(cIDfield#) no-error.
          if hField# <> ? then 
          do:
            assign
              iOfBuffer# = iBuffSub#
              cFiach#    = "first".
            leave b_BuffSub.
          end.
        end.
        if cFiach# = "" then cFiach# = "each".
      end.
      
      /* Generate the prepare string */
      cPrep# = 
        cPrep# + (if iBuff# = 1 then "for " else ", ") + cFiach# + " " +
        cBuff# + " /*[qWhere_" + trim(string(iBuff#,"999")) + "]*/"  + 
        (if iBuff# = 1 then "" else " of " 
        + 
        (if cBuff# begins "ttCalc" or cBuff# matches("*-ttCalc*") then replace(cBuff#,"ttCalc","tt") else hQueryIP#:get-buffer-handle(iOfBuffer#):name))
         + 
        " no-lock " +
        (if cBuff# begins "ttCalc" or cBuff# matches("*-ttCalc*") then "outer-join " else ""). 
      
    end.
    
    do on error undo, throw:
    
      hQueryIP#:query-prepare(cPrep#).
    
      catch e as Progress.Lang.Error :
        panaedra.msex.logic.sc_showexception:ShowException(e).
        undo, throw e.
      end catch.
      
    end.

  end method. /* PrepareStringSimpleGenImplement */


  method public logical SetWhere(iBufferIP# as integer, cWhereIP# as character):
    
    /* Call the static version of this method */
    panaedra.msroot.msdr.logic.c_qry:SetWhereImplement(this-object,iBufferIP#,cWhereIP#).
    
  end method. /* SetWhere */
  

  method public static logical SetWhereImplement(oQryIP# as panaedra.msroot.msdr.logic.c_qry, iBufferIP# as integer, cWhereIP# as character):
    
    define variable cPrep#      as character no-undo.
    define variable iStartPos#  as integer   no-undo.
    define variable iEndPos#    as integer   no-undo.
    define variable cTag#       as character no-undo.
    define variable iTagLength# as integer   no-undo.
    
    /*for each b-qryfull-tt_DATA_ /*[qWhere_001]*/ no-lock, first b-qryfull-tt_DATA_ /*[qWhere_002]*/ of b-qryfull-tt_DATA_ no-lock, first b-qryfull-tt_DATA_Type /*[qWhere_003]*/ of b-qryfull-tt_DATA_ no-lock*/
    if valid-handle(oQryIP#:hQuery) then 
    do:

      cPrep# = oQryIP#:hQuery:prepare-string.
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
      
      if cPrep# <> oQryIP#:hQuery:prepare-string then 
      do:
        do on error undo, throw:
          oQryIP#:hQuery:query-prepare(cPrep#).
          oQryIP#:hQuery:query-open().
          sc_eventbroadcaster:FireEvent("evt@c_qry@queryopen", oQryIP#).
          catch e as Progress.Lang.Error:
            undo, throw new panaedra.msex.logic.c__FCMPNY_exception(999500007,substitute("Query where '&1' is invalid.~n&2~n&3", cWhereIP#, cPrep#, e:GetMessage(1))).
          end catch.
        end.
      end.
      
    end.

  end method. /* SetWhereImplement */


  method public void Resync():
    
    /* Call the static version of this method */
    panaedra.msroot.msdr.logic.c_qry:ResyncImplement(this-object).
    
  end method. /* Resync */


  method public static void ResyncImplement(oQryIP# as panaedra.msroot.msdr.logic.c_qry):
    
    /* Resync syncs the local buffers of the OnHold query to the rowid's of the query that's in use.
       Normally these are static buffers, so this method facilitates strong typed source code. 
    */
    
    define variable iTell#  as integer no-undo.
    define variable rRowid# as rowid   no-undo.
    
    if 
      oQryIP#:hQueryOnHold <> ? and 
      oQryIP#:hQueryOnHold <> oQryIP#:hQuery then 
    do:
      
      do iTell# = 1 to oQryIP#:hQueryOnHold:num-buffers:
        
        rRowid# = oQryIP#:hQuery:get-buffer-handle(iTell#):rowid.
        
        if rRowid# = ? then
          oQryIP#:hQueryOnHold:get-buffer-handle(iTell#):buffer-release().
        else
          oQryIP#:hQueryOnHold:get-buffer-handle(iTell#):find-by-rowid(rRowid#, no-lock).
        
      end.
      
    end.

  end method. /* ResyncImplement */


  method public logical QueryOpen():
    
    hQuery:query-open().
    hQuery:get-first().
    sc_eventbroadcaster:FireEvent("evt@c_qry@queryopen", this-object).
    return hQuery:query-off-end.
    
  end method. /* QueryOpen */
  

  method public logical QueryGetPrev():
    
    hQuery:get-prev().
    sc_eventbroadcaster:FireEvent("evt@c_qry@querygetprev", this-object).
    return hQuery:query-off-end.
    
  end method. /* QueryGetPrev */
  

  method public logical QueryGetNext():
    
    hQuery:get-next().
    sc_eventbroadcaster:FireEvent("evt@c_qry@querygetnext", this-object).
    return hQuery:query-off-end.
    
  end method. /* QueryGetNext */
  
end class.

/* EOF */ 
