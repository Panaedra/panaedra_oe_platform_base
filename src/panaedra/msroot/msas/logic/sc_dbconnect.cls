{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
    
class panaedra.msroot.msas.logic.sc_dbconnect: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msas/logic/sc_dbconnect.cls $ 
          Version: $Revision: 6 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:17+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:45:54+01:00 $ 

      Description: Connect to database(s) (also for appservers) 

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_dbconnect(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 6 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static temp-table ttDbConnect no-undo rcode-info
    field cEnv      as char xml-node-type "attribute"
    field cHostname as char xml-node-type "attribute" /* First look for specific hostname, secondly for empty hostname */
    field cConnect  as char xml-node-type "attribute"
    index cEnv_cHostname is primary unique cEnv cHostname
    .

  method public static void ConnectExtraDbs():
    ConnectExtraDbs_Implement().     
    SetAliases().       
  end method. /* ConnectExtraDbs */


  method protected static void ConnectExtraDbs_Implement():

    define variable cExtraDbs# as character no-undo.

    cExtraDbs# = sc_boot:SessionParameter("ExtraDbs").

    if cExtraDbs# > "" then 
      ConnectValue(cExtraDbs#) .
    
  end method. /* ConnectExtraDbs_Implement */


  method protected static void ConnectValue(cConnectIP# as character):

    connect value(cConnectIP#) no-error.
    
    if error-status:num-messages > 0 then
      undo, throw new c_panaedraexception(
        95001267,
        sc_lang:oEnglish,
        subst("DB connect error: &1~n(&2)", error-status:get-message(1), cConnectIP#)
        ).
        
  end method. /* ConnectValue */
  
  
  method public static void SetAliases():
 
    def var cDbLd#     as char no-undo.
    def var iTell#     as int  no-undo.
    def var cAliasDbs# as char no-undo.
    def var cMasterDb# as char no-undo.
  
    /* Compatibility for special cases like _CMPNY_ xref viewer.
       
     */
   
    cMasterDb# = sc_prop:GetSharedVar("Aliases","MasterDb") no-error.
   
    /* no-error: static classes, supers.. */
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
      "for each _File where " + /* codeQok#7105  */
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
    def var iTell#     as int  no-undo.
  
    /* no-error: supers (old style) not running. */
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
