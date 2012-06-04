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
  
    HandleEvent(
      "MyTestEvent",
      "MyTestMonitorID",
      "At some location...",
      "This is a message.~n The following text 'A test' can be stripped."
      ).
  
  end method. /* TestDefaultConfig */
  
  
  method public static void HandleEvent(
    
    /* Handle a monitor event, by config file */
    
    cEventIP#     as character, 
    cMonitorIdIP# as character, 
    cLocationIP#  as character, 
    cMessageIP#   as character):
    
    define variable cOsCommand#             as character                no-undo.
    define variable oTempfileBuilderObject# as i_msmon_itempfilebuilder no-undo.
    define variable cTempFile#              as character                no-undo.
    define variable cErrorFile#             as character                no-undo.
    define variable cCmdErrors#             as longchar                 no-undo.
    
    define buffer b-ttMsMonFeedbackDef for ttMsMonFeedbackDef.
    
    /*  (service, part, level, location, message):           */
    /*  # service = service,dienst,application               */
    /*  # part    = service/application module               */
    /*  # level   = event level: debug/info/warn/error/fatal */
    /*  # message = description of error condition           */
  
    ReloadConfig().
    
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

    if not avail b-ttMsMonFeedbackDef then
      undo, throw new c_panaedraexception(
        99938299,
        sc_lang:oEnglish,
        substitute("No MsMonFeedbackDef configuration found for monitor ID '&1', environment '&2', opsys '&3', message '&4'", cMonitorIdIP#, sc_environment:cEnv, opsys, cMessageIP#)
        ).
      
    cOsCommand# = b-ttMsMonFeedbackDef.cOsCommand.
    
    if cOsCommand# > "" then 
    do on error undo, throw:

      assign      
        b-ttMsMonFeedbackDef.cMessage    = cMessageIP#
        b-ttMsMonFeedbackDef.cStackTrace = sc_info:GetCallStack()
        b-ttMsMonFeedbackDef.cUsername   = sc_environment:cUserID
        b-ttMsMonFeedbackDef.cLocation   = cLocationIP#
        b-ttMsMonFeedbackDef.cProcessID  = cMonitorIdIP#
        .
      
      /*-- if requested create a tempfile to use with the oscommand --*/
      if b-ttMsMonFeedbackDef.cTempfileBuilderObject > "" then
      do:
        oTempfileBuilderObject# = dynamic-new b-ttMsMonFeedbackDef.cTempfileBuilderObject().
        cTempFile# = oTempfileBuilderObject#:CreateTempfile(
          buffer b-ttMsMonFeedbackDef:handle
          ). 
        cErrorFile# = cTempfile# + ".err".  
      end. /* if */
      
      
      cOsCommand# = replace(cOsCommand#,"[:cService:]",b-ttMsMonFeedbackDef.cService).
      cOsCommand# = replace(cOsCommand#,"[:cLevel:]",b-ttMsMonFeedbackDef.cLevel).
      cOsCommand# = replace(cOsCommand#,"[:cPart:]",b-ttMsMonFeedbackDef.cPart).
      cOsCommand# = replace(cOsCommand#,"[:cLocation:]",cLocationIP#).
      cOsCommand# = replace(cOsCommand#,"[:cTempfile:]",cTempFile#).
      
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
      
      /* redirect errors to errorfile, (temp.solution with unix script) */
      cOsCommand# = subst("/ota/wrktst/rdbo_script_redirect &1 &2", cErrorFile#, cOsCommand#).
      
      os-command silent value(cOsCommand#).
      
      /* handle any errors of the feedback */
      if sc_osfile:FileExists(cErrorFile#) then
      do:
        
        copy-lob file cErrorFile# to cCmdErrors#.
        if cCmdErrors# > "" then
          undo, throw new c_panaedraexception(
            50466438,
            sc_lang:oEnglish,
            substitute("OS command error: '&1'", cCmdErrors#)
            ).
        else
        do:
          sc_osfile:DeleteFile(cErrorFile#).
        end.
      end.

      
      finally:
        if valid-object(oTempfileBuilderObject#) then
          delete object oTempfileBuilderObject#.	
      end finally.
      
    end.
  
  end method. /* HandleEvent */
  
  
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
