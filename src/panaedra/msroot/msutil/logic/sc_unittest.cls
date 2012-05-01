using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_unittest: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Unit Test functionality

  \*****************************  Include Files ********************************/
{panaedra/msroot/msutil/logic/tt/mspersistencyinfo_tt.i &class=class &protected=protected &static=static &ttSuffix=Pre}
{panaedra/msroot/msutil/logic/tt/mspersistencyinfo_tt.i &class=class &protected=protected &static=static &ttSuffix=Post}
  
  &glob ttExtraFields           ~
  field cWarning   as character ~
  field iInstances as integer
  
{panaedra/msroot/msutil/logic/tt/mspersistencyinfo_tt.i &class=class &protected=protected &static=static &ttSuffix=Warn}
  
  &undefine ttExtraFields

  /************************  Source control constructor ************************/
  constructor public sc_unittest(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected static temp-table ttFile no-undo
    field cFullPath as char.

  define protected static temp-table ttSessionUnittest no-undo
    field cTestID         as character
    field bLastTestFailed as logical
    field hLastTestProc   as handle
    field cLastTestProc   as character
    field dtmLastInit     as datetime-tz
    field dtmLastFinish   as datetime-tz
    index cTestID is primary unique cTestID.

  define protected static variable cLogFile              as character no-undo.
  define protected static variable cPreviousGlobalTestID as character no-undo.
  define protected static variable cCurrentGlobalTestID  as character no-undo.
  define protected static variable bFirstOfTwo           as logical   no-undo.
  
    
  method public static void UnittestInit(
  
    /* Always run this method once, at the start of the unittest, outside of any transactions */
    
    hUnittestProcIP# as handle,
    cTestIDIP#       as character):

    define variable bFirstOfTwo# as logical no-undo.
    
    if sc_environment:bLiveEnv then
      undo, throw new c_panaedraexception(
        99958111,
        sc_lang:oEnglish,
        substitute("Running of unit tests in a live environment is never allowed. TestID='&1'", cTestIDIP#)).

    /* Assign a value to the global data member */
    assign
      /* Check if we are running *this* unittest for the first time */
      bFirstOfTwo#          = (cPreviousGlobalTestID <> cTestIDIP#)
      /* Update data members */
      cPreviousGlobalTestID = (if not bFirstOfTwo# then "" else cCurrentGlobalTestID) /* Clear "previous", otherwise a "third" run is not identified as a "first" */
      cCurrentGlobalTestID  = cTestIDIP# 
      bFirstOfTwo           = bFirstOfTwo#
      . 
    
    /* First register */    
    RegisterUnittest(hUnittestProcIP#,cTestIDIP#).
    
    if bFirstOfTwo then 
    do:
      empty temp-table ttPersistentThingsPre.
      empty temp-table ttPersistentThingsPost.
    end.
        
    catch oError# as Progress.Lang.Error:
      OnException(cTestIDIP#,oError#).
    end catch.
    
  end method. /* UnittestInit */
  

  method public static void UnittestFinish(
  
    /* Always run this method once, at the end of the unittest, after cleanup of handles/objects, outside of any transactions */
    
    hUnittestProcIP# as handle,
    cTestIDIP#       as character):
    
    define variable cFile# as character no-undo.
    
    define buffer b-ttPersistentThingsPost for ttPersistentThingsPost.
    define buffer b-ttPersistentThingsPre  for ttPersistentThingsPre.
    define buffer b-ttPersistentThingsWarn for ttPersistentThingsWarn .
    
    /* Part of file name */
    cFile# = subst("&1_&2_&3",sc_environment:cEnv, sc_osfile:StripInvalidChars(lc(cTestIDIP#),true), sc_date_timestamp:cTimeStamp_Readable_DateAndTime).
    
    if bFirstOfTwo then 
    do:
      /* The unittest */
      if (not GetLastTestFailed())
        then 
      do:
        /* After first test run: collect "pre" info */
        sc_persistency_info:AllPersistentThingsToTt(output table ttPersistentThingsPre by-reference).
      end.
    end.
    else 
    do:
      /* After second test run: collect "post" info. We only get a second run if the first test had no assert-errors/exceptions. */
      sc_persistency_info:AllPersistentThingsToTt(output table b-ttPersistentThingsPost by-reference).
    end.
    
    if not bFirstOfTwo then
    do:

      /* Empty the "Warn" temp-table, which is only used to pass all warning messages to a protected method */
      empty temp-table b-ttPersistentThingsWarn.

      /* Compare persistent things pre/post */
      for each b-ttPersistentThingsPost 
        break
        by b-ttPersistentThingsPost.cType
        by b-ttPersistentThingsPost.cName
        on error undo, throw:
        
        if first-of(b-ttPersistentThingsPost.cName) then 
        do:
        
          create b-ttPersistentThingsWarn.
          assign
            b-ttPersistentThingsWarn.cType      = b-ttPersistentThingsPost.cType
            b-ttPersistentThingsWarn.cName      = b-ttPersistentThingsPost.cName
            b-ttPersistentThingsWarn.iInstances = 0.
        
        end. /* first-of */

        b-ttPersistentThingsWarn.iInstances = b-ttPersistentThingsWarn.iInstances + 1.
        
        if last-of(b-ttPersistentThingsPost.cName) then 
        do:
          
          for each b-ttPersistentThingsPre
            where b-ttPersistentThingsPre.cType = b-ttPersistentThingsPost.cType 
            and   b-ttPersistentThingsPre.cName = b-ttPersistentThingsPost.cName
            on error undo, throw:
              
            b-ttPersistentThingsWarn.iInstances = b-ttPersistentThingsWarn.iInstances - 1.
            
          end.
          
        end. /* last-of */
          
      end. /* each b-ttPersistentThingsPost */
      
      for each b-ttPersistentThingsWarn where b-ttPersistentThingsWarn.iInstances <= 0 on error undo, throw:
        delete b-ttPersistentThingsWarn.
      end.
      
      if can-find(first b-ttPersistentThingsWarn) then 
      do: 
        PersistencyWarning(cTestIDIP#).
        empty temp-table ttPersistentThingsWarn.
      end.
      else 
      do:
        cFile# = subst("&1_&2_&3",sc_environment:cEnv, sc_osfile:StripInvalidChars(lc(cTestIDIP#),true), sc_date_timestamp:cTimeStamp_Readable_DateAndTime).
        sc_html:TempTableToHTML(buffer b-ttPersistentThingsPost:handle, sc_path:cLogVoortgangDir + "persistencycheck_" + cFile# + "_info.html").
      end.
      
      empty temp-table b-ttPersistentThingsPre.
      empty temp-table b-ttPersistentThingsPost.
      
    end. /* not first test */

    if bFirstOfTwo then 
    do:
      if (not GetLastTestFailed())
        then
        /* Run it a second time, to look for memory leaks */
        RunLastTestAgain().
    end.
        
    catch oError# as Progress.Lang.Error :
      OnException(cTestIDIP#,oError#).
    end catch.
    
  end method. /* UnittestFinish */


  method public static void Assert(
    cTestIDIP# as character, 
    cTestDescIP# as character,
    bNewValueIP# as logical,
    bExpectedValueIP# as logical
    ):
      
    if (bExpectedValueIP# = ? and bNewValueIP# <> ?)
      or (bExpectedValueIP# <> ? and bNewValueIP# = ?)
      or (bExpectedValueIP# <> bNewValueIP#) then 
    do:
      
      RegisterUnitFail().
      
      LogMessage(subst("env=&1 id=&2, descr=&3, calc=&4, exp=&5",   
        sc_environment:cEnv,
        cTestIDIP#,
        cTestDescIP#,
        bNewValueIP#,
        bExpectedValueIP#
        )
        ).
      
      message now "Assert failed." skip
        sc_environment:cEnv skip
        cTestIDIP# skip
        cTestDescIP# skip
        "Calculated:" bNewValueIP# skip
        "Expected:" bExpectedValueIP#
        view-as alert-box.
      
    end.

  end method. /* Assert ; logical field */
  
  
  method public static void Assert(
    cTestIDIP# as character, 
    cTestDescIP# as character,
    cNewValueIP# as character,
    cExpectedValueIP# as character
    ):
      
    if (cExpectedValueIP# = ? and cNewValueIP# <> ?)
      or (cExpectedValueIP# <> ? and cNewValueIP# = ?)
      or (cExpectedValueIP# <> cNewValueIP#) then 
    do:
      
      RegisterUnitFail().
      
      LogMessage(subst("env=&1 id=&2, descr=&3, calc=&4, exp=&5",   
        sc_environment:cEnv,
        cTestIDIP#,
        cTestDescIP#,
        cNewValueIP#,
        cExpectedValueIP#
        )
        ).
      
      message now "Assert failed." skip
        sc_environment:cEnv skip
        cTestIDIP# skip
        cTestDescIP# skip
        "Calculated:" cNewValueIP# skip
        "Expected:" cExpectedValueIP#
        view-as alert-box.
      
    end.

  end method. /* Assert ; character field */
  
  
  method public static void Assert(
    cTestIDIP# as character, 
    cTestDescIP# as character,
    iNewValueIP# as integer,
    iExpectedValueIP# as integer
    ):
      
    if (iExpectedValueIP# = ? and iNewValueIP# <> ?)
      or (iExpectedValueIP# <> ? and iNewValueIP# = ?)
      or (iExpectedValueIP# <> iNewValueIP#) then 
    do:
      
      RegisterUnitFail().

      LogMessage(subst("env=&1 id=&2, descr=&3, calc=&4, exp=&5",   
        sc_environment:cEnv,
        cTestIDIP#,
        cTestDescIP#,
        iNewValueIP#,
        iExpectedValueIP#
        )
        ).
      
      message now "Assert failed." skip
        sc_environment:cEnv skip
        cTestIDIP# skip
        cTestDescIP# skip
        "Calculated:" iNewValueIP# skip
        "Expected:" iExpectedValueIP#
        view-as alert-box.
      
    end.

  end method. /* Assert ; integer field */
  
  
  method public static void Assert(
    cTestIDIP# as character, 
    cTestDescIP# as character,
    fNewValueIP# as decimal,
    fExpectedValueIP# as decimal
    ):
      
    if (fExpectedValueIP# = ? and fNewValueIP# <> ?)
      or (fExpectedValueIP# <> ? and fNewValueIP# = ?)
      or (fExpectedValueIP# <> fNewValueIP#) then 
    do:
      
      RegisterUnitFail().
      
      LogMessage(subst("env=&1 id=&2, descr=&3, calc=&4, exp=&5",   
        sc_environment:cEnv,
        cTestIDIP#,
        cTestDescIP#,
        fNewValueIP#,
        fExpectedValueIP#
        )
        ).
      
      message now "Assert failed." skip
        sc_environment:cEnv skip
        cTestIDIP# skip
        cTestDescIP# skip
        "Calculated:" fNewValueIP# skip
        "Expected:" fExpectedValueIP#
        view-as alert-box.
      
    end.

  end method. /* Assert ; decimal field */
  
  
  method public static void Assert(
    cTestIDIP# as character, 
    cTestDescIP# as character,
    dtNewValueIP# as date,
    dtExpectedValueIP# as date
    ):
      
    if (dtExpectedValueIP# = ? and dtNewValueIP# <> ?)
      or (dtExpectedValueIP# <> ? and dtNewValueIP# = ?)
      or (dtExpectedValueIP# <> dtNewValueIP#) then 
    do:
      
      RegisterUnitFail().

      LogMessage(subst("env=&1 id=&2, descr=&3, calc=&4, exp=&5",   
        sc_environment:cEnv,
        cTestIDIP#,
        cTestDescIP#,
        dtNewValueIP#,
        dtExpectedValueIP#
        )
        ).
      
      message now "Assert failed." skip
        sc_environment:cEnv skip
        cTestIDIP# skip
        cTestDescIP# skip
        "Calculated:" dtNewValueIP# skip
        "Expected:" dtExpectedValueIP#
        view-as alert-box.
      
    end.

  end method. /* Assert ; date field */

  
  method public static void Assert(
    cTestIDIP# as character, 
    cTestDescIP# as character,
    dataset-handle hDatasetOneIP#, 
    dataset-handle hDatasetTwoIP#, 
    bExpectedEqualIP# as logical
    ):
      
    define variable bDatasetsEqual# as logical  no-undo.  
    define variable clobJsonOne#    as longchar no-undo.  
    define variable clobJsonTwo#    as longchar no-undo.
    
    bDatasetsEqual# = sc_dataset:DatasetCompare(dataset-handle hDatasetOneIP#, dataset-handle hDatasetTwoIP#). 
    
    if (bExpectedEqualIP# = ? and bDatasetsEqual# <> ?)
      or (bExpectedEqualIP# <> ? and bDatasetsEqual# = ?)
      or (bExpectedEqualIP# <> bDatasetsEqual#) then 
    do:
      
      RegisterUnitFail().
      
      hDatasetOneIP#:write-json("longchar", clobJsonOne#, true, "utf-8").  
      hDatasetTwoIP#:write-json("longchar", clobJsonTwo#, true, "utf-8").

      LogMessage(   
        subst("&1~n&2~n&3~n&4~n&5~n&6~n&7~n&8~n&9~n",
        subst("Assert failed. [Env] &1", sc_environment:cEnv),
        cTestIDIP#,
        cTestDescIP#,
        subst("Calculated: &1", bDatasetsEqual#                                                  ),
        subst("Expected:   &1", bExpectedEqualIP#                                                ),
        subst("Dataset One: &1 &2", hDatasetOneIP#:name, hDatasetOneIP#:get-buffer-handle(1):name),
        subst("Dataset Two: &1 &2", hDatasetTwoIP#:name, hDatasetTwoIP#:get-buffer-handle(1):name),
        subst("JSON One: &1", string(substring(clobJsonOne#,1,90))                               ),
        subst("JSON Two: &1", string(substring(clobJsonTwo#,1,90))                               )
        )
        ).

      sc_messagebox:MsgBox(
        subst("&1~n&2~n&3~n&4~n&5~n&6~n&7~n&8~n&9~n",
        subst("Assert failed. [Env] &1", sc_environment:cEnv),
        cTestIDIP#,
        cTestDescIP#,
        subst("Calculated: &1", bDatasetsEqual#                                                  ),
        subst("Expected:   &1", bExpectedEqualIP#                                                ),
        subst("Dataset One: &1 &2", hDatasetOneIP#:name, hDatasetOneIP#:get-buffer-handle(1):name),
        subst("Dataset Two: &1 &2", hDatasetTwoIP#:name, hDatasetTwoIP#:get-buffer-handle(1):name),
        subst("JSON One: &1", string(substring(clobJsonOne#,1,90))                               ),
        subst("JSON Two: &1", string(substring(clobJsonTwo#,1,90))                               )
        )).

    end.
    
  end method. /* Assert ; two datasets */

  
  method public static void OnException(
  
    cTestIDIP#   as character, 
    oExIP#       as Progress.Lang.Error):
      
    define variable cExceptionMsg# as character no-undo.  
      
    cExceptionMsg# = subst("&1~n&2~n&3~n&4~n&5~n&6~n&7~n&8~n&9~n",
      "Assert failed; exception.", 
      sc_environment:cEnv,
      cTestIDIP#,
      oExIP#:GetMessage(1),
      oExIP#:GetMessage(2),
      oExIP#:GetMessage(3),
      oExIP#:CallStack     
      ). 
    
    LogMessage(cExceptionMsg#).
    sc_messagebox:MsgBox(cExceptionMsg#).

    RegisterUnitFail().
    
  end method. /* OnException */  
  
  
  method public static void LogMessage(
    
    /* Write a message to unittest session log */
  
    input cMessageIP# as character
    ):
      
    if cMessageIP# > "" then 
    do:
      
      if cLogFile = "" then  
        cLogFile = sc_path:cLogVoortgangDir + subst("unittest_&1_&2.log", sc_environment:cEnv, sc_date_timestamp:cTimeStamp_Short_DateAndTime).
    
      output to value(cLogFile) append.
      put unformatted cMessageIP# skip.
      output close.
      
    end.
    
  end method. /* LogMessage */


  method protected static void PersistencyWarning(
  
    cTestIDIP# as character):
    
    define variable cMessage# as character no-undo.
    define variable cFile#    as character no-undo.
    
    define buffer b-ttPersistentThingsPre  for ttPersistentThingsPre.
    define buffer b-ttPersistentThingsPost for ttPersistentThingsPost.
    define buffer b-ttPersistentThingsWarn for ttPersistentThingsWarn.
    
    cFile# = subst("&1_&2_&3",sc_environment:cEnv, sc_osfile:StripInvalidChars(lc(cTestIDIP#),true), sc_date_timestamp:cTimeStamp_Readable_DateAndTime).
    
    for each b-ttPersistentThingsWarn on error undo, throw:
      cMessage# = cMessage# + chr(10) + subst("&1 instances of &2 named &3", b-ttPersistentThingsWarn.iInstances, b-ttPersistentThingsWarn.cType, b-ttPersistentThingsWarn.cName).
    end.
    
    cMessage# = substring(cMessage#,2).
    
    cMessage# = cMessage# + chr(10) + "See files: " .
    cMessage# = cMessage# + chr(10) + sc_path:cLogVoortgangDir + "persistencycheck_" + cFile# + "_pre.html".
    cMessage# = cMessage# + chr(10) + sc_path:cLogVoortgangDir + "persistencycheck_" + cFile# + "_post.html".
    cMessage# = cMessage# + chr(10) + sc_path:cLogVoortgangDir + "persistencycheck_" + cFile# + "_warn.html".
    
    sc_html:TempTableToHTML(buffer b-ttPersistentThingsPre:handle,  sc_path:cLogVoortgangDir + "persistencycheck_" + cFile# + "_pre.html").
    sc_html:TempTableToHTML(buffer b-ttPersistentThingsPost:handle, sc_path:cLogVoortgangDir + "persistencycheck_" + cFile# + "_post.html").
    sc_html:TempTableToHTML(buffer b-ttPersistentThingsWarn:handle, sc_path:cLogVoortgangDir + "persistencycheck_" + cFile# + "_warn.html").

    &if false &then
    
    /* Excel doesn't work for this specific temp-table, as of 20120425 */
    /* Create an excel(xml) file of the temp-table */
    sc_msoffice_crossplatform:ExcelSaxToXml(
      (buffer ttPersistentThingsPre:handle), ?,
      sc_path:cLogVoortgangDir + "persistencycheck_" + cFile# + "_pre.xml",
      "[UserName] unittest [AutoFilter] yes [Header] yes [ExcelUseDataType] yes"
      ).

    /* Create an excel(xml) file of the temp-table */
    sc_msoffice_crossplatform:ExcelSaxToXml(
      (buffer ttPersistentThingsPost:handle), ?,
      sc_path:cLogVoortgangDir + "persistencycheck_" + cFile# + "_post.xml",
      "[UserName] unittest [AutoFilter] yes [Header] yes [ExcelUseDataType] yes"
      ).

    /* Create an excel(xml) file of the temp-table */
    sc_msoffice_crossplatform:ExcelSaxToXml(
      (buffer b-ttPersistentThingsWarn:handle), ?,
      sc_path:cLogVoortgangDir + "persistencycheck_" + cFile# + "_warn.xml",
      "[UserName] unittest [AutoFilter] yes [Header] yes [ExcelUseDataType] yes"
      ).
      
    &endif
    
    LogMessage(subst("env=&1 id=&2, descr=&3, &4",
      sc_environment:cEnv,
      cTestIDIP#,
      "PersistencyWarning",
      cMessage#
      )
      ).
    
    panaedra.msroot.msutil.logic.sc_messagebox:MsgBox(
      subst("env=&1 id=&2, descr=&3, &4",
      sc_environment:cEnv,
      cTestIDIP#,
      "PersistencyWarning",
      cMessage#
      )).
      
  end method. /* PersistencyWarning */


  method public static void RunAllUnittests(
    
    /* Run all unit tests that are found in the supplied propath entries */
  
    cSvSourcedirsIP# as character
    ):
    
    define variable iTell# as integer no-undo.
    define buffer b-ttFile for ttFile.
    
    empty temp-table ttFile.
        
    do iTell# = 1 to num-entries(cSvSourcedirsIP#):
      sc_osfile:GetFileNamesInDirectory(entry(iTell#,cSvSourcedirsIP#), "*_unittest~~.p", yes,  output table ttFile append).
    end.
    
    /* Cleanup */
    for each b-ttFile on error undo, throw:
      if b-ttFile.cFullPath matches "*/eclipsecreate_unittest~~.p" then delete b-ttFile.
    end.
    
    b_each:
    for each b-ttFile on error undo, throw:
      
      b_run:
      do
        on error  undo, throw
        on stop   undo b_run, retry b_run
        on endkey undo b_run, leave b_each:
          
        if retry then 
        do:
          LogMessage("Error: Stop condition encountered").
          message "Error: Stop condition encountered"
            view-as alert-box.
          next b_each.
        end.  
  
        LogMessage(subst("Start: &1 &2",iso-date(now),b-ttFile.cFullPath)).
        
        sc_eventbroadcaster:FireEvent("evt@unittest@run", b-ttFile.cFullPath).
        
        run value(b-ttFile.cFullPath).
        
      end.

      catch oError# as Progress.Lang.Error :
        OnException(b-ttFile.cFullPath, oError#).
        next b_each.
      end catch.
      
    end.

  end method. /* RunAllUnittests */
  
  
  method protected static void RegisterUnittest(
  
    hUnittestProcIP# as handle,
    cTestIDIP#       as character):
  
    define buffer b-ttSessionUnittest for ttSessionUnittest.

    find b-ttSessionUnittest where b-ttSessionUnittest.cTestID = cTestIDIP# no-error.
  
    if not avail b-ttSessionUnittest then 
    do:
      create b-ttSessionUnittest.
      assign 
        b-ttSessionUnittest.cTestID = cTestIDIP#
        .
    end.

    if bFirstOfTwo then
      assign 
        b-ttSessionUnittest.dtmLastInit     = now
        b-ttSessionUnittest.dtmLastFinish   = ?
        b-ttSessionUnittest.bLastTestFailed = false 
        .
    
    assign 
      b-ttSessionUnittest.hLastTestProc = hUnittestProcIP#
      b-ttSessionUnittest.cLastTestProc = b-ttSessionUnittest.hLastTestProc:file-name
      .
  
  end method. /* RegisterUnittest */
  

  method protected static void RegisterUnitFail():
  
    define buffer b-ttSessionUnittest for ttSessionUnittest.
  
    find b-ttSessionUnittest where b-ttSessionUnittest.cTestID = cCurrentGlobalTestID no-error.
  
    if not avail b-ttSessionUnittest then 
      undo, throw new c_panaedraexception(
        99940291,
        sc_lang:oEnglish,
        substitute("ttSessionUnittest not found with '&1'", cCurrentGlobalTestID)
        ).

    assign 
      b-ttSessionUnittest.bLastTestFailed = true.
  
  end method. /* RegisterUnitFail */
  

  method protected static logical GetLastTestFailed():
  
    define buffer b-ttSessionUnittest for ttSessionUnittest.
  
    find b-ttSessionUnittest where b-ttSessionUnittest.cTestID = cCurrentGlobalTestID no-error.
  
    if not avail b-ttSessionUnittest then 
      undo, throw new c_panaedraexception(
        99940291,
        sc_lang:oEnglish,
        substitute("ttSessionUnittest not found with '&1'", cCurrentGlobalTestID)
        ).

    return b-ttSessionUnittest.bLastTestFailed.
  
  end method. /* GetLastTestFailed */
  
  
  method protected static void RunLastTestAgain():
  
    define buffer b-ttSessionUnittest for ttSessionUnittest.
  
    find b-ttSessionUnittest where b-ttSessionUnittest.cTestID = cCurrentGlobalTestID no-error.
  
    if not avail b-ttSessionUnittest then 
      undo, throw new c_panaedraexception(
        99940291,
        sc_lang:oEnglish,
        substitute("ttSessionUnittest not found with '&1'", cCurrentGlobalTestID)
        ).

    run value(b-ttSessionUnittest.cLastTestProc).
  
  end method. /* RunLastTestAgain */

end class.

/* EOF */
