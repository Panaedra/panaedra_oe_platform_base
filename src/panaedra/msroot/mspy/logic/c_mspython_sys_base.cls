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
	{panaedra/msroot/mspy/logic/sc_mspython_externals_def.i &protected=protected &static=static &OnlyPreprocessorDefs=true}

  /************************  Source control constructor ************************/
	constructor public c_mspython_sys_base(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
		panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
	end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
	define protected static variable hProcEvalPython as handle    no-undo.
	define protected static variable iNumInstances   as integer   no-undo.

	define public           variable clobDataIn      as longchar  no-undo.
	define public           variable clobOutput      as longchar  no-undo.
	define public           variable clobError       as longchar  no-undo.
	define protected        variable mError          as memptr    no-undo.
	define public           variable iErrorLen       as int64     no-undo.
	define protected        variable mInput          as memptr    no-undo.
	define protected        variable mOutput         as memptr    no-undo.
	define public           variable iOutputLen      as int64     no-undo.
	define public           variable clobPyCode      as longchar  no-undo.
  
	define protected static variable cSvId           as character no-undo. /* We use a csv instead of a temp-table. This is quicker up until about 200 entries. */
  
	define property cId as character no-undo
		public get.
		protected set.
  
	define property cClass as character no-undo
		public get.
		protected set.
  
	define property cMethod as character no-undo
		public get.
		protected set.
  
	define property cNamespace as character no-undo
		public get.
		protected set.
  
	constructor public c_mspython_sys_base(
  
		cIdIP#        as character,
		cClassIP#     as character,
		cMethodIP#    as character,
		cNamespaceIP# as character):
		
		assign	
			iNumInstances = iNumInstances + 1
			cId           = cIdIP#                
			cClass        = cClassIP#     
			cMethod       = cMethodIP#    
			cNamespace    = cNamespaceIP#.
			
		if substring(cNamespace,length(cNamespace)) = "." then
		  /* Panaedra standard, namespace contains class name. Ending the namespace with a dot does that for you. */
		  cNamespace = cNamespace + cClass.
		
		set-size(mError) = {&MaxErrorLen}.
		if not valid-handle(hProcEvalPython) then run panaedra/msroot/mspy/logic/c_mspython_sys_base_sub.p persistent set hProcEvalPython.
	
	end constructor.
	

	destructor c_mspython_sys_base():
		
		set-size(mError) = 0.
		iNumInstances = iNumInstances - 1.
		if iNumInstances <= 0 then 
		do:
			if valid-handle(hProcEvalPython) then sc_procedurehandles:DeleteProcedure(this-object, hProcEvalPython).
		end.
		
	end destructor.
	

	method public void _sys_GeneratePyCode():
    
    /* Generate Python code that *does* the following: 
       Run a python static method in a python class (of a specific namespace/package).
       The method that will be called *must* have exactly 1 input parameter, and 
       return exactly 1 output parameter. These can be simple strings, unicode strings, 
       or bytearrays.
    */
    
		clobPyCode = 
			subst("from &1 import &2",cNamespace, cClass)    + chr(10) +
			subst("cDataOP = &1.&2(cDataIP)",cClass,cMethod) + chr(10) +
			subst("#EOF").

	end method.  /* _sys_GeneratePyCode */
	

	method public void QxPy_SetCompiledPyCode(input iPyObjectIP# as integer, input cPyDescIP# as character):
    
		run QxPy_SetCompiledPyCode in hProcEvalPython (iPyObjectIP#, cPyDescIP#, clobPyCode, input-output mError, output iErrorLen).

		if iErrorLen > 0 then
			clobError = get-string(mError, 1, iErrorLen).
		else
			clobError = "".
    
	end method. /* QxPy_SetCompiledPyCode */
  
  
	method public void QxPy_RunCompiledPyCodeUnbuffered(
  
    /* Run compiled python code. cInputIP in python is a unicode object */

		input iPyObjectIP# as integer):

		if clobDataIn = "" or clobDataIn = ? then
			clobDataIn = " ". /* Some data needed (one space), otherwise OE complains about uninitialized memptr */
    
		set-size(mInput) = 0.
		copy-lob clobDataIn to mInput. /* Deep copy needed because direct longchar to shared object has big memleak in OE10.2B and small memleak OE11.2SP01. Progress help recommends copying to memptr, it seems to be a necessity, alas. */
    
		run QxPy_RunCompiledPyCodeUnbuffered in hProcEvalPython (iPyObjectIP#, input mInput, output iOutputLen, input-output mError, output iErrorLen, output mOutput).
    
		set-size(mInput) = 0.
    
		if iOutputLen > 0 then
			clobOutput = get-string(mOutput, 1, iOutputLen).
      &if false &then
      /* This should be more correct (with convert to cpinternal), but gives the following error: 
         copy-lob mOutput starting at 1 for iOutputLen to clobOutput. 
         gives (OE10.2B04,OE11.2,OE11.2SP01) Cannot copy large object starting at 1 for 17 bytes when object size is 0. (11305)*/
      /* Note on mOutput : set-size to 0 not needed, memptr lives in python, ABL does not even know the size. */    
      &endif
		else
			clobOutput = "".
      
		if iErrorLen > 0 then
			clobError = get-string(mError, 1, iErrorLen).
		else
			clobError = "".
      
	end method. /* QxPy_RunCompiledPyCodeUnbuffered */
  

	method public void QxPy_RunCompiledPyCodeUnbufferedB(
  
    /* Same as QxPy_RunCompiledPyCodeUnbuffered, but cInputIP in python is a bytearray instead of a unicode object */
    
		input iPyObjectIP# as integer):
    

		if clobDataIn = "" or clobDataIn = ? then
			clobDataIn = " ". /* Some data needed (one space), otherwise OE complains about uninitialized memptr */
    
		set-size(mInput) = 0.
		copy-lob clobDataIn to mInput. /* Deep copy needed because direct longchar to shared object has big memleak in OE10.2B and small memleak OE11.2SP01. Progress help recommends copying to memptr, it seems to be a necessity, alas. */
    
		run QxPy_RunCompiledPyCodeUnbufferedB in hProcEvalPython (iPyObjectIP#, input mInput, output iOutputLen, input-output mError, output iErrorLen, output mOutput).
    
		set-size(mInput) = 0.
    
		if iOutputLen > 0 then
			clobOutput = get-string(mOutput, 1, min(iOutputLen,31500)).
      &if false &then
      /* This should be more correct (with convert to cpinternal), but gives the following error: 
         copy-lob mOutput starting at 1 for iOutputLen to clobOutput. 
         gives (OE10.2B04,OE11.2,OE11.2SP01) Cannot copy large object starting at 1 for 17 bytes when object size is 0. (11305)*/
      /* Note on mOutput : set-size to 0 not needed, memptr lives in python, ABL does not even know the size. */    
      &endif
		else
			clobOutput = "".
      
		if iErrorLen > 0 then
			clobError = get-string(mError, 1, iErrorLen).
		else
			clobError = "".
      
	end method. /* QxPy_RunCompiledPyCodeUnbufferedB */
  

	method public void QxPy_RunCompiledPyCodeUnbufferedBB(
  
    /* Same as QxPy_RunCompiledPyCodeUnbuffered, but cInputIP in python is a bytearray 
       instead of a unicode object, and cDataOP in python must also be a bytearray object. */
    
		input iPyObjectIP# as integer):
    

		if clobDataIn = "" or clobDataIn = ? then
			clobDataIn = " ". /* Some data needed (one space), otherwise OE complains about uninitialized memptr */
    
		set-size(mInput) = 0.
		copy-lob clobDataIn to mInput. /* Deep copy needed because direct longchar to shared object has big memleak in OE10.2B and small memleak OE11.2SP01. Progress help recommends copying to memptr, it seems to be a necessity, alas. */
    
		run QxPy_RunCompiledPyCodeUnbufferedBB in hProcEvalPython (iPyObjectIP#, input mInput, output iOutputLen, input-output mError, output iErrorLen, output mOutput).
    
		set-size(mInput) = 0.
    
		if iOutputLen > 0 then
			clobOutput = get-string(mOutput, 1, iOutputLen).
      &if false &then
      /* This should be more correct (with convert to cpinternal), but gives the following error: 
         copy-lob mOutput starting at 1 for iOutputLen to clobOutput. 
         gives (OE10.2B04,OE11.2,OE11.2SP01) Cannot copy large object starting at 1 for 17 bytes when object size is 0. (11305)*/
      /* Note on mOutput : set-size to 0 not needed, memptr lives in python, ABL does not even know the size. */    
      &endif
		else
			clobOutput = "".
      
		if iErrorLen > 0 then
			clobError = get-string(mError, 1, iErrorLen).
		else
			clobError = "".

	end method. /* QxPy_RunCompiledPyCodeUnbufferedBB */
	
	method public void QxPy_FreeCompiledPyCode(
	  iBlablaIP# as int):
	  run QxPy_FreeCompiledPyCode in hProcEvalPython (iBlablaIP#).
	end method. /* name */
  
end class.

/* EOF */ 
