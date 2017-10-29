using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.c_file_stream   : 

  /****************************** Source Header ********************************\

      Description: Use this for passing stream within classes, create a new instance
                   of this object to access the stream-handle hStream

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define public    property hStream         as handle no-undo get. set.
  define protected property hPersistentProc as handle no-undo get. set.
  
  define public variable bIsDisposed as log no-undo.

  constructor public c_file_stream():
    
    define variable hProc#   as handle no-undo.
    define variable hStream# as handle no-undo.
    
    /* Contains stream */
    run panaedra/msroot/msutil/logic/c_file_stream_sub.p persistent set hProc# (output hStream#).
    
    assign 
      hPersistentProc = hProc#
      hStream         = hStream#.
    
  end constructor.
  

  method public void Dispose(
    /* cleanup after use or (later) unregister usage */
    ):
    
    bIsDisposed = true.
    
    if valid-handle(hPersistentProc) then 
      sc_procedurehandles:DeleteProcedure(this-object, hPersistentProc).
    
  end method. /* Dispose */


  destructor public c_file_stream():
    
    if not bIsDisposed then Dispose().
    
  end destructor.

end class.

/* EOF */ 
