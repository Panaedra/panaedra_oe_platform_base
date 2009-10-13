{panaedra/msi/logic/ctop_class.i} 

class panaedra.msex.logic.sc_exception: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msex/logic/sc_exception.cls $ 
          Version: $Revision: 7 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-13 06:51:51+02:00 $ 
    Date Modified: $Modtime: 2009-10-13 06:50:00+02:00 $ 

      Description: defineer speciale gebeurtenissen bij gekozen exceptions.

  \*****************************  Include Files ********************************/
  {def/_PRODUCT_.i &class=class}
  {panaedra/msroot/msas/logic/ds/ascontext_ds.i &protected=protected &static=static &reference-only=reference-only &class=class}
  
  /************************  Source control constructor ************************/
  constructor public sc_exception(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 7 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define stream str-log.
  
  define protected static variable oLastException as Progress.Lang.Error no-undo.

  define protected static temp-table ttCallStackCache no-undo rcode-info
    field cName      as character
    field cVersion   as character
    index cName is primary unique cName.

  /********************************** Methods **********************************/
  
  method public static integer ErrorNumberRating (iErrorIP# as integer):
   
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
    
    define variable iNumErrorPS# as integer   no-undo.
    
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
    
    /* Moet nog afgemaakt worden */
    
/*    define variable iRow#        as integer   no-undo.                                                                                                                            */
/*    define variable cRow#        as character no-undo.                                                                                                                            */
/*    define variable iRowEntry#   as integer   no-undo.                                                                                                                            */
/*    define variable cRowEntry#   as character no-undo.                                                                                                                            */
/*    define variable cClassName#  as character no-undo.                                                                                                                            */
/*                                                                                                                                                                                  */
/*    define buffer b-ttCallStack for ttCallStack.                                                                                                                                  */
/*                                                                                                                                                                                  */
/*    /* ttCallStack heeft geen index, dus wordt hier de laatst aangemaakte gevonden.                                                                                               */
/*       Zou geen probleem moeten zijn, anders geindexeerd veld toevoegen.                                                                                                          */
/*     */                                                                                                                                                                           */
/*    find last b-ttCallStack no-error.                                                                                                                                             */
/*                                                                                                                                                                                  */
/*    /* Ga de laatst aangemaakte callstack na en haal kopieer elke class die er in staat 1x                                                                                        */
/*       zodat er geen duplicaten onstaan */                                                                                                                                        */
/*    if available b-ttCallStack then                                                                                                                                               */
/*    do:                                                                                                                                                                           */
/*      replace(b-ttCallStack.cCallStack, chr(13) + chr(10), chr(10)).                                                                                                              */
/*                                                                                                                                                                                  */
/*      /* Loop alles entries in de callstack door om er de juist versie bij te vinden */                                                                                           */
/*      do iRow# = 1 to num-entries(b-ttCallStack.cCallStack, chr(10)):                                                                                                             */
/*                                                                                                                                                                                  */
/*        cRow# = entry(iRow#, b-ttCallStack.cCallStack, chr(10)).                                                                                                                  */
/*                                                                                                                                                                                  */
/*        /* Sommige rows hebben eerst een method en dan pas de classname, gescheiden door een spatie */                                                                            */
/*        do iRowEntry# = 1 to num-entries(cRow#, chr(20)):                                                                                                                         */
/*                                                                                                                                                                                  */
/*          cRowEntry# = entry(iRowEntry#, chr(20)).                                                                                                                                */
/*                                                                                                                                                                                  */
/*          file-info:filename = cRowEntry#.                                                                                                                                        */
/*                                                                                                                                                                                  */
/*          /* Als deze entrie een bestaande class is */                                                                                                                            */
/*          if file-info:full-pathname <> ? then                                                                                                                                    */
/*          do:                                                                                                                                                                     */
/*            find ttCallStackClasses where ttCallStackClasses.cClassName = file-info:full-pathname                                                                                 */
/*              no-error.                                                                                                                                                           */
/*                                                                                                                                                                                  */
/*            /* Als we deze class nog niet gedaan hebben, voeg deze dan toe */                                                                                                     */
/*            if not available ttCallStackClasses then                                                                                                                              */
/*            do:                                                                                                                                                                   */
/*              create ttCallStackClasses.                                                                                                                                          */
/*              assign                                                                                                                                                              */
/*                ttCallStackClasses.cClassName# = file-info:full-pathname.                                                                                                         */
/*              ttCallStackClasses.cVersion#   = panaedra.xd.sourcecontrol.logic.sc_sourcecontrol:GetSourceVersion(panaedra.msf.logic.sc_path:SplitGetClassName(file-info:full-pathname)).*/
/*            end. /* if not available ttCallStackClasses then */                                                                                                                   */
/*                                                                                                                                                                                  */
/*          end. /* if file-info:full-pathname <> ? then */                                                                                                                         */
/*        end. /* do iRowEntry# = 1 to num-entries(cRow#, chr(20)): */                                                                                                              */
/*      end. /* do iEntry# = 1 to num-entries(b-ttCallStack.cCallStack, chr(10)) */                                                                                                 */
/*    end. /* if available b-ttCallStack then */                                                                                                                                    */
/*                                                                                                                                                                                  */
  end method. /* AddVersionsToTtCallStack */

  
  method public static Progress.Lang.Error ReThrow (oExceptionIP# as Progress.Lang.Error, cMsgIP# as character):
    
    /* [EN] Can be used for rethrowing a catched exception */
    /* [NL] Kan gebruikt worden voor rethrow van een binnenkomende exception */
    
    define variable cArrayMsgIP# as character no-undo extent 1.
    
    assign 
      cArrayMsgIP#[1] = cMsgIP#.
    
    return ReThrowImplement(oExceptionIP#, cArrayMsgIP#).
    
  end method. /* ReThrow */  


  method public static Progress.Lang.Error ReThrow (oExceptionIP# as Progress.Lang.Error, cMsgIP# as character, cArg01IP# as character):
    
    /* [EN] Can be used for rethrowing a catched exception */
    /* [NL] Kan gebruikt worden voor rethrow van een binnenkomende exception */
    
    define variable cArrayMsgIP# as character no-undo extent 2.
    
    assign 
      cArrayMsgIP#[1] = cMsgIP#
      cArrayMsgIP#[2] = cArg01IP#.
    
    return ReThrowImplement(oExceptionIP#, cArrayMsgIP#).
    
  end method. /* ReThrow */  


  method public static Progress.Lang.Error ReThrow (oExceptionIP# as Progress.Lang.Error, cMsgIP# as character, cArg01IP# as character, cArg02IP# as character):
    
    /* [EN] Can be used for rethrowing a catched exception */
    /* [NL] Kan gebruikt worden voor rethrow van een binnenkomende exception */
    
    define variable cArrayMsgIP# as character no-undo extent 3.
    
    assign 
      cArrayMsgIP#[1] = cMsgIP#
      cArrayMsgIP#[2] = cArg01IP#
      cArrayMsgIP#[3] = cArg02IP#.
    
    return ReThrowImplement(oExceptionIP#, cArrayMsgIP#).
    
  end method. /* ReThrow */  


  method public static Progress.Lang.Error ReThrow (oExceptionIP# as Progress.Lang.Error, cMsgIP# as character, cArg01IP# as character, cArg02IP# as character, cArg03IP# as character):
    
    /* [EN] Can be used for rethrowing a catched exception */
    /* [NL] Kan gebruikt worden voor rethrow van een binnenkomende exception */
    
    define variable cArrayMsgIP# as character no-undo extent 4.
    
    assign 
      cArrayMsgIP#[1] = cMsgIP#
      cArrayMsgIP#[2] = cArg01IP#
      cArrayMsgIP#[3] = cArg02IP#
      cArrayMsgIP#[4] = cArg03IP#.
    
    return ReThrowImplement(oExceptionIP#, cArrayMsgIP#).
    
  end method. /* ReThrow */  


  method protected static Progress.Lang.Error ReThrowImplement (oExceptionIP# as Progress.Lang.Error, cArrayMsgIP# as character extent):
    
    /* [EN] Can be used for rethrowing a catched exception */
    /* [NL] Kan gebruikt worden voor rethrow van een binnenkomende exception */
    
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
