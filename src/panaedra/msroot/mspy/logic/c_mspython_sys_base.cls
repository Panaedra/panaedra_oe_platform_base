using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.mspy.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.mspy.logic.c_mspython_sys_base: 

  /****************************** Source Header ********************************\

      Description: Python base class, to execute logic in the private python interpreter. 
                   Uses sc_mspython.cls
                   
 FREF@d981b49da++: Set-size of external-allocated memptr with multiple external ABL calls. This set-size is for ABL bookkeeping only. Since it's an external MEMPTR, the ABL leaves the content of the memptr untouched. The ABL has a bug however: when making multiple external calls, it "sticks" on a recent value, which can be smaller than iOutputLen. Therefore we lie, and set it to the maximum int value. Be careful with boundary checks. 2016Q2 OE11.3SP02 win32 TW.

  \*****************************  Include Files ********************************/
  {panaedra/msroot/mspy/logic/sc_mspython_externals_def.i &protected=protected &static=static &OnlyPreprocessorDefs=true}

  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable hProcEvalPython as handle    no-undo.
  define protected static variable iNumInstances   as integer   no-undo.

  define public           variable clobDataIn      as longchar  no-undo. /* Note: Use either clobDataIn or blobDataIn    */
  define public           variable blobDataIn      as memptr    no-undo. /* Note: Use either clobDataIn or blobDataIn    */
  define public           variable iLenBlobDataIn  as int64     no-undo. /* Note: only used when blobDataIn has size > 0 */
  define public           variable clobOutput      as longchar  no-undo.
  define public           variable blobOutput      as memptr    no-undo.
  define public           variable iOutputLen      as int64     no-undo.
  define public           variable clobError       as longchar  no-undo.
  define protected        variable mError          as memptr    no-undo.
  define public           variable iErrorLen       as int64     no-undo.
  define public           variable clobPyCode      as longchar  no-undo.
  
  define protected static variable cSvId           as character no-undo. /* We use a csv instead of a temp-table. This is quicker up until about 200 entries. */
  
  define property cId as character no-undo
    public get.
    protected set.
  
  define property iId as integer no-undo
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
    
  define property bPyCompiled as logical no-undo
    public get.
    protected set.
  
  constructor protected c_mspython_sys_base(
    
    /* This is the normal constructor */
    
    cIdIP#        as character,
    cClassIP#     as character,
    cMethodIP#    as character,
    cNamespaceIP# as character):
    
    define variable iIndex# as integer no-undo.
    
    assign  
      iNumInstances = iNumInstances + 1
      cId           = cIdIP#                
      cClass        = cClassIP#     
      cMethod       = cMethodIP#    
      cNamespace    = cNamespaceIP#.
    
    if substring(cNamespace,length(cNamespace)) = "." then
      /* Panaedra standard, namespace contains class name. Ending the namespace with a dot does that for you. */
      cNamespace = cNamespace + cClass.
      
    ConstructorPost().

  end constructor.
  

  constructor protected c_mspython_sys_base(
    
    /* Constructor only to be used for small snippets of python code, which can use cDataIP if needed. */
    
    cIdIP#        as character,
    cPyCodeIP#    as character):
    
    assign  
      iNumInstances = iNumInstances + 1
      cId           = cIdIP#
      clobPyCode    = cPyCodeIP#.
    
    ConstructorPost().
    
  end constructor.
  
  
  method protected void ConstructorPost():
  
    define variable iIndex# as integer no-undo.
    
    if lookup(cSvId,cId,chr(3)) > 0 then 
    do:
      undo, throw new c_panaedraexception(
        99937288,
        sc_lang:oEnglish,
        substitute("Python (base) object with id '&1' already exists.", cId)).
    end.  
    
    if length(cSvId) = 0 then cSvId = cId.
    else 
    do:
      if cSvId begins chr(3) then cSvId = cId + cSvId.
      else 
      do:
        if substring(cSvId,length(cSvId)) = chr(3) then cSvId = cSvId + cId.
        else 
        do:
          iIndex# = index(cSvId, fill(chr(3),2)). /* Fill gaps */
          if iIndex# > 0 then 
            cSvId = substring(cSvId,1,iIndex#) + cId + substring(cSvId,iIndex# + 1).   
          else
            cSvId = cSvId + chr(3) + cId.
        end.
      end.
    end.

    iId = lookup(cId,cSvId,chr(3)) - 1. /* zero based */
    
    if iId < 0 then
      undo, throw new c_panaedraexception(
        99937289,
        sc_lang:oEnglish,
        substitute("cSvId '&1' error, cId='&2'.", cSvId, cId)).
    
    set-size(mError) = {&MaxErrorLen}.
    if not valid-handle(hProcEvalPython) then run panaedra/msroot/mspy/logic/c_mspython_sys_base_sub.p persistent set hProcEvalPython.
    
    sc_mspython:MsPythonInitialize().
    
    PyCompile().
    
    if clobError > "" then
      undo, throw new c_panaedraexception(
        99937290,
        sc_lang:oEnglish,
        substitute("PyCompile failed for '&1': &2", cSvId, substring(clobError,1,1000))).
        
  end method. /* ConstructorPost */
  
  
  destructor c_mspython_sys_base():
    
    if bPyCompiled then QxPy_FreeCompiledPyCode().
    set-size(mError) = 0.
    
    assign
      entry(iId + 1,cSvId,chr(3)) = "" /* iId is zero based */
      iNumInstances               = iNumInstances - 1.
    
    if iNumInstances <= 0 then 
    do:
      if valid-handle(hProcEvalPython) then 
        sc_procedurehandles:DeleteProcedure(this-object, hProcEvalPython).
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
      subst("from &1 import &2", cNamespace, cClass)     + chr(10) + /* codeQok#7126 */
      subst("cDataOP = &1.&2(cDataIP)", cClass, cMethod) + chr(10) +
      subst("#EOF").

  end method.  /* _sys_GeneratePyCode */
  
  
  method public void PyCompile():
    
    QxPy_SetCompiledPyCode(iId,cId).
    
  end method.
  

  method public void QxPy_SetCompiledPyCode(input iPyObjectIP# as integer, input cPyDescIP# as character):
    
    if length(clobPyCode) = 0 then _sys_GeneratePyCode().
    
    run QxPy_SetCompiledPyCode in hProcEvalPython (iPyObjectIP#, cPyDescIP#, clobPyCode, input-output mError, output iErrorLen).

    if iErrorLen > 0 then
      clobError = get-string(mError, 1, iErrorLen).
    else 
      assign
        bPyCompiled = true
        clobError   = "".
    
  end method. /* QxPy_SetCompiledPyCode */
  
  
  method public void PyRunU():

    /* Unbuffered / clob in / clob out , see header in next method called. */
    
    QxPy_RunCompiledPyCodeUnbuffered(iId).

    if clobError > "" then
      undo, throw new c_panaedraexception(
        99937291,
        sc_lang:oEnglish,
        substitute("&1", substring(clobError,1,1000))). /* We don't apply formatting, the python exception is already formatted. */
    
  end method. /* PyRunU */
  
  
  method public void QxPy_RunCompiledPyCodeUnbuffered(
  
    /* Run compiled python code. cInputIP in python is a unicode object */

    input iPyObjectIP# as integer):
      
    define variable bUseBlobDataIn# as logical no-undo.
    
    bUseBlobDataIn# = (iLenBlobDataIn > 0 and get-size(blobDataIn) > 0).
    
    if not bUseBlobDataIn# then
    do:
      if clobDataIn = "" or clobDataIn = ? then
        clobDataIn = " ". /* Some data needed (one space), otherwise OE complains about uninitialized memptr */
      set-size(blobDataIn) = 0.
      copy-lob clobDataIn to blobDataIn. /* codeQok#7133 - Deep copy needed because direct longchar to shared object has big memleak in OE10.2B and small memleak OE11.2SP01. Progress help recommends copying to memptr, it seems to be a necessity, alas. */
      iLenBlobDataIn = get-size(blobDataIn).
    end.
    
    run QxPy_RunCompiledPyCodeUnbuffered in hProcEvalPython (iPyObjectIP#, iLenBlobDataIn, blobDataIn, output iOutputLen, input-output mError, output iErrorLen, output blobOutput).
    
    if not bUseBlobDataIn# then
      set-size(blobDataIn) = 0.
    
    if iOutputLen > 0 then do:
      set-size(blobOutput) = sc_data:iMaxInt /* Note: Should be iOutputLen, see FREF@d981b49da */.
      clobOutput = get-string(blobOutput, 1, iOutputLen).
      &if false &then
      /* This should be more correct (with convert to cpinternal), but gives the following error: 
         copy-lob blobOutput starting at 1 for iOutputLen to clobOutput. (codeQok#7133) 
         gives (OE10.2B04,OE11.2,OE11.2SP01) Cannot copy large object starting at 1 for 17 bytes when object size is 0. (11305)*/
      /* Note on blobOutput : set-size to 0 not needed, memptr lives in python, ABL does not even know the size. */    
      /* New info 2016Q1: set-size to iOutputLen solves it, memptr lives in python, ABL needs to know the size. set-size does not reset the data in this scenario. */    
      &endif
    end.
    else
      clobOutput = "".
      
    if iErrorLen > 0 then
      clobError = get-string(mError, 1, iErrorLen).
    else
      clobError = "".
      
  end method. /* QxPy_RunCompiledPyCodeUnbuffered */
  
  
  method public void PyRunUB():
    
    /* Unbuffered / bytearray in / clob out , see header in next method called. */
    
    QxPy_RunCompiledPyCodeUnbufferedB(iId).

    if clobError > "" then
      undo, throw new c_panaedraexception(
        99937292,
        sc_lang:oEnglish,
        substitute("&1", substring(clobError,1,1000))). /* We don't apply formatting, the python exception is already formatted. */
    
  end method. /* PyRunUB */
  
  
  method public void QxPy_RunCompiledPyCodeUnbufferedB(
  
    /* Same as QxPy_RunCompiledPyCodeUnbuffered, but cInputIP in python is a bytearray instead of a unicode object */
    
    input iPyObjectIP# as integer):
    
    define variable bUseBlobDataIn# as logical no-undo.
    
    bUseBlobDataIn# = (iLenBlobDataIn > 0 and get-size(blobDataIn) > 0).
    
    if not bUseBlobDataIn# then
    do:
      if clobDataIn = "" or clobDataIn = ? then
        clobDataIn = " ". /* Some data needed (one space), otherwise OE complains about uninitialized memptr */
      set-size(blobDataIn) = 0.
      copy-lob clobDataIn to blobDataIn. /* codeQok#7133 - Deep copy needed because direct longchar to shared object has big memleak in OE10.2B and small memleak OE11.2SP01. Progress help recommends copying to memptr, it seems to be a necessity, alas. */
      iLenBlobDataIn = get-size(blobDataIn).
    end.
    
    run QxPy_RunCompiledPyCodeUnbufferedB in hProcEvalPython (iPyObjectIP#, iLenBlobDataIn, blobDataIn, output iOutputLen, input-output mError, output iErrorLen, output blobOutput).
    
    if not bUseBlobDataIn# then
      set-size(blobDataIn) = 0.
    
    if iOutputLen > 0 then do:
      set-size(blobOutput) = sc_data:iMaxInt /* Note: Should be iOutputLen, see FREF@d981b49da */.
      clobOutput = get-string(blobOutput, 1, min(iOutputLen,31500)).
      &if false &then
      /* This should be more correct ... (see comment above) */    
      &endif
    end.
    else
      clobOutput = "".
      
    if iErrorLen > 0 then
      clobError = get-string(mError, 1, iErrorLen).
    else
      clobError = "".
      
  end method. /* QxPy_RunCompiledPyCodeUnbufferedB */
  
  
  method public void PyRunUBB():
    
    /* Unbuffered / bytearray in / bytearray out , see header in next method called. */
    
    QxPy_RunCompiledPyCodeUnbufferedBB(iId).

    if clobError > "" then
      undo, throw new c_panaedraexception(
        99937293,
        sc_lang:oEnglish,
        substitute("&1", substring(clobError,1,1000))). /* We don't apply formatting, the python exception is already formatted. */
    
  end method. /* PyRunUBB */
  

  method public void QxPy_RunCompiledPyCodeUnbufferedBB(
  
    /* Same as QxPy_RunCompiledPyCodeUnbuffered, but cInputIP in python is a bytearray 
       instead of a unicode object, and cDataOP in python must also be a bytearray object. */
    
    input iPyObjectIP# as integer):
    
    define variable bUseBlobDataIn# as logical no-undo.
    
    bUseBlobDataIn# = (iLenBlobDataIn > 0 and get-size(blobDataIn) > 0).
    
    if not bUseBlobDataIn# then
    do:
      if clobDataIn = "" or clobDataIn = ? then
        clobDataIn = " ". /* Some data needed (one space), otherwise OE complains about uninitialized memptr */
      set-size(blobDataIn) = 0.
      copy-lob clobDataIn to blobDataIn. /* codeQok#7133 - Deep copy needed because direct longchar to shared object has big memleak in OE10.2B and small memleak OE11.2SP01. Progress help recommends copying to memptr, it seems to be a necessity, alas. */
      iLenBlobDataIn = get-size(blobDataIn).
    end.
    
    run QxPy_RunCompiledPyCodeUnbufferedBB in hProcEvalPython (iPyObjectIP#, iLenBlobDataIn, blobDataIn, output iOutputLen, input-output mError, output iErrorLen, output blobOutput).
    
    if not bUseBlobDataIn# then
      set-size(blobDataIn) = 0.
    
    if iOutputLen > 0 then do:
      set-size(blobOutput) = sc_data:iMaxInt /* Note: Should be iOutputLen, see FREF@d981b49da */.
      if (not bUseBlobDataIn#) /* Note: If the caller uses blob data, and uses "bytearray in / bytearray out", it will expect to find the binary data in blobOutput, not clobOutput */
        then
        clobOutput = get-string(blobOutput, 1, iOutputLen).
        &if false &then
        /* This should be more correct ... (see comment above) */     
        &endif
      else
        clobOutput = "".
    end.
    else
      clobOutput = "".
    
    if iErrorLen > 0 then
      clobError = get-string(mError, 1, iErrorLen).
    else
      clobError = "".

  end method. /* QxPy_RunCompiledPyCodeUnbufferedBB */
  
  
  method public void QxPy_FreeCompiledPyCode():
    
    if valid-handle(hProcEvalPython) then
      run QxPy_FreeCompiledPyCode in hProcEvalPython (iId).
    
  end method. /* QxPy_FreeCompiledPyCode */
  
end class.

/* EOF */ 
