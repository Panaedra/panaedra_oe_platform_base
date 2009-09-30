{panaedra/msi/logic/ctop_class.i}

class panaedra.msb.logic.sc_asconnect : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msb/logic/sc_asconnect.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-30 12:21:44+02:00 $ 
    Date Modified: $Modtime: 2009-09-30 12:17:26+02:00 $ 

      Description: Methods aan te roepen vanaf de client om een 
                   appserver connectie te maken.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_asconnect(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  
  def protected static temp-table ttAsConnect no-undo rcode-info
    field cEnv       as char xml-node-type "attribute"
    field cMirror    as char xml-node-type "attribute"
    field cSuffix    as char xml-node-type "attribute"
    field cConnect   as char xml-node-type "attribute"
    field hAppserver as handle    xml-node-type "hidden"
    index cEnv_cMirror is primary unique cEnv cMirror cSuffix
    .
  
  define protected static variable bInitialized as logical no-undo.
  
  method public static void Initialize():
    temp-table ttAsConnect:read-xml("file", tool.sc-path:cIniDir + "sc-asconnect.config", "empty", ?, false).
  end method.


  method public static logical ConnectToServer(cMirrorIP# as char /* Leeg = default */ ):
    
    define variable cEnv#    as character no-undo.
    define variable cSuffix# as character no-undo.
    
    if not bInitialized then 
    do:
      bInitialized = yes.
      Initialize().
    end.
    
    cEnv#    = panaedra.msb.logic.sc_boot:SessionParameter("Env").
    cSuffix# = GetSuffix().
    
    find ttAsConnect where ttAsConnect.cEnv = cEnv#
      and ttAsConnect.cMirror = cMirrorIP#
      and ttAsConnect.cSuffix = cSuffix#
      no-error.
    
    if avail ttAsConnect then 
    do:
      if not valid-handle(ttAsConnect.hAppserver) or (ttAsConnect.hAppserver = session:handle) or not ttAsConnect.hAppserver:connected() then 
      do:
        /* Als er inline gerunned moet worden voor b.v. debuggen */
        if ttAsConnect.cConnect = "[session:handle]" then
        do:
          ttAsConnect.hAppserver = session:handle.
          return true.
        end.
        /* Normale appserver connect */  
        else
        do:
          create server ttAsConnect.hAppserver.
          ttAsConnect.hAppserver:connect(ttAsConnect.cConnect) no-error.
          
          if error-status:num-messages = 0 and valid-handle(ttAsConnect.hAppserver) and ttAsConnect.hAppserver:connected() then 
            return true.
        end. /* else do */ 
      end. /* if not valid handle */    
    end. /* if avail ttAsConnect */
    
    return false.
    
  end method. 


  method public static handle GetAppServer(input cMirrorIP# as char):
    /* This method returns an appserverhandle of the default appserver (cMirrorIP# = empty) or 
       a mirror appserver.
    */
    define variable hReturn# as handle    no-undo.
    define variable cEnv#    as character no-undo.
    define variable cSuffix# as character no-undo.
    
    if not bInitialized then 
    do:
      bInitialized = yes.
      Initialize().
    end.
    
    cEnv#    = panaedra.msb.logic.sc_boot:SessionParameter("Env").
    cSuffix# = GetSuffix().

    find ttAsConnect where ttAsConnect.cEnv = cEnv#
      and ttAsConnect.cMirror = cMirrorIP#
      and ttAsConnect.cSuffix = cSuffix#
      no-error.
        
    if avail ttAsConnect then 
    do:
      if not valid-handle(ttAsConnect.hAppserver) or not ttAsConnect.hAppserver:connected() then 
      do:
        ConnectToServer(cMirrorIP#).
      end.    
      hReturn# = ttAsConnect.hAppserver.
    end.
    
    return hReturn#.

  end method.
  
  
  method protected static char GetSuffix ():
    
    define variable cSuffix# as character no-undo.
    define variable iEntry#  as integer   no-undo.
    define variable cEntry#  as character no-undo.   
       
    cSuffix# = panaedra.msb.logic.sc_boot:SessionParameter("AsMode").
    
    do iEntry# = 1 to num-entries(cSuffix#, ";"):
      cEntry# = entry(iEntry#, cSuffix#, ";").
  
      if cEntry# matches "*suffix*" then 
      do:
        cSuffix# = entry(2, cSuffix#, "="). 
      end.
    end. /* iTell# = 1 to num-entries(cSuffix#) */ 
    
    if cSuffix# = ? then
      cSuffix# = "".
    
    return cSuffix#.

  end method. /* getSuffix */  
  
end class.
