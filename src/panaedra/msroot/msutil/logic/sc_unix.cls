using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_unix: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Unix generic shared objects externals.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_unix(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected static variable hExternals as handle  no-undo.
  define protected static variable oSingleton as sc_unix no-undo.


  constructor protected sc_unix():

  end constructor.


  method public static void MicroSleep(iMillisecondsIP# as integer):
    
    define variable iReturn# as integer no-undo.
    
    if not valid-handle(hExternals) then 
    do:
      if not valid-object(oSingleton) then oSingleton = new sc_unix().
      sc_procedurehandles:PersistentProcedure(oSingleton, "panaedra/msroot/msutil/logic/sc_unix_sub.p", output hExternals).
    end.
    
    run usleep in hExternals (1000 * iMillisecondsIP#, output iReturn#).
    
  end method. /* Microsleep */


  method public static void SetEnvironmentValue(cTokenIP# as character, cValueIP# as character):
    
    define variable iReturn# as integer no-undo.
    
    if not valid-handle(hExternals) then 
    do:
      if not valid-object(oSingleton) then oSingleton = new sc_unix().
      sc_procedurehandles:PersistentProcedure(oSingleton, "panaedra/msroot/msutil/logic/sc_unix_sub.p", output hExternals).
    end.
    
    run setenvironmentvalue in hExternals (cTokenIP#, cValueIP#, output iReturn#).
    
    if iReturn# = ? or iReturn# <> 0 then
      undo, throw new c_panaedraexception(
        99978001, sc_lang:oEnglish, substitute("Setting environment value (setenv) returns '&1'", iReturn#)).
        
  end method. /* SetEnvironmentValue */


end class.

/* EOF */ 
