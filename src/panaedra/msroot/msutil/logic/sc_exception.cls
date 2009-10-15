{panaedra/msi/logic/ctop_class.i} 

class panaedra.msex.logic.sc_exception: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msex/logic/sc_exception.cls $ 
          Version: $Revision: 11 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-15 10:43:35+02:00 $ 
    Date Modified: $Modtime: 2009-10-15 10:40:47+02:00 $ 

      Description: defineer speciale gebeurtenissen bij gekozen exceptions.

  \*****************************  Include Files ********************************/
  {def/_PRODUCT_.i &class=class}
  {panaedra/msroot/msas/logic/ds/ascontext_ds.i &protected=protected &static=static &reference-only=reference-only &class=class}
  
  /************************  Source control constructor ************************/
  constructor public sc_exception(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 11 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define stream str-log.
  
  define protected static variable oLastException as Progress.Lang.Error no-undo.

  define protected static temp-table ttCallStackCache no-undo rcode-info
    field cName    as character
    field cVersion as character
    index cName is primary unique cName.
  
  /********************************** Methods **********************************/
  
  method public static integer ErrorNumberRating():
    
    /* De overload zonder parameters kijkt naar de error-status system handle.
       Geeft unknown value terug bij 0 errors, zodat je bv "if rating <= 10" kunt doen.
     */
     
    if error-status:num-messages = 0 then return ?.
    else return ErrorNumberRating(error-status:get-number(1)).
    
  end method. /* ErrorNumberRating */
  
  
  method public static integer ErrorNumberRating(ex as Progress.Lang.Error):
    
    /* De overload via een exception kijkt naar de 1e error in de exception.
       Geeft unknown value terug bij 0 errors, zodat je bv "if rating <= 10" kunt doen.
     */
     
    if ex:NumMessages = 0 then return ?.
    else return ErrorNumberRating(ex:GetMessageNum(1)).
    
  end method. /* ErrorNumberRating */
  
  
  method public static integer ErrorNumberRating(iErrorIP# as integer):
   
    /* deze method geeft foutmeldingen een rating, van 1 tot 30, op dit moment opgedeeld in 10 20 en 30.
       10 = hoog (default), 20 = middel en 30 = laag (zoals verkeerde dataconversie) */
    
    define variable cHostname# as character no-undo.   
       
    case iErrorIP#:
         
      /* 10 */
         
         
      /* 20 */
         
         
      /* 30 */
      when 76 then /* ** Invalid character in numeric input <character>. (76) */
        return 30.
           
      when 5729 then /* Incompatible datatypes found during runtime conversion. (5729) */
        return 30. 
           
      /* Nog niet bekende */
      otherwise 
      do:
        /* Log de foutmelding _PPL_UNDISCLOSED_ en process id zodat we eventueel dit bestand kunnen uitbreiden. */
        cHostname# = panaedra.msb.logic.sc_environment:GetHostName().   
           
        output stream str-log to value({&logdir} + "sc-exception_rating.log") unbuffered append.
        put stream str-log unformatted substitute("User: &1, PID: &2, Errornum: &3", cHostname#, panaedra.msb.logic.sc_environment:GetProcessID(), iErrorIP#) skip.
        put stream str-log unformatted substitute("Calling procedure: &1, &2", program-name(2), iso-date(now)) skip.
        output stream str-log close.
           
        return 10.
      end.    
         
    end.  /* Case */
  
  end method. /* ErrorNumberRating */
  

  method public static void FillTtExceptionTtCallstack(oExceptionIP as Progress.Lang.Error, dataset dsContext /* by ref */, cMirrorIP# as character):
    
    define variable iNumErrorPS# as integer no-undo.
    
    define buffer b-ttExceptions for ttExceptions.
    define buffer b-ttCallstack  for ttCallstack.
    
    if valid-object(oExceptionIP) then
    do:
      /* Vul de Callstack (alle betrokken programma's) */
      if oExceptionIP:CallStack > "" then 
      /* oftewel: -errorstack staat aan */
      do:
        create b-ttCallstack.
        b-ttCallStack.cCallStack = replace(oExceptionIP:CallStack, 
          ":IMPLICIT", ":IMPLICIT (AppServer Boundary on ~"" +
          &if opsys = "unix" &then
          "unix"  +
          &else
          "win32" +
          &endif 
          "~" ~"" + 
          panaedra.msb.logic.sc_asconnect:GetAppserverID() + "~")").
        release b-ttCallStack.
      end.
      else 
      do:
        /* We hebben dan niet de callstack van waar de fout is opgetreden, maar wel via welke api de appserver is benaderd. */
        create b-ttCallstack.
        b-ttCallStack.cCallStack = panaedra.msses.logic.sc_info:GetCallStack().
        release b-ttCallStack.
      end.
      
      /* Vul alle excepties */
      do iNumErrorPS# = 1 to oExceptionIP:NumMessages:
        create b-ttExceptions.
        b-ttExceptions.iOrder = iNumErrorPS#.
        b-ttExceptions.iError = oExceptionIP:getMessageNum(iNumErrorPS#).
        b-ttExceptions.cError = oExceptionIP:getMessage(iNumErrorPS#).
      end.
    end. /* Valid exception object */
    
    if not can-find(first b-ttExceptions) then
    do iNumErrorPS# = 1 to error-status:num-messages:
      create b-ttExceptions.
      b-ttExceptions.iOrder = iNumErrorPS#.
      b-ttExceptions.iError = error-status:get-number(iNumErrorPS#).
      b-ttExceptions.cError = error-status:get-message(iNumErrorPS#).
    end.
    
    if not can-find(first b-ttCallstack) then
    do:
      /* We hebben dan niet de callstack van waar de fout is opgetreden, maar wel via welke api de appserver is benaderd. */
      create b-ttCallstack.
      b-ttCallStack.cCallStack = panaedra.msses.logic.sc_info:GetCallStack().
      release b-ttCallStack.
    end.
        
    if panaedra.msb.logic.sc_boot:SessionParameter("UiMode") <> "AppServer"
      and panaedra.msb.logic.sc_asconnect:GetAppserver(cMirrorIP#) <> session:handle then
    do:
      /* Dit regelt het laatste ontbrekende stukje callstack */
      create b-ttCallstack.
      b-ttCallStack.cCallStack = panaedra.msses.logic.sc_info:GetCallStack().
      release b-ttCallStack.
    end.        
     
    AddVersionsToTtCallStack().
        
  end method. /* FillTtExceptionTtCallstack */


  method protected static void AddVersionsToTtCallStack ():
    
    define variable cNewCallStack as character no-undo.
      
    define buffer b-ttCallStack for ttCallStack.
    
    do for b-ttCallStack:
    
      /* ttCallStack heeft geen index, dus wordt hier de laatst aangemaakte gevonden.
         Zou geen probleem moeten zijn, anders geindexeerd veld toevoegen.
       */
      find last b-ttCallStack no-error.
      
      /* Ga de laatst aangemaakte callstack na en haal kopieer elke class die er in staat 1x
         zodat er geen duplicaten onstaan */
      if available b-ttCallStack then
      do:
        
        /* Loop de callstack door en filter de dubbele bestanden die er in staan */
        FilterDoublesFromCallStack(replace(b-ttCallStack.cCallStack, chr(13) + chr(10), chr(10))). 
        
        find current b-ttCallStack no-error.
      
        if available b-ttCallStack then
        do:
          /* Loop de callstack door en voeg versie nummers toe aan de callstack */
          b-ttCallStack.cCallStack = PutVersionsF_SRVR_llStack(replace(b-ttCallStack.cCallStack, chr(13) + chr(10), chr(10))).
        end.  
      
      end. /* if available b-ttCallStack then */
    
    end. /* do for b-ttCallStack */
    
  end method. /* AddVersionsToTtCallStack */

  
  method protected static void FilterDoublesFromCallStack (cCallStackIP# as character):
    
    define variable iRow#      as integer   no-undo.
    define variable cRow#      as character no-undo.
    define variable iRowEntry# as integer   no-undo.
    define variable cRowEntry# as character no-undo.
    define variable cVersion#  as character no-undo.
    
    /* Loop alles entries in de callstack door om de dubbele er uit te filteren */
    do iRow# = 1 to num-entries(cCallStackIP#, chr(10)):

      cRow# = entry(iRow#, cCallStackIP#, chr(10)).
      
      /* Sommige rows hebben eerst een method en dan pas de classname, gescheiden door een spatie */
      do iRowEntry# = 1 to num-entries(cRow#, " "):
        
        cRowEntry# = entry(iRowEntry#, cRow#, ""). 
        
        /* Zet de entry en het versienummer in de callstackcache */
        AddToTtCallStackCache(cRowEntry#).
        
      end. /* do iRowEntry# = 1 to num-entries(cRow#, chr(20)): */
    end. /* do iEntry# = 1 to num-entries(b-ttCallStack.cCallStack, chr(10)) */
    
  end method. /* FilterDoublesFromCallStack */  
  
  
  method protected static void AddToTtCallStackCache (cRowEntryIP# as character):
    
    define variable cVersion# as character no-undo.
    
    define buffer b-ttCallStackCache for ttCallStackCache.
    
    /* Bekijk of deze entry er al in staat (in de callstack komen dubbele voor) */
    find b-ttCallStackCache where b-ttCallStackCache.cName = cRowEntryIP#
      no-error.
    
    /* Als we deze entry nog niet gehad hebben, voeg deze dan toe */
    if not available b-ttCallStackCache then
    do:
      /* Haal het juiste versienummer erbij (string) */
      cVersion# = panaedra.xd.sourcecontrol.logic.sc_sourcecontrol:GetSourceVersion(cRowEntryIP#).
      
      create b-ttCallStackCache.
      assign
        b-ttCallStackCache.cName    = cRowEntryIP#
        b-ttCallStackCache.cVersion = cVersion#.
    end. /* if not available ttCallStackCache then */

  end method. /* AddToTtCallStackCache */  
  
  
  method protected static character PutVersionsF_SRVR_llStack (cCallStackIP# as character):
    
    define variable iRow#              as integer   no-undo.
    define variable cRow#              as character no-undo.
    define variable iRowEntry#         as integer   no-undo.
    define variable cRowEntry#         as character no-undo.
    define variable cUpdatedCallStack# as character no-undo.
    
    define variable Eclipsefix         as character no-undo.
    define buffer b-ttCallStackCache for ttCallStackCache.
    
    /* Loop alles entries in de callstack door om er de juist versie bij te vinden */
    do iRow# = 1 to num-entries(cCallStackIP#, chr(10)):

      cRow# = entry(iRow#, cCallStackIP#, chr(10)).

      /* Sommige rows hebben eerst een method en dan pas de classname, gescheiden door een spatie */
      do iRowEntry# = 1 to num-entries(cRow#, " "):

        cRowEntry# = entry(iRowEntry#, cRow#, " ").

        /* Zoek de juiste entry erbij */
        find b-ttCallStackCache where b-ttCallStackCache.cName = cRowEntry#. 
        
        /* Plaats het versie nummer, als deze not available is is deze leeg */
        cUpdatedCallStack# = cUpdatedCallStack# + cRowEntry# + b-ttCallStackCache.cVersion.                  
        
        /* Plaats de huidige seperator terug */
        cUpdatedCallStack# = cUpdatedCallStack# + " ".
        
      end. /* do iRowEntry# = 1 to num-entries(cRow#, chr(20)): */
      
      /* Plaats de huidige seperator terug */
      cUpdatedCallStack# = cUpdatedCallStack# + chr(10).
      
    end. /* do iEntry# = 1 to num-entries(b-ttCallStack.cCallStack, chr(10)) */
    
    return trim(cUpdatedCallStack#, chr(10)).
    
  end method. /* WalkThroughCallStack */  


  method public static Progress.Lang.Error ReThrow (oExceptionIP# as Progress.Lang.Error, cMsgIP# as character):
    
    define variable cArrayMsgIP# as character no-undo extent 1.
    
    assign 
      cArrayMsgIP#[1] = cMsgIP#.
    
    return ReThrowImplement(oExceptionIP#, cArrayMsgIP#).
    
  end method. /* ReThrow */  


  method public static Progress.Lang.Error ReThrow (oExceptionIP# as Progress.Lang.Error, cMsgIP# as character, cArg01IP# as character):
    
    define variable cArrayMsgIP# as character no-undo extent 2.
    
    assign 
      cArrayMsgIP#[1] = cMsgIP#
      cArrayMsgIP#[2] = cArg01IP#.
    
    return ReThrowImplement(oExceptionIP#, cArrayMsgIP#).
    
  end method. /* ReThrow */  


  method public static Progress.Lang.Error ReThrow (oExceptionIP# as Progress.Lang.Error, cMsgIP# as character, cArg01IP# as character, cArg02IP# as character):
    
    define variable cArrayMsgIP# as character no-undo extent 3.
    
    assign 
      cArrayMsgIP#[1] = cMsgIP#
      cArrayMsgIP#[2] = cArg01IP#
      cArrayMsgIP#[3] = cArg02IP#.
    
    return ReThrowImplement(oExceptionIP#, cArrayMsgIP#).
    
  end method. /* ReThrow */  


  method public static Progress.Lang.Error ReThrow (oExceptionIP# as Progress.Lang.Error, cMsgIP# as character, cArg01IP# as character, cArg02IP# as character, cArg03IP# as character):
    
    define variable cArrayMsgIP# as character no-undo extent 4.
    
    assign 
      cArrayMsgIP#[1] = cMsgIP#
      cArrayMsgIP#[2] = cArg01IP#
      cArrayMsgIP#[3] = cArg02IP#
      cArrayMsgIP#[4] = cArg03IP#.
    
    return ReThrowImplement(oExceptionIP#, cArrayMsgIP#).
    
  end method. /* ReThrow */  


  method protected static Progress.Lang.Error ReThrowImplement (oExceptionIP# as Progress.Lang.Error, cArrayMsgIP# as character extent):
    
    /* Kan gebruikt worden voor rethrow van een binnenkomende exception */
    
    define variable oReturn# as Progress.Lang.AppError no-undo.
    define variable iTell#   as integer                no-undo.
    define variable cMsg#    as character              no-undo.
    
    cMsg# = cArrayMsgIP#[1].
    
    case extent(cArrayMsgIP#):
      
      when 2 then 
        cMsg# = subst(cMsg#, cArrayMsgIP#[2]).
      when 3 then 
        cMsg# = subst(cMsg#, cArrayMsgIP#[2], cArrayMsgIP#[3]).
      when 4 then 
        cMsg# = subst(cMsg#, cArrayMsgIP#[2], cArrayMsgIP#[3], cArrayMsgIP#[4]).
       
    end case.
    
    cMsg# = cMsg# + subst("~n&1", oExceptionIP#:GetMessage(1)).
    
    oReturn# = new Progress.Lang.AppError(cMsg#, oExceptionIP#:GetMessageNum(1)).
    
    do iTell# = 2 to oExceptionIP#:NumMessages:
      oReturn#:AddMessage(oExceptionIP#:GetMessage(iTell#),oExceptionIP#:GetMessageNum(iTell#)).
    end.

    if oExceptionIP#:CallStack > "" then oReturn#:AddMessage(oExceptionIP#:CallStack,99950005).
    
    return oReturn#.
    
  end method. /* ReThrowImplement */  


end class.


/* EOF */ 
