using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.mspy.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.mspy.logic.sc_mspysys: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Python system calls

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_mspysys(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected static variable oPySleep as c_mspython_call no-undo.

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

end class.

/* EOF */ 
