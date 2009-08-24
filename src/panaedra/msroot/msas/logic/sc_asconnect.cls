{panaedra/msi/logic/ctop_class.i}

class panaedra.msb.logic.sc_asconnect : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msb/logic/sc_asconnect.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-08-24 08:56:30+02:00 $ 
    Date Modified: $Modtime: 2009-08-24 08:56:19+02:00 $ 

      Description: Methods aan te roepen vanaf de client om een 
                   appserver connectie te maken.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_asconnect(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  
  def protected static temp-table ttAsConnect no-undo rcode-info
    field cEnv       as char   xml-node-type "attribute"
    field cMirror    as char   xml-node-type "attribute"
    field cConnect   as char   xml-node-type "attribute"
    field hAppserver as handle xml-node-type "hidden"
    index cEnv_cMirror is primary unique cEnv cMirror
    .
  
  define protected static variable bInitialized as logical no-undo.
  
  method public static void Initialize():
    temp-table ttAsConnect:read-xml("file", tool.sc-path:cIniDir + "sc-asconnect.config", "empty", ?, false).
  end method.


  method public static logical ConnectToServer(cMirrorIP# as char /* Leeg = default */ ):
    
    define variable cEnv# as character no-undo.
    
    if not bInitialized then 
    do:
      bInitialized = yes.
      Initialize().
    end.
    
    cEnv# = dynamic-function("SessionParameter","Env").

    find ttAsConnect where ttAsConnect.cEnv = cEnv#
      and ttAsConnect.cMirror = cMirrorIP#
      no-error.
    
    if avail ttAsConnect then 
    do:
      if not valid-handle(ttAsConnect.hAppserver) or (ttAsConnect.hAppserver = session:handle) or not ttAsConnect.hAppserver:connected() then 
      do:
        create server ttAsConnect.hAppserver.
        ttAsConnect.hAppserver:connect(ttAsConnect.cConnect) no-error.  
        if error-status:num-messages = 0 and valid-handle(ttAsConnect.hAppserver) and ttAsConnect.hAppserver:connected() then 
          return true.
      end.    
    end.
    
    return false.
    
  end method. 


  method public static handle GetAppServer(input cMirrorIP# as char):
    /* This method returns an appserverhandle of the default appserver (cMirrorIP# = empty) or 
       a mirror appserver.
    */
    define variable hReturn# as handle    no-undo.
    define variable cEnv#    as character no-undo.
    
    if not bInitialized then 
    do:
      bInitialized = yes.
      Initialize().
    end.
    
    cEnv# = dynamic-function("SessionParameter","Env").

    find ttAsConnect where ttAsConnect.cEnv = cEnv#
      and ttAsConnect.cMirror = cMirrorIP#
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
  
end class.
