using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msas.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_exception: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_exception.cls $ 
          Version: $Revision: 15 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:53:29+01:00 $ 

      Description: Generic exception functionality with support for serializing (for appserver boundaries).

  \*****************************  Include Files ********************************/
{panaedra/msroot/msas/logic/ds/ascontext_ds.i &protected=protected &static=static &reference-only=reference-only &class=class}
  
  /************************  Source control constructor ************************/
  constructor public sc_exception(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 15 $', '{&sourcecontrolversions}').
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
    
    /* This overload without parameters looks at the error-status system handle.
       Returns unknown value at 0 errors, so "if rating <= 10" coding is possible.
     */
     
    if error-status:num-messages = 0 then return ?.
    else return ErrorNumberRating(error-status:get-number(1)).
    
  end method. /* ErrorNumberRating */
  
  
  method public static integer ErrorNumberRating(ex as Progress.Lang.Error):
    
    /* Looks at the first error in the exception
       Returns unknown value at 0 errors, so "if rating <= 10" coding is possible.
     */
     
    if ex:NumMessages = 0 then return ?.
    else return ErrorNumberRating(ex:GetMessageNum(1)).
    
  end method. /* ErrorNumberRating */
  
  
  method public static integer ErrorNumberRating(iErrorIP# as integer):
   
    /* Give a rating to error codes, rating 1 to 30, at the moment only 10 20 30.
       10 = high (default), 20 = medium and 30 = low (like invalid character) */
    
    define variable cHostname# as character no-undo.   
       
    case iErrorIP#:
         
      /* 10 */
      when 2570 then /* Routine <name> sent called routine <name> mismatched parameters. (2570) */
        return 10.         
         
      /* 20 */
         
         
      /* 30 */
      when 76 then /* ** Invalid character in numeric input <character>. (76) */
        return 30.
            
      when 5729 then /* Incompatible datatypes found during runtime conversion. (5729) */
        return 30. 
           
      /* Unknown errors */
      otherwise 
      do:
        /* Log hostname and rating info. */
        cHostname# = sc_environment:GetHostName().   
           
        output stream str-log to value(sc_path:cLogDir + "sc_exception_rating.log") unbuffered append.
        put stream str-log unformatted substitute("User: &1, PID: &2, Errornum: &3. Error number is not rated, modify source: sc_exception.cls.", cHostname#, sc_environment:GetProcessID(), iErrorIP#) skip.
        put stream str-log unformatted substitute("Calling procedure: &1, &2", program-name(2), iso-date(now)) skip.
        output stream str-log close.
           
        return 10.
      end.    
         
    end.  /* Case */
  
  end method. /* ErrorNumberRating */
  

  method public static void FillTtExceptionTtCallstack(oExceptionIP# as Progress.Lang.Error, dataset dsContext /* by ref */, cExtraErrorInfoIP# as character):
    
    define variable iNumErrorPS#    as integer   no-undo.
    define variable cMirror#        as character no-undo.
    define variable cCallstackLine# as character no-undo.
    
    define buffer b-ttExceptions for ttExceptions.
    define buffer b-ttCallstack  for ttCallstack.

    cCallstackLine# = sc_string_csv:GetParam(cExtraErrorInfoIP#,"CallStackLine").
    if cCallstackLine# = ? then cCallstackLine# = "".
    
    if cCallstackLine# > "" then 
    do:
      create b-ttCallstack.
      b-ttCallStack.cCallStack = subst("&1",cCallstackLine#).
      release b-ttCallStack.
    end.
    
    if valid-object(oExceptionIP#) then
    do:
      
      /* Fill the Callstack (alle involved methods) */
      if oExceptionIP#:CallStack > "" then 
      /* meaning: -errorstack is active */
      do:
        create b-ttCallstack.
        b-ttCallStack.cCallStack = replace(oExceptionIP#:CallStack, 
          ":IMPLICIT", ":IMPLICIT (AppServer Boundary on ~"" +
          &if opsys = "unix" &then
          "unix"  +
          &else
          "win32" +
          &endif 
          "~" ~"" + 
          sc_asconnect:GetAppserverID() + "~")").
        release b-ttCallStack.
      end.
      else 
      do:
        /* We might not know the full callstack, maar we do know which api was called. */
        create b-ttCallstack.
        b-ttCallStack.cCallStack = GetCallStack().
        release b-ttCallStack.
      end.
      
      /* Fill all exceptions */
      do iNumErrorPS# = 1 to oExceptionIP#:NumMessages:
        create b-ttExceptions.
        b-ttExceptions.iOrder = iNumErrorPS#.
        b-ttExceptions.iError = oExceptionIP#:getMessageNum(iNumErrorPS#).
        b-ttExceptions.cError = oExceptionIP#:getMessage(iNumErrorPS#).
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
      /* We might not know the full callstack, maar we do know which api was called. */
      create b-ttCallstack.
      b-ttCallStack.cCallStack = GetCallStack().
      release b-ttCallStack.
    end.
        
    if sc_boot:SessionParameter("UiMode") <> "AppServer" then 
    do:
      
      cMirror# = sc_string_csv:GetParam(cExtraErrorInfoIP#,"Mirror").
      
      if cMirror# > "" and sc_asconnect:GetAppserver(cMirror#) <> session:handle then
      do:
        /* This adds a final missing piece to the callstack */
        create b-ttCallstack.
        b-ttCallStack.cCallStack = GetCallStack().
        release b-ttCallStack.
      end.
              
    end.
      
  end method. /* FillTtExceptionTtCallstack */


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
    
    /* Can be used for rethrow */
    
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
  

  method public static character GetCallStack():

    define variable iProgramNo#    as integer   no-undo.
    define variable cCallStack#    as character no-undo.
    define variable cProgramStack# as character no-undo.

    /* Program 1 is skipped, it's this class itself */
    iProgramNo# = 2.
    
    /* Look for known runs */
    do while program-name(iProgramNo#) > ""
      and program-name(iProgramNo#) <> "adecomm/_runcode.p":
      
      /* Exclude routine framework calls. */
      if not (program-name(iProgramNo#) = "ShowException tool.panaedra.msroot.msutil.logic.sc_showexception"
        or program-name(iProgramNo#) = "ShowException panaedra.msroot.msutil.view.c_dotnetformshowexception") then
      do:
        cProgramStack# = cProgramStack# + "," + program-name(iProgramNo#).
      end.
      
      iProgramNo# = iProgramNo# + 1. 
      
    end.
    
    /* Collate the call stack, must recent on top */
    do iProgramNo# = 1 to num-entries(cProgramStack#):
      cCallStack# = cCallStack# + chr(13) + chr(10) + entry(iProgramNo#, cProgramStack#).
    end.      
    
    /* Cleanup */
    cCallStack# = trim(cCallStack#, chr(13) + chr(10)).
    
    return cCallStack#.

  end method. /* GetCallStack */
  
  
  method public static logical IsWrapped(
    
    /* Call this method to see if you need to wrap this exception to clarify it, for sc_msmon_feedback for example */
    
    oExceptionIP# as Progress.Lang.Error):
      
    return 
      type-of(oExceptionIP#, c_panaedraexception) 
      and 
      (cast(oExceptionIP#,c_panaedraexception):cCategoryEvent > "" 
      or 
      valid-object(cast(oExceptionIP#,c_panaedraexception):oInnerException)).
      
  end method. /* IsWrapped */
  
  
  method public static Progress.Lang.Error ReThrow(
    
    /* Rethrow a message if not already wrapped (if wrapped: just pass through) */
  
    iErrorIP#          as integer, 
    oInnerExceptionIP# as Progress.Lang.Error,
    cCategoryEventIP#  as character,
    oDutchIP#          as i_language_dutch,
    cErrorMsgIP#       as character
    ):
    
    define variable oReturn# as Progress.Lang.Error no-undo.

    if sc_exception:IsWrapped(oInnerExceptionIP#) then oReturn# = oInnerExceptionIP#.
    else 
      oReturn# = new c_panaedraexception(
        iErrorIP#,
        oInnerExceptionIP#,
        cCategoryEventIP#,
        sc_lang:oDutch,
        cErrorMsgIP#
        ).
     
    return oReturn#.
    
  end method. /* ReThrow ; dutch */


  method public static Progress.Lang.Error ReThrow(
    
    /* Rethrow a message if not already wrapped (if wrapped: just pass through) */
  
    iErrorIP#          as integer, 
    oInnerExceptionIP# as Progress.Lang.Error,
    cCategoryEventIP#  as character,
    oDutchIP#          as i_language_english,
    cErrorMsgIP#       as character
    ):
    
    define variable oReturn# as Progress.Lang.Error no-undo.

    if sc_exception:IsWrapped(oInnerExceptionIP#) then oReturn# = oInnerExceptionIP#.
    else 
      oReturn# = new c_panaedraexception(
        iErrorIP#,
        oInnerExceptionIP#,
        cCategoryEventIP#,
        sc_lang:oEnglish,
        cErrorMsgIP#
        ).
     
    return oReturn#.
    
  end method. /* ReThrow ; english */

end class.


/* EOF */ 
