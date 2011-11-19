{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
{paninui/logic/includes/preproc_dotnetclasses.i &class=class}

using paninui.view.init.display.*.

using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msdr.logic.*.

class panaedra.msroot.msdr.logic.c_qry implements panaedra.msroot.msdr.interfaces.i_qry:

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msdr/logic/c_qry.cls $ 
          Version: $Revision: 21 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-02-08 08:15:42+01:00 $ 
    Date Modified: $Modtime: 2010-02-06 16:51:15+01:00 $ 

      Description: ABL Query Wrapper Class for strong-typed query handle passing.
                   
                   This class is not dependent on sc_datasetpool (but does support 
                   the datasetpool by loose coupling through broadcasted events).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_qry(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 21 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected variable hQueryPrivate       as handle  no-undo.
  define protected variable hQueryOnHoldPrivate as handle  no-undo.
  define protected variable iNewRowLastPosition as integer no-undo.
  
  define property sys__oParentQry     as panaedra.msroot.msdr.interfaces.i_qry no-undo 
    public get. 
    public set.
    
  define property sys__oBindingSource as c_bindingsource no-undo 
    public get. 
    public set.

  define property iNumResults         as integer no-undo 
    public get:
      return (if valid-handle(hQueryPrivate) then hQueryPrivate:num-results else 0).
    end get. 

  define property iUiRowPosition      as integer no-undo 
    public get:
      define variable oBindingSource# as c_bindingsource no-undo.
      oBindingSource# = GetActiveBindingsource().      
      return (if valid-object(oBindingSource#) then oBindingSource#:Position else 0).
    end get. 
    public set (iValueIP# as integer):
      define variable oBindingSource# as c_bindingsource no-undo.
      oBindingSource# = GetActiveBindingsource().      
      oBindingSource#:Position = iValueIP#.
    end get. 

  define public property sys__hQuery as handle no-undo
    get:
      return hQueryPrivate.
    end get.
    set(hQueryIP# as handle): 
      hQueryPrivate = hQueryIP#.
    end set.
  
  define public property sys__hQueryOnHold as handle no-undo
    get:
      return hQueryOnHoldPrivate.
    end get.
    set(hQueryIP# as handle): 
      hQueryOnHoldPrivate = hQueryIP#.
    end set.
  

  define public property cPrepareString as character no-undo 
    get:
      return if valid-handle(sys__hQuery) then sys__hQuery:prepare-string else "[no_valid_query]".
    end get. /* cPrepareString */


  define public property bIsOpen as logical no-undo 
    get:
      return if valid-handle(sys__hQuery) then sys__hQuery:is-open else ?.
    end get. /* cPrepareString */


  define public property cName as character no-undo 
    get:
      define variable cReturn# as character no-undo.
      if cName > "" then return cName.
      if valid-handle(sys__hQuery) and sys__hQuery:name <> ? then cName = sys__hQuery:name.
      return cName.
    end get. /* cName */
    set(cValueIP# as character):
      cName = cValueIP#.
    end set.

  define public property hDisplayField as handle extent no-undo get. set.
   
  define public property hKeyField     as handle extent no-undo get. set. 

  define public property iNumBuffers   as integer no-undo 
    get:
      return if valid-handle(sys__hQuery) then sys__hQuery:num-buffers else 0.
    end get. /* cPrepareString */


  constructor public c_qry(hQueryIP# as handle):
    
    sys__hQuery = hQueryIP#.

  end constructor.


  method public void PrepareStringGenSimple():
    
    /* Call the static version of this method */
    panaedra.msroot.msdr.logic.c_qry:PrepareStringGenSimpleImplement(hQueryPrivate).

  end method. /* PrepareStringGenSimple */
  

  method protected static void PrepareStringGenSimpleImplement(hQueryIP# as handle):

    /* Generate a simple prepare string using "of" and "first" or "each" statements */
    
    define variable cPrep#           as character no-undo.
    define variable iBuff#           as integer   no-undo.
    define variable iBuffSub#        as integer   no-undo.
    define variable cBuff#           as character no-undo.
    define variable hBuff#           as handle    no-undo.
    define variable hBuffSub#        as handle    no-undo.
    define variable cIDfield#        as character no-undo.
    define variable cFiach#          as character no-undo. /* "first" or "each" */
    define variable hField#          as handle    no-undo.
    define variable iOfBuffer#       as integer   no-undo.
    define variable bOuterJoin#      as logical   no-undo.
    define variable cOfPhraseBuffer# as character no-undo.
    
    do iBuff# = 1 to hQueryIP#:num-buffers:
      
      hBuff# = hQueryIP#:get-buffer-handle(iBuff#).
    
      bOuterJoin#  =   sc_prop:GetProp(hBuff#,"bOuterJoin") = "true".
      if bOuterJoin# = ? then bOuterJoin# = false.
    
      cOfPhraseBuffer# = sc_prop:GetProp(hBuff#,"cOfPhraseBuffer").
      if cOfPhraseBuffer# = ? then cOfPhraseBuffer# = "".
      
      assign
        cBuff# = hBuff#:name.
      
      /* Determine first/each */  
      if iBuff# = 1 then cFiach# = "each".
      else 
      do:
        /* If parent iID is present in previous buffer(s), use first. Else use each. */
        assign
          cFiach#    = ""
          cIDfield#  = "iID" + panaedra.msroot.msutil.logic.sc_dbtrig:GetCased(hBuff#)
          iOfBuffer# = iBuff# - 1.
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
        cBuff# + " no-lock /*[qWhere_" + trim(string(iBuff#,"999")) + "]*/"  + 
        (if iBuff# = 1 then "" else " of " 
        + 
        (if cOfPhraseBuffer# > "" then cOfPhraseBuffer# else
        (if cBuff# begins "ttCalc" or cBuff# matches("*-ttCalc*") then replace(cBuff#,"ttCalc","tt") else hQueryIP#:get-buffer-handle(iOfBuffer#):name)))
        + " " +
        (if bOuterJoin# or cBuff# begins "ttCalc" or cBuff# matches("*-ttCalc*") then "outer-join " else " "). 
        
      cPrep# = right-trim(cPrep#) + " /*[qStartBy]*/".  
      
    end.
    
    do on error undo, throw:
      
      hQueryIP#:query-prepare(cPrep#).
    
      catch e as Progress.Lang.Error :
        panaedra.msroot.msutil.logic.sc_showexception:ShowException(e).
        undo, throw e.
      end catch.
      
    end.

  end method. /* PrepareStringGenSimpleImplement */


  method public logical SetWhere(iBufferIP# as integer, cWhereIP# as character):
    
    /* Call the static version of this method */
    panaedra.msroot.msdr.logic.c_qry:SetWhereImplement(this-object,sys__hQuery,iBufferIP#,cWhereIP#, true).
    
  end method. /* SetWhere */
  

  method public logical SetBy(cByIP# as character):
    
    /* Call the static version of this method */
    panaedra.msroot.msdr.logic.c_qry:SetByImplement(this-object,sys__hQuery, cByIP#).
    
  end method. /* SetBy */
  

  method public logical SetWhere(iBufferIP# as integer, cWhereIP# as character, bQueryOpenIP# as logical):
    
    /* Call the static version of this method */
    panaedra.msroot.msdr.logic.c_qry:SetWhereImplement(this-object,sys__hQuery,iBufferIP#,cWhereIP#, bQueryOpenIP#).
    
  end method. /* SetWhere */
  

  method protected static logical SetWhereImplement(oQryIP# as panaedra.msroot.msdr.logic.c_qry, hQueryIP# as handle, iBufferIP# as integer, cWhereIP# as character, bQueryOpenIP# as logical):
    
    define variable cPrep#      as character no-undo.
    define variable iStartPos#  as integer   no-undo.
    define variable iEndPos#    as integer   no-undo.
    define variable cTag#       as character no-undo.
    define variable iTagLength# as integer   no-undo.
    
    if valid-handle(hQueryIP#) then 
    do:

      cPrep# = hQueryIP#:prepare-string.
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
        if substring(cPrep#, iEndPos# - 13, 14) = "exclusive-lock" then iEndPos# = iEndPos# - 14. /* codeQok#7102 */
        
        iStartPos# = iStartPos# + iTagLength#.
        
        /* Put space before and/or after submitted where phrase if necessary */
        if (not cWhereIP# begins " ") and substring(cPrep#, iStartPos# - 1, 1) <> " " then cWhereIP# = " " + cWhereIP#.
        if (not substring(cWhereIP#, length(cWhereIP#),1) = " ") and substring(cPrep#, iEndPos# + 1, 1) <> " " then cWhereIP# = cWhereIP# + " ".

        substring(cPrep#, iStartPos#, max(1,iEndPos# - iStartPos#)) = cWhereIP#.
        
      end.
      
      if cPrep# <> hQueryIP#:prepare-string then 
      do:
        do on error undo, throw:
          hQueryIP#:query-prepare(cPrep#).
          if bQueryOpenIP# then oQryIP#:QueryOpen().
          catch e as Progress.Lang.Error:
            undo, throw new panaedra.msroot.msutil.logic.c__FCMPNY_exception(999500007,substitute("Query where '&1' is invalid.~n&2~n&3", cWhereIP#, cPrep#, e:GetMessage(1))).
          end catch.
        end.
      end.
      
    end.

  end method. /* SetWhereImplement */


  method protected static logical SetByImplement(oQryIP# as panaedra.msroot.msdr.logic.c_qry, hQueryIP# as handle, cByIP# as character):

    define variable cPrep#      as character no-undo.
    define variable iStartPos#  as integer   no-undo.
    define variable iEndPos#    as integer   no-undo.
    define variable cTag#       as character no-undo.
    define variable iTagLength# as integer   no-undo.
    
    if valid-handle(hQueryIP#) then 
    do:

      cPrep# = hQueryIP#:prepare-string.

      assign
        cTag#       = "/*[qStartBy]*/"
        iTagLength# = length(cTag#)
        iStartPos#  = index(cPrep#, cTag#).
      
      if iStartPos# = 0 then 
      do:
        /* Must be a custom query. Add qStartBy tag to the end of it. */
        assign
          cPrep#     = cPrep# + " /*[qStartBy]*/"
          iStartPos# = index(cPrep#, cTag#).
      end.
      
      if iStartPos# > 0 then 
      do:
        iEndPos# = 
          index(cPrep#, ",", iStartPos#).
        if iEndPos# = 0 then iEndPos# = length(cPrep#).
        else iEndPos# = iEndPos# - 1.
        
        if substring(cPrep#, iEndPos# - 6, 7) = "no-lock" then iEndPos# = iEndPos# - 7.
        if substring(cPrep#, iEndPos# - 13, 14) = "exclusive-lock" then iEndPos# = iEndPos# - 14. /* codeQok#7102 */
        
        iStartPos# = iStartPos# + iTagLength#.
        
        /* Put space before and/or after submitted where phrase if necessary */
        if (not cByIP# begins " ") and substring(cPrep#, iStartPos# - 1, 1) <> " " then cByIP# = " " + cByIP#.
        if (not substring(cByIP#, length(cByIP#),1) = " ") and substring(cPrep#, iEndPos# + 1, 1) <> " " then cByIP# = cByIP# + " ".

        substring(cPrep#, iStartPos#, max(1,iEndPos# - iStartPos#)) = cByIP#.
        
      end.
      
      if cPrep# <> hQueryIP#:prepare-string then 
      do:
        do on error undo, throw:
          hQueryIP#:query-prepare(cPrep#).
          catch e as Progress.Lang.Error:
            undo, throw new panaedra.msroot.msutil.logic.c__FCMPNY_exception(999500008,substitute("Query by '&1' is invalid.~n&2~n&3", cByIP#, cPrep#, e:GetMessage(1))).
          end catch.
        end.
      end.
      
    end.
      
  end method. /* SetByImplement */


  method public void SyncLocal():
    
    /* Call the static version of this method */
    panaedra.msroot.msdr.logic.c_qry:SyncLocalImplement(this-object, sys__hQuery, sys__hQueryOnHold).
    
  end method. /* SyncLocal */


  method protected static void SyncLocalImplement(oQryIP# as panaedra.msroot.msdr.logic.c_qry, hQueryIP# as handle, hQueryOnHoldIP# as handle):
    
    /* SyncLocal syncs the local buffers of the OnHold query to the rowid's of the query that's in use.
       Normally these are static buffers, so this method facilitates strong typed source code. 
    */
    
    define variable iTell#  as integer no-undo.
    define variable rRowid# as rowid   no-undo.
    
    if 
      hQueryOnHoldIP# <> ? and 
      hQueryOnHoldIP# <> hQueryIP# then 
    do:
      
      do iTell# = 1 to hQueryOnHoldIP#:num-buffers:
        
        rRowid# = hQueryIP#:get-buffer-handle(iTell#):rowid.
        
        if rRowid# = ? then
          hQueryOnHoldIP#:get-buffer-handle(iTell#):buffer-release().
        else
          hQueryOnHoldIP#:get-buffer-handle(iTell#):find-by-rowid(rRowid#, no-lock).
        
      end.
      
    end.

  end method. /* SyncLocalImplement */


  method public logical SetPrepareString(ccPrepareStringIP# as character):
    
    /* Simply do a query-prepare, nothing else */
    this-object:sys__hQuery:query-prepare(ccPrepareStringIP#).
    
  end method. /* SetPrepareString */
  

  method public handle GetBuffer(iBufferIP# as integer):
    
    /* Simply give back the buffer handle, nothing else */
    return this-object:sys__hQuery:get-buffer-handle(iBufferIP#).
    
  end method. /* GetBuffer */
  

  method public logical QueryOpen():
    
    return QueryOpen(false).
    
  end method. /* QueryOpen ; parameterless */
  

  method public logical QueryOpenAndReposition():
    
    define variable rReposition# as rowid   no-undo extent 18.
    define variable iTell#       as integer no-undo.
    define variable bReturn#     as logical no-undo.
    
    rReposition# = ?.
    
    do iTell# = 1 to min(sys__hQuery:num-buffers, 18):
      rReposition#[iTell#] = sys__hQuery:get-buffer-handle(iTell#):rowid.
    end.
    
    bReturn# = QueryOpen(false).
    
    if bReturn# and rReposition#[1] <> ? then 
    do:
      sys__hQuery:reposition-to-rowid(rReposition#) no-error.
      if error-status:num-messages > 0 then do:
        sys__hQuery:reposition-to-row(0) no-error.
      end.
      /* 
         Workaround: if the result is 1, sometimes a child buffer is not available. 
         Even if the reposition-to-rowid (2 rowid's) succeeded, get-buffer-handle(2):avail 
         returned false. 
      */
      if sys__hQuery:num-results = 1
      then do:
         bReturn# = QueryOpen(false).
      end.
    end.
    
    return bReturn#.
    
  end method. /* QueryOpenAndReposition */


  method public logical QueryRepositionToBuffers():
    
    define variable rReposition# as rowid   no-undo extent 18.
    define variable iTell#       as integer no-undo.
    define variable bReturn#     as logical no-undo.
    
    rReposition# = ?.
    
    do iTell# = 1 to min(sys__hQuery:num-buffers, 18):
      rReposition#[iTell#] = sys__hQuery:get-buffer-handle(iTell#):rowid.
    end.
    
    if rReposition#[1] <> ? then 
    do:
      bReturn# = true.
      sys__hQuery:reposition-to-rowid(rReposition#) no-error.
      if error-status:num-messages > 0 then do:
        sys__hQuery:reposition-to-row(0) no-error.
      end.
    end.
    
    /* Workaround; always "find" the buffer to the original rowid*/
    do iTell# = 1 to min(sys__hQuery:num-buffers, 18):
      sys__hQuery:get-buffer-handle(iTell#):find-by-rowid(rReposition#[iTell#], no-lock).
    end.

    return bReturn#.
    
  end method. /* QueryRepositionToBuffers */
  

  method public logical QueryOpen(bPointerBeforeFirstIP# as logical):
    
    define variable bReturn# as logical   no-undo.
    define variable cName#   as character no-undo.
    
    sys__hQuery:query-open().
    sys__hQuery:get-first().
    bReturn# = not sys__hQuery:query-off-end.
    
    if bReturn# and bPointerBeforeFirstIP# then sys__hQuery:get-prev().
    
    /* Fire a broad scope event, for sc_coll_*.cls */
    sc_eventbroadcaster:FireEvent("evt@c_qry@queryopen", this-object).
    
    cName# = cName.
    if cName# > "" then 
    do:
      /* Fire an event with a smaller scope, for custom logic procedures.
         The query name should include a pack id or other scope identifier,
         i.e.: qXyZoner@000001.
       */
      sc_eventbroadcaster:FireEvent(subst("evt@c_qry@queryopen@&1", cName#), this-object).
    end.
    
    return bReturn#.

  end method. /* QueryOpen ; optionally set the pointer before the first record  */
  

  method public logical QueryOpen(cPrepareStringIP# as character, bPointerBeforeFirstIP# as logical):
    
    SetPrepareString(cPrepareStringIP#).
    
    return QueryOpen(bPointerBeforeFirstIP#).

  end method. /* QueryOpen ; with a full (custom) prepare string + optionally set the pointer before the first record */
  

  method public logical QueryOpen(cPrepareStringIP# as character):
    
    SetPrepareString(cPrepareStringIP#).
    
    /* Note: If a custom prepare string is given, you normally want
             to have the pointer before the first record, so you can
             use GetNext immediately. So (true) is used below.
             This differs from the parameterless QueryOpen() method,
             which you normally use for refreshing changed data.
    */
    
    return QueryOpen(true).

  end method. /* QueryOpen ; with a full (custom) prepare string */
  

  method public void QueryClose():
    
    /* Note that the used query is closed. This query can span
       multiple frame logic objects. Reopen it after you're done.
     */
    
    sys__hQuery:query-close().
    sc_eventbroadcaster:FireEvent("evt@c_qry@queryclose", this-object).
    
  end method. /* QueryClose */
  

  method public logical GetPrev():
    
    sys__hQuery:get-prev().
    sc_eventbroadcaster:FireEvent("evt@c_qry@querygetprev", this-object).
    return not sys__hQuery:query-off-end.
    
  end method. /* QueryGetPrev */
  

  method public logical GetNext():
    
    sys__hQuery:get-next().
    sc_eventbroadcaster:FireEvent("evt@c_qry@querygetnext", this-object).
    return not sys__hQuery:query-off-end.
    
  end method. /* QueryGetNext */
  

  method public logical QueryOffEnd():
    
    return sys__hQuery:query-off-end.
    
  end method. /* QueryOffEnd */


  method public static panaedra.msroot.msdr.interfaces.i_qry CreateClone(
    
    /* Use this method to create a clone of a i_qry object.
    
       The *same* buffers are used, so the original i_qry object
       should be closed (using CloseQuery()).
       
       The difference is, that no databinding is attached,
       so you can walk this clone without worrying about
       screen updates.
       
       Delete the clone after you're done with it.
       
       Since the same buffers are used, the clone doesn't have
       to be registered at the datasetpool.

    */
    
    oQryIP# as panaedra.msroot.msdr.interfaces.i_qry):
    
    return CreateClone(oQryIP#, "").
    
  end method.
  

  method public static panaedra.msroot.msdr.interfaces.i_qry CreateClone(
    
    /* Use this method to create a clone of a i_qry object.

       == [Start] in SlaveMode ==

       The original buffers of the oQryForBuffersIP# are used, 
       so the original i_qry object doesn't have to be closed if 
       you're not the initiator of this query (meaning: you are just 
       some extra framelogic that acts as a slave to an already 
       initiated query).
       
       == [End] in SlaveMode ==
       
       See simple overload above for more comment (when "" is used, the default mode.).
       
    */
    
    oQryIP#  as panaedra.msroot.msdr.interfaces.i_qry,
    cModeIP# as character): /* Allowed: "" or "SlaveMode" */
    
    define variable oReturn# as panaedra.msroot.msdr.interfaces.i_qry no-undo.
    define variable hQuery#  as handle                             no-undo.
    define variable iTell#   as integer                            no-undo.
    
    create query hQuery#.
    
    case cModeIP#:
      
      when "" then 
        do iTell# = 1 to oQryIP#:iNumBuffers:
          hQuery#:add-buffer(oQryIP#:GetBuffer(iTell#)).
        end.
        
      when "SlaveMode" then 
        /* Use the "on hold" buffers for the query; it's requested. */
        do iTell# = 1 to oQryIP#:iNumBuffers:
          hQuery#:add-buffer(oQryIP#:sys__hQueryOnHold:get-buffer-handle(iTell#)).
        end.

      otherwise 
      undo, throw new panaedra.msroot.msutil.logic.c__FCMPNY_exception(99950248,subst("Invalid value of cModeIP#: '&1'", cModeIP#)).
      
    end case. /* cModeIP# */
    
    hQuery#:query-prepare(oQryIP#:cPrepareString).
    
    oReturn# = new panaedra.msroot.msdr.logic.c_qry(hQuery#).
    
    /* Resync on the clone should do the same as resync on the original.
       This is accomplished by hQueryOnHold, which has the local buffers 
       but is not active or used itself. We can synchronize the local buffers
       to the active query, which can be in a different frame logic
       object with buffers who are normally static but can be dynamic.
     */
     
    oReturn#:sys__hQueryOnHold = oQryIP#:sys__hQueryOnHold.
    
    return oReturn#.

  end method. /* CreateClone */

  
  method public void UiRefreshRecord():
    
    define variable oBindingSource# as c_bindingsource no-undo.
    
    oBindingSource# = GetActiveBindingsource().
    
    if valid-object(oBindingSource#) then 
      oBindingSource#:Refresh().

  end method. /* UiRefreshRecord ; no parameters */

  
  method public void UiRefreshRecord(iRowIP# as integer):
    
    define variable oBindingSource# as c_bindingsource no-undo.
    
    oBindingSource# = GetActiveBindingsource().
    
    if valid-object(oBindingSource#) then 
      oBindingSource#:Refresh(iRowIP#).

  end method. /* UiRefreshRecord ; + row entry in the query */


  method public void UiRefreshAll():
    
    UiRefreshAllImplement("").
    
  end method. /* UiRefreshAll */

  
  method public void UiRefreshAll(cOptionIP# as character):

    UiRefreshAllImplement(cOptionIP#).
    
  end method. /* UiRefreshAll */
  

  method protected void UiRefreshAllImplement(cOptionIP# as character):
    
    
    define variable oBindingSource# as c_bindingsource no-undo.
    define variable iUiRowPosition# as integer         no-undo.
    
    oBindingSource# = GetActiveBindingsource().
    
    if oBindingSource# <> ? then 
    do:
      if cOptionIP# = "keep_uirowposition" then iUiRowPosition# = iUiRowPosition.
      oBindingSource#:RefreshAll().
      if cOptionIP# = "keep_uirowposition" then iUiRowPosition = iUiRowPosition#.
    end.

    catch ex as Progress.Lang.Error:
      sc_showexception:ShowException(ex).
    end catch.

  end method. /* UiRefreshAll */


  method public c_bindingsource GetActiveBindingsource():
    
    define variable oBindingSource# as c_bindingsource no-undo.
    
    if valid-object(sys__oBindingSource) then 
      oBindingSource# = sys__oBindingSource.
    else 
    do:
      if    valid-object(sys__oParentQry) 
        and valid-object(sys__oParentQry:sys__oBindingSource)
        then 
        oBindingSource# = sys__oParentQry:sys__oBindingSource.
    end.
    return oBindingSource#.
  
  end method. /* GetActiveBindingsource */


  method public void UiAddNewRow():
    
    define variable oBindingSource# as c_bindingsource no-undo.
    
    oBindingSource# = GetActiveBindingsource().

    if valid-object(oBindingSource#) then 
    do:
      if not oBindingSource#:NewRow then iNewRowLastPosition = oBindingSource#:Position.
      oBindingSource#:AddNew().
    end.

  end method. /* UiAddNewRow */
  

  method public void UiDeleteNewRow():
    
    define variable oBindingSource# as c_bindingsource no-undo.
    
    oBindingSource# = GetActiveBindingsource().

    if valid-object(oBindingSource#) then 
    do:
      if oBindingSource#:NewRow then 
      do:
        oBindingSource#:CancelEdit(). /* That's enough for i.e. bound DataGridViews */
        oBindingSource#:Position = iNewRowLastPosition.
      end.
    end.

  end method. /* UiDeleteNewRow */
  

  method public void UiResetCurrentItem():
    
    define variable oBindingSource# as c_bindingsource no-undo.
    
    oBindingSource# = GetActiveBindingsource().

    if valid-object(oBindingSource#) then 
    do:
      oBindingSource#:ResetCurrentItem().
      /* Fire a broad scope event, for sc_coll_*.cls */
      sc_eventbroadcaster:FireEvent("evt@c_qry@UiResetCurrentItem", this-object).
    end.

  end method. /* UiResetCurrentItem */
  

  destructor c_qry():
    
    assign
      extent(hDisplayField) = ?
      extent(hKeyField)     = ?. 

    if valid-handle(sys__hQuery) and sys__hQuery:dynamic then delete object sys__hQuery.

  end destructor.

end class.

/* EOF */ 
