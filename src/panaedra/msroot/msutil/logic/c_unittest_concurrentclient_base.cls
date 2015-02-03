using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msas.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.c_unittest_concurrentclient_base: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: For unit tests: start another session to get actual concurrent behaviour, automated by TCP socket.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_unittest_concurrentclient_base(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected variable bExtraSessionIsBooted as logical   no-undo.
  
  define property cUtClientGuid as character no-undo
    public get:
      if length(cUtClientGuid) = 0 then
        cUtClientGuid = guid.
      return cUtClientGuid.
    end get.
    protected set.
    
  constructor public c_unittest_concurrentclient_base():
      
  end constructor.
  

  destructor c_unittest_concurrentclient_base():
    sc_unittest:_sys_SocketClientUnregister(cUtClientGuid).  
  end destructor.

  
  method protected void BootExtraSession(
  
     /* From the current session, start a new progress session that will be controlled by the current session */
     
     cBootprocToRunIP#        as character):

    define variable cCommand#                as character no-undo.
    define variable cEnv#                    as character no-undo.
    define variable cWorkPath#               as character no-undo.
    define variable bDevToken#               as logical   no-undo.
    define variable bClientGuidFeedbackOkay# as logical   no-undo.
    
    /* Set up a server-socket (if not already running) */
    sc_unittest:_sys_InitializeUtServerSocket().

    /* Start a separate session that connects to the server socket */
    assign
      cEnv#      = sc_boot:SessionParameter("Env")
      cWorkPath# = sc_boot:SessionParameter("WorkPath").

    bDevToken# = length(os-getenv("DevToken")) > 0 no-error.
    if bDevToken# = ? then bDevToken# = false.

    if cWorkPath# = ? or cWorkPath# = "" then
      cWorkPath# = sc_path:cWorkDir.
    
    cCommand# = subst('. /etc/profile ; unset PROPATH ; &1 &2 ; export LOGFILEID=&3 ; export UtClientGuid=&3 ; export AsModeSuffixPre=&4 ; CpSuffix=_utf8_s850 $SCRIPTS/RunRaw ',
      " export OTAUSER=yes ;" 
      /* tmp solution, remove if live is OE113 */
      + if sc_environment:cEnv <> "misc" then "" else ". /progress/scripts/progressProfile113A;",
      subst(". $SCRIPTS/PropathSet &1 ; export PROPATHPRE=$PROPATH", if bDevToken# then os-getenv("DlcTest_") else "test"),
      cUtClientGuid,
      replace(sc_asconnect:GetSuffix(), "_batch", "") /* _batch can be removed here */
      ) +
      subst(' "&1" &2 &3 BATCH " [UnittestPort] &4 [SharedIniDir] &5 &6 "',
      cBootprocToRunIP#,
      sc_environment:cEnv, 
      cWorkPath# /* Working directory */,
      sc_unittest:sys_iUtServerPort,
      sc_path:cIniDir,
      if sc_boot:SessionParameter("DevIP") > "" then subst("[DevIP] &1 ", sc_boot:SessionParameter("DevIP")) else ""
      ).
    
    /* Start the client process. */
    os-command silent value(cCommand#).
    /* After 5 seconds the process should be in the air. */
    sc_unittest:_sys_SocketClientGuidWait(cUtClientGuid, 5000, output bClientGuidFeedbackOkay#).
    
    if not bClientGuidFeedbackOkay# then
      undo, throw new c_panaedraexception(
        99028172,
        sc_lang:oEnglish,
        substitute("UnitTest client '&1' did not respond after '&2' ms.", cUtClientGuid, 5000)).
      
  end method. /* BootExtraSession */

end class.

/* EOF */ 
