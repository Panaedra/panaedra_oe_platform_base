{panaedra/msi/logic/ctop_class.i}

using panaedra.msb.logic.*.
using panaedra.msf.logic.*.

class panaedra.msdr.logic.sc_dbtrigrelations   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msdr/logic/sc_dbtrigrelations.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-08-07 21:22:38+02:00 $ 
    Date Modified: $Modtime: 2009-08-07 21:22:38+02:00 $ 

      Description: Ophalen van dbtrigrelations temp-table, voor db of temp-table triggers.
                   Wordt altijd gecached tbv performance.

  \*****************************  Include Files ********************************/
  
  {panaedra/msdr/logic/sc_dbtrigrelations_tt.i &class=class &protected=protected &static=static}
  
  /************************  Source control constructor ************************/
  constructor public sc_dbtrigrelations(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  def static buffer b-glob-ttMsdrDbtrigTables    for ttMsdrDbtrigTables.
  def static buffer b-glob-ttMsdrDbtrigRelations for ttMsdrDbtrigRelations.
  
  define protected static temp-table ttCacheLoadedModules no-undo rcode-information
    field cModule as char
    index cModule is primary unique cModule
    .  
  
  method public static void GetDbtrigRelations (cTableIP# as character, output hBuffTtMsdrDbtrigTablesOP# as handle, output hBuffTtMsdrDbtrigRelationsOP# as handle):
  
    /* Wordt gebruikt door delete triggers, maar kan ook client-side voor datasets/temp-tables worden gebruikt */
    
    define variable cModule# as character no-undo.
    
    if not can-find(first ttMsdrDbtrigTables) then 
    do:
      /* Voorlopig doen we het enkel en only uit een xml file.
         Kan later ook uit de database (indien op de db layer). */
      dataset dsDbRelations:read-xml("file", sc_path:cIniDir + "sc_dbtrigrelations.config", "empty", ?, false). 
    end.
    
    cModule# = lc(substring(cTableIP#,1,2)). 

    if not can-find(first ttMsdrDbtrigTables where ttMsdrDbtrigTables.cModule = cModule#) then 
    do:
      find first ttCacheLoadedModules where ttCacheLoadedModules.cModule = cModule# no-error.
      if not avail ttCacheLoadedModules then 
      do:
        create ttCacheLoadedModules.
        assign 
          ttCacheLoadedModules.cModule = cModule#.
        if search(sc_path:cIniDir + subst("sc_dbtrigrelations_&1.config",cModule#)) <> ? then 
        do:
          dataset dsDbRelations:read-xml("file", sc_path:cIniDir + subst("sc_dbtrigrelations_&1.config",cModule#), "append", ?, false). 
        end.
      end.
    end.
    
    hBuffTtMsdrDbtrigTablesOP#    = buffer b-glob-ttMsdrDbtrigTables:handle.
    hBuffTtMsdrDbtrigRelationsOP# = buffer b-glob-ttMsdrDbtrigRelations:handle.

  end method. /* GetDbtrigRelations */

  

end class.

/* EOF */ 
