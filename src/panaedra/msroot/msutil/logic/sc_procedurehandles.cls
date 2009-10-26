{panaedra/msi/logic/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_procedurehandles: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_procedurehandles.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-26 09:25:52+01:00 $ 
    Date Modified: $Modtime: 2009-10-26 09:23:50+01:00 $ 

      Description: Support for procedure handles.
                   In Panaedra we use procedure handles only when technically necessary.
                   For example: sax readers or sax writers, or external win32 api or 
                   unix shared-object calls.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_procedurehandles(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected static temp-table ttClaimProcedure no-undo
    field hCallProc as handle
    field cCallProc as character
    field hPersProc as handle
    field cPersProc as character
    index hPersProc_hCallProc is primary unique hPersProc hCallProc
    index hCallProc_hPersProc                   hCallProc hPersProc
    .


  method public static void DeleteProcedure(input hSourceProcIP# as handle,input hProcIP# as handle):

    /* Procedure voor het netjes afsluiten van
       persistent procedures (bv. libraries).
       
       Laat persistent procedures altijd eerst
       hun eigen troep opruimen in hun eigen 
       close event.
    */ 

    define buffer b-ttClaimProcedure for ttClaimProcedure.
  
    find first b-ttClaimProcedure where
      b-ttClaimProcedure.hCallProc = hSourceProcIP# and
      b-ttClaimProcedure.hPersProc = hProcIP#
      no-error.
  
    if avail b-ttClaimProcedure then
      delete b-ttClaimProcedure.
  
    if valid-handle(hProcIP#)
      and hProcIP#:persistent
      and not can-find(first b-ttClaimProcedure
      where b-ttClaimProcedure.hPersProc = hProcIP#)
      then 
    do:
      apply "close" to hProcIP#.
    
      if valid-handle(hProcIP#)
        /* geen "close" event aanwezig, danwel procedure
           ruimt zichzelf niet op in het close event */
        then delete procedure hProcIP#.
    end.  

  end method. /* DeleteProcedure */


  method public static void ClaimProcedure(input hSourceProcIP# as handle, cLibIP# as handle):

    /* 
         Na het starten van een persistent procedure
         via persistentProcedure, is het mogelijk
         deze te "claimen". Wanneer andere procedures
         een deleteProcedure runnen, wordt een geclaimde
         procedure toch niet uit de lucht gegooid, totdat
         de claimende procedure dit zelf doet.
         Meerdere procedures kunnen een claim uitbrengen,
         en pas na het wegvallen van de laatste claim
         zal de procedure daadwerkelijk gekilled worden.
         
         Indien ooit een geclaimde procedure toch moet worden 
         gekilled, maak dan een ip "deleteClaimedProcedure"
         aan in deze library, en zorg dat de procedure
         toch weer in de lucht wordt gegooid, met herstel
         van een eventuele context.
         
      */
    def buffer b-ttClaimProcedure for ttClaimProcedure.
  
    create b-ttClaimProcedure.
    assign
      b-ttClaimProcedure.hCallProc = hSourceProcIP#
      b-ttClaimProcedure.cCallProc = hSourceProcIP#:file-name /* tbv debug als de proc al weg is */
      b-ttClaimProcedure.hPersProc = cLibIP#
      b-ttClaimProcedure.cPersProc = cLibIP#:file-name.

  end method. /* ClaimProcedure */


  method public static void PersistentProcedure(
    input  cProcIP# as character,
    output hProcOP# as handle):

    /* Procedure voor het netjes opstarten van
       persistent procedures (bv. libraries).
       Als de procedure binnen de sessie reeds is opgestart, 
       zal de handle van de draaiende procedure worden 
       teruggegeven.
    */ 
    _sys_PersistentProcedureSub(cProcIP#, no, output hProcOP#).

  end method. /* PersistentProcedure */


  method public static void DeleteProcedureByName(input cProcIP# as character):

    /* Procedure voor het netjes afsluiten van
     persistent procedures (bv. libraries).
     
     Deze procedure kan worden aangeroepen 
     wanneer je niet weet of de procedure
     in de lucht is, maar hem wel af wilt
     sluiten omdat je bijvoorbeeld een
     database wilt disconnecteren.
     
     Laat persistent procedures altijd eerst
     hun eigen troep opruimen in hun eigen 
     close event.
     
     N.B.: op dit moment kijkt deleteProcedureByName
     nog niet naar local libraries en/of claims.
     Dat wordt wellicht nog ingebouwd; bv via een 
     cs-lijstje met handles die niet mochten worden 
     opgeruimd, op 1) de return value of
     2) via een setProp op source-procedure.
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
        /* geen "close" event aanwezig, danwel procedure
           ruimt zichzelf niet op in het close event */
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
