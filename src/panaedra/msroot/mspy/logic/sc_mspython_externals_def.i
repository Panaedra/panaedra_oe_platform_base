/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: External procedure definitions for Panaedra python bridge

\**************************** End of Dvcs_ Header ****************************/
/******************************* $NoKeywords:  $ *****************************/

&if opsys = "win32" &then
&glob qx_python_dll "E:\work\eclipse\11.1A\python_core\PCbuild\qx_python.dll"
&else
&glob qx_python_dll "panaedra/msroot/mspy/bin/aix_64/panaedra_pythonbridge.so"
&endif

&if opsys = "win32" &then
&glob PythonExePath "E:\work\eclipse\11.1A\python_core\PCbuild\python.exe"
&else
&glob PythonExePath "/usr/bin/python2.7"
&endif

&glob MaxErrorLen 10000

&glob cdecl cdecl

&if not "{&OnlyPreprocessorDefs}" = "true" &then

define {&protected} {&static} variable cPythonExePath# as character no-undo init {&PythonExePath}.

&if "{&WithInitializeFinalize}" = "true" &then

procedure QxPy_InitializeInterpreter external {&qx_python_dll} {&cdecl} persistent:
  define input  parameter       cProgramNameIP# as character no-undo.
  define input  parameter       iMaxModulesIP#  as long      no-undo.
  define input-output parameter mErrorOP#       as memptr    no-undo.
  define output parameter       iErrorLenOP#    as int64     no-undo.
end procedure.

procedure QxPy_FinalizeInterpreter external {&qx_python_dll} {&cdecl} persistent:
end procedure.

&endif

&if "{&WithEvalLogic}" = "true" &then

procedure QxPy_SetCompiledPyCode external {&qx_python_dll} {&cdecl} persistent:
  define input         parameter iPyCodeIP#   as long             no-undo.
  define input         parameter cPyIdIP#     as character        no-undo.
  define input         parameter cPyCodeIP#   as character        no-undo.
  define input-output  parameter mErrorOP#    as memptr           no-undo.
  define output        parameter iErrorLenOP# as int64            no-undo.
end procedure.

&scop RunPy1 ~
  define input parameter        iPyObjectOP#      as long             no-undo. ~
  define input parameter        clobInputOP#      as handle to memptr no-undo. ~
  define input-output parameter mOutputOP#        as handle to memptr no-undo. ~
  define input parameter        iOutputAllocSize# as int64            no-undo. ~
  define output parameter       iOutputLenOP#     as int64            no-undo. ~
  define input-output parameter mErrorOP#         as handle to memptr no-undo. ~
  define output parameter       iErrorLenOP#      as int64            no-undo.

procedure QxPy_RunCompiledPyCode external {&qx_python_dll} {&cdecl} persistent:
  {&RunPy1}
end procedure.

procedure QxPy_RunCompiledPyCodeB external {&qx_python_dll} {&cdecl} persistent:
  {&RunPy1}
end procedure.

procedure QxPy_RunCompiledPyCodeBB external {&qx_python_dll} {&cdecl} persistent:
  {&RunPy1}
end procedure.

&scop RunPy2 ~
  define input parameter        iPyObjectOP#      as long             no-undo. ~
  define input parameter        clobInputOP#      as handle to memptr no-undo. ~
  define output parameter       iOutputLenOP#     as int64            no-undo. ~
  define input-output parameter mErrorOP#         as handle to memptr no-undo. ~
  define output parameter       iErrorLenOP#      as int64            no-undo. ~
  define       return parameter mOutputOP#        as memptr no-undo.

procedure QxPy_RunCompiledPyCodeUnbuffered external {&qx_python_dll} {&cdecl} persistent:
  {&RunPy2}
end procedure.

procedure QxPy_RunCompiledPyCodeUnbufferedB external {&qx_python_dll} {&cdecl} persistent:
  {&RunPy2}
end procedure.

procedure QxPy_RunCompiledPyCodeUnbufferedBB external {&qx_python_dll} {&cdecl} persistent:
  {&RunPy2}
end procedure.

procedure QxPy_FreeCompiledPyCode external {&qx_python_dll} {&cdecl} persistent:
  define input parameter iPyObjectOP# as long no-undo.
end procedure.

&endif /* WithEvalLogic */

&if "{&WithFifoLogic}" = "true" &then

procedure QxPy_MkFifo external {&qx_python_dll} {&cdecl} persistent:
  define input  parameter       cPathToPipeIP# as character no-undo.
  define output parameter       iErrorOP#      as long      no-undo.
end procedure.

procedure QxPy_RmFifo external {&qx_python_dll} {&cdecl} persistent:
  define input  parameter       cPathToPipeIP# as character no-undo.
  define output parameter       iErrorOP#      as long      no-undo.
end procedure.

procedure QxPy_UnlinkFifo external {&qx_python_dll} {&cdecl} persistent:
  define input  parameter       cPathToPipeIP# as character no-undo.
  define output parameter       iErrorOP#      as long      no-undo.
end procedure.

&endif /* WithFifoLogic */

&endif /* OnlyPreprocessorDefs */

/* EOF : panaedra/msroot/mspy/logic/mxqx_python_externals_def.i */
