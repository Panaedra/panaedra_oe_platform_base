{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.mspy.logic.c_mspython_call
	inherits
	panaedra.msroot.mspy.logic.c_mspython_sys_base: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Standard python call object to external python script

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_mspython_call(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    super(o-sourcecontrol, this-object).
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  constructor public c_mspython_call(
  
    cClassIP#     as character,
    cMethodIP#    as character,
    cNamespaceIP# as character
    ):
    	
   super(cClassIP#,cMethodIP#,cNamespaceIP#). 	
	
	end constructor.

end class.

/* EOF */ 
