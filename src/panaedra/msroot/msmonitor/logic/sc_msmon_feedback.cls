using panaedra.msroot.msmonitor.interfaces.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msmonitor.logic.sc_msmon_feedback: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Send feedback from monitoring processes to developers/sysadmins/users

  \*****************************  Include Files ********************************/
  
{panaedra/msroot/msmonitor/logic/ds/msmon_feedback_ds.i &class=class &static=static &protected=protected}
  
  /************************  Source control constructor ************************/
  constructor public sc_msmon_feedback(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable dtmLastConfig as datetime-tz no-undo.
  
  method public static void TestDefaultConfig(
    
    /* Test the default configuration */
    /* panaedra.msroot.msmonitor.logic.sc_msmon_feedback:TestDefaultConfig(). */
    
    ):
    
    define variable oPanaedraError# as c_panaedraexception no-undo.
    
    oPanaedraError# = new c_panaedraexception(
      99958118,
      sc_lang:oEnglish,
      substitute("Test error at time: '&1'~nThis is a message.~n The following text 'A test' could be stripped if cMessageFormat=~"commandline~".", now)
      ).
    
    HandleEvent(
      "MyTestEvent",
      "MyTestMonitorID",
      "At some location...",
      "",          /* Message, if supplied: overrules exception message           */
      oPanaedraError# /* Optional exception object, to pass callstack and other info */
      ).
    
    finally:
      if valid-object(oPanaedraError#)
        then delete object oPanaedraError#.
    end finally.
    
  end method. /* TestDefaultConfig */


  method public static logical HandleEvent(
    
    /* Handle a monitor event, by config file */
    
    cEventIP#     as character, 
    cMonitorIdIP# as character, 
    cLocationIP#  as character, 
    cMessageIP#   as character):
    
    ReloadConfig().
    
    return HandleEvent_Implement(
      cEventIP#,    
      cMonitorIdIP#,
      cLocationIP#, 
      cMessageIP#,
      ?,
      no /* FailSafe */
      ).
      
  end method. /* HandleEvent ; overload without exception object */
  
    
  method public static logical HandleEvent(
    
    /* Handle a monitor event, by config file */
    
    cEventIP#     as character, 
    cMonitorIdIP# as character, 
    cLocationIP#  as character, 
    cMessageIP#   as character,
    oErrorIP#     as c_panaedraexception):

    ReloadConfig().

    return HandleEvent_Implement(
      cEventIP#,    
      cMonitorIdIP#,
      cLocationIP#, 
      "",
      oErrorIP#,
      no /* FailSafe */
      ).
      
  end method. /* HandleEvent ; overload with only exception object and no message string */
    
  
  method public static logical HandleEvent(
    
    /* Handle a monitor event, by config file */
    
    cEventIP#     as character, 
    cMonitorIdIP# as character, 
    cLocationIP#  as character, 
    oErrorIP#     as c_panaedraexception):

    ReloadConfig().

    return HandleEvent_Implement(
      cEventIP#,    
      cMonitorIdIP#,
      cLocationIP#, 
      "",
      oErrorIP#,
      no /* FailSafe */
      ).
      
  end method. /* HandleEvent ; overload with only exception object and no message string */
  
  
  method public static logical HandleEvent(
    
    /* Handle a monitor event, by config file
       bFailSafeIP#  yes= handle previous a failed event, failover mechanism. */
    
    cEventIP#     as character, 
    cMonitorIdIP# as character, 
    cLocationIP#  as character, 
    cMessageIP#   as character,
    oErrorIP#     as c_panaedraexception,
    bFailSafeIP#  as logical ):
      
    ReloadConfig().
      
    return HandleEvent_Implement(
      cEventIP#,    
      cMonitorIdIP#,
      cLocationIP#, 
      "",
      oErrorIP#,
      no /* FailSafe */
      ).
      
  end method.    

  
  method protected static logical HandleEvent_Implement(
    
    /* Handle a monitor event, by config file 
       note:  
       use ReloadConfig() before using this overload.
    */
    
    cEventIP#     as character, 
    cMonitorIdIP# as character, 
    cLocationIP#  as character, 
    cMessageIP#   as character,
    oErrorIP#     as c_panaedraexception,
    bFailSafeIP#  as logical ):
    
    define variable cOsCommand#             as character                no-undo.
    define variable oTempfileBuilderObject# as i_msmon_itempfilebuilder no-undo.
    define variable cTempFile#              as character                no-undo.
    define variable cErrorFile#             as character                no-undo.
    define variable cCmdErrors#             as longchar                 no-undo.
    define variable bReturn#                as logical                  no-undo.
    
    define buffer b-ttMsMonFeedbackDef for ttMsMonFeedbackDef.
    
    /*  (service, part, level, location, message):           */
    /*  # service = service,dienst,application               */
    /*  # part    = service/application module               */
    /*  # level   = event level: debug/info/warn/error/fatal */
    /*  # message = description of error condition           */
    
    find b-ttMsMonFeedbackDef where 
      b-ttMsMonFeedbackDef.cEvent     = cEventIP#                and
      b-ttMsMonFeedbackDef.cEnv       = sc_environment:cEnv      and
      b-ttMsMonFeedbackDef.cOpsys     = opsys                    and
      b-ttMsMonFeedbackDef.cHostname  = sc_environment:cHostName and
      b-ttMsMonFeedbackDef.cMonitorID = cMonitorIdIP#
      no-error.
    
    if not avail b-ttMsMonFeedbackDef then
      find b-ttMsMonFeedbackDef where 
        b-ttMsMonFeedbackDef.cEvent     = cEventIP#            and
        b-ttMsMonFeedbackDef.cEnv       = sc_environment:cEnv  and
        b-ttMsMonFeedbackDef.cOpsys     = opsys                and
        b-ttMsMonFeedbackDef.cHostname  = "(default)"          and
        b-ttMsMonFeedbackDef.cMonitorID = cMonitorIdIP#
        no-error.
  
    if bFailSafeIP# = no then 
    do:
      if not avail b-ttMsMonFeedbackDef then
        find b-ttMsMonFeedbackDef where 
          b-ttMsMonFeedbackDef.cEvent     = "(default)"          and
          b-ttMsMonFeedbackDef.cEnv       = sc_environment:cEnv  and
          b-ttMsMonFeedbackDef.cOpsys     = opsys                and
          b-ttMsMonFeedbackDef.cHostname  = "(default)"          and
          b-ttMsMonFeedbackDef.cMonitorID = cMonitorIdIP#
          no-error.
  
      if not avail b-ttMsMonFeedbackDef then
        find b-ttMsMonFeedbackDef where 
          b-ttMsMonFeedbackDef.cEvent     = "(default)"          and
          b-ttMsMonFeedbackDef.cEnv       = sc_environment:cEnv  and
          b-ttMsMonFeedbackDef.cOpsys     = opsys                and
          b-ttMsMonFeedbackDef.cHostname  = "(default)"          and
          b-ttMsMonFeedbackDef.cMonitorID = "(default)"
          no-error.
    end. /* if bFailSafeIP# = no */
    else 
    do:
      find b-ttMsMonFeedbackDef where 
        b-ttMsMonFeedbackDef.cEvent     = cEventIP#                and
        b-ttMsMonFeedbackDef.cEnv       = sc_environment:cEnv      and
        b-ttMsMonFeedbackDef.cOpsys     = opsys                    and
        b-ttMsMonFeedbackDef.cHostname  = "(default)"              and
        b-ttMsMonFeedbackDef.cMonitorID = "(default)"
        no-error.
    end.
    
    if not avail b-ttMsMonFeedbackDef then
      undo, throw new c_panaedraexception(
        99938299,
        sc_lang:oEnglish,
        substitute("No MsMonFeedbackDef configuration found for event '&1', environment '&2', opsys '&3', hostname '&4', monitor ID '&5', message '&6'", 
        cEventIP#, sc_environment:cEnv, opsys, sc_environment:cHostName, cMonitorIdIP#, cMessageIP#)
        ).
      
    cOsCommand# = b-ttMsMonFeedbackDef.cOsCommand.
    
    if cOsCommand# > "" then 
    do on error undo, throw:

      assign      
        b-ttMsMonFeedbackDef.cMessage   = cMessageIP#
        b-ttMsMonFeedbackDef.cUsername  = sc_environment:cUserID
        b-ttMsMonFeedbackDef.cLocation  = cLocationIP#
        b-ttMsMonFeedbackDef.cProcessID = string(sc_environment:GetProcessID())
        b-ttMsMonFeedbackDef.cEvent     = cEventIP#
        b-ttMsMonFeedbackDef.cService   = cMonitorIdIP#
        b-ttMsMonFeedbackDef.cEnv       = sc_environment:cEnv
        b-ttMsMonFeedbackDef.cOpsys     = opsys
        b-ttMsMonFeedbackDef.cHostname  = sc_environment:cHostName
        b-ttMsMonFeedbackDef.cMonitorID = cMonitorIdIP#
        .
      
      if oErrorIP# <> ? and (cMessageIP# = ? or cMessageIP# = "") then
        b-ttMsMonFeedbackDef.cMessage    = sc_showexception:ExceptionMsgToString(oErrorIP#).
      
      if oErrorIP# <> ? then
        b-ttMsMonFeedbackDef.cStackTrace = oErrorIP#:CallStack.  
      
      if b-ttMsMonFeedbackDef.cStackTrace = "" then
        b-ttMsMonFeedbackDef.cStackTrace = sc_info:GetCallStack().
      
      /*-- if requested create a tempfile to use with the oscommand --*/
      if b-ttMsMonFeedbackDef.cTempfileBuilderObject > "" then
      do:
        oTempfileBuilderObject# = dynamic-new b-ttMsMonFeedbackDef.cTempfileBuilderObject().
        cTempFile# = oTempfileBuilderObject#:CreateTempfile(
          buffer b-ttMsMonFeedbackDef:handle
          ). 
        cErrorFile# = cTempfile# + ".err".  
      end. /* if */
      
      /* replace macros from the config in the commandline */
      cOsCommand# = replace(cOsCommand#,"[:cService:]",b-ttMsMonFeedbackDef.cService).
      cOsCommand# = replace(cOsCommand#,"[:cLevel:]",b-ttMsMonFeedbackDef.cLevel).
      cOsCommand# = replace(cOsCommand#,"[:cPart:]",b-ttMsMonFeedbackDef.cPart).
      cOsCommand# = replace(cOsCommand#,"[:cLocation:]",cLocationIP#).
      cOsCommand# = replace(cOsCommand#,"[:cTempfile:]",cTempFile#).
      cOsCommand# = replace(cOsCommand#,"[:cErrorfile:]",cErrorFile#).
      
      /* If message is sent command-line, we strip invalid chars. */
      if b-ttMsMonFeedbackDef.cMessageFormat="commandline" then 
      do:
        /* Strip dangerous stuff like pipe tokens and quotes. Keep spaces and slashes */ 
        cMessageIP# = sc_osfile:StripInvalidChars(cMessageIP#, false).
        if opsys = "unix" then
          /* Backslashes on the unix command line is asking for trouble. Turn them into forward slashes. */
          cMessageIP# = replace(cMessageIP#,"~\","/"). 
        /* Replace carriage returns and line feeds */
        cMessageIP# = replace(trim(replace(replace(cMessageIP#,chr(10)," "),chr(13)," ")),'"',"").
      end.
      cOsCommand# = replace(cOsCommand#,"[:cMessage:]",cMessageIP#).
      cOsCommand# = replace(cOsCommand#,"[:cMonitorID:]",cMonitorIdIP#).
      cOsCommand# = replace(cOsCommand#,"[:cEnv:]",sc_environment:cEnv).
      cOsCommand# = replace(cOsCommand#,"[:cEvent:]",cEventIP#).
      
      /* expand env.variables in the commandline */
      cOsCommand# = sc_string_substitute:ExpandOsEnv(cOsCommand#).
      
      /* execute the command to report feedback */
      os-command value(cOsCommand#).
      bReturn# = yes.
      
      /* handle any errors of the feedback */
      if sc_osfile:FileExists(cErrorFile#) then
      do:
        
        copy-lob file cErrorFile# to cCmdErrors#.
        if cCmdErrors# > "" then  /* any errors while giving feedback? */ 
        do:
          bReturn# = no.
          
          if bFailSafeIP# = no then /* prevent looping in FailSafe mode */
            /* handle a second even (FailSafe) reporting errors of the first feedback attempt. */
            HandleEvent_Implement (
              "FailSafe",    
              cMonitorIdIP#,
              cLocationIP#, 
              string(cCmdErrors#),
              oErrorIP#,
              yes /* FailSafe */
              ).
          else /* the second (FailSafe) event also failed, it stops here, throw an event */
            undo, throw new c_panaedraexception(
              50463301,
              sc_lang:oEnglish,
              substitute("MsMonFeedback error (FailSafe error loop): &1", cCmdErrors#)
              ).
              
        end. /* if */    
        else
          sc_osfile:DeleteFile(cErrorFile#).
      end. /* if sc_osfile:FileExists(cErrorFile#) */

      finally:
        if sc_osfile:FileExists(cTempFile#) then
          sc_osfile:DeleteFile(cTempFile#). 
        
        if valid-object(oTempfileBuilderObject#) then
          delete object oTempfileBuilderObject#.	
      end finally.
      
    end.
  
  end method. /* HandleEvent ; overload with all parameters */
  
  
  method public static void ReloadConfig():
    
    define variable cConfigFile#   as character   no-undo.
    define variable dtmConfigFile# as datetime-tz no-undo.
    define variable bReload#       as logical     no-undo.
    
    assign
      cConfigFile#   = sc_path:cIniDir + subst("sc_msmon_feedback_&1.config", if sc_environment:bLiveEnv then "live" else "nonlive")
      dtmConfigFile# = sc_osfile:GetFileModDatetime(cConfigFile#).
    
    if dtmLastConfig = ? 
      then bReload# = true.
    
    if (not bReload#) and (dtmLastConfig <> dtmConfigFile#)
      then bReload# = true.
    
    if bReload# then
    do:
      sc_config:ReadXml(dataset dsMsMonFeedback:handle,cConfigFile#).
      dtmLastConfig = dtmConfigFile#.
    end.
  
  end method. /* ReloadConfig */
  
end class.

/* EOF */ 
