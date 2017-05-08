using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.mspy.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.mspy.logic.c_mspython_sys_interpreter
  implements 
  panaedra.msroot.msutil.interfaces.i_eventbroadcastclient: 

  /****************************** Source Header ********************************\

      Description: Start the python interpreter (system class), happens once per session.

  \*****************************  Include Files ********************************/
  {panaedra/msroot/mspy/logic/sc_mspython_externals_def.i &protected=protected &static=static &OnlyPreprocessorDefs=true}
  
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable hProcInitFinalyzePython as handle   no-undo.
  define public           variable clobError               as longchar no-undo.
  define protected        variable mError                  as memptr   no-undo.
  define public           variable iErrorLen               as int64    no-undo.
  
  constructor public c_mspython_sys_interpreter(oSemiProtectedOVID# as sc_mspython):
    
    set-size(mError) = {&MaxErrorLen}. /* Hardcoded safe limit in shared object / dll */
    
    if valid-handle(hProcInitFinalyzePython) then
      undo, throw new c_panaedraexception(
        99948114,
        sc_lang:oEnglish,
        "Objects of class c_mspython_sys_interpreter should be singletons").
    
    run panaedra/msroot/mspy/logic/c_mspython_sys_interpreter_sub.p persistent set hProcInitFinalyzePython.
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@SessionClose").
       
  end constructor.


  method public void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
    case oBroadcastDataIP#:cEventName:
      
      when "evt@SessionClose" then 
        do:
          /* Note: Let python objects first do their thing */
          sc_eventbroadcaster:FireEvent("evt@PythonInterpreterExit").
          /* Note: Cleanup python interpreter */
          if valid-handle(hProcInitFinalyzePython) then 
          do:
            do on error undo, throw:
              /* Note: AllObjectsToTrash ->
               *   Implemented while bugfixing CORE dump _TOOLING_ at end of ABL session. 
               *   The problem is generic, so this solution applies to all sessions. */
              sc_mspysys:AllObjectsToTrash().
              catch oError# as Progress.Lang.Error:
                sc_showexception:ShowException(oError#).  
              end catch.
            end.
            run QxPy_FinalizeInterpreter in hProcInitFinalyzePython.
          end.
          delete object this-object.
        end.
        
    end case.
    
  end method. /* OnEventBroadcast */
  

  method public void QxPy_InitializeInterpreter():

    run QxPy_InitializeInterpreter in hProcInitFinalyzePython ({&PythonExePath}, 1000, input-output mError, output iErrorLen). /* Note: iMaxModulesIP#=100.000 in initialize (but not used yet) gives an increase of ProcessMemSize=19744KB to ProcessMemSize=20516KB. This shows it's okay to leave some margin. */
  
    if iErrorLen > 0 then
      clobError = get-string(mError, 1, iErrorLen).
    else
      clobError = "".

    if iErrorLen > 0 then
      undo, throw new c_panaedraexception(
        99951992,
        sc_lang:oEnglish,
        substitute("Error initializing Python interpreter: '&1'", this-object:clobError)
        ).
      
  end method. /* QxPy_InitializeInterpreter */

end class.

/* EOF */
