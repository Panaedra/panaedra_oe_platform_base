{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
{paninui/logic/includes/preproc_dotnetclasses.i &class=class}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_persistency_info: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_persistency_info.cls $ 
          Version: $Revision: 9 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-06-22 14:42:04+02:00 $ 
    Date Modified: $Modtime: 2010-06-22 14:34:31+02:00 $ 

      Description: Uses the session handle to find persistent buffers, procedures, or objects.
                   Very useful for checking if you didn't forget to clean something up.

  \*****************************  Include Files ********************************/
  
  {panaedra/msroot/msutil/logic/tt/mspersistencyinfo_tt.i &class=class &protected=protected &static=static}
  
  /************************  Source control constructor ************************/
  constructor public sc_persistency_info(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 9 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static temp-table ttSourceControl no-undo
    field iOrder    as int 
    field cFileName as char format "x(30)"
    field cIden     as char format "x(30)"
    field iVersion  as int   format "->>>,>>>,>>9"
    field hProc     as handle
    index iOrder_cIden iOrder cIden.


  method public static void ShowAllPersistentThings():
    
    define variable hProcDummy# as handle no-undo.
    
    ShowAllPersistentThings(hProcDummy#).
    
  end method. /* ShowAllPersistentThings */
  

  
  method public static void ShowAllPersistentThingsOverLimit(iFilesizeIP# as integer):
    
    define variable hProcDummy# as handle no-undo.
    
    ShowAllPersistentThingsOverLimit(hProcDummy#, iFilesizeIP#).
    
  end method. /* ShowAllPersistentThingsOverLimit */
  

  method public static void ShowAllPersistentThings(hProcIP# as handle):

    empty temp-table ttPersistentThings.
    
    do on error undo, throw:
      FillPersistentObjects().
    end.
    
    FillGenericInfo().
    FillPersistentProcedures().
    FillBuffers().
    FillDatasets().
    FillQueries().
    FillSourcecontrolRuntimeInfo(hProcIP#).

    ShowTempTable(0).

  end method. /* ShowAllPersistentThings */


  method public static void AllPersistentThingsToFile(hProcIP# as handle, cHtmlFileIP# as character):

    AllPersistentThingsToTt_Implement(hProcIP#, true, true).

    sc_html:TempTableToHTML(buffer ttPersistentThings:handle, cHtmlFileIP#).
    
  end method. /* AllPersistentThingsToFile */
  

  method public static void AllPersistentThingsToTt(
  
    hProcIP#                     as handle, 
    bGenericInfoIP#              as logical, 
    bSourcecontrolRuntimeInfoIP# as logical, 
    output table ttPersistentThings):

    AllPersistentThingsToTt_Implement(hProcIP#, bGenericInfoIP#, bSourcecontrolRuntimeInfoIP#).

  end method. /* AllPersistentThingsToTt */
  

  method public static void AllPersistentThingsToTt(
  
    output table ttPersistentThings):

    AllPersistentThingsToTt_Implement(?, false, false).

  end method. /* AllPersistentThingsToTt ; compact overload */
  

  method protected static void AllPersistentThingsToTt_Implement(
    hProcIP#                     as handle,
    bGenericInfoIP#              as logical, 
    bSourcecontrolRuntimeInfoIP# as logical
    ):

    empty temp-table ttPersistentThings.
    
    do on error undo, throw:
      FillPersistentObjects().
    end.
    
    if bGenericInfoIP# then
      FillGenericInfo().
      
    FillPersistentProcedures().
    FillBuffers().
    FillDatasets().
    FillQueries().
    
    if bSourcecontrolRuntimeInfoIP# then
      FillSourcecontrolRuntimeInfo(hProcIP#).

  end method. /* AllPersistentThingsToTt_Implement */


  method public static void ShowAllPersistentThingsOverLimit(hProcIP# as handle, iFilesizeIP# as integer):

    empty temp-table ttPersistentThings.
    
    do on error undo, throw:
      FillPersistentObjects().
    end.
    
    FillGenericInfo().
    FillPersistentProcedures().
    FillBuffers().
    FillDatasets().
    FillQueries().
    FillSourcecontrolRuntimeInfo(hProcIP#).

    ShowTempTable(iFilesizeIP#).

  end method. /* ShowAllPersistentThingsOverLimit */


  method public static void ShowPersistentObjects():
    
    empty temp-table ttPersistentThings.

    FillPersistentObjects().

    ShowTempTable(0).

  end method. /* ShowPersistentObjects */


  method protected static void ShowTempTable(iMinFilesizeIP# as integer):
    
    define variable cHtmlFile# as character no-undo.
    define variable bShow#     as logical   no-undo init true.
    
    &if not {&paninui_tty} &then

    cHtmlFile# = sc_path:cTempDir + subst("&1_persistent_things_&2.html", sc_date_timestamp:cTimeStamp_Short_DateAndTime, sc_environment:cSessionGuid).
      
    if sc_html:TempTableToHTML(buffer ttPersistentThings:handle, cHtmlFile#) then 
    do:
      if iMinFilesizeIP# > 0 then 
      do:
        file-info:file-name = cHtmlFile#.
        if file-info:file-size < iMinFilesizeIP# then 
        do:
          os-delete value(cHtmlFile#).
          bShow# = false.
        end. 
      end.
      if bShow# then sc_win32:ShellExecute(cHtmlFile#). /* Show HTML file */
    end.

    &else
    
    cHtmlFile# = sc_path:cLogDir + subst("&1_persistent_things_&2.html", sc_date_timestamp:cTimeStamp_Short_DateAndTime, sc_environment:cSessionGuid).
      
    if sc_html:TempTableToHTML(buffer ttPersistentThings:handle, cHtmlFile#) then do: 
      if iMinFilesizeIP# > 0 then 
      do:
        file-info:file-name = cHtmlFile#.
        if file-info:file-size < iMinFilesizeIP# then 
        do:
          os-delete value(cHtmlFile#).
          bShow# = false.
        end. 
      end.
      if bShow# then message "Open the following file yourself: " cHtmlFile#
        view-as alert-box.
    end.
        
    &endif

  end method. /* ShowTempTable */


  method protected static void FillGenericInfo():

    define variable bEclipseFix# as logical no-undo.
    define buffer ttPersistentThings for ttPersistentThings.
    
    do for ttPersistentThings on error undo, throw:
      
      create ttPersistentThings.
      assign 
        ttPersistentThings.cType        = "_session"
        ttPersistentThings.cName        = "now"
        ttPersistentThings.cPrivateData = string(now)
        .
        
      create ttPersistentThings.
      assign 
        ttPersistentThings.cType        = "_session"
        ttPersistentThings.cName        = "Process ID"
        ttPersistentThings.cPrivateData = string(panaedra.msroot.msutil.logic.sc_environment:GetProcessID())
        .
        
      create ttPersistentThings.
      assign 
        ttPersistentThings.cType        = "_session"
        ttPersistentThings.cName        = "Memory Size"
        ttPersistentThings.cPrivateData = string(panaedra.msroot.msutil.logic.sc_environment:GetProcessMemSize())
        .
        
      create ttPersistentThings.
      assign 
        ttPersistentThings.cType        = "_session"
        ttPersistentThings.cName        = "[Env]"
        ttPersistentThings.cPrivateData = sc_boot:SessionParameter("Env")
        .
        
      create ttPersistentThings.
      assign 
        ttPersistentThings.cType        = "_session"
        ttPersistentThings.cName        = "session:startup-parameters"
        ttPersistentThings.cPrivateData = session:startup-parameters
        .
        
      create ttPersistentThings.
      assign 
        ttPersistentThings.cType        = "_session"
        ttPersistentThings.cName        = "propath"
        ttPersistentThings.cPrivateData = propath
        .
        
    end.

  end method. /* FillGenericInfo */


  method protected static void FillPersistentObjects():
    
    define variable oObj#     as Progress.Lang.Object no-undo.
    define variable oObjNext# as Progress.Lang.Object no-undo.
    define buffer ttPersistentThings for ttPersistentThings.
    
    do for ttPersistentThings on error undo, throw:
      
      oObj# = session:first-object.
      
      do while valid-object(oObj#):
        oObjNext# = oObj#:next-sibling. /* Because it could in theory be deleted in the meantime */
        create ttPersistentThings.
        assign 
          ttPersistentThings.cType = "Object"
          ttPersistentThings.cName = oObj#:ToString()
          .
        oObj# = oObjNext#.
      end.
    end.
    
  end method. /* FillPersistentObjects */
  
  
  method protected static void FillPersistentProcedures():
    
    define variable hProc# as handle no-undo.
    define buffer ttPersistentThings for ttPersistentThings.
    
    do for ttPersistentThings:
      
      hProc# = session:first-procedure.
      
      do while valid-handle(hProc#):
        create ttPersistentThings.
        assign 
          ttPersistentThings.cType        = "Procedure"
          ttPersistentThings.cName        = hProc#:file-name
          ttPersistentThings.hHandle      = hProc#
          ttPersistentThings.cPrivateData = hProc#:private-data
          .
        hProc# = hProc#:next-sibling.
      end.
       
    end.
    
  end method. /* FillPersistentProcedures */


  method public static integer IsProcedurePersistent(
    input hProcIP# as character):

    define variable hProc#                  as handle  no-undo.
    define variable iProcedureIsPersistent# as integer no-undo.
    
    hProc# = session:first-procedure.
      
    b_find_proc:
    do while valid-handle(hProc#):
      if hProc#:file-name = hProcIP# then
        iProcedureIsPersistent# = iProcedureIsPersistent# + 1.

      hProc# = hProc#:next-sibling.
    end. /* do while valid */
    
    return iProcedureIsPersistent#.   
    
  end method. /* IsProcedurePersistent */
  
  
  method protected static void FillBuffers():
    
    define variable hBuff# as handle no-undo.
    define buffer ttPersistentThings for ttPersistentThings.
    
    do for ttPersistentThings:
      
      hBuff# = session:first-buffer.
      
      do while valid-handle(hBuff#):
        create ttPersistentThings.
        assign 
          ttPersistentThings.cType   = "Buffer"
          ttPersistentThings.cName   = hBuff#:name
          ttPersistentThings.hHandle = hBuff#.
        assign  
          ttPersistentThings.cPrivateData = hBuff#:private-data
          no-error.
        assign
          ttPersistentThings.cInstantiatingProc = hBuff#:instantiating-procedure:file-name no-error.
        hBuff# = hBuff#:next-sibling.
      end.
       
    end.
    
  end method. /* FillBuffers */


  method protected static void FillDatasets():
    
    define variable hDs# as handle no-undo.
    define buffer ttPersistentThings for ttPersistentThings.
    
    do for ttPersistentThings:
      
      hDs# = session:first-dataset.
      
      do while valid-handle(hDs#):
        create ttPersistentThings.
        assign 
          ttPersistentThings.cType   = "Dataset"
          ttPersistentThings.cName   = hDs#:name
          ttPersistentThings.hHandle = hDs#.
        assign  
          ttPersistentThings.cPrivateData = hDs#:private-data
          no-error.
        assign
          ttPersistentThings.cInstantiatingProc = hDs#:instantiating-procedure:file-name no-error.
        hDs# = hDs#:next-sibling.
      end.
       
    end.
    
  end method. /* FillDatasets */


  method protected static void FillQueries():
    
    define variable hQuery# as handle no-undo.
    define buffer ttPersistentThings for ttPersistentThings.
    
    do for ttPersistentThings:
      
      hQuery# = session:first-query.
      
      do while valid-handle(hQuery#):
        create ttPersistentThings.
        assign 
          ttPersistentThings.cType   = "Query"
          ttPersistentThings.cName   = hQuery#:name
          ttPersistentThings.hHandle = hQuery#.
        assign
          ttPersistentThings.cInstantiatingProc = hQuery#:instantiating-procedure:file-name no-error.
        if ttPersistentThings.cName = ? or ttPersistentThings.cName = "" then
          ttPersistentThings.cName = hQuery#:prepare-string no-error.
        if ttPersistentThings.cName = ? or ttPersistentThings.cName = "" then
          ttPersistentThings.cName = hQuery#:get-buffer-handle(1):name no-error.
        if ttPersistentThings.cName = ? or ttPersistentThings.cName = "" then
          ttPersistentThings.cName = hQuery#:get-buffer-handle(1):table no-error.
        if ttPersistentThings.cName = ? or ttPersistentThings.cName = "" then
          ttPersistentThings.cName = hQuery#:get-buffer-handle(1):table-handle:name no-error.
        if ttPersistentThings.cName = ? or ttPersistentThings.cName = "" then
          ttPersistentThings.cName = subst("Unknown query &1",(if hQuery#:is-open then ", is open" else ", is not open")).

        assign  
          ttPersistentThings.cPrivateData = hQuery#:private-data
          no-error.

        hQuery# = hQuery#:next-sibling.
        
      end.
       
    end.
    
  end method. /* FillQueries */


  method public static void FillSourcecontrolRuntimeInfo():
    
    define variable hProcDummy# as handle no-undo.
    
    FillSourcecontrolRuntimeInfo(hProcDummy#).
    
  end method. /* FillSourcecontrolRuntimeInfo */ 
  
  
  method public static void FillSourcecontrolRuntimeInfo(hProcOndeIP# as handle):

    define variable iTell#       as integer   no-undo.
    define variable iOrder#      as integer   no-undo.
    define variable cDvcs_ProcEntry#      as character no-undo.
    define variable bDebugAlert# as logical   no-undo view-as fill-in format "Y/N" label "Debug-alert".
    define variable hProcAll#    as handle    no-undo.
    
    empty temp-table ttSourceControl.
    
    if hProcOndeIP# <> ? then 
    do:

      do iTell# = 1 to num-entries(hProcOndeIP#:internal-entries):
        cDvcs_ProcEntry# = entry(iTell#,hProcOndeIP#:internal-entries).
        if cDvcs_ProcEntry# begins "dvcs__" then 
        do:
          run value(cDvcs_ProcEntry#) in hProcOndeIP# no-error.
          create ttSourceControl.
          ttSourceControl.hProc     = hProcOndeIP#.
          ttSourceControl.cFileName = hProcOndeIP#:file-name.
          ttSourceControl.cIden     = cDvcs_ProcEntry#.
          ttSourceControl.iVersion  = int(trim(entry(2,return-value,":")," $")) no-error.
          release ttSourceControl.
        end.
      end.

      if not can-find(first ttSourceControl) then 
      do:
        create ttSourceControl.
        assign 
          ttSourceControl.hProc     = hProcOndeIP#
          ttSourceControl.cFileName = hProcOndeIP#:file-name
          ttSourceControl.iVersion  = 0.
        release ttSourceControl.
      end.
    
    end.

    hProcAll# = session:first-procedure.

    do while valid-handle(hProcAll#):
      do iTell# = 1 to num-entries(hProcAll#:internal-entries):
        cDvcs_ProcEntry# = entry(iTell#,hProcAll#:internal-entries).
        if cDvcs_ProcEntry# begins "dvcs__" then 
        do:
          iOrder# = iOrder# + 1.
          run value(cDvcs_ProcEntry#) in hProcAll# no-error.
          create ttSourceControl.
          ttSourceControl.hProc     = hProcAll#.
          ttSourceControl.cFileName = hProcAll#:file-name.
          ttSourceControl.cIden     = cDvcs_ProcEntry#.
          ttSourceControl.iOrder    = iOrder#.
          ttSourceControl.iVersion  = int(trim(entry(2,return-value,":")," $")) no-error.
          release ttSourceControl.
        end.
      end.
      hProcAll# = hProcAll#:next-sibling.
    end.
    
    for each ttSourceControl on error undo, throw:

      create ttPersistentThings.
      assign 
        ttPersistentThings.cType        = "SourceControl"
        ttPersistentThings.hHandle      = ttSourceControl.hProc
        ttPersistentThings.cName        = ttSourceControl.cFileName
        ttPersistentThings.cPrivateData = ttSourceControl.cIden
        ttPersistentThings.iVersion     = ttSourceControl.iVersion
        .
  
    end.

  end method. /* FillSourcecontrolRuntimeInfo */  

end class.

/* EOF */ 
