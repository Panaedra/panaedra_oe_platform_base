using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.mspy.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.mspy.logic.c_mspython_sys_base: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Python base class, to execute logic in the private python interpreter. 
                   Uses sc_mspython.cls

  \*****************************  Include Files ********************************/
	{panaedra/msroot/mspy/logic/sc_mspython_externals_def.i &static=static &protected=protected &OnlyPreprocessorDefs=true}

  /************************  Source control constructor ************************/
	constructor public c_mspython_sys_base(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
		panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
	end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
	define protected static variable hProcEvalPython as handle  no-undo.
	define protected static variable iNumInstances   as integer no-undo.

	constructor public c_mspython_sys_base(
  
		cClassIP#     as character,
		cMethodIP#    as character,
		cNamespaceIP# as character):
			
		iNumInstances = iNumInstances + 1.
		if not valid-handle(hProcEvalPython) then run panaedra/msroot/mspy/logic/c_mspython_sys_base_sub.p persistent set hProcEvalPython.
	
	end constructor.
	

	destructor c_mspython_sys_base():
		
		iNumInstances = iNumInstances - 1.
		if iNumInstances <= 0 then 
		do:
			if valid-handle(hProcEvalPython) then sc_procedurehandles:DeleteProcedure(this-object, hProcEvalPython).
		end.
		
	end destructor.

end class.

/* EOF */ 
