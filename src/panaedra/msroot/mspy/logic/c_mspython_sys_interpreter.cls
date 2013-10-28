using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.mspy.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.mspy.logic.c_mspython_sys_interpreter
	implements 
	panaedra.msroot.msutil.interfaces.i_eventbroadcastclient: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Start the python interpreter (system class), happens once per session.

  \*****************************  Include Files ********************************/
	{panaedra/msroot/mspy/logic/sc_mspython_externals_def.i &static=static &protected=protected &OnlyPreprocessorDefs=true}
  
  /************************  Source control constructor ************************/
	constructor public c_mspython_sys_interpreter(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
		panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
	end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
	define protected static variable hProcInitFinalyzePython as handle   no-undo.
	define public           variable clobError               as longchar no-undo.
	define protected        variable mError                  as memptr   no-undo.
	define public           variable iErrorLen               as int64    no-undo.
  
	constructor public c_mspython_sys_interpreter(oSemiProtectedOVID# as sc_mspython):
  	
		set-size(mError) = {&MaxErrorLen}. /* Hardcoded safe limit in shared object / dll */
		run panaedra/msroot/mspy/logic/c_mspython_sys_interpreter_sub.p persistent set hProcInitFinalyzePython.
		sc_eventbroadcaster:SubscribeEvent(this-object,"evt@SessionClose").
       
	end constructor.


	method public void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
		case oBroadcastDataIP#:cEventName:
      
			when "evt@SessionClose" then 
				do:
          /* cleanup python interpreter */
					if valid-handle(hProcInitFinalyzePython) then run QxPy_FinalizeInterpreter in hProcInitFinalyzePython.
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
