{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
    
class panaedra.msroot.msas.logic.sc_dbconnect: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msas/logic/sc_dbconnect.cls $ 
          Version: $Revision: 5 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-11-06 14:50:49+01:00 $ 
    Date Modified: $Modtime: 2009-11-06 13:57:16+01:00 $ 

      Description: Connect to database(s) (for appserver)

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_dbconnect(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 5 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  def protected static temp-table ttDbConnect no-undo rcode-info
    field cEnv      as char xml-node-type "attribute"
    field cHostname as char xml-node-type "attribute" /* We zoeken eerst naar specifieke hostname, daarna naar blanco hostname */
    field cConnect  as char xml-node-type "attribute"
    index cEnv_cHostname is primary unique cEnv cHostname
    .
    
  method public static void connect_ma_lo():
    
    define variable cEnv#      as character no-undo.
    define variable cHostName# as character no-undo.
    define variable cExtraDbs# as character no-undo.
    
    if not can-find(first ttDbConnect)
      then temp-table ttDbConnect:read-xml("file", panaedra.msf.logic.sc_path:cIniDir + "sc_dbconnect.config", "empty", ?, false).
    
    /* Als er nog geen database verbinding is ... */
    if not connected("ma") and not connected("lo") then 
    do:
      
      cEnv#      = panaedra.msb.logic.sc_boot:SessionParameter("Env").      
      cHostName# = panaedra.msb.logic.sc_environment:GetHostName().
      cExtraDbs# = panaedra.msb.logic.sc_boot:SessionParameter("ExtraDbs").
      
      
      /* Zoek voor record met hostname _SRVR_ of _PRODUCT_ */
      find ttDbConnect 
        where ttDbConnect.cEnv      = cEnv#
        and   ttDbConnect.cHostname = cHostName#
        no-error.
    
      /* Als er geen record gevonden is zoek dan voor record met hostname "" */
      if not available ttDbConnect then
      do:
        find ttDbConnect 
          where ttDbConnect.cEnv      = cEnv#
          and   ttDbConnect.cHostname = ""
          no-error.
      end.  
        
      /* Als er een record gevonden is ... */
      if available ttDbConnect then
      do:
        connect value(ttDbConnect.cConnect). /* In principe: adm en log (en zonodig andere db's) */
      end.  
      
      if cExtraDbs# > "" then 
        connect value(cExtraDbs#).
        
      SetAliases().  
     
    end. /* Connected */
    
  end method. /* connect_ma_lo */
  
  
  method public static void SetAliases():
 
    def var cDbLd#     as char no-undo.
    def var iTell#     as int   no-undo.
    def var cAliasDbs# as char no-undo.
    def var cMasterDb# as char no-undo.
  
    /* Deze shared vars zullen only in speciale gevallen
       gevuld zijn, bv vanuit de _CMPNY_ xref viewer.
       Normale sessies: AliasDbs = leeg, MasterDb = "ma"
     */
   
    cMasterDb# = sc_prop:GetSharedVar("Aliases","MasterDb") no-error.
   
    /* no-error: supers wellicht nog niet in de lucht. */
    cAliasDbs# =  sc_prop:GetSharedVar("Aliases","AliasDbs") no-error.
    if cAliasDbs# = ? then cAliasDbs# = "".
  
    _sys_DbAliases().
  
    do iTell# = 1 to num-dbs:
      if cAliasDbs# = "" or can-do(cAliasDbs#,ldbname(iTell#))
        then 
      do:
        _sys_createTableAliases(ldbname(iTell#)).
      end.
    end.
  
  end method. /* SetAliases */


  method public static void _sys_CreateTableAliases(cDbIP# as char):
 
    /* Create all <table>.<table> aliases
    */
  
    def var hBuff# as handle no-undo.
    def var hQuer# as handle no-undo.
 
    create buffer hBuff# for table subst("&1._File",cDbIP#).
    create query hQuer#.
    hQuer#:set-buffers(hBuff#).
    hQuer#:query-prepare(
      "for each _File where " +
      "not _File._Hidden and " +
      "not _File._File-Name begins 'sys'").
    hQuer#:query-open.
    hQuer#:get-first(). 
  
    do while hBuff#:available:
      delete alias value(hBuff#:buffer-field("_File-Name"):buffer-value).
      create alias value(hBuff#:buffer-field("_File-Name"):buffer-value) 
        for database value(cDbIP#).
      hQuer#:get-next().
    end. 
  
    delete object hQuer#.
    delete object hBuff#.

  end method. /* _sys_CreateTableAliases */


  method public static void  _sys_DbAliases():

    /* 1) Create database aliases for databases 
       that have been merged into the master 
       database.
       2) Create generic per-db aliases
    */
  
    def var cMasterDb# as char no-undo.
    def var iTell#     as int   no-undo.
  
    /* no-error: supers wellicht nog niet in de lucht. */
    cMasterDb# = sc_prop:GetSharedVar("Aliases","MasterDb") no-error.
  
    if cMasterDb# > "" and connected(cMasterDb#) then 
    do:
   
      delete alias db-lock.
      create alias db-lock 
        for database value(cMasterDb#).
    
    end.

  end method. /* _sys_DbAliases */

  
end class.

/* EOF */

