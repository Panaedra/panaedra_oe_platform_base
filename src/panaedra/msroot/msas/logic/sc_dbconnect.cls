{panaedra/msi/logic/ctop_class.i} 
    
class panaedra.msroot.msas.logic.sc_dbconnect: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msas/logic/sc_dbconnect.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-01 10:45:25+02:00 $ 
    Date Modified: $Modtime: 2009-09-30 16:12:05+02:00 $ 

      Description: Connect to database(s) (for appserver)

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_dbconnect(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
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
    
    if not can-find(first ttDbConnect)
      then temp-table ttDbConnect:read-xml("file", panaedra.msf.logic.sc_path:cIniDir + "sc-dbconnect.config", "empty", ?, false).
    
    /* Als er nog geen database verbinding is ... */
    if not connected("ma") and not connected("lo") then 
    do:
      
      cEnv#      = panaedra.msb.logic.sc_boot:SessionParameter("Env").      
      cHostName# = panaedra.msb.logic.sc_environment:GetHostName().
      
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
     
    end. /* Connected */
  end method. /* connect_ma_lo */
  

end class.

/* EOF */

