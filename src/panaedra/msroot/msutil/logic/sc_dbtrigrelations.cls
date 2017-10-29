using panaedra.msroot.msdr.logic.*.
using panaedra.msroot.msdr.interfaces.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i}

class panaedra.msroot.msutil.logic.sc_dbtrigrelations: 

  /****************************** Source Header ********************************\

      Description: Read xml file's *.datarel_xml, for db or temp-table triggers.
                   Data is always cached after first read for fast performance.

  \*****************************  Include Files ********************************/
  {panaedra/msroot/msutil/logic/tt/sc_dbtrigrelations_tt.i &class=class &protected=protected &static=static}
  /******************************* $NoKeywords:  $ *****************************/
  
  define static buffer b-glob-ttMsdrDbtrigTables    for ttMsdrDbtrigTables.
  define static buffer b-glob-ttMsdrDbtrigRelations for ttMsdrDbtrigRelations.
  
  define protected static temp-table ttCacheLoadedModules no-undo rcode-information
    field cModule as char
    index cModule is primary unique cModule
    .  
  
  method public static void GetDbtrigRelations(hBuffTableInfoIP# as handle, output hBuffTtMsdrDbtrigTablesOP# as handle, output hBuffTtMsdrDbtrigRelationsOP# as handle):
  
    /* Is used by delete triggers, can also be used client-side by datasets/temp-tables. */
    
    define variable cNsGroupdir# as character no-undo.
    define variable cFileName#   as character no-undo.
    
    define buffer b-ttMsdrDbtrigTables     for ttMsdrDbtrigTables.
    define buffer b-ttMsdrTriggerLink      for ttMsdrTriggerLink.
    define buffer b-done-ttMsdrTriggerLink for ttMsdrTriggerLink.
    define buffer b-ttCacheLoadedModules   for ttCacheLoadedModules.
    
    if not can-find(first b-ttMsdrDbtrigTables) then 
    do:
      /* sc_dbtrigrelations.datarel_xml is the central (override-)storage for datarelations. Normally empty. */
      sc_config:ReadXml(dataset dsDbRelations:handle, "panaedra/msroot/msutil/logic_val/cfg/sc_dbtrigrelations.datarel_xml").
    end.
    
    cNsGroupdir# = hBuffTableInfoIP#::cNsGroupdir. 

    if not can-find(first b-ttMsdrDbtrigTables where b-ttMsdrDbtrigTables.cModule = cNsGroupdir#) then 
    do:
      find first b-ttCacheLoadedModules where b-ttCacheLoadedModules.cModule = cNsGroupdir# no-error.
      if not avail b-ttCacheLoadedModules then 
      do:
        create b-ttCacheLoadedModules.
        assign 
          b-ttCacheLoadedModules.cModule = cNsGroupdir#.
        release b-ttCacheLoadedModules.
        
        cFileName# = lc("panaedra/" 
          + (if hBuffTableInfoIP#::cNsSubroot = "(none)" then "" else hBuffTableInfoIP#::cNsSubroot + "/") 
          + hBuffTableInfoIP#::cNsGroupdir + "/logic_val/cfg/"
          + substitute("&1.&2.datarel_xml", hBuffTableInfoIP#::cNsKey, cNsGroupdir#))
          .

        sc_config:ReadXml(dataset dsDbRelations:handle,cFileName#, "append").
          
        /* This do while is needed, because within the preselect, 
           new records can be created. 
           Circular recursion *is* allowed in datarel_xml files,
           this construction prevents infinite loops.
        */
        do while can-find(first b-ttMsdrTriggerLink where b-ttMsdrTriggerLink.bHandled = false):
        
          repeat preselect each b-ttMsdrTriggerLink where b-ttMsdrTriggerLink.bHandled = false
            on error undo, throw:
            
            find next b-ttMsdrTriggerLink.
          
            if can-find(
              first b-done-ttMsdrTriggerLink where b-done-ttMsdrTriggerLink.bHandled = true
              and b-done-ttMsdrTriggerLink.cPath = b-ttMsdrTriggerLink.cPath)
              then /* File is already read through a previous triggerlink */ delete b-ttMsdrTriggerLink.
            else 
            do:
          
              /* A triggerlink means the datarelation file is dependent on another datarelation file.
                 Read it in. 
               */
              assign
                b-ttMsdrTriggerLink.bHandled = true
                file-information:file-name   = b-ttMsdrTriggerLink.cPath.
                
              sc_config:ReadXml(dataset dsDbRelations:handle, lc(b-ttMsdrTriggerLink.cPath), "append").  
          
            end.
            
          end. /* repeat preselect */
          
        end. /* do while */
        
      end.
    end.
    
    hBuffTtMsdrDbtrigTablesOP#    = buffer b-glob-ttMsdrDbtrigTables:handle.
    hBuffTtMsdrDbtrigRelationsOP# = buffer b-glob-ttMsdrDbtrigRelations:handle.

  end method. /* GetDbtrigRelations */


  method public static void DebugShowData():
    
    if sc_html:TempTableToHTML(
      buffer ttMsdrDbtrigTables:handle, 
      sc_path:cTempDir + "ttMsdrDbtrigTables.html") 
      then 
      sc_win32:ShellExecute(sc_path:cTempDir + "ttMsdrDbtrigTables.html").  
      
    if sc_html:TempTableToHTML(
      buffer ttMsdrDbtrigRelations:handle, 
      sc_path:cTempDir + "ttMsdrDbtrigRelations.html") 
      then 
      sc_win32:ShellExecute(sc_path:cTempDir + "ttMsdrDbtrigRelations.html").  
      
  end method. /* DebugShowData */

end class.

/* EOF */ 
