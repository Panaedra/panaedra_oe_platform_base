{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_dbtrig   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_dbtrig.cls $ 
          Version: $Revision: 20 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-05-20 15:27:00+02:00 $ 
    Date Modified: $Modtime: 2010-05-20 14:59:25+02:00 $ 

      Description: This class is called by db delete and write triggers.
                   
                   It's also used for temp-tables and datasets, on a UI client
                   or a db-less appserver.
                   Temp-table get negative iID values.
                   
                   Table records get positive iID values, determined by a sequence
                   that is dedicated to the table.
                   
                   cGUID* is generated at creation of the temp-table record, or (db-only) at 
                   creation of the db table record.
                   If the db table record is based on a temp-table, cGUID* is simply copied.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_dbtrig(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 20 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected static variable iNewID       as int64 no-undo.
  define protected static variable bInitialized as log   no-undo.
  define protected static variable bDbLayer     as log   no-undo.

  define protected static temp-table ttTableInfo no-undo
    field cTempTableName as character init ? /* either cTempTableName or cDbTableName is filled */
    field cDbTableName   as character init ? /* either cTempTableName or cDbTableName is filled */
    field cNonCased      as character
    field cCased         as character
    field cLabel         as character 
    field cDescription   as character
    field cNsSubroot     as character
    field cNsGroupdir    as character
    field cNsKey         as character
    field cNsPath        as character
    index cCased is primary        cCased
    index cTempTableName is unique cTempTableName
    index cDbTableName is unique   cDbTableName
    .
  
  define protected static temp-table ttCacheLogicLocations no-undo
    field cTable        as character
    field cType         as character init "wri"
    field cLogic        as character init "<none>"
    field bDummy        as logical   init ?
    /* The following index is a workaround on a OE10.2A01 bug.
       A direct/normal cTable cType index gets corrupted:
       Find statement on index doesn't work in tty (unix or win32). 
       Unique or not doesn't matter. 
    */
    index cTable_cType is primary unique cTable cType 
    . 
  

  method public static logical OnWriteOrCreate (hBuffIP# as handle):
    
    /* Use the overload handle,handle,handle from db triggers.
       This method overload is strictly for temp-tables. 
     */

    define variable hBuffDummy# as handle no-undo.

    return OnWriteOrCreate(hBuffIP#, hBuffDummy#, hBuffDummy#).

  end method. /* OnWriteOrCreate ; single buffer overload */


  method public static logical OnWriteOrCreate (hBuffIP# as handle, hBuffOldIP# as handle):
    
    return OnWriteOrCreate(hBuffIP#, hBuffIP#, hBuffOldIP#).
    
  end method. /* OnWriteOrCreate ; current + old buffer overload */


  method public static void SetKeyFields(hBuffInputIP# as handle):
    
    define variable cCased# as character no-undo.

    cCased# = GetCased(hBuffInputIP#).
    
    SetKeyFields(hBuffInputIP#, cCased#).
    
  end method. /* SetKeyFields : simple overload */


  method public static void SetKeyFields(hBuffInputIP# as handle, cCasedIP# as char):
    
    /*
    
    Only fill the key fields (iID), and dtmMod* + dtmCre* fields.
    No validation logic is called.
    Also see sc_buffercopy:CopyKey (which calls SetKeyFields itself).
    
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
          (/* db tables always get a positive iID */
          if hBuffInputIP#:table-handle = ? then true
        /* temp-tables kan keep their negative iID, but ? or 0 will be filled with a new iID. */ 
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

  end method. /* SetKeyFields : efficient overload when cCased is already known. */


  method public static logical OnWriteOrCreate (hBuffIP# as handle, hBuffNewIP# as handle, hBuffOldIP# as handle):

    /* Fill ID if empty (negative for temp-table). 
       Fill cGUID*  if empty. 
       Fill dtmCre* if empty. 
       Fill dtmMod* always. */
    
    define variable hField#     as handle    no-undo.
    define variable cCased#     as character no-undo.
    define variable hBuffInput# as handle    no-undo.
    
    define buffer b-ttTableInfo for ttTableInfo.
    
    do transaction
      on error undo, throw
      on stop undo, retry
      on endkey undo, retry:
        
      if retry then 
      do:
        undo, throw new Progress.Lang.AppError(subst("Error on write of '&1'", cCased#), 99952301).
      end.  
      
      if hBuffNewIP# <> ? and hBuffNewIP#:avail then hBuffInput# = hBuffNewIP#.
      else hBuffInput# = hBuffIP#.
      
      /* Each Panaedra table also has a cased version of the table name.
         The cased name is the "logical" name, which is used throughout the trigger logic.
         Cased name and noncased name can be very different,
         
       */

      if hBuffIP#:table-handle <> ? then 
        GetTtInfo(buffer b-ttTableInfo, hBuffIP#).
      else 
        GetDbInfo(buffer b-ttTableInfo, hBuffIP#).


      cCased# = b-ttTableInfo.cCased.
      
      if ExecuteLogic(buffer b-ttTableInfo:handle, hBuffInput#, hBuffOldIP#, "wri") then.
      else return false.
      
      SetKeyFields(hBuffInput#, cCased#).
      
    end. /* transaction */
    
    return true.

  end method. /* OnWriteOrCreate */


  method public static logical OnDelete (hBuffIP# as handle):

    define variable cCased#      as character no-undo.
    
    define variable hQueryRel#   as handle    no-undo.
    define variable hBuffTable#  as handle    no-undo.
    define variable hBuffRel#    as handle    no-undo.
    
    define variable hQueryChild# as handle    no-undo.
    define variable hBuffChild#  as handle    no-undo.
    
    define variable cIDParent#   as character no-undo.
    define variable iIDParent#   as int64     no-undo.
    
    define buffer b-ttTableInfo for ttTableInfo.

    if hBuffIP#:table-handle <> ? then 
      GetTtInfo(buffer b-ttTableInfo, hBuffIP#).
    else 
      GetDbInfo(buffer b-ttTableInfo, hBuffIP#).

    cCased# = b-ttTableInfo.cCased.
    
    do transaction
      on error undo, throw
      on stop undo, retry
      on endkey undo, retry:
        
      if retry then 
      do:
        undo, throw new Progress.Lang.AppError(subst("Error on delete of '&1'", cCased#), 123002).
      end.
      
      if not ExecuteLogic(buffer b-ttTableInfo:handle, hBuffIP#,?,"del") then return false.
      
      sc_dbtrigrelations:GetDbtrigRelations(buffer b-ttTableInfo:handle, output hBuffTable#, output hBuffRel#).
       
      if hBuffTable# <> ?
        then
      do on error undo, throw:
        
        create query hQueryRel#.
        
        hQueryRel#:set-buffers(hBuffTable#, hBuffRel#).
        hQueryRel#:query-prepare(subst("for each &1 where &1.cTable = &2, each &3 of &1", hBuffTable#:name, quoter(b-ttTableInfo.cNonCased), hBuffRel#:name)).
        hQueryRel#:query-open.
        hQueryRel#:get-first.
        
        do while not hQueryRel#:query-off-end on error undo, throw:
          
          if hBuffIP#:table-handle = ? then
            create buffer hBuffChild# for table string(hBuffRel#::cChildTable).
          else
            /* TODO: Datarelation temp-table delete; For dataset support a dataset context is necessary. */
            hBuffChild# = ?.
          
          if hBuffChild# <> ? then 
          do:  
            
            create query hQueryChild#.
            
            assign
              cIDParent# = "iID" + b-ttTableInfo.cCased
              iIDParent# = hBuffIP#:buffer-field(cIDParent#):buffer-value.
              
            hQueryChild#:set-buffers(hBuffChild#).
            hQueryChild#:query-prepare(subst("for each &1 where &1.&2 = &3 exclusive-lock", hBuffRel#::cChildTable, cIDParent#, iIDParent#)).
            hQueryChild#:query-open.
            hQueryChild#:get-first.
            
            do while not hQueryChild#:query-off-end:
              hBuffChild#:buffer-delete.
              hQueryChild#:get-next.  
            end. /* Walk childs */
            
          end. /* Valid child buffer */
          
          hQueryRel#:get-next.
          
          finally:
            if hQueryChild# <> ? then delete object hQueryChild#.
            if hBuffChild# <> ? then delete object hBuffChild#.
          end finally.
          
        end. /* Walk relations */
        
        finally:
          if hQueryRel# <> ? then delete object hQueryRel#.
        end.
        
      end. /* Valid Data Relations */
       
    end. /* transaction */
    
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
      iNewID = -1 * time. /* Mainly for developing purposes, where a static class can be reloaded, and we don't want to start each time with the same negative number because of ambiguity.  */
    end.
    
    if not bDbLayer or hBuffIP#:table-handle <> ? then 
    do:
      iNewID = iNewID - 1.
      return iNewID.
    end.
    else 
    do transaction on error undo, throw:
      return dynamic-next-value("s_ID" + cCasedIP#, hBuffIP#:table /* sc_dbconnect:SetAliases() is used; table name is alias db name */).
    end.

  end method. /* NewID */ 
  
  
  method public static char GetCased(hBuffIP# as handle):

    define variable cCased# as character no-undo.
    
    define buffer b-ttTableInfo for ttTableInfo.
    
    /* N.B. buffer or temp-table handle has no help attribute. 
       We use the help string (or GetProp/SetProp) of the first field of the (temp-)table buffer. 
    */

    if hBuffIP#:table-handle <> ? then 
      GetTtInfo(buffer b-ttTableInfo, hBuffIP#).
    else 
      GetDbInfo(buffer b-ttTableInfo, hBuffIP#).

    cCased# = b-ttTableInfo.cCased.

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
    
    /* TableAlias is optional, but is automatically generated from Panaedra 2010.01+. 
       If set (on the first buffer field), it overrules the default flow. 
       It can be used with "like" temp-tables, or "&ttPrefix/&ttSuffix" 
       temp-tables as used in changesets. 
    */
    cNonCased# = sc_prop:GetProp(hFirstField#,"TableAlias").

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
      
    end. /* Property "TableAlias" was not used */
    
    /* For tables with an abstraction from table to temp-table; 
       I.E. table "_CCMPNY_" could have "Pr_CCMPNY_/_CCMPNY_" as label. 
    */
    cNonCased# = entry(num-entries(cNonCased#,"/"),cNonCased#,"/").
    
    cNonCased# = lc(cNonCased#).
    
    return cNonCased#.
    
  end method. /* GetNonCased */

  
  method protected static void GetDbInfo(buffer b-ttTableInfo for ttTableInfo, hBuffIP# as handle):
    
    define variable bEclipseFix# as logical no-undo.
    
    define variable hQuery#      as handle  no-undo.
    define variable hBuff#       as handle  no-undo.
      
    find first b-ttTableInfo where b-ttTableInfo.cDbTableName = hBuffIP#:table no-error.
    
    if not avail b-ttTableInfo then 
    do:
      create b-ttTableInfo.
      assign 
        b-ttTableInfo.cDbTableName = hBuffIP#:table.
      create buffer hBuff# for table /* assumes sc_dbconnect:SetAliases() is used; */ hBuffIP#:table + "._File".
      hBuff#:find-first(subst("where _File._File-name = &1 ", quoter(hBuffIP#:table)), no-lock) no-error.
      if not hBuff#:available then undo, throw new Progress.Lang.AppError(subst("Table '&1' not found", hBuffIP#:table),99950285).
      if not num-entries(hBuff#::_Desc,"/") >= 3 then undo, throw new Progress.Lang.AppError(subst("Table '&1' Description invalid: '&2'", hBuffIP#:table, hBuff#::_Desc),99950286).
      assign
        b-ttTableInfo.cNonCased    = hBuffIP#:table
        b-ttTableInfo.cLabel       = hBuff#::_File-Label
        b-ttTableInfo.cDescription = hBuff#::_Desc
        b-ttTableInfo.cNsPath      = entry(1,b-ttTableInfo.cDescription,"/")
        b-ttTableInfo.cCased       = entry(2,b-ttTableInfo.cDescription,"/")
        b-ttTableInfo.cNsKey       = entry(3,b-ttTableInfo.cDescription,"/")
        b-ttTableInfo.cNsSubroot   = entry(1,b-ttTableInfo.cNsPath,".")
        b-ttTableInfo.cNsGroupdir  = entry(2,b-ttTableInfo.cNsPath,".")
        .
    end.
        
  end method. /* GetDbInfo */  
  

  method protected static void GetTtInfo(buffer b-ttTableInfo for ttTableInfo, hBuffIP# as handle):
    
    define variable hFirstField# as handle    no-undo.
    define variable cHelpString# as character no-undo.

    find first b-ttTableInfo where b-ttTableInfo.cTempTableName = hBuffIP#:table-handle:name no-error.
    
    if not avail b-ttTableInfo then 
    do:
      
      create b-ttTableInfo.
      assign 
        b-ttTableInfo.cTempTableName = hBuffIP#:table-handle:name.
        
      hFirstField# = hBuffIP#:buffer-field(1).
      cHelpString# = hFirstField#:help.
      
      /* Properties may be set in the definition (in help string) or at run-time (with SetProp) */
      if cHelpString# matches "*[private-data]*" and hFirstField#:private-data = ? then
        sc_prop:PropsFromString(hFirstField#, sc_string_csv:GetParam(cHelpString#,"private-data")).
      
      assign
        b-ttTableInfo.cCased      = sc_prop:GetProp(hFirstField#,"CasedTableName")
        b-ttTableInfo.cNonCased   = sc_prop:GetProp(hFirstField#,"TableAlias")
        b-ttTableInfo.cNsKey      = sc_prop:GetProp(hFirstField#,"NsKey")
        b-ttTableInfo.cNsSubroot  = sc_prop:GetProp(hFirstField#,"NsSubroot")
        b-ttTableInfo.cNsGroupdir = sc_prop:GetProp(hFirstField#,"NsGroupdir")
        .
      
      if trim(b-ttTableInfo.cCased) = "" or b-ttTableInfo.cCased = ? then 
        undo, throw new Progress.Lang.AppError(subst("Temp-table buffer '&1' (first field) has an invalid CasedTableName property of: '&2'", hBuffIP#:name, b-ttTableInfo.cCased),99950288).
      
    end.
        
  end method. /* GetTtInfo */  
  

  method public static void DebugShowTtCacheLogic():
    
    define variable bEclipseFix# as logical no-undo.
    
    define buffer b-ttCacheLogicLocations for ttCacheLogicLocations.

    if sc_html:TempTableToHTML(
      buffer b-ttCacheLogicLocations:handle, 
      sc_path:cTempDir + "ttCacheLogicLocations.html") 
      then 
      sc_win32:ShellExecute(sc_path:cTempDir + "ttCacheLogicLocations.html").

  end method. /* DebugShowTtCacheLogic */  
  

  method protected static logical ExecuteLogic (hBuffTableInfoIP# as handle, hBuffIP# as handle, hBuffOldIP# as handle, cTypeIP# as char):

    define variable bValidateOkay#     as logical            no-undo.
    define variable iError#            as integer            no-undo.
    define variable cError#            as character          no-undo.
    define variable cTable#            as character          no-undo.
    
    define variable oTriggerLogic#     as i_triggerlogic     no-undo.
    define variable oTriggerLogicData# as c_triggerlogicdata no-undo.
    
    define buffer b-ttCacheLogicLocations     for ttCacheLogicLocations.
    define buffer b-ttTableInfo               for ttTableInfo.
    
    if hBuffTableInfoIP# <> ? and hBuffTableInfoIP#:available 
      then 
      find first b-ttTableInfo where rowid(b-ttTableInfo) = hBuffTableInfoIP#:rowid.
    
    else 
    do:
     
      if hBuffIP#:table-handle <> ? then 
        GetTtInfo(buffer b-ttTableInfo, hBuffIP#).
      else 
        GetDbInfo(buffer b-ttTableInfo, hBuffIP#).
    end.
    
    cTable# = b-ttTableInfo.cNonCased.
    
    do for b-ttCacheLogicLocations:
    
      find first 
        b-ttCacheLogicLocations where 
        b-ttCacheLogicLocations.cTable = cTable# and
        b-ttCacheLogicLocations.cType = cTypeIP# 
        no-error.
      
      if not avail b-ttCacheLogicLocations then 
      do:
      
        create b-ttCacheLogicLocations.
        assign 
          b-ttCacheLogicLocations.cTable = cTable#
          b-ttCacheLogicLocations.cType  = cTypeIP#.
      
        file-info:file-name = 
          "panaedra/" 
          + (if b-ttTableInfo.cNsSubroot = "(none)" then "" else b-ttTableInfo.cNsSubroot + "/")
          + b-ttTableInfo.cNsGroupdir + "/logic_val/c_"
          + cTypeIP# + "log_" + subst("&1",cTable#) + ".cls".
        if file-info:full-pathname = ? then 
        do:
          file-info:file-name = 
            "panaedra/" 
            + (if b-ttTableInfo.cNsSubroot = "(none)" then "" else b-ttTableInfo.cNsSubroot + "/")
            + b-ttTableInfo.cNsGroupdir + "/logic_val/c_"
            + cTypeIP# + "log_" + subst("&1",cTable#) + ".r".
        end.
        if file-info:full-pathname <> ? then 
        do:
          b-ttCacheLogicLocations.cLogic = replace(file-info:file-name,"~\","/").
          entry(num-entries(b-ttCacheLogicLocations.cLogic,"."),b-ttCacheLogicLocations.cLogic,".") = "".
          b-ttCacheLogicLocations.cLogic = right-trim(b-ttCacheLogicLocations.cLogic,". ").
          b-ttCacheLogicLocations.cLogic = replace(b-ttCacheLogicLocations.cLogic,"/",".").
        end.
        
      end. /* If not avail ; initialization, searching propath only once */  
    
      if b-ttCacheLogicLocations.cLogic <> "<none>" then 
      do:
        if not valid-object(oTriggerLogicData#) then
          oTriggerLogicData# = new panaedra.msroot.msutil.logic.c_triggerlogicdata().
        if cTypeIP# = "wri" then 
        do:
          oTriggerLogic# = dynamic-new b-ttCacheLogicLocations.cLogic (hBuffIP#, hBuffOldIP#, oTriggerLogicData#, output bValidateOkay#).
        end.
        else /* "del" */ 
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
    
    end. /* strong scoping, strange tt index problem */
        
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
    
    sc_messagebox:Show(sc_messageboxtype:Simple, subst(cErrorIP#, 
      cFieldValues#[1], cFieldValues#[2], cFieldValues#[3], cFieldValues#[4], 
      cFieldValues#[5], cFieldValues#[6], cFieldValues#[7], cFieldValues#[8], 
      cFieldValues#[9])).
    
  end method. /* DisplayTriggerLogicError */

  
end class.

/* EOF */
