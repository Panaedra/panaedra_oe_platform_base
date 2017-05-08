using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.mspy.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.mspy.logic.sc_mspysys: 

  /****************************** Source Header ********************************\

      Description: Python system calls

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define protected static variable oPySleep as c_mspython_call no-undo.
  define protected static variable oPyTrash as c_mspython_call no-undo.

  method public static void MicroSleep(
  
    /* Does the same as sc_abl:MicroSleep(), but enables responding 
     * to signals like kill -2 (SIGINT) by using pythons threading 
     * module */
     
    input iMillisecondsIP# as integer):
    
    if iMillisecondsIP# > 0 then 
    do:
      
      if not valid-object(oPySleep) then
        oPySleep = new c_mspython_call("Sleep","sc_mspysys","MicroSleep","panaedra.msroot.msutil.logic.").

      oPySleep:clobDataIn = trim(string(iMillisecondsIP#,">>>>>>999")). 
      oPySleep:PyRunU().
      if length(oPySleep:clobError) > 0 then
        undo, throw new c_panaedraexception(99959152,sc_lang:oEnglish,substitute("&1", oPySleep:clobError)).
    
    end.
    
  end method.  /* MicroSleep */


  method public static void AllObjectsToTrash(
  
    /* Does a 'del' on all python class objects.
     * Prevents core dumps at the end of an ABL session. */
     
    ):
    
    if not valid-object(oPyTrash) then
      oPyTrash = new c_mspython_call("Trash","sc_mspysys","AllObjectsToTrash","panaedra.msroot.msutil.logic.").

    oPyTrash:clobDataIn = "". 
    oPyTrash:PyRunU().
    if length(oPyTrash:clobError) > 0 then
      undo, throw new c_panaedraexception(99959153,sc_lang:oEnglish,substitute("&1", oPyTrash:clobError)).
    
  end method.  /* AllObjectsToTrash */

end class.

/* EOF */ 
