{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.


class panaedra.msroot.msutil.logic.sc_dbtrig   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_dbtrig.cls $ 
          Version: $Revision: 11 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 20:21:25+01:00 $ 

      Description: Deze class wordt aangeroepen door db delete en write triggers,
                   voor dynamische afhandeling.
                   
                   Moet ook geschikt zijn voor temp-tables; kan gebruikt
                   worden vanaf de UI layer of een db-loze AppServer.
                   In dat geval worden negatieve ID nummers uitgedeeld.
                   
                   Op de db server wordt in de echte tabel een positief 
                   ID nummer uitgedeeld.
                   
                   cGUID* wordt bij de aanmaak van de table óf temp-table gevuld.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_dbtrig(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 11 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected static variable iNewID       as int64 no-undo.
  define protected static variable bInitialized as log   no-undo.
  define protected static variable bDbLayer     as log   no-undo.

  
  define protected static temp-table ttCacheLabels no-undo
    field cTable as char
    field cLabel as char
    index cTable is primary unique cTable.
  
  define protected static temp-table ttCacheLogicLocations no-undo
    field cTable as char
    field cType  as char init "wri"
    field cLogic as char init "<none>"
    index cTable_cType_cLogic is primary unique cTable cType cLogic.
  

  method public static logical OnWriteOrCreate (hBuffIP# as handle):
    
    /* Gebruik de overload handle,handle,handle vanaf db triggers.
       Deze method is only voor temp-tables. 
     */

    define variable hBuffDummy# as handle no-undo.

    OnWriteOrCreate(hBuffIP#, hBuffDummy#, hBuffDummy#).

  end method. /* OnWriteOrCreate */


  method public static void SetKeyFields (hBuffInputIP# as handle, cCasedIP# as char):
    
    /*
    
    Vult only de key fields, en de dtmMod* en dtmCre* velden.
    Roept geen validatie logica aan, only vullen van velden.
    Wordt ook extern aangeroepen, bv vanaf sc_buffercopy:CopyKey.
    
    */

    define variable hField# as handle no-undo.

    /* Fields */
        
    hField# = hBuffInputIP#:buffer-field("cGUID" + cCasedIP#) no-error.
    
    if hField# <> ? then 
    do:
      if hField#:buffer-value > "" then. /* not "" or ? */
      else hField#:buffer-value = NewGUID().
    end. 
    
    
    hField# = hBuffInputIP#:buffer-field("iID" + cCasedIP#) no-error.
    
    if hField# <> ? then 
    do:
      if hField#:buffer-value = ? or hField#:buffer-value <= 0 then 
      do:
        if 
          (/* echte tabellen krijgen altijd een nieuw ID */
          if hBuffInputIP#:table-handle = ? then true
        /* temp-tables mogen negatief ID behouden, maar ? of 0 krijgt nieuw ID. */ 
        else (hField#:buffer-value = ? or hField#:buffer-value = 0))
          then hField#:buffer-value = NewID(hBuffInputIP#, cCasedIP#).
      end.
    end.
    

    hField# = hBuffInputIP#:buffer-field("dtmMod" + cCasedIP#) no-error.
    
    if hField# <> ? then 
    do:
      hField#:buffer-value = now.
    end.
    

    hField# = hBuffInputIP#:buffer-field("dtmCre" + cCasedIP#) no-error.
    
    if hField# <> ? then 
    do:
      if hField#:buffer-value = ? then hField#:buffer-value = now.
    end.

  end method. /* SetKeyFields */


  method public static logical OnWriteOrCreate (hBuffIP# as handle, hBuffNewIP# as handle, hBuffOldIP# as handle):

    /* Vul ID indien niet gevuld (negatief bij temp-table). 
       Vul cGUID* indien niet gevuld. 
       Vul dtmCre* indien niet gevuld. 
       Vul dtmMod* altijd. */
    
    define variable hField#     as handle    no-undo.
    define variable cCased#     as character no-undo.
    define variable hBuffInput# as handle    no-undo.
    
    do transaction
      on error undo, throw
      on stop undo, retry
      on endkey undo, retry:
        
      if retry then 
      do:
        undo, throw new Progress.Lang.AppError(subst("Error on write of '&1'", cCased#), 123001).
      end.  
      
      if hBuffNewIP# <> ? and hBuffNewIP#:avail then hBuffInput# = hBuffNewIP#.
      else hBuffInput# = hBuffIP#.
      
      /* Elke Panaedra tabel heeft ook een cased versie van de tabelnaam.
         Dat is de "logische" naam van de tabel, die verder in dbtrig wordt gebruikt.
         Bij bijvoorbeeld de _DATA_, wijkt de logische naam _DATA_ af van
         de fysieke database tabelnaam.
       */
      cCased# = GetCased(hBuffInput#).
      
      if ExecuteLogic(hBuffInput#, hBuffOldIP#, "wri") then.
      else return false.
      
      SetKeyFields(hBuffInput#, cCased#).
      
    end. /* transaction */
    
    return true.

  end method. /* OnWriteOrCreate */


  method public static logical OnDelete (hBuffIP# as handle):

    define variable cCased#       as character no-undo.
    
    define variable hQueryTt#     as handle    no-undo.
    define variable hBuffTable#   as handle    no-undo.
    define variable hBuffRel#     as handle    no-undo.
    
    define variable hQueryDb#     as handle    no-undo.
    define variable hBuffDbInput# as handle    no-undo.
    define variable hBuffDb#      as handle    no-undo.
    
    define variable rRowid#       as rowid     no-undo.

    cCased# = GetCased(hBuffIP#).
    
    do transaction
      on error undo, throw
      on stop undo, retry
      on endkey undo, retry:
        
      if retry then 
      do:
        undo, throw new Progress.Lang.AppError(subst("Error on delete of '&1'", cCased#), 123002).
      end.
      
      if not ExecuteLogic(hBuffIP#,?,"del") then return false.
      
      sc_dbtrigrelations:GetDbtrigRelations(cCased#, output hBuffTable#, output hBuffRel#). 
      
      if hBuffTable# <> ?
        and
      /* In eerste instantie only voor db relations.
         Support voor datasets wordt later ingebouwd. 
      */
        hBuffIP#:table-handle <> ? 
        then 
      do on error undo, throw:
        
        if hBuffIP#:table-handle <> ? then create buffer hBuffDbInput# for table hBuffIP#:table.
        else create buffer hBuffDbInput# for table hBuffIP#:table-handle.
        
        rRowid# = hBuffIP#:rowid.
        
        create query hQueryTt#.
        hQueryTt#:set-buffers(hBuffTable#, hBuffRel#).
        hQueryTt#:query-prepare(subst("for each &1 where &1.cTable = &2, each &3 of &1", hBuffTable#:name, quoter(cCased#), hBuffRel#:name)).
        hQueryTt#:query-open.
        hQueryTt#:get-first.
        do while not hQueryTt#:query-off-end:
          create buffer hBuffDb# for table string(hBuffRel#::cChildTable).
          create query hQueryDb#.
          hQueryDb#:set-buffers(hBuffDbInput#, hBuffDb#).
          hQueryDb#:query-prepare(subst("for each &1 where rowid(&1) = to-rowid(&2) no-lock", hBuffDbInput#:name, quoter(rRowid#)) + 
            ", each " + hBuffRel#::cChildTable + " of " + hBuffRel#::cTable + " exclusive-lock").
          hQueryDb#:query-open.
          hQueryDb#:get-first.
          
          do while not hQueryDb#:query-off-end:
            hBuffDb#:buffer-delete.
            hQueryDb#:get-next.  
          end.
          hQueryTt#:get-next.
        end.
        
        finally:
          delete object hQueryTt# no-error.
          delete object hQueryDb# no-error.
          delete object hBuffDb#  no-error.
          delete object hBuffDbInput# no-error.
        end.
      end.
        
    end.
    
    return true.
    
  end method. /* OnDelete */
  

  method public static character NewGUID ():
    
    return replace(guid(generate-uuid),"-","").
    
  end method. /* NewGUID */
  
  
  method public static int64 NewID ( hBuffIP# as handle, cCasedIP# as char):

    if not bInitialized then 
    do:
      bInitialized = true.
      if panaedra.msroot.msutil.logic.sc_boot:cBootSessionParameter > "" then.
      else panaedra.msroot.msutil.logic.sc_boot:cBootSessionParameter = session:parameter.
      bDbLayer = lookup(panaedra.msroot.msutil.logic.sc_boot:SessionParameter("Layer"),"all,db,db_r,db_u") > 0.
      if bDbLayer = ? then bDbLayer = false.
      iNewID = -1 * time. /* Tbv developing / reload static class */
    end.
    
    if not bDbLayer or hBuffIP#:table-handle <> ? then 
    do:
      iNewID = iNewID - 1.
      return iNewID.
    end.
    else 
    do transaction on error undo, throw:
      return dynamic-next-value("s_ID" + cCasedIP# ,"panaedradb").
    end.

  end method. /* NewID */ 
  
  
  method public static char GetCased(hBuffIP# as handle):

    define variable cCased#      as character no-undo.
    define variable hFirstField# as handle    no-undo.
    define variable cHelpString# as character no-undo.
    
    /* N.B. buffer or temp-table handle has no help attribute. 
       We use the help string (or GetProp/SetProp) of the first field of the (temp-)table buffer. 
    */
    
    hFirstField# = hBuffIP#:buffer-field(1).
    cHelpString# = hFirstField#:help.
    
    if cHelpString# matches "*[private-data]*" and hFirstField#:private-data = ? then
      sc_prop:PropsFromString(hFirstField#, sc_string_csv:GetParam(cHelpString#,"private-data")).
    
    /* CasedTableName is optional. If set (on the first buffer field), 
       it overrules the default flow. 
       It can be used with "like" temp-tables, or "&ttPrefix/&ttSuffix" 
       temp-tables as used in changesets. 
    */
    cCased# = sc_prop:GetProp(hFirstField#,"CasedTableName").
    
    if cCased# > "" then.
    else 
    do:
    
      if hBuffIP#:table-handle <> ? then 
      do:
        if hBuffIP#:table-handle:name begins "tt" then cCased# = substring(hBuffIP#:table-handle:name,3).
        else cCased# = hBuffIP#:table-handle:name.
      end.
      else  
        cCased# = GetDbLabel(hBuffIP#).
    
      if cCased# = "" or cCased# = ? or 
        index(cCased#, " ") > 0 then
      do:
        if (hBuffIP#:table <> ?) then
          cCased# = hBuffIP#:table.
        else if (hBuffIP#:table-handle <> ?) then
            cCased# = hBuffIP#:table-handle:name.
      end.
      
    end. /* CasedTableName found by GetProp */
    
    /* For tables with an abstraction from table to temp-table; 
       I.E. table "_CCMPNY_" could have "Pr_CCMPNY_/_CCMPNY_" as label. 
    */
    cCased# = entry(1,cCased#,"/"). 
    
    return cCased#.
    
  end method. /* GetCased */

  
  method public static character GetNonCased(hBuffIP# as handle):

    define variable cNonCased#   as character no-undo.
    define variable hFirstField# as handle    no-undo.
    define variable cHelpString# as character no-undo.
    
    /* N.B. buffer or temp-table handle has no help attribute. 
       We use the help string (or GetProp/SetProp) of the first field of the (temp-)table buffer. 
    */
    
    hFirstField# = hBuffIP#:buffer-field(1).
    cHelpString# = hFirstField#:help.
    
    if cHelpString# matches "*[private-data]*" and hFirstField#:private-data = ? then
      sc_prop:PropsFromString(hFirstField#, sc_string_csv:GetParam(cHelpString#,"private-data")).
    
    /* NonCasedTableName is optional. If set (on the first buffer field), 
       it overrules the default flow. 
       It can be used with "like" temp-tables, or "&ttPrefix/&ttSuffix" 
       temp-tables as used in changesets. 
    */
    cNonCased# = sc_prop:GetProp(hFirstField#,"NonCasedTableName").

    if cNonCased# > "" then.
    else 
    do:
      if hBuffIP#:table-handle <> ? then 
      do:
        if hBuffIP#:table-handle:name begins "tt" 
          then cNonCased# = substring(hBuffIP#:table-handle:name,3).
        else cNonCased# = hBuffIP#:table-handle:name.
      end.
      else  
        cNonCased# = hBuffIP#:name.
    
      if cNonCased# = "" or cNonCased# = ? or 
        index(cNonCased#, " ") > 0 then
      do:
        if (hBuffIP#:table <> ?) then
          cNonCased# = hBuffIP#:table.
        else if (hBuffIP#:table-handle <> ?) then 
          do:
            cNonCased# = hBuffIP#:table-handle:name.
            if cNonCased# begins "tt" then cNonCased# = substring(cNonCased#,3).
          end.
      end.
      
    end. /* Property "NonCasedTableName" was not used */
    
    /* For tables with an abstraction from table to temp-table; 
       I.E. table "_CCMPNY_" could have "Pr_CCMPNY_/_CCMPNY_" as label. 
    */
    cNonCased# = entry(num-entries(cNonCased#,"/"),cNonCased#,"/").
    
    cNonCased# = lc(cNonCased#).
    
    return cNonCased#.
    
  end method. /* GetNonCased */

  
  method protected static char GetDbLabel (hBuffIP# as handle):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer b-ttCacheLabels for ttCacheLabels.
    
    define variable hQuery# as handle no-undo.
    define variable hBuff#  as handle no-undo.
      
    find first b-ttCacheLabels where b-ttCacheLabels.cTable = hBuffIP#:table no-error.
    
    if not avail b-ttCacheLabels then 
    do:
      create b-ttCacheLabels.
      assign 
        b-ttCacheLabels.cTable = hBuffIP#:table.
      create buffer hBuff# for table "panaedradb._File".
      hBuff#:find-first(subst("where panaedradb._File._File-name = &1 ", quoter(hBuffIP#:table)), no-lock).
      b-ttCacheLabels.cLabel = hBuff#::_File-Label.
    end.
        
    return b-ttCacheLabels.cLabel.

  end method. /* GetDbLabel */  
  

  method protected static logical ExecuteLogic (hBuffIP# as handle, hBuffOldIP# as handle, cTypeIP# as char):

    define variable bValidateOkay#     as logical            no-undo.
    define variable iError#            as integer            no-undo.
    define variable cError#            as character          no-undo.
    define variable cTable#            as character          no-undo case-sensitive.
    
    define variable oTriggerLogic#     as i_triggerlogic     no-undo.
    define variable oTriggerLogicData# as c_triggerlogicdata no-undo.
    
    define buffer b-ttCacheLogicLocations for ttCacheLogicLocations.
    
    if hBuffIP#:table-handle <> ? then 
    do:
      cTable# = hBuffIP#:table-handle:name.
      if cTable# begins "tt" then cTable# = substring(cTable#,3).
    end.
    else cTable# = hBuffIP#:table.
    
    cTable# = lc(cTable#).
    
    find first b-ttCacheLogicLocations 
      where b-ttCacheLogicLocations.cTable = cTable#
      and   b-ttCacheLogicLocations.cType  = cTypeIP#
      no-error.
      
    if not avail b-ttCacheLogicLocations then 
    do:
      create b-ttCacheLogicLocations.
      assign 
        b-ttCacheLogicLocations.cTable = cTable#
        b-ttCacheLogicLocations.cType  = cTypeIP#.
      file-info:file-name = "panaedra/dbtrig/logic/" + cTypeIP# + "log_" + subst("&1",cTable#) + ".cls".
      if file-info:full-pathname = ? then
        file-info:file-name = "panaedra/dbtrig/logic/" + cTypeIP# + "log_" + subst("&1",cTable#) + ".r".
      if file-info:full-pathname <> ? then 
      do:
        b-ttCacheLogicLocations.cLogic = replace(file-info:file-name,"~\","/").
        entry(num-entries(b-ttCacheLogicLocations.cLogic,"."),b-ttCacheLogicLocations.cLogic,".") = "".
        b-ttCacheLogicLocations.cLogic = right-trim(b-ttCacheLogicLocations.cLogic,". ").
        b-ttCacheLogicLocations.cLogic = replace(b-ttCacheLogicLocations.cLogic,"/",".").
      end.
    end.  
    
    if b-ttCacheLogicLocations.cLogic <> "<none>" then 
    do:
      if not valid-object(oTriggerLogicData#) then
        oTriggerLogicData# = new panaedra.msroot.msutil.logic.c_triggerlogicdata().
      if cTypeIP# = "wri" then 
      do:
        oTriggerLogic# = dynamic-new b-ttCacheLogicLocations.cLogic (hBuffIP#, hBuffOldIP#, oTriggerLogicData#, output bValidateOkay#).
      end.
      else /* "del" dus */ 
      do:
        oTriggerLogic# = dynamic-new b-ttCacheLogicLocations.cLogic (hBuffIP#, oTriggerLogicData#, output bValidateOkay#).
      end.

      oTriggerLogicData#:_sys_SetBuffers(hBuffIP#, hBuffOldIP#).
      delete object oTriggerLogic# no-error. /* Data blijft bewaard. */
      oTriggerLogic# = ?.
      
      if bValidateOkay# then.
      else 
      do:
        /* ToDo: Later kunnen we de data verzamelen, maar voorlopig (proof of concept fase) toon ik only de eerste error want dat is makkelijker. */
        if oTriggerLogicData#:_sys_HasErrorText() then DisplayTriggerLogicError(hBuffIP#, hBuffOldIP#, oTriggerLogicData#:_sys_FirstErrorText()).
        else DisplayTriggerLogicError(hBuffIP#, hBuffOldIP#, subst("A data logic error has occurred for '&1'.", hBuffIP#:name)).
        return false.
      end.
    end.
    
    return true.
    
  end method. /* ExecuteLogic */


  method public static void DisplayTriggerLogicError (hBuffIP# as handle, hBuffOldIP# as handle, cErrorIP# as char):
    
    define variable cFieldNames#  as character no-undo extent 9.
    define variable cFieldValues# as character no-undo extent 9.
    define variable iIndex#       as integer   no-undo.
    define variable iExtent#      as integer   no-undo.
    define variable iTell#        as integer   no-undo.
    
    define variable cFields#      as character no-undo.
    define variable cOldValue#    as character no-undo.
    
    iIndex# = r-index(cErrorIP#,"[",length(cErrorIP#)).
    
    if iIndex# > 0 then 
    do:
      cFields# =  trim(substring(cErrorIP#,iIndex# + 1),"]").
      cErrorIP# = substring(cErrorIP#,1,iIndex# - 1).
    end.
    
    if cFields# > "" then 
    do:
      iExtent# = num-entries(cFields#).
      do iTell# = 1 to num-entries(cFields#):
        cFieldNames#[iTell#] = entry(iTell#,cFields#).
        cFieldValues#[iTell#] = trim(string(hBuffIP#:buffer-field(cFieldNames#[iTell#]):buffer-value)).
        if hBuffOldIP# <> ? then 
        do:
          cOldValue# = trim(string(hBuffOldIP#:buffer-field(cFieldNames#[iTell#]):buffer-value)).
          if cOldValue# > "" and cOldValue# <> cFieldValues#[iTell#]
            then cFieldValues#[iTell#] = cOldValue# + " -> " + cFieldValues#[iTell#].
        end. 
      end.
    end.
    
    message subst(cErrorIP#, 
      cFieldValues#[1], cFieldValues#[2], cFieldValues#[3], cFieldValues#[4], 
      cFieldValues#[5], cFieldValues#[6], cFieldValues#[7], cFieldValues#[8], 
      cFieldValues#[9])
      view-as alert-box.

  end method. /* DisplayTriggerLogicError */
  
  
end class.

/* EOF */
