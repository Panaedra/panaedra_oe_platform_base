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
  define protected static variable bInitialized          as logical                    no-undo.
  
  method public static logical MsPythonInitialize():
    
    /* 
      Initialize the Python interpreter of this session/process. 
      May be called multiple times, does nothing if already initialized.
    */
    
    define variable oOvid# as sc_mspython     no-undo.
    define variable oPy#   as c_mspython_call no-undo.
    
    {panaedra/msroot/msutil/logic/sc_unix_set_libpath.i}
    
    if not valid-object(oPythonSysInterpreter) then 
    do:
      if not bInitialized then 
      do:
        bInitialized = true. 
        /* Note: this 'double check' via bInitialized is done because the progress procedure editor (_edit.r) 
           cleans up objects without calling its destructor, or (ofcourse) without broadcasting the evt@SessionClose 
           event.
           Initializing the python interpreter twice, causes a crash plus core dump.
           The static boolean is not affected by the procedure editor, unless this static class is reloaded
           within the progress runtime (which is not impossible, but hard to do if you don't intend to).
        */
        
        oPythonSysInterpreter = new c_mspython_sys_interpreter(oOvid#).
        oPythonSysInterpreter:QxPy_InitializeInterpreter().
        
        /* Send environment of Progress to the Python environment, as a Python dict */
        oPy# = new c_mspython_call("inherit-env","sc_environment","_InheritAblEnvironmentSettings","panaedra.msroot.msutil.logic.").
        oPy#:clobDataIn = 
          "~{" +
          subst("'cEnv'               : '&1',", sc_environment:cEnv) +
          subst("'bLiveEnv'           :  &1 ,", trim(string(sc_environment:bLiveEnv,"True/False"))) +
          subst("'cUiMode'            : '&1',", sc_boot:SessionParameter("UiMode")) +
          subst("'cLogDir'            : '&1',", sc_boot:SessionParameter("LogDir")) +
          subst("'cSharedIniDir'      : '&1',", sc_boot:SessionParameter("SharedIniDir")) +
          subst("'cDevIP'             : '&1',", sc_boot:SessionParameter("DevIP")) +
          subst("'cOtaPath'           : '&1',", sc_boot:SessionParameter("OtaPath")) +
          subst("'cAsMode'            : '&1',", sc_boot:SessionParameter("AsMode")) +
          subst("'cUserID'            : '&1',", sc_environment:cUserID) +
          subst("'cOsUserID'          : '&1',", sc_environment:cOsUserID) +
          subst("'cLayer'             : '&1',", sc_environment:cLayer) +
          subst("'cLang'              : '&1',", sc_environment:cLang) +
          subst("'cSessionGuid'       : '&1',", sc_environment:cSessionGuid) +
          subst("'cSessionGuidShort'  : '&1',", sc_environment:cSessionGuidShort) +
          subst("'cSessionGuidRemote' : '&1',", sc_environment:cSessionGuidRemote) +
          subst("'cWorkPath'          : '&1',", sc_boot:SessionParameter("WorkPath")) +
          subst("'cDevToken'          : '&1',", sc_environment:GetOsEnv("DevToken") ) +
          "~}".
        oPy#:PyRunU().
      end.
    end.

    finally:
      if valid-object(oPy#) then delete object oPy#.
    end finally.    
    
  end method. /* MsPythonInitialize */
  
  
  method public static character PyEval(
    
    /* Simple evaluation and cleanup of a small python fragment.
       If you want more control and efficiency, use a c_mspython_call.cls 
       object.
       Inside your python code, use the special Panaedra python bridge variables:
          cDataIP: for the input character data
          cDataOP: for the returned character data
       Example:
          using panaedra.msroot.mspy.logic.*.
          message sc_mspython:PyEval("cDataOP = 'Hello ' + cDataIP", "World") view-as alert-box.
     */
    
    cPyCodeIP# as character,
    cDataIP#   as character):
      
    define variable oPyEval# as c_mspython_eval no-undo.
    define variable cReturn# as character       no-undo.
    
    oPyEval# = new c_mspython_eval(cPyCodeIP#).
    
    oPyEval#:clobDataIn = cDataIP#.
    
    oPyEval#:PyRunU().
    
    cReturn# = subst("&1",oPyEval#:clobOutput).
    
    return cReturn#. 
  
    finally:
      if valid-object(oPyEval#) then delete object oPyEval#.
    end finally.    
  
  end method. /* PyEval */

end class.

/* EOF */ 
