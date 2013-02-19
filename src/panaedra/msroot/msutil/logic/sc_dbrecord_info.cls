using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 




class panaedra.msroot.msutil.logic.sc_dbrecord_info: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: info about (locked) records

  \*****************************  Include Files ********************************/

  {panaedra/msroot/msutil/logic/tt/sc_dbrecord_info_lock.i &class=class &static=static}

  /************************  Source control constructor ************************/
  constructor public sc_dbrecord_info(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  
  method public static void GetLockingInfo(
    /* -----------------------------------------------------------
       Get more info about who keeps a record locked.
       hBufferIP# needs to be a record found by NO-LOCK
       http://knowledgebase.progress.com/%61rticles/%41rticle/19136
       ----------------------------------------------------------- */
    input hBufferIP#  as handle,
    output cNameOP#   as character,
    output cPidOP#    as character,
    output cDeviceOP# as character
    ):
      
    define variable iDb# as integer no-undo.
    
    do iDb# = 1 to num-dbs:
      GetLockingInfo(
        input ldbname(iDb#),
        input hBufferIP#,
        output cNameOP#,
        output cPidOP#,
        output cDeviceOP#).      
      if cPidOP# > "" then leave.
    end. 

  end method.  /* GetLockingInfo */
  
  
  method public static void GetLockingInfo(
    /* -----------------------------------------------------------
       Get more info about who keeps a record locked.
       hBufferIP# needs to be a record found by NO-LOCK
       http://knowledgebase.progress.com/%61rticles/%41rticle/19136
       ----------------------------------------------------------- */
    input cDbIP#      as character,
    input hBufferIP#  as handle,
    output cNameOP#   as character,
    output cPidOP#    as character,
    output cDeviceOP# as character
    ):
      
    define variable iFileNum#  as integer no-undo.
   
    define variable hLockBuff# as handle  no-undo.
    define variable hQuery#    as handle  no-undo.
    define variable iRecid#    as recid   no-undo.
   
    create buffer hLockBuff# for table subst("&1._lock", cDbIP#). 
    create query hQuery#.
   
    if hQuery#:set-buffers(hLockBuff#)
      and hQuery#:query-prepare(subst("for each &1._lock no-lock", cDbIP#))
      and hQuery#:query-open()
      and hQuery#:get-first()
      then 
    do:  
      repeat while (not hQuery#:query-off-end and hLockBuff#::_lock-recid <> ?) on error undo, throw:
        
        if hLockBuff#::_lock-recid = hBufferIP#:recid and
          hLockBuff#::_lock-table = hBufferIP#:table-number and
          hLockBuff#::_lock-flags matches "*X*" 
          then leave.
  
        hQuery#:get-next().
        
      end. /* repeat */  
    end. /* do */

    if hLockBuff#:available and hLockBuff#::_lock-recid <> ? then 
    do:
      GetUserInfo(
        cDbIP#, 
        hLockBuff#::_lock-usr, 
        output cNameOP#,
        output cPidOP#,
        output cDeviceOP#
        ).
    end.
   
    finally:
      
      if valid-handle(hQuery#) then
        delete object hQuery#.
      if valid-handle(hLockBuff#) then	
        delete object hLockBuff#.
        
    end finally.   
  
  end method. /* GetLockingInfo */
  
  
  method protected static void GetUserInfo(
    /* -----------------------------------------------------------
       returns info about a user connection to a progress database
       ----------------------------------------------------------- */
    input cDbIP#      as character,
    input iUseridIP#  as integer,
    output cNameOP#   as character,
    output cPidOP#    as character,
    output cDeviceOP# as character
    ):
    
    define variable hBuffer# as handle no-undo.
    define variable hQuery#  as handle no-undo.
    
    create buffer hBuffer# for table subst("&1._connect", cDbIP#).
    create query hQuery#.
    
    if hQuery#:set-buffers(hBuffer#)
      and hQuery#:query-prepare(subst("for each &1._connect where &1._connect._connect-usr = &2 no-lock", cDbIP#, iUseridIP#))
      and hQuery#:query-open()
      and hQuery#:get-first()
      then 
    do:
      assign 
        cNameOP#   = hBuffer#::_connect-name
        cPidOP#    = hBuffer#::_connect-pid
        cDeviceOP# = hBuffer#::_connect-device.
    end.
  
    finally:
      
      if valid-handle(hBuffer#) then  
        delete object hBuffer#.	
      if valid-handle(hQuery#) then  
        delete object hQuery#. 
        
    end finally.
  
  end method. /* GetUserInfo */
  
  
  method protected static void GetTableInfo(
    /* -----------------------------------------------------------
       returns info about table in a progress database
       ----------------------------------------------------------- */
    input cDbIP#      as character,
    input iFileNoIP#  as integer,
    output cNameOP#   as character
    ):
    
    define variable hBuffer# as handle no-undo.
    define variable hQuery#  as handle no-undo.
    
    create buffer hBuffer# for table subst("&1._file", cDbIP#).
    create query hQuery#.
    
    if hQuery#:set-buffers(hBuffer#)
      and hQuery#:query-prepare(subst("for each &1._file where &1._file._file-number = &2 no-lock", cDbIP#, iFileNoIP#))
      and hQuery#:query-open()
      and hQuery#:get-first()
      then 
    do:
      assign 
        cNameOP# = hBuffer#::_File-Name.
    end.
  
    finally:
      
      if valid-handle(hBuffer#) then  
        delete object hBuffer#. 
      if valid-handle(hQuery#) then  
        delete object hQuery#. 
        
    end finally.
  
  end method. /* GetTableInfo */


  method protected static void GetConnectionInfo(
    /* -----------------------------------------------------------
       returns info about connection to a progress database
       ----------------------------------------------------------- */
    input cDbIP#      as character,
    input iUserNoIP#  as integer,
    output cDeviceOP#   as character
    ):
    
    define variable hBuffer# as handle no-undo.
    define variable hQuery#  as handle no-undo.
    
    create buffer hBuffer# for table subst("&1._connect", cDbIP#).
    create query hQuery#.
    
    if hQuery#:set-buffers(hBuffer#)
      and hQuery#:query-prepare(subst("for each &1._connect where &1._connect._connect-usr = &2 no-lock", cDbIP#, iUserNoIP#))
      and hQuery#:query-open()
      and hQuery#:get-first()
      then 
    do:
      assign 
        cDeviceOP# = hBuffer#::_connect-device.
    end.
  
    finally:
      
      if valid-handle(hBuffer#) then  
        delete object hBuffer#. 
      if valid-handle(hQuery#) then  
        delete object hQuery#. 
        
    end finally.
  
  end method. /* GetConnectionInfo */
  
  
  method protected static void GetTransactionInfo(
    /* -----------------------------------------------------------
       returns info about transactions to a progress database
       ----------------------------------------------------------- */
    input cDbIP#                as character,
    input iUserNoIP#            as integer,
    output iTransactionNumOP#   as integer
    ):
    
    define variable hBuffer# as handle no-undo.
    define variable hQuery#  as handle no-undo.
    
    create buffer hBuffer# for table subst("&1._trans", cDbIP#).
    create query hQuery#.
    
    if hQuery#:set-buffers(hBuffer#)
      and hQuery#:query-prepare(subst("for each &1._trans where  &1._trans._trans-usrnum = &2 and &1._trans._trans-state <> ? no-lock", cDbIP#, iUserNoIP#))
      and hQuery#:query-open()
      and hQuery#:get-first()
      then 
    do:
      assign 
        iTransactionNumOP# = hBuffer#::_trans-num.
    end.
  
    finally:
      
      if valid-handle(hBuffer#) then  
        delete object hBuffer#. 
      if valid-handle(hQuery#) then  
        delete object hQuery#. 
        
    end finally.
  
  end method. /* GetTransactionInfo */
  
  
  method public static void GetAllRecordLockInfo(
    /* -----------------------------------------------------------
       returns a temp-table with info about all record locks 
       for all connected databases, using vst tables
       ----------------------------------------------------------- */
    output table for ttLock /* by-reference */
    ):
      
    define variable iDb#     as integer no-undo.
    define variable hBuffer# as handle  no-undo.
    define variable hQuery#  as handle  no-undo.  
    define variable iIdLock# as int64   no-undo.
    
    empty temp-table ttLock.

    do iDb# = 1 to num-dbs on error undo, throw:
      
      
      create query hQuery#.
      create buffer hBuffer# for table subst("&1._Lock", ldbname(iDb#)).
      
      if hQuery#:add-buffer(hBuffer#)
        and hQuery#:query-prepare(subst("for each &1._Lock no-lock", ldbname(iDb#)))
        and hQuery#:query-open()
        and hQuery#:get-first()
        then 
      do while (not hQuery#:query-off-end and hBuffer#::_Lock-Usr <> ? ) :
        
        create ttLock.
        assign
          iIdLock# = iIdLock# + 1
          ttLock.iIDLock    = iIdLock#
          ttLock.cDb        = ldbname(iDb#)
          ttLock.iLockId    = hBuffer#::_Lock-Id
          ttLock.iLockUsr   = hBuffer#::_Lock-Usr
          ttLock.cLockName  = hBuffer#::_Lock-Name
          ttLock.iLockTable = hBuffer#::_Lock-Table
          ttLock.dtmSince   = now
          .
          
        ttLock.cSince     = sc_datetime:GetTimeHH_FCMPNY_S(ttLock.dtmSince).
          
        GetTableInfo(ldbname(iDb#), ttLock.iLockTable, output ttLock.cTableName).
        GetConnectionInfo(ldbname(iDb#), ttLock.iLockUsr, output ttLock.cDevice).
        GetTransactionInfo(ldbname(iDb#), ttLock.iLockUsr, output ttLock.iTransactionNum).
        ttLock.cWhoInfo  = sc_environment:GetWorkstationDescription(ttLock.cDevice). 
          
        hQuery#:get-next().
      end.
      
      finally:
        if valid-handle(hQuery#) then
          delete object hQuery#.
        if valid-handle(hBuffer#) then
          delete object hBuffer#.	
      end finally.
      
    end. /* do iDb# .... */   
  
  end method. /* GetAllRecordLockInfo */
  
end class.

/* EOF */ 
