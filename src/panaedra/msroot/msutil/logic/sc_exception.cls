{panaedra/msi/logic/ctop_class.i} 

class panaedra.msex.logic.sc_exception: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msex/logic/sc_exception.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-06 21:50:54+02:00 $ 
    Date Modified: $Modtime: 2009-10-06 16:12:48+02:00 $ 

      Description: defineer speciale gebeurtenissen bij gekozen exceptions.

  \*****************************  Include Files ********************************/
  {def/_PRODUCT_.i &class=class}
  {panaedra/msroot/msas/logic/ds/ascontext_ds.i &protected=protected &static=static &reference-only=reference-only &class=class}
  
  /************************  Source control constructor ************************/
  constructor public sc_exception(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define stream str-log.
  
  define protected static variable oLastException as Progress.Lang.Error no-undo.

  
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
  
  method public static void FillTtExceptionTtCallstack(oExceptionIP as Progress.Lang.Error, dataset dsContext /* by ref */):
    
    define variable iNumErrorPS# as integer no-undo.
    
    if valid-object(oExceptionIP) then
    do:
      
      /* Vul de Callstack (alle betrokken programma's) */
      if oExceptionIP:CallStack > "" then 
      /* oftewel: -errorstack staat aan */
      do:
        create ttCallstack.
        ttCallStack.cCallStack = oExceptionIP:CallStack.
      end.
      else 
      do:
        /* We hebben dan niet de callstack van waar de fout is opgetreden, maar wel via welke api de appserver is benaderd. */
        create ttCallstack.
        ttCallStack.cCallStack = panaedra.msses.logic.sc_info:GetCallStack().
      end.
      
      /* Vul alle excepties */
      do iNumErrorPS# = 1 to oExceptionIP:NumMessages:
        create ttExceptions.
        ttExceptions.iOrder = iNumErrorPS#.
        ttExceptions.iError = oExceptionIP:getMessageNum(iNumErrorPS#).
        ttExceptions.cError = oExceptionIP:getMessage(iNumErrorPS#).
      end.
      
    end. /* Valid exception object */
    
    if not can-find(first ttExceptions) then
    do iNumErrorPS# = 1 to error-status:num-messages:
      create ttExceptions.
      ttExceptions.iOrder = iNumErrorPS#.
      ttExceptions.iError = error-status:get-number(iNumErrorPS#).
      ttExceptions.cError = error-status:get-message(iNumErrorPS#).
    end.
    
    if not can-find(first ttCallstack) then
    do:
      /* We hebben dan niet de callstack van waar de fout is opgetreden, maar wel via welke api de appserver is benaderd. */
      create ttCallstack.
      ttCallStack.cCallStack = panaedra.msses.logic.sc_info:GetCallStack().
    end.
        
  end method. /* FillTtExceptionTtCallstack */

end class.


/* EOF */ 
