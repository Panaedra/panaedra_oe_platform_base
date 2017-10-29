{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_procedurehandles: 

  /****************************** Source Header ********************************\

      Description: Support for procedure handles.
                   In Panaedra we use procedure handles only when technically necessary.
                   For example: sax readers or sax writers, or external win32 api or 
                   unix shared-object calls.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define protected static temp-table ttClaimProcedure no-undo
    field hCallProc   as handle
    field cCallProc   as character
    field oCallObject as Progress.Lang.Object
    field cCallObject as character
    field hPersProc   as handle
    field cPersProc   as character
    index hPersProc_hCallProc is primary unique hPersProc   hCallProc
    index hPersProc_oCallObject                 hPersProc   oCallObject
    index hCallProc_hPersProc                   hCallProc   hPersProc
    index oCallObject_hPersProc                 oCallObject hPersProc
    .


  /* The method overload below is removed. Use the other overload and supply this-procedure (or this-object when it's implemented) */
  /* -> method protected static void DeleteProcedure(input hSourceProcIP# as handle):*/


  method public static void DeleteProcedure(
    input oSourceObjectIP# as Progress.Lang.Object, /* Normally: this-object.       */ 
    input hLibProcIP#    as handle):                /* The library procedure handle */
    
    DeleteProcedureImplement(oSourceObjectIP#, ?, hLibProcIP#).
    
  end method. /* DeleteProcedure : called by object */


  method public static void DeleteProcedure(
    input hSourceProcIP# as handle,  /* Normally: this-procedure.    */ 
    input hLibProcIP#    as handle): /* The library procedure handle */
    
    DeleteProcedureImplement(?, hSourceProcIP#, hLibProcIP#).
    
  end method. /* DeleteProcedure : called by procedure */
    
  
  method protected static void DeleteProcedureImplement(
    input oSourceObjectIP# as Progress.Lang.Object, /* Normally: this-object.       */
    input hSourceProcIP# as handle,                 /* Normally: this-procedure.    */
    input hLibProcIP#    as handle):                /* The library procedure handle */

    /* Persistent procedures always need to clean up their own runtime artefacts at close event. */ 

    define buffer b-ttClaimProcedure for ttClaimProcedure.
    
    if oSourceObjectIP# <> ? then 
    do:
      find first b-ttClaimProcedure where
        b-ttClaimProcedure.oCallObject = oSourceObjectIP# and
        b-ttClaimProcedure.hPersProc   = hLibProcIP#
        no-error.
    end.
    else 
    do:
      find first b-ttClaimProcedure where
        b-ttClaimProcedure.hCallProc = hSourceProcIP# and
        b-ttClaimProcedure.hPersProc = hLibProcIP#
        no-error.
    end.
    
    if avail b-ttClaimProcedure then
      delete b-ttClaimProcedure.
  
    if valid-handle(hLibProcIP#)
      and hLibProcIP#:persistent
      and not can-find(first b-ttClaimProcedure
      where b-ttClaimProcedure.hPersProc = hLibProcIP#)
      then 
    do:
      apply "close" to hLibProcIP#.
    
      if valid-handle(hLibProcIP#)
        /* no correct "close" event present */
        then delete procedure hLibProcIP#.
    end.  

  end method. /* DeleteProcedure */


  method public static void ClaimProcedure(input hSourceProcIP# as handle, cLibIP# as handle):

    /* 
         After starting a persistent procedure, you
         can "claim" it. Subsequent procedures trying
         to deleteProcedure your lib will not be honoured.
         
         End result is, that you get control back over your persistent procedure.
         
         Only if the last claim is deleted, the procedure handle is deleted.
           
    */
    
    define variable bEclipseFix# as logical no-undo.
    define buffer b-ttClaimProcedure for ttClaimProcedure.
  
    create b-ttClaimProcedure.
    assign
      b-ttClaimProcedure.hCallProc = hSourceProcIP#
      b-ttClaimProcedure.cCallProc = hSourceProcIP#:file-name /* debugging purposes, after delete procedure */
      b-ttClaimProcedure.hPersProc = cLibIP#
      b-ttClaimProcedure.cPersProc = cLibIP#:file-name.

  end method. /* ClaimProcedure : called by procedure */


  method public static void ClaimProcedure(input oSourceObjectIP# as Progress.Lang.Object, cLibIP# as handle):

    /* 
         After starting a persistent procedure, you
         can "claim" it. Subsequent procedures trying
         to deleteProcedure your lib will not be honoured.
         
         End result is, that you get control back over your persistent procedure.
         
         Only if the last claim is deleted, the procedure handle is deleted.
           
    */
    
    define variable bEclipseFix# as logical no-undo.
    define buffer b-ttClaimProcedure for ttClaimProcedure.
  
    create b-ttClaimProcedure.
    assign
      b-ttClaimProcedure.oCallObject = oSourceObjectIP#
      b-ttClaimProcedure.cCallObject = string(oSourceObjectIP#) /* debugging purposes, after delete procedure */
      b-ttClaimProcedure.hPersProc = cLibIP#
      b-ttClaimProcedure.cPersProc = cLibIP#:file-name.

  end method. /* ClaimProcedure : called by object */


  method public static void PersistentProcedure(
    input  hSourceProcIP# as handle,    /* Normally: this-procedure.                 */ 
    input  cProcIP#       as character, /* The relative path to the library to start */
    output hProcOP#       as handle):   /* The library procedure handle is returned. */

    /* Proper way to start a persistent library procedure. Session cached, re-uses handles. */
     
    _sys_PersistentProcedureSub(cProcIP#, no, output hProcOP#).

  end method. /* PersistentProcedure : called by procedure */


  method public static void PersistentProcedure(
    input  oSourceObjectIP# as Progress.Lang.Object, /* Normally: this-object.                    */ 
    input  cProcIP#         as character,            /* The relative path to the library to start */
    output hProcOP#         as handle):              /* The library procedure handle is returned. */

    /* Proper way to start a persistent library procedure. Session cached, re-uses handles. */
    
    _sys_PersistentProcedureSub(cProcIP#, no, output hProcOP#).

  end method. /* PersistentProcedure : called by object */


  method public static void DeleteProcedureByName(input cProcIP# as character):

    
    /* Proper way to delete a persistent library procedure.                                      
       Persistent procedures always need to clean up their own runtime artefacts at close event. 
    */

    def var hProc#    as handle no-undo.
    def var hProcDel# as handle no-undo.
  
    hProc# = session:first-procedure.
  
    iterDelProc: 
    do while valid-handle(hProc#):
   
      if hProc#:file-name = cProcIP# then 
      do:
        hProcDel# = hProc#.
        leave iterDelProc.
      end.
    
      hProc# = hProc#:next-sibling.
     
    end. /* iterDelProc */
  
    if valid-handle(hProcDel#)
      then 
    do:
      apply "close" to hProcDel#.
    
      if valid-handle(hProcDel#)
        /* no proper close event present */
        then delete procedure hProcDel#.
    end.  

  end method. /* DeleteProcedureByName */


  method public static void GetBufTtClaimProcedure(output hBufOP# as handle):

    hBufOP# = buffer ttClaimProcedure:handle.

  end method. /* GetBufTtClaimProcedure */  


  method public static void _sys_PersistentProcedureSub(
    input  cProcIP#  as character,
    input  bLocalIP# as logical,
    output hProcOP#  as handle):
 
    define variable cProcFilt# as character no-undo.
  
    cProcFilt# = cProcIP#.
  
    entry(num-entries(cProcFilt#,"."),cProcFilt#,".") = "".
  
    if not bLocalIP# then 
    do:
      hProcOP# = session:last-procedure.
    
      findProc:
      do while valid-handle(hProcOP#) :
     
        if hProcOP#:file-name begins cProcFilt# then 
        do:
          if panaedra.msroot.msutil.logic.sc_prop:GetProp(hProcOP#,"LocalLibrary") > "" then 
          do:
            /* overslaan */
            hProcOP# = hProcOP#:prev-sibling.
            next findProc.
          end.
          else /* prop = unknown or empty */
            leave findProc. /* gevonden. */
        end.
      
        hProcOP# = hProcOP#:prev-sibling.
       
      end. /* walk the procedure stack */
    
    end.
    
    if hProcOP# = ? then
      run value(cProcIP#) persistent set hProcOP#.

  end method. /* _sys_PersistentProcedureSub  */


end class.

/* EOF */ 
