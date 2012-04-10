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

  /************************  Source control constructor ************************/
  constructor public sc_unittest(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define static temp-table ttFile no-undo
    field cFullPath as char.
    
  method public static void UnittestInit(
  
    /* Always run this method once, at the start of the unittest, outside of any transactions */
    
    cTestIDIP# as character):
    
    if sc_environment:bLiveEnv then
    undo, throw new c_panaedraexception(
      99958111,
      sc_lang:oEnglish,
      substitute("Running of unit tests in a live environment is never allowed. TestID='&1'", cTestIDIP#)).
    
  end method. /* UnittestInit */  
  

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

      panaedra.msroot.msutil.logic.sc_messagebox:MsgBox(
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

    panaedra.msroot.msutil.logic.sc_messagebox:MsgBox(
      subst("&1~n&2~n&3~n&4~n&5~n&6~n&7~n&8~n&9~n",
      "Assert failed; exception.", 
      sc_environment:cEnv,
      cTestIDIP#,
      oExIP#:GetMessage(1),
      oExIP#:GetMessage(2),
      oExIP#:GetMessage(3),
      oExIP#:CallStack     
      )).

  end method. /* OnException */  
  
  
  method public static void Logmessage(
    input cMessageIP# as character
    ):
      
    define variable cFile# as character no-undo.  
  
    cFile# = sc_path:cLogVoortgangDir + subst("unittest_&1_&2.log", sc_environment:cEnv, sc_date_timestamp:cTimeStamp_Short_Date).
    
    output to value(cFile#) append.
    put unformatted cMessageIP# skip.
    output close.
  
  end method. /* Logmessage */


  method public static void RunAllUnittests(
    
    /* Run all unit tests that are found in the supplied propath entries */
  
    cSvSourcedirsIP# as character
    ):
    
    define variable iTell# as integer no-undo.
    
    empty temp-table ttFile.
        
    do iTell# = 1 to num-entries(cSvSourcedirsIP#):
      sc_osfile:GetFileNamesInDirectory(entry(iTell#,cSvSourcedirsIP#), "*_unittest~~.p", yes,  output table ttFile append).
    end.
    
    for each ttFile /* codeQok#7105 */
      on error undo, next
      on stop  undo, next:

      sc_eventbroadcaster:FireEvent("evt@unittest@run", ttFile.cFullPath).
      run value(ttFile.cFullPath).
      
    end.

    hide frame frm-ut.
     
  end method. /* RunAllUnittests */

end class.

/* EOF */ 
