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
  

  method public static integer AblSignalThreadmaskApply():
    
    /* 
     * FREF@60c9fefbb: Set a threadmask (by ''pthread_sigmask'') before creating new threads, so we don't interrupt critical signal handling of the OpenEdge ABL runtime. Effect can immediately be seen with Ctrl+C in TTY/CHUI on AIX. OE11.6.2-x64-AIX7.1, 2017Q1. (see: _DOC_)
     * Block specific signals in the current thread, as well as the next thread created
     * http://knowledgebase.progress.com/%61rticles/%41rticle/P67938 (How Progress interprets and handles kill signals)
     */
  
    define variable iReturn# as integer no-undo.
    
    if not valid-handle(hExternals) then 
    do:
      if not valid-object(oSingleton) then oSingleton = new sc_unix().
      sc_procedurehandles:PersistentProcedure(oSingleton, "panaedra/msroot/msutil/logic/sc_unix_sub.p", output hExternals).
    end.
    
    run abl_signal_threadmask_apply in hExternals (output iReturn#).
    
  end method. /* AblSignalThreadmaskApply */
  
  
  method public static integer AblSignalThreadmaskReset():
  
    /* 
     * FREF@60c9fefbb: Set a threadmask (by ''pthread_sigmask'') before creating new threads, so we don't interrupt critical signal handling of the OpenEdge ABL runtime. Effect can immediately be seen with Ctrl+C in TTY/CHUI on AIX. OE11.6.2-x64-AIX7.1, 2017Q1. (see: _DOC_)
     * Remove any signalmask in the threadmask of the current thread
     * If you call abl_signal_threadmask_apply from the main thread (before creating a new
     * thread), you must call abl_signal_threadmask_reset afterwards.
     * If you call abl_signal_threadmask_apply from the new thread itself, there is no need to reset.
     */
    
    define variable iReturn# as integer no-undo.
    
    if not valid-handle(hExternals) then 
    do:
      if not valid-object(oSingleton) then oSingleton = new sc_unix().
      sc_procedurehandles:PersistentProcedure(oSingleton, "panaedra/msroot/msutil/logic/sc_unix_sub.p", output hExternals).
    end.
    
    run abl_signal_threadmask_reset in hExternals (output iReturn#).
    
  end method. /* AblSignalThreadmaskReset */

end class.

/* EOF */
