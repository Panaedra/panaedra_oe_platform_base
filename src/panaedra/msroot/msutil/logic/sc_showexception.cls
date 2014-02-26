using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msmonitor.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i}

&if opsys <> "unix" and "{&window-system}" <> "tty" &then
using System.*.
using System.Windows.Forms.*.
&endif

class panaedra.msroot.msutil.logic.sc_showexception:

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_showexception.cls $ 
          Version: $Revision: 10 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-08-02 08:43:20+02:00 $ 
    Date Modified: $Modtime: 2010-07-31 19:27:34+02:00 $ 

      Description: Show exceptions/errors on all platforms and ui's.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_showexception(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 10 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  &if opsys <> "unix" and "{&window-system}" <> "tty" &then
  define protected static variable oForm as panaedra.msroot.msutil.view.c_dotnetformshowexception no-undo.
  &endif

  method public static void ShowException(
    input iErrorIP# as integer,
    input cErrorIP# as character,
    input oLanguageIP# as i_language_dutch):

    ShowException(
      new c_panaedraexception(
        iErrorIP#,
        oLanguageIP#,
        substitute("Zie: '&1'", cErrorIP#) /* codeQok#7104 */
        )).
    
  end method. /* ShowException | NL: input errornr and text */
  
  
  method public static void ShowException(
    input iErrorIP# as integer,
    input cErrorIP# as character,
    input oLanguageIP# as i_language_english):

    ShowException(
      new c_panaedraexception(
        iErrorIP#,
        oLanguageIP#,
        substitute("See: '&1'", cErrorIP#)
        )).
    
  end method. /* ShowException | EN: input errornr and text */
  
  
  method public static void ShowException(
    
    /* Default exception handling. Depending on session type and config: to screen, logfile, or (in batchmode) posted as a monitor event. */
    input oErrorIP# as Progress.Lang.Error):
      
    ShowException("",oErrorIP#).
      
  end method. /* ShowException, simple overload */

  &if opsys <> "unix" &then
  method public static void ShowException(
    
    /* See comment in complete overload below. */
    
    input oDotnetErrorIP# as System.Exception):
      
    ShowException("", oDotnetErrorIP#).
    
  end method. /* ShowException; dotnet exception */
  
    
  method public static void ShowException(
    
    /* Default exception handling for DOTNET errors. 
       Since oe11.1, dotnet exceptions can't be handled transparently anymore, probably a progress bug.
       Example error:
       A variable of class 'System.Reflection.ReflectionTypeLoadException' cannot be assigned to a variable of class 'Progress.Lang.Error'. (13448)
       Workaround:
       Implement an extra catch block for System.Exception, and call this overload.
    */
    input cExtraMessageIP# as character,
    input oDotnetErrorIP# as System.Exception):
    
    define variable oReflectionError# as System.Reflection.ReflectionTypeLoadException no-undo.
    
    define variable cMessage#         as character                                     no-undo.
    define variable cCallStack#       as character                                     no-undo.
    
    cMessage# = subst("&1", oDotnetErrorIP#:ToString()).
    cCallStack# = oDotnetErrorIP#:CallStack. /* codeQok#7120 */
    
    if type-of(oDotnetErrorIP#, System.Reflection.ReflectionTypeLoadException) then 
    do:
      
      oReflectionError# = cast(oDotnetErrorIP#, System.Reflection.ReflectionTypeLoadException).
      
      do on error undo, throw:
        cMessage# = subst("&1~n~n&2",oReflectionError#:ToString(), cast(oReflectionError#:LoaderExceptions:GetValue(0),System.Exception):Message).
        catch oExtraSafe# as Progress.Lang.Error:
          cMessage# = subst("&1", oReflectionError#:ToString()).
        end catch.
      end.
      
    end.
    
    ShowException(cExtraMessageIP#, 
      new c_panaedraexception(
      99917228,
      sc_lang:oEnglish,
      substitute("Dotnet exception:~n&1~n~nDotnet callstack:~n&2", cMessage#, cCallStack#) /* codeQok#7120 */
      )).

  end method. /* ShowException; message + dotnet exception */
  &endif /* opsys <> unix */


  method public static void ShowException(
    
    /* Default exception handling. Depending on session type and config: to screen, logfile, or (in batchmode) posted as a monitor event. */
    
    input cExtraMessageIP# as character,
    input oErrorIP#        as Progress.Lang.Error):
    
    define variable bKeepNative#                  as logical          no-undo.
    define variable bSuccess#                     as logical          no-undo.
    define variable cEventID#                     as character        no-undo. /* EventID is meant to be used in (for example) url's to link 
                                                                                  to documentation. Here we set it to something that is as 
                                                                                  specific as possible. In panaedra exception, the error number 
                                                                                  is (non-forced) unique to the source location, so it's a 
                                                                                  good ID. For SysError's, part of the stack is a better ID. */
    define variable bUseStackForID#               as logical          no-undo.
    
    define variable iError#                       as integer          no-undo.
    define variable cExceptionCallStackLastEntry# as character        no-undo.
    define variable oPanaedraError#                  as c_panaedraexception no-undo.
    
    if sc_environment:bBatchMode then 
    do:
      
      iError# = oErrorIP#:GetMessageNum(1).
    
      if iError# = 0 or iError# = ? then iError# = 99948192. /* Nothing better to do than give a unique error number */
    
      if type-of(oErrorIP#, c_panaedraexception) then 
      do:
        oPanaedraError# = cast(oErrorIP#,c_panaedraexception).
        if valid-object(oPanaedraError#:oRecordStatus) then 
        do:
          /* A record status has a table, this is useful in the ID */
          if length(oPanaedraError#:oRecordStatus:cTablename) > 0 then
            cEventID# = "_" + oPanaedraError#:oRecordStatus:cTablename.
          bUseStackForID# = false.  
        end.
        else
          bUseStackForID# = false.

      end.
      else 
        bUseStackForID# = true.
      
      cExceptionCallStackLastEntry# = ExceptionCallStackLastEntry(oErrorIP#).
    
      if bUseStackForID# then
        cEventID# = cExceptionCallStackLastEntry# + cEventID#.
      else
        cEventID# = subst("Loc_&1",string(iError#,"99999999")) + cEventID#.
        
      if length(cExtraMessageIP#) > 0 then
        cExtraMessageIP# = cExtraMessageIP# + "~n".
      else /* in case of unknown value */
        cExtraMessageIP# = "".  
        
      cExtraMessageIP# = cExtraMessageIP# + sc_showexception:ExceptionMsgToString(oErrorIP#).  
    
      bSuccess# = 
        sc_msmon_feedback:HandleEvent(
        "ShowException",                /* Event */
        cEventID#,                      /* ID */
        cExceptionCallStackLastEntry#,
        cExtraMessageIP#,
        oErrorIP#).
      if not bSuccess# then 
        bKeepNative# = true.  
        
    end. /* batchmode */
    
    else /* no batchmode */
      bKeepNative# = true.
    
    if bKeepNative# then
      /* To screen or default output, no external routes */
      ShowExceptionKeepNative(cExtraMessageIP#,oErrorIP#).
    
  end method. /* ShowException */
  

  method public static void ShowExceptionKeepNative(
    
    input oErrorIP# as Progress.Lang.Error):
    
    ShowExceptionKeepNative("", oErrorIP#).
      
  end method. /* ShowExceptionKeepNative ; simple overload */
  
  
  method public static void ShowExceptionKeepNative(
    
    /* "Keep native" means: 
       Keep the message inside the session, don't use post monitor event, os-command's, or such.
       In other words:
       Force the message to go to the screen (UI clients) or to the default 
       output stream (Batch clients).
    */
    
    input cExtraMessageIP# as character,
    input ex as Progress.Lang.Error):
    
    &if opsys <> "unix" and "{&window-system}" <> "tty" &then
    
    /* This code does not compile on unix, only on .NET win32 */
    
    if not sc_environment:bBatchMode then 
    do:
    
      if not valid-object(oForm) then
        oForm = new panaedra.msroot.msutil.view.c_dotnetformshowexception().
        
      /* Fill form data with data from exception. */
      oForm:ShowException(cExtraMessageIP#,ex).
      
      do on error undo, throw:
        
        /* Show the form if possible */
        ShowFormSafe().
        
        catch oError# as Progress.Lang.Error :
          /* Possible input blocking, just show message. */
          ShowExceptionKeepNativeImplement(cExtraMessageIP#,ex).    
        end catch.
        
      end.
      
    end.
    
    else
      &endif /* Not unix/tty */
    
      ShowExceptionKeepNativeImplement(cExtraMessageIP#,ex).
    
    
    finally:
      &if opsys <> "unix" and "{&window-system}" <> "tty" &then
      /* In oe11 / .net 4, you can't re-show a modal form. 
         We always destroy it now. 
      */
      if valid-object(oForm) then 
        oForm:Dispose().
      if valid-object(oForm) then 
        delete object oForm.
    &endif /* Not unix/tty */
    end finally.  
    
  end method. /* ShowExceptionKeepNative */
  
  
  method protected static void ShowExceptionKeepNativeImplement(
    input cExtraMessageIP# as character,
    input oErrorIP# as Progress.Lang.Error):

    /* The following code is used on win32 as well as unix */
    
    define variable cLastProgram# as character no-undo.
    define variable cMessage#     as character no-undo.
    define variable iTell#        as integer   no-undo.
    
    assign
      cLastProgram# = GetSessionCallStack()
      cLastProgram# = entry(num-entries(cLastProgram#,chr(10)), cLastProgram#, chr(10))
      cLastProgram# = entry(num-entries(cLastProgram#," ")    , cLastProgram#, " ").
    
    if length(cLastProgram#) >= 60 then
      cLastProgram# = "..." + 
        substring(cLastProgram#, length(cLastProgram#) - 59).
    
    if length(cExtraMessageIP#) > 0 then
      cMessage# = cExtraMessageIP# + chr(10).
    
    cMessage# = cMessage# + sc_showexception:ExceptionMsgToString(oErrorIP#).
    
    message 
      sc_messagebox:MessageToDisplayableMessage(
      subst("&1~n&2~n&3",
      cMessage#,
      GetCallStack(oErrorIP#),
      cLastProgram#))
      view-as alert-box title "Panaedra " + string(now,"99-99-99 hh:mm:ss").
  
  end method. /* ShowExceptionKeepNativeImplement */

  &if not opsys = "unix" &then
  method public static character ExceptionToString(
    
    /* Get all info from an exception and put it in a simple string */
  
    input oErrorIP# as System.Exception):

    define variable cLastProgram#       as character           no-undo.
    define variable cMessage#           as character           no-undo.
    define variable iTell#              as integer             no-undo.
    define variable oApiProxyException# as c_apiproxyexception no-undo.
    
    assign
      cLastProgram# = GetSessionCallStack()
      cLastProgram# = entry(num-entries(cLastProgram#,chr(10)), cLastProgram#, chr(10))
      cLastProgram# = entry(num-entries(cLastProgram#," ")    , cLastProgram#, " ").
    
    if length(cLastProgram#) >= 60 then
      cLastProgram# = "..." + 
        substring(cLastProgram#, length(cLastProgram#) - 59).
    
    cMessage# = cMessage# + ExceptionMsgToString(oErrorIP#) + " ~n[Callstack] " + GetCallstack(oErrorIP#). /* codeQok#7120 */
          
    return cMessage#.
  
  end method. /* ExceptionToString */
  &endif /* not opsys = unix */ 
  
  method public static character ExceptionToString(
    
    /* Get all info from an exception and put it in a simple string */
  
    input oErrorIP# as Progress.Lang.Error):

    define variable cLastProgram#       as character           no-undo.
    define variable cMessage#           as character           no-undo.
    define variable iTell#              as integer             no-undo.
    define variable oApiProxyException# as c_apiproxyexception no-undo.
    
    assign
      cLastProgram# = GetSessionCallStack()
      cLastProgram# = entry(num-entries(cLastProgram#,chr(10)), cLastProgram#, chr(10))
      cLastProgram# = entry(num-entries(cLastProgram#," ")    , cLastProgram#, " ").
    
    if length(cLastProgram#) >= 60 then
      cLastProgram# = "..." + 
        substring(cLastProgram#, length(cLastProgram#) - 59).
    
    cMessage# = cMessage# + ExceptionMsgToString(oErrorIP#) + " ~n[Callstack] " + GetCallstack(oErrorIP#). /* codeQok#7120 */
          
    return cMessage#.
  
  end method. /* ExceptionToString */
  
  &if not opsys = "unix" &then
  method public static character ExceptionMsgToString(
    
    /* Get only "message" info from an exception (omit the callstack) and put it in a simple string codeQok#7120 */
  
    input oErrorIP# as System.Exception):

    define variable cMessage#           as character           no-undo.
    
    cMessage# = ExceptionMsgToStringSub(oErrorIP#).
    
    return cMessage#.
  
  end method. /* ExceptionMsgToString */
  &endif /* not opsys = unix */
  
  method public static character ExceptionMsgToString(
    
    /* Get only "message" info from an exception (omit the callstack) and put it in a simple string codeQok#7120 */
  
    input oErrorIP# as Progress.Lang.Error):

    define variable cMessage#           as character           no-undo.
    define variable cMessageInner#      as character           no-undo.
    
    define variable oPanaedraException#    as c_panaedraexception    no-undo.
    define variable oApiProxyException# as c_apiproxyexception no-undo.
    
    cMessage# = ExceptionMsgToStringSub(oErrorIP#).
    
    if type-of(oErrorIP#, c_panaedraexception) then 
    do:
      oPanaedraException# = cast(oErrorIP#, c_panaedraexception).
      if valid-object(oPanaedraException#:oInnerException)
        then 
      do:
        cMessageInner# = ExceptionMsgToStringSub(oPanaedraException#:oInnerException).
        if length(cMessageInner#) > 0 then
          cMessage# = subst("&1~n&2",cMessage#,cMessageInner#).
      end.
    end.
    
    return cMessage#.
  
  end method. /* ExceptionMsgToString */
  
  &if not opsys = "unix" &then
  method protected static character ExceptionMsgToStringSub(
    
    /* Get only "message" info from an exception (omit the callstack) and put it in a simple string codeQok#7120 */
  
    input oErrorIP# as System.Exception):

    define variable cLastProgram# as character no-undo.
    define variable cMessage#     as character no-undo.
    define variable iTell#        as integer   no-undo.
    
    do iTell# = 1 to oErrorIP#:NumMessages on error undo, throw:
      
      if iTell# > 1 
        then cMessage# = cMessage# + chr(10).
        
      cMessage# = cMessage# + 
        oErrorIP#:GetMessage(iTell#).
        
      if index(cMessage#, subst("(&1)", oErrorIP#:GetMessageNum(iTell#))) = 0
        then cMessage# = cMessage# + subst(" (&1)", oErrorIP#:GetMessageNum(iTell#)).
        
      catch oError# as Progress.Lang.Error:
        /* Just to be ultra safe; ensure no unknown value is returned. We are in exception handling here. */
        cMessage# = "". 
      end catch.
      
    end. /* do iTell# */
    
    return cMessage#.
  
  end method. /* ExceptionMsgToStringSub */
  &endif /* not opsys = unix */
  
  method protected static character ExceptionMsgToStringSub(
    
    /* Get only "message" info from an exception (omit the callstack) and put it in a simple string codeQok#7120 */
  
    input oErrorIP# as Progress.Lang.Error):

    define variable cLastProgram# as character no-undo.
    define variable cMessage#     as character no-undo.
    define variable iTell#        as integer   no-undo.
    
    do iTell# = 1 to oErrorIP#:NumMessages on error undo, throw:
      
      if iTell# > 1 
        then cMessage# = cMessage# + chr(10).
        
      cMessage# = cMessage# + 
        oErrorIP#:GetMessage(iTell#).
        
      if index(cMessage#, subst("(&1)", oErrorIP#:GetMessageNum(iTell#))) = 0
        then cMessage# = cMessage# + subst(" (&1)", oErrorIP#:GetMessageNum(iTell#)).
        
      catch oError# as Progress.Lang.Error:
        /* Just to be ultra safe; ensure no unknown value is returned. We are in exception handling here. */
        cMessage# = "". 
      end catch.
      
    end. /* do iTell# */
    
    return cMessage#.
  
  end method. /* ExceptionMsgToStringSub */
  
  &if not opsys = "unix" &then
  method public static character ExceptionCallStackLastEntry(
    
    /* This is a method, because behaviour is different between oe10 and oe11+.
     
       "Last" means: last called code block just before the exception occurred.
    */
    
    oErrorIP# as System.Exception):
      
    define variable cReturn# as character no-undo.  
    
    if oErrorIP#:CallStack = ? then /* codeQok#7120 */
      cReturn# = program-name(3).
    else
      cReturn# = trim(entry(
        &if int(entry(1,proversion,".")) <= 10 &then
        num-entries(oErrorIP#:CallStack,chr(10)) /* codeQok#7120 */
        &else
        1
        &endif
        ,oErrorIP#:CallStack,chr(10))). /* codeQok#7120 */
      
    
    return cReturn#.  
  
  end method. /* ExceptionCallStackLastEntry */
  &endif /* not opsys = unix */
  
  method public static character ExceptionCallStackLastEntry(
    
    /* This is a method, because behaviour is different between oe10 and oe11+.
     
       "Last" means: last called code block just before the exception occurred.
    */
    
    oErrorIP# as Progress.Lang.Error):
      
    define variable cReturn# as character no-undo.  
    
    if oErrorIP#:CallStack = ? then /* codeQok#7120 */
      cReturn# = program-name(3).
    else
      cReturn# = trim(entry(
        &if int(entry(1,proversion,".")) <= 10 &then
        num-entries(oErrorIP#:CallStack,chr(10)) /* codeQok#7120 */
        &else
        1
        &endif
        ,oErrorIP#:CallStack,chr(10))). /* codeQok#7120 */
      
    
    return cReturn#.  
  
  end method. /* ExceptionCallStackLastEntry */

  &if not opsys = "unix" &then
  method public static character GetCallStack(
    
    /* Uses apiproxyexception to give back extended callstack    codeQok#7120
       wich has appserver bounderies */
       
    oExceptionIP# as System.Exception
    ):
    
    define variable cCallstack#         as character           no-undo.
     
    if length(oExceptionIP#:CallStack) > 0 then /* codeQok#7120 */ 
      cCallstack# = oExceptionIP#:CallStack. /* codeQok#7120 */
    else  
      cCallstack# = GetSessionCallStack().
     
    return cCallstack#. 
       
  end method. /* GetCallStack ; dotnet */
  &endif /* not opsys = unix */ 
  
  method public static character GetCallStack(
    
    /* Uses apiproxyexception to give back extended callstack    codeQok#7120
       wich has appserver bounderies */
       
    oExceptionIP# as Progress.Lang.Error
    ):
    
    define variable hDscontext#         as handle              no-undo.
    define variable hTtCallstack#       as handle              no-undo.
    define variable cCallstack#         as character           no-undo.
    define variable oApiproxyexception# as c_apiproxyexception no-undo.
    define variable hQuery#             as handle              no-undo.
    define variable hBuff#              as handle              no-undo.
     
    if type-of(oExceptionIP#,c_apiproxyexception) then
    do on error undo, throw:
      
      assign
        oApiproxyexception# = cast(oExceptionIP#,c_apiproxyexception)
        hDscontext#         = oApiproxyexception#:GetDsContextHandle()
        hTtCallstack#       = hDscontext#:get-buffer-handle("ttCallStack"):table-handle
        hBuff#              = hTtCallstack#:default-buffer-handle.
      
      create query hQuery#.
      hQuery#:set-buffers(hBuff#).
      hQuery#:query-prepare(subst("for each &1 no-lock",hBuff#:name)).
      hQuery#:query-open.
      hQuery#:get-last.   

      /* Invert callstack order codeQok#7120 */
      do while not hQuery#:query-off-end:
        cCallstack# = cCallstack# + replace(hBuff#::cCallStack, chr(10), chr(13) + chr(10)) + chr(13) + chr(10). 
        hQuery#:get-prev.
      end. /* do while */

      finally:
        delete object hQuery#.  
      end finally.
            
    end. /* oApiproxyexception# */  
    else
    do:
      if length(oExceptionIP#:CallStack) > 0 then /* codeQok#7120 */ 
        cCallstack# = oExceptionIP#:CallStack. /* codeQok#7120 */
      else  
        cCallstack# = GetSessionCallStack().
    end.    
     
    return cCallstack#. 
       
  end method. /* GetCallStack ; apiproxyexception */
  
    
  method public static character GetSessionCallStack():

    define variable iProgramNo#    as integer   no-undo.
    define variable cCallStack#    as character no-undo.
    define variable cProgramStack# as character no-undo.

    /* Program 1 is skipped, it's this class itself */
    iProgramNo# = 2.
    
    /* Look for known runs */
    do while length(program-name(iProgramNo#)) > 0
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

  end method. /* GetSessionCallStack */
  
  
  &if opsys <> "unix" and "{&window-system}" <> "tty" &then
  
  method protected static void ShowFormSafe():
    
    do on error undo, throw
      on stop undo, retry:
      
      if retry then
        undo, throw new c_panaedraexception(
          99952997,
          sc_lang:oEnglish,
          substitute("Error: '&1'", "Cannot do wait-for on oForm of showexception")
          ).
        
      /* Show the exception form and wait for Okay. */
      wait-for oForm:ShowDialog(). 
      
    end.
    
  end method.
  
&endif /* unix/tty */

end class.

/* EOF */
