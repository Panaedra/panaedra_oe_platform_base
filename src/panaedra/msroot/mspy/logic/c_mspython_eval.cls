{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.mspy.logic.c_mspython_eval 
	inherits
	panaedra.msroot.mspy.logic.c_mspython_sys_base: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Python call object for loose snippets of python code, evaluated real-time

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_mspython_eval(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
     super(o-sourcecontrol, this-object).
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  constructor public c_mspython_eval(cPyCodeIP# as character):
    	
    super(guid, cPyCodeIP#). 	
	
	end constructor.

end class.

/* EOF */ 
