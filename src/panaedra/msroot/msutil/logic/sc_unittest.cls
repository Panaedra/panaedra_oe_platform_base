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
    bNewValueIP# as date,
    bExpectedValueIP# as date
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
  

end class.

/* EOF */ 
