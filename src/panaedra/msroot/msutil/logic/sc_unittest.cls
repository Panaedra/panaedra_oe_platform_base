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
      
    define variable bDatasetsEqual# as logical no-undo.  
    
    bDatasetsEqual# = sc_dataset:DatasetCompare(dataset-handle hDatasetOneIP#, dataset-handle hDatasetTwoIP#). 
    
    if (bExpectedEqualIP# = ? and bDatasetsEqual# <> ?)
      or (bExpectedEqualIP# <> ? and bDatasetsEqual# = ?)
      or (bExpectedEqualIP# <> bDatasetsEqual#) then 
    do:
      
      define variable bJsonOne# as longchar no-undo.  
      define variable bJsonTwo# as longchar no-undo.
    
      hDatasetOneIP#:write-json("longchar", bJsonOne#, true, "utf-8").  
      hDatasetTwoIP#:write-json("longchar", bJsonTwo#, true, "utf-8").

      message now "Assert failed." skip
        sc_environment:cEnv skip
        cTestIDIP# skip
        cTestDescIP# skip
        "Calculated:" bDatasetsEqual# skip
        "Expected:" bExpectedEqualIP# skip(2)
        "Dataset One:" hDatasetOneIP#:name hDatasetOneIP#:get-buffer-handle(1):name skip
        "Dataset Two:" hDatasetTwoIP#:name hDatasetTwoIP#:get-buffer-handle(1):name skip
        "JSON One:" string(substring(bJsonOne#,1,90)) skip
        "JSON Two:" string(substring(bJsonTwo#,1,90))
        view-as alert-box.

    end.
    
  end method. /* Assert ; two datasets */

end class.

/* EOF */ 
