using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.mspy.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.mspy.logic.sc_mspython: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Logic for communicating with the qx_python local session python interpreter

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_mspython(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable oPythonSysInterpreter as c_mspython_sys_interpreter no-undo.
  
/*  method public static c_mspython GetPython(*/
/*    cClassIP# as character,                 */
/*    cMethodIP# as character,                */
/*    cNamespaceIP# as character              */
/*    ):                                      */
/*	                                            */
/*	end method. /* GetPython */                */


  method public static logical MsPythonInitialize():
  	
	  /* Initialize the Python interpreter of this session/process */
	  if not valid-object(oPythonSysInterpreter) then do:
	  	define variable oOvid# as sc_mspython no-undo.
	  	oPythonSysInterpreter = new c_mspython_sys_interpreter(oOvid#).
	  	oPythonSysInterpreter:QxPy_InitializeInterpreter().
	  end.
	  
	end method. /* MsPythonInitialize */

end class.

/* EOF */ 
