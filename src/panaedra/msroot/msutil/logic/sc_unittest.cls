using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msmonitor.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_unittest
  implements
  i_unittest_param: 

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
  
  &glob ttExtraFields ~
  field cSvHandles as character xml-node-type "attribute" ~
  field cWarning   as character xml-node-type "attribute" ~
  field iInstances as integer   xml-node-type "attribute"
  
{panaedra/msroot/msutil/logic/tt/mspersistencyinfo_tt.i &class=class &protected=protected &static=static &ttSuffix=Warn &ttWarnFieldsOnly=true}
  
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
    field oLastTestClass  as Progress.Lang.Object
    field cLastTestProc   as character
    field dtmLastInit     as datetime-tz
    field dtmLastFinish   as datetime-tz
    index cTestID is primary unique cTestID.

  define protected static variable oSingleton            as sc_unittest no-undo.
  define protected static variable cLogFile              as character   no-undo.
  define protected static variable cPreviousGlobalTestID as character   no-undo.
  define protected static variable cCurrentGlobalTestID  as character   no-undo.
  define protected static variable bFirstOfTwo           as logical     no-undo. /* If a unittest has finished okay, it's run a second time for memleak check. Stored in bFirstOfTwo. */
  define protected static variable bRunOnNonTstOkay      as logical     no-undo.
  
  constructor protected sc_unittest():
    
  end constructor.
    

  method public static void UnittestInit(
  
    /* Always run this method once, at the start of the unittest, outside of any transactions */
    
    hUnittestProcIP# as handle,
    cTestIDIP#       as character):
    
    UnittestInit(hUnittestProcIP#,?,cTestIDIP#).
      
  end method. /* UnittestInit | procedure handle */
     
    
  method public static void UnittestInit(
  
    /* Always run this method once, at the start of the unittest, outside of any transactions */
    
    oUnittestClassIP#   as i_unittest_client,
    cTestIDIP# as character):
    
    UnittestInit(?,oUnittestClassIP#,cTestIDIP#).
      
  end method. /* UnittestInit | object */
     
    
  method protected static void UnittestInit(
  
    /* Always run this method once, at the start of the unittest, outside of any transactions */
    
    hUnittestProcIP#  as handle,
    oUnittestClassIP# as i_unittest_client,
    cTestIDIP#        as character):

    define variable bFirstOfTwo# as logical no-undo.
    
    if sc_environment:bLiveEnv then
      undo, throw new c_panaedraexception(
        99958111,
        sc_lang:oEnglish,
        substitute("Running of unit tests in a live environment is NEVER allowed. TestID='&1'", cTestIDIP#)).

    if not sc_environment:cEnv matches "*tst*" then 
    do:
      if sc_environment:bBatchMode then
        undo, throw new c_panaedraexception(
          99958112,
          sc_lang:oEnglish,
          substitute("Unit tests should be run on a *tst* environment. TestID='&1'", cTestIDIP#)).
      else 
      do:
        message 
          substitute("Unit tests should be run on a *tst* environment. TestID='&1'", cTestIDIP#) skip
          "Do you want to continue?"
          view-as alert-box buttons yes-no update bRunOnNonTstOkay.
        if not bRunOnNonTstOkay then 
          undo, throw new c_panaedraexception(
            99958113,
            sc_lang:oEnglish,
            substitute("Unit tests should be run on a *tst* environment. TestID='&1'", cTestIDIP#)).
      end.
    end.

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
    RegisterUnittest(hUnittestProcIP#,oUnittestClassIP#,cTestIDIP#).
    
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
    oUnittestClassIP# as i_unittest_client,
    cTestIDIP#        as character):
    
    UnittestFinish(?,oUnittestClassIP#,cTestIDIP#).
    
  end method. /* UnittestFinish | object */
  
  
  method public static void UnittestFinish(
    hUnittestProcIP#  as handle,
    cTestIDIP#        as character):
  
    UnittestFinish(hUnittestProcIP#,?,cTestIDIP#).
    
  end method. /* UnittestFinish | procedure */
  
  
  method public static void UnittestFinish(
  
    /* Always run this method once, at the end of the unittest, after cleanup of handles/objects, outside of any transactions */
    
    hUnittestProcIP#  as handle,
    oUnittestClassIP# as i_unittest_client,
    cTestIDIP#        as character):
    
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
            b-ttPersistentThingsWarn.cSvHandles = "," /* For easier string replace later on */
            b-ttPersistentThingsWarn.iInstances = 0.
        
        end. /* first-of */

        b-ttPersistentThingsWarn.iInstances = b-ttPersistentThingsWarn.iInstances + 1.
        
        if b-ttPersistentThingsPost.hHandle <> ? then
          b-ttPersistentThingsWarn.cSvHandles = 
            b-ttPersistentThingsWarn.cSvHandles + 
            trim(string(b-ttPersistentThingsPost.hHandle)) + ",". 
        
        if last-of(b-ttPersistentThingsPost.cName) then 
        do:
          
          for each b-ttPersistentThingsPre
            where b-ttPersistentThingsPre.cType = b-ttPersistentThingsPost.cType 
            and   b-ttPersistentThingsPre.cName = b-ttPersistentThingsPost.cName
            on error undo, throw:
              
            b-ttPersistentThingsWarn.iInstances = b-ttPersistentThingsWarn.iInstances - 1.

            if b-ttPersistentThingsPre.hHandle <> ? then 
            do:
              /* Remove handle from "warning" list */
              b-ttPersistentThingsWarn.cSvHandles = replace(
                b-ttPersistentThingsWarn.cSvHandles, 
                "," + trim(string(b-ttPersistentThingsPre.hHandle)) + ",", 
                ",").
            end. 
            
          end.
          
          b-ttPersistentThingsWarn.cSvHandles = trim(b-ttPersistentThingsWarn.cSvHandles,",").
          
        end. /* last-of */
          
      end. /* each b-ttPersistentThingsPost */
      
      for each b-ttPersistentThingsWarn where b-ttPersistentThingsWarn.iInstances <= 0 on error undo, throw:
        delete b-ttPersistentThingsWarn.
      end.
      
      if can-find(first b-ttPersistentThingsWarn) then 
      do: 
        PersistencyFeedback(cTestIDIP#).
        empty temp-table ttPersistentThingsWarn.
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
      AssertFailFeedback(cTestIDIP#, cTestDescIP#, subst("&1",bNewValueIP#), subst("&1",bExpectedValueIP#), "").
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
      AssertFailFeedback(cTestIDIP#, cTestDescIP#, subst("&1",cNewValueIP#), subst("&1",cExpectedValueIP#), "").
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
      AssertFailFeedback(cTestIDIP#, cTestDescIP#, subst("&1",iNewValueIP#), subst("&1",iExpectedValueIP#), "").
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
      AssertFailFeedback(cTestIDIP#, cTestDescIP#, subst("&1",fNewValueIP#), subst("&1",fExpectedValueIP#), "").
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
      AssertFailFeedback(cTestIDIP#, cTestDescIP#, subst("&1",dtNewValueIP#), subst("&1",dtExpectedValueIP#), "").
    end.

  end method. /* Assert ; date field */

  
  method public static void Assert(
    cTestIDIP# as character, 
    cTestDescIP# as character,
    dataset-handle hDatasetOneIP#, 
    dataset-handle hDatasetTwoIP#, 
    bExpectedEqualIP# as logical
    ):
      
    define variable bDatasetsEqual# as logical   no-undo.  
    define variable clobJsonOne#    as longchar  no-undo.  
    define variable clobJsonTwo#    as longchar  no-undo.
    define variable cExtraInfo#     as character no-undo.
    
    bDatasetsEqual# = sc_dataset:DatasetCompare(dataset-handle hDatasetOneIP# by-reference, dataset-handle hDatasetTwoIP# by-reference). 
    
    if (bExpectedEqualIP# = ? and bDatasetsEqual# <> ?)
      or (bExpectedEqualIP# <> ? and bDatasetsEqual# = ?)
      or (bExpectedEqualIP# <> bDatasetsEqual#) then 
    do:
      
      RegisterUnitFail().
      
      /* write files for more information */
      hDatasetOneIP#:write-xml ("file",sc_path:cWorkDir + "unittestxml1.xml", yes, "UTF-8", ?, no).
      hDatasetTwoIP#:write-xml ("file",sc_path:cWorkDir + "unittestxml2.xml", yes, "UTF-8", ?, no).
      hDatasetOneIP#:write-json("file",sc_path:cWorkDir + "unittestjson1.json", yes, "UTF-8").  
      hDatasetTwoIP#:write-json("file",sc_path:cWorkDir + "unittestjson2.json", yes, "UTF-8").
            
      cExtraInfo# = subst("See &1 for more information.",sc_path:cWorkDir + "unittestxml1.xml").

      AssertFailFeedback(cTestIDIP#, cTestDescIP#, subst("&1",bDatasetsEqual#), subst("&1",bExpectedEqualIP#), cExtraInfo#).

    end.
    
    finally:
      /* Parameters cleanup */
      delete object hDatasetOneIP# no-error. /* by-ref/not : no other way than no-error */
      delete object hDatasetTwoIP# no-error. /* by-ref/not : no other way than no-error */
    end finally.
    
  end method. /* Assert ; two datasets */

  
  method public static void OnException(
  
    cTestIDIP#   as character, 
    oExIP#       as Progress.Lang.Error):
      
    RegisterUnitFail().
    ExceptionFeedback(cTestIDIP#, oExIP#,"").

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

  
  method protected static void AssertFailFeedback(
    
    /* Feedback; to user interface and/or log file, to e-mail, or to intranet */
    
    input cTestIDIP# as character,
    input cTestDescIP# as character,
    input cNewValueIP# as character,
    input cExpectedValueIP# as character,
    input cExtraInfoIP# as character
    ):

    LogMessage(subst("Assert failed. env=&1 id=&2, descr=&3, calc=&4, exp=&5, info=&6",   
      sc_environment:cEnv,
      cTestIDIP#,
      cTestDescIP#,
      cNewValueIP#,
      cExpectedValueIP#,
      cExtraInfoIP#
      )).
    
    if not sc_environment:bBatchMode then 
    do:
      sc_messagebox:MsgBox(subst("&1 Assert failed. [&2]~n&3 -> &4~nCalculated:&5~nExpected:&6~n&7",
        now,
        sc_environment:cEnv,
        cTestIDIP#,
        cTestDescIP#,
        cNewValueIP#,
        cExpectedValueIP#,
        cExtraInfoIP#)).
    end.
    else 
    do:
      sc_msmon_feedback:HandleEvent(
        "Unittest Assert Failed",      /* Event */
        cTestIDIP#,                    /* ID */
        cTestDescIP#,
        subst("[Env] &1~nCalculated value: &2~nExpected value: &3~nExtra info: &4", 
        sc_environment:cEnv, 
        cNewValueIP#,
        cExpectedValueIP#,
        cExtraInfoIP#)).
    end.
      
  end method. /* AssertFailFeedback */


  method protected static void ExceptionFeedback(
    
    /* Feedback; to user interface and/or log file, to e-mail, or to intranet */
    
    input cTestIDIP# as character,
    input oErrorIP# as Progress.Lang.Error,
    input cExtraInfoIP# as character
    ):

    LogMessage(subst("Exception encountered. env=&1 id=&2, exception=&3, info=&4",   
      sc_environment:cEnv,
      cTestIDIP#,
      sc_showexception:ExceptionToString(oErrorIP#),
      cExtraInfoIP#
      )).
    
    if not sc_environment:bBatchMode then 
    do:
      sc_messagebox:MsgBox(subst("&1 &2~n&3~n&4~n&5~n&6",
        now,
        "Exception encountered.",
        sc_environment:cEnv,
        cTestIDIP#,
        sc_showexception:ExceptionToString(oErrorIP#),
        cExtraInfoIP#)).
    end.
    else 
    do:
      /* Note: this ShowException will handled by sc_msmon_feedback, because we are in batchmode */
      sc_showexception:ShowException(
        subst("Unittest Exception [&1]:~n&2~n&3",
        sc_environment:cEnv,
        cTestIDIP#,
        cExtraInfoIP#),
        oErrorIP#).
    end.
    
  end method. /* ExceptionFeedback */


  method protected static void PersistencyFeedback(
  
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

    LogMessage(subst("env=&1 id=&2, descr=&3, &4",
      sc_environment:cEnv,
      cTestIDIP#,
      "PersistencyWarning",
      cMessage#)).
    
    if not sc_environment:bBatchMode then 
    do:
      sc_messagebox:MsgBox(
        subst("env=&1 id=&2, descr=&3, &4",
        sc_environment:cEnv,
        cTestIDIP#,
        "PersistencyWarning",
        cMessage#)).
    end.
    else 
    do:
      sc_msmon_feedback:HandleEvent(
        "Unittest Persistency Warning", /* Event */
        cTestIDIP#,                     /* ID */
        sc_path:cLogVoortgangDir + "persistencycheck_" + cFile# + "_warn.html", /* Location */
        subst("[Env] &1~n&2", 
        sc_environment:cEnv, 
        cMessage#)).
    end.
      
  end method. /* PersistencyFeedback */


  method public static void RunAllUnittests(
    
    /* Run all unit tests that are found in the supplied propath entries */
  
    cSvSourcedirsIP# as character
    ):
    
    define variable iTell#           as integer           no-undo.
    
    define buffer b-ttFile            for ttFile.
    define buffer b-ttSessionUnittest for ttSessionUnittest.

    /* Needed for special unittest constructor in c_*_unittests.cls */
    if not valid-object(oSingleton) then
      oSingleton = new sc_unittest(). 

    empty temp-table ttFile.
    
    /* Collect all unittests */    
    do iTell# = 1 to num-entries(cSvSourcedirsIP#):
      sc_osfile:GetFileNamesInDirectory(entry(iTell#,cSvSourcedirsIP#), "*_unittest~~.p", yes,  output table ttFile append).
      sc_osfile:GetFileNamesInDirectory(entry(iTell#,cSvSourcedirsIP#), "*_unittests~~.cls", yes,  output table ttFile append).
    end.
    
    /* Cleanup */
    for each b-ttFile on error undo, throw:
      if b-ttFile.cFullPath matches "*/eclipsecreate_unittest~~.p" then delete b-ttFile.
    end.
    
    /* Walk trough each unittest file */
    b_each:
    for each b-ttFile on error undo, throw:
      
      b_run:
      do
        on error  undo, throw
        on stop   undo b_run, retry b_run
        on endkey undo b_run, leave b_each:
          
        if retry then 
        do:
          undo, throw new c_panaedraexception(
            99948119,
            sc_lang:oEnglish,
            substitute("Error: Stop condition encountered for &1", b-ttFile.cFullPath)
            ).
        end.  
        
        RunSingleUnittest(b-ttFile.cFullPath).  
        
      end.

      catch oError# as Progress.Lang.Error :
        OnException(b-ttFile.cFullPath, oError#).
        next b_each.
      end catch.
      
    end.
    
    
    finally:
      
      /* Cleanup each unittest object */  
      for each b-ttSessionUnittest 
        where b-ttSessionUnittest.oLastTestClass > ?
        on error undo, throw:
            
        if valid-object (b-ttSessionUnittest.oLastTestClass) then
          delete object b-ttSessionUnittest.oLastTestClass.
            
      end. /* each ttSessionUnittest */
           
    end. /* finally */
        
  end method. /* RunAllUnittests */
  
  
  method public static void RunSingleUnittest(
    /* ------------------------------------------------------------
       runs a single unittest
       ------------------------------------------------------------ */
    cFullPathIP# as character
    ):
    
    define variable oUnittestClient# as i_unittest_client no-undo.
    define variable cSvUnittests#    as character         no-undo.
    

    /* Needed for special unittest constructor in c_*_unittests.cls */
    if not valid-object(oSingleton) then
      oSingleton = new sc_unittest(). 

    
    LogMessage(subst("Start unittest: &1 &2",iso-date(now), cFullPathIP#)).
        
    sc_eventbroadcaster:FireEvent("evt@unittest@run", cFullPathIP#).

    if cFullPathIP# matches "*~~.cls" then
    do:
      /* If the unittest is a class, get the relative class name and create an object from it */
      oUnittestClient# = dynamic-new(sc_path:SplitGetClassName(sc_path:Full2PartialPath(cFullPathIP#)) /* en .cls er af */) (oSingleton).
          
      /* Get a lists of all units in this class */
      oUnittestClient#:GetUnittests(output cSvUnittests#).
          
      /* Run alle unittests in this class */
      RunUnittestsInClass(oUnittestClient#, cSvUnittests#).
    end.
    else
      run value(cFullPathIP#).
  
  end method. /* RunSingleUnittest */
  
  
  method protected static void RunUnittestsInClass(
    oUnittestClientIP# as i_unittest_client,
    cSvUnittestsIP#  as character):
    
    define variable iTell#  as integer   no-undo.
    define variable cEntry# as character no-undo.
    
    /* Walk trough each unit */
    do iTell# = 1 to num-entries(cSvUnittestsIP#):
      cEntry# = entry(iTell#,cSvUnittestsIP#).
      
      if cEntry# > "" then 
      do:
        oUnittestClientIP#:ExecuteUnittest(cEntry#).
      end.
      
    end. /* iTell# = 1 to num-entries(cSvUnittestsIP#) */ 
  
  end method. /* RunUnittestsInClass */
  
  
  method protected static void RegisterUnittest(
  
    hUnittestProcIP#  as handle,
    oUnittestClassIP# as i_unittest_client,
    cTestIDIP#        as character):
  
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
      b-ttSessionUnittest.hLastTestProc  = hUnittestProcIP#
      b-ttSessionUnittest.oLastTestClass = oUnittestClassIP#
      b-ttSessionUnittest.cLastTestProc  = if hUnittestProcIP# <> ? 
        then b-ttSessionUnittest.hLastTestProc:file-name 
        else b-ttSessionUnittest.oLastTestClass:tostring()
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
    
    if b-ttSessionUnittest.oLastTestClass <> ? then do:
      sc_eventbroadcaster:FireEvent("evt@UnitTestRerunMemcheck").
      cast(b-ttSessionUnittest.oLastTestClass,i_unittest_client):ExecuteUnittest(b-ttSessionUnittest.cTestID).
    end.
    else
      run value(b-ttSessionUnittest.cLastTestProc).
  
  end method. /* RunLastTestAgain */

end class.

/* EOF */
