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
    input  hBufferIP#           as handle,
    output cConnectNameOP#      as character,
    output iPidOP#              as integer,
    output cDeviceOP#           as character
    ):
      
    define variable iDb# as integer no-undo.
    
    do iDb# = 1 to num-dbs:
      GetLockingInfo(
        input ldbname(iDb#),
        input hBufferIP#,
        output cConnectNameOP#,
        output iPidOP#,
        output cDeviceOP#).      
      if iPidOP# > 0 then leave.
    end. 

  end method.  /* GetLockingInfo */
  
  
  method public static void GetLockingInfo(
    /* -----------------------------------------------------------
       Get more info about who keeps a record locked.
       hBufferIP# needs to be a record found by NO-LOCK
       http://knowledgebase.progress.com/%61rticles/%41rticle/19136
       ----------------------------------------------------------- */
    input  cDbIP#               as character,
    input  hBufferIP#           as handle,
    output cConnectNameOP#      as character,
    output iPidOP#              as integer,
    output cDeviceOP#           as character
    ):
         
    define variable hLockBuff# as handle  no-undo.
    define variable hQuery#    as handle  no-undo.
   
    create buffer hLockBuff# for table subst("&1._Lock", cDbIP#). 
    create query hQuery#.
   
    if hQuery#:set-buffers(hLockBuff#)
      and hQuery#:query-prepare("for each _Lock no-lock where _lock-recid <> ?")
      and hQuery#:query-open()
      and hQuery#:get-first()
      then 
    do: 
       
      repeat while (not hQuery#:query-off-end ) on error undo, throw:
        
        if hLockBuff#::_lock-recid = hBufferIP#:recid and
          hLockBuff#::_lock-table  = hBufferIP#:table-number and
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
        output cConnectNameOP#,
        output iPidOP#,
        output cDeviceOP#).
        
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
    input cDbIP#                as character,
    input iUseridIP#            as integer,
    output cConnectNameOP#      as character,
    output iPidOP#              as integer,
    output cDeviceOP#           as character
    ):
    
    define variable hBuffer# as handle no-undo.
    define variable hQuery#  as handle no-undo.
    
    create buffer hBuffer# for table subst("&1._connect", cDbIP#).
    create query hQuery#.
    
    if hQuery#:set-buffers(hBuffer#)
      and hQuery#:query-prepare(subst("for each _Connect no-lock where _Connect._Connect-Usr = &1", iUseridIP#))
      and hQuery#:query-open()
      and hQuery#:get-first()
      then 
    do:
      assign 
        cConnectNameOP# = hBuffer#::_connect-name
        iPidOP#         = hBuffer#::_connect-pid
        cDeviceOP#      = hBuffer#::_connect-device.
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
    input  cDbIP#        as character,
    input  iFileNoIP#    as integer,
    output cTableNameOP# as character
    ):
    
    define variable hBuffer# as handle no-undo.
    define variable hQuery#  as handle no-undo.
    
    create buffer hBuffer# for table subst("&1._File", cDbIP#).
    create query hQuery#.
    
    if hQuery#:set-buffers(hBuffer#)
      and hQuery#:query-prepare(subst("for each _File no-lock where _File._File-number = &1", iFileNoIP#))
      and hQuery#:query-open()
      and hQuery#:get-first()
      then 
    do:
      assign 
        cTableNameOP# = hBuffer#::_File-Name.
    end.
  
    finally:
      if valid-handle(hQuery#) then  
        delete object hQuery#. 
      if valid-handle(hBuffer#) then  
        delete object hBuffer#. 
    end finally.
  
  end method. /* GetTableInfo */
  
  
  method public static character _deprecated_GetKeyFieldDataString(
    
    
    /* Deprecated, use panaedra.msroot.msutil.logic.sc_bufferfield  */
    
    /* Get the buffer-values, separated by "space", from the fields of the primary index of a record buffer */
  
    cDbIP#    as character, 
    cTableIP# as character, 
    rRecidIP# as recid):
  
    define variable cReturn#       as character no-undo.
    define variable hBuff#         as handle    no-undo.
    define variable cBuffIdx#      as character no-undo.
    define variable hBuffIdx#      as handle    no-undo.
    define variable hQuerIdx#      as handle    no-undo.
    define variable cBuffFile#     as character no-undo.
    define variable hBuffFile#     as handle    no-undo.
    define variable cIdxName#      as character no-undo.
    define variable hBuffIdxField# as handle    no-undo.
    define variable hBuffFldOfIdx# as handle    no-undo.
    define variable hQuerIdxFld#   as handle    no-undo.
  
    /* Actual record ... */
    create buffer hBuff# for table substitute("&1.&2", cDbIP#, cTableIP#) no-error.
    if valid-handle(hBuff#) then hBuff#:find-first(subst("where recid(&1) = &2", hBuff#:name, rRecidIP#), no-lock) no-error.
  
    if valid-handle(hBuff#) and hBuff#:available then 
    do:
  
      /* _File ... */
      cBuffFile#  = substitute("&1._File", cDbIP#).
      create buffer hBuffFile# for table cBuffFile# no-error.
      hBuffFile#:find-first("where _File-Name = " + quoter(cTableIP#),no-lock).
  
      /* _Index ... */
      cBuffIdx#  = substitute("&1._Index", cDbIP#).
      create buffer hBuffIdx# for table cBuffIdx# no-error.
      create query hQuerIdx#.
      hQuerIdx#:set-buffers(hBuffIdx#).
      hQuerIdx#:query-prepare(substitute("for each &1 no-lock where &1._File-recid = &2", hBuffIdx#:name, hBuffFile#:recid)).
      hQuerIdx#:query-open().
      hQuerIdx#:get-first.
  
      /* Walk through _Index metadata ... */
      do while hBuffIdx#:available:
    
        if hBuffIdx#:recid = hBuffFile#::_Prime-Index then 
        do:
      
          /* Note - Other index meta fields: _Wordidx , _Unique , _Active */
          cIdxName# = hBuffIdx#::_Index-Name.
      
          /* Fields in index */
          create buffer hBuffIdxField# for table substitute("&1._Index-Field", cDbIP#) no-error.
          create buffer hBuffFldOfIdx# for table substitute("&1._Field", cDbIP#)       no-error.

          if valid-handle(hBuffIdxField#) and valid-handle(hBuffFldOfIdx#) then 
          do on error undo, throw:

            create query hQuerIdxFld#.
            hQuerIdxFld#:set-buffers(hBuffIdxField#, hBuffFldOfIdx#).
            hQuerIdxFld#:query-prepare(substitute("for each &1 no-lock where &1._Index-recid = &2, first &3 no-lock of &1", hBuffIdxField#:name, hBuffIdx#:recid, hBuffFldOfIdx#:name)).
            hQuerIdxFld#:query-open().
            hQuerIdxFld#:get-first.

            do while hBuffIdxField#:available:
              if hBuffFldOfIdx#::_Field-name > "" then  
                cReturn# = cReturn# + subst(" &1", hBuff#:buffer-field(hBuffFldOfIdx#::_Field-name):buffer-value ).
              hQuerIdxFld#:get-next.
            end.
        
            cReturn# = substring(cReturn#,2).
          
            finally:
              if valid-handle(hQuerIdxFld#  ) then delete object hQuerIdxFld#.
              if valid-handle(hBuffIdxField#) then delete object hBuffIdxField#.
              if valid-handle(hBuffFldOfIdx#) then delete object hBuffFldOfIdx#.
            end finally.

          end. /* Fields in index */

        end.
    
        hQuerIdx#:get-next.

      end. /* Query on Indices */
  
    end. /* (Normal) record can be found */
    
    return cReturn#.
    
    catch oError# as Progress.Lang.Error:
      sc_showexception:ShowException(oError#).  
    end catch.
    
    finally:
      if valid-handle(hBuff#    ) then delete object hBuff#    . 
      if valid-handle(hQuerIdx# ) then delete object hQuerIdx# .
      if valid-handle(hBuffFile#) then delete object hBuffFile#. 
      if valid-handle(hBuffIdx# ) then delete object hBuffIdx# .
    end finally.
  
  end method. /* _deprecated_GetKeyFieldDataString */
  

  method protected static void GetConnectionInfo(
    /* -----------------------------------------------------------
       returns info about connection to a progress database
       ----------------------------------------------------------- */
    input cDbIP#      as character,
    input iUserNoIP#  as integer,
    output cDeviceOP# as character,
    output iPidOP#    as integer
    ):
    
    define variable hBuffer# as handle no-undo.
    define variable hQuery#  as handle no-undo.
    
    create buffer hBuffer# for table subst("&1._connect", cDbIP#).
    create query hQuery#.
    
    if hQuery#:set-buffers(hBuffer#)
      and hQuery#:query-prepare(subst("for each _Connect no-lock where _Connect._Connect-Usr = &1", iUserNoIP#))
      and hQuery#:query-open()
      and hQuery#:get-first()
      then 
    do:
      assign 
        cDeviceOP# = hBuffer#::_Connect-device
        iPidOP#    = hBuffer#::_Connect-Pid .
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
    output iTransactionNumOP#   as integer,
    output dtmSinceOP#          as datetime-tz,
    output cTransStatOP#        as character
    ):
    
    define variable hBuffer# as handle no-undo.
    define variable hQuery#  as handle no-undo.
    
    create buffer hBuffer# for table subst("&1._trans", cDbIP#).
    create query hQuery#.
    
    if hQuery#:set-buffers(hBuffer#)
      and hQuery#:query-prepare(subst("for each _Trans no-lock where _Trans._Trans-Usrnum = &1 and _Trans._Trans-State <> ?", iUserNoIP#))
      and hQuery#:query-open()
      and hQuery#:get-first()
      then 
    do:
      assign 
        iTransactionNumOP# = hBuffer#::_trans-num.
      assign
        /* Note: if hBuffer#::_Trans-State = "ALLOCATED", no timestamp info is available yet. As soon as record changes are pending, state "ACTIVE", timestamp info will be filled. */
        cTransStatOP# = hBuffer#::_Trans-State
        dtmSinceOP#   = add-interval(now, (if hBuffer#::_Trans-Duration <> ? then -1 * int(hBuffer#::_Trans-Duration) else 0), "seconds").
      &if false &then
      message "dtmSinceOP#" dtmSinceOP# skip
        "hBuffer#::_trans-num" hBuffer#::_trans-num skip
        "hBuffer#::_Trans-txtime" hBuffer#::_Trans-txtime skip
        "hBuffer#::_Trans-State" hBuffer#::_Trans-State skip
        "hBuffer#::_Trans-Duration" hBuffer#::_Trans-Duration skip
        view-as alert-box.
      &endif
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
      
    define variable iDb#       as integer no-undo.
    define variable hBuffLock# as handle  no-undo.
    define variable hQuery#    as handle  no-undo.  
    define variable iIdLock#   as int64   no-undo.
    
    empty temp-table ttLock.

    do iDb# = 1 to num-dbs on error undo, throw:
      
      OpenLockInfoQuery(ldbname(iDb#), input-output hQuery#, input-output hBuffLock#).
      
      hQuery#:get-first().

      do while ( not hQuery#:query-off-end ): 

        /* Entries in _Lock no longer appear at top of resultset from OpenEdge 11.4 onward.
           there is no garantee where the lock records are in the resultset.
           we now check for valid _lock records in the where clause of the query.
           http://knowledgebase.progress.com/%61rticles/%41rticle/000056304 */
           
        create ttLock.
        assign
          iIdLock#          = iIdLock# + 1
          ttLock.iIDLock    = iIdLock#
          ttLock.cDb        = ldbname(iDb#)
          ttLock.iLockId    = hBuffLock#::_Lock-Id
          ttLock.rLockRecid = hBuffLock#::_Lock-RecId
          ttLock.iLockUsr   = hBuffLock#::_Lock-Usr
          ttLock.cLockName  = hBuffLock#::_Lock-Name
          ttLock.iLockTable = hBuffLock#::_Lock-Table
          .
          
        GetTableInfo      (ldbname(iDb#), ttLock.iLockTable, output ttLock.cTableName).
        GetConnectionInfo (ldbname(iDb#), ttLock.iLockUsr,   output ttLock.cDevice,         output ttLock.iPid).
        GetTransactionInfo(ldbname(iDb#), ttLock.iLockUsr,   output ttLock.iTransactionNum, output ttLock.dtmSince, output ttLock.cTransStat).
        
        assign
          ttLock.cSince          = sc_datetime_logic:GetTimeHH_FCMPNY_S(ttLock.dtmSince)
          ttLock.cWhoInfo        = sc_environment:GetWorkstationDescription(ttLock.cDevice)
          ttLock.cCommandLineRaw = sc_environment:GetCommandLine(ttLock.iPid). 
          
        hQuery#:get-next().
        
      end.
      
      catch oError# as Progress.Lang.Error:
        
        sc_exception:ReThrow(
          99958112,
          oError#,
          "recordlockinfo_loop-end", 
          sc_lang:oEnglish,
          substitute("Db='&1/&2', valid-handle(hBuffLock#)=&3", ldbname(iDb#), pdbname(iDb#), valid-handle(hBuffLock#))  
          ).
        
      end catch.
      
      finally:
        if valid-handle(hQuery#) then
          delete object hQuery#.
        if valid-handle(hBuffLock#) then
          delete object hBuffLock#.  
      end finally.
      
    end. /* do iDb# .... */   
  
  end method. /* GetAllRecordLockInfo */
  
  
  method protected static void OpenLockInfoQuery(
    /* -----------------------------------------------------------
    Open query in separate method for debugging purposes
       ----------------------------------------------------------- */
    input        cDbIP#        as character,
    input-output hQueryIOP#    as handle,
    input-output hBuffLockIOP# as handle
    ):

    create query hQueryIOP#.
    create buffer hBuffLockIOP# for table subst("&1._Lock", cDbIP#).
      
    hQueryIOP#:add-buffer(hBuffLockIOP#).
    hQueryIOP#:query-prepare("for each _Lock no-lock where _Lock-Usr <> ? ").
    hQueryIOP#:query-open().
  
  end method. /* GetAllRecordLockInfo */
  
  
  method public static integer GetLocktableCount(
    /* -----------------------------------------------------------
       gets the locktable count of a specific db, via _DbStatus 
       VST single record table 
       ----------------------------------------------------------- */
    input cDbIP# as character):
      
    define variable iReturn# as integer no-undo.
    define variable hBuff#   as handle  no-undo.
    
    create buffer hBuff# for table subst("&1._DbStatus", cDbIP#).
    
    hBuff#:find-first("where _DbStatus-NumLocks > 0", no-lock) no-error.
    
    if hBuff#:available then iReturn# = hBuff#::_DbStatus-NumLocks. 
    
    return iReturn#.  
    
    finally:
      if valid-handle(hBuff#) then delete object hBuff#.
    end finally.
  
  end method. /* GetLocktableCount */
  
  
  method public static integer GetLocktableCountExt(
    /* -----------------------------------------------------------
       gets the locktable count of a specific db, via _DbStatus 
       VST single record table. Supply/clean-up your own handle.
       ----------------------------------------------------------- */
    input-output hBuffIOP# as handle,
    input        cDbIP#    as character):
      
    define variable iReturn# as integer no-undo.
    
    if not valid-handle(hBuffIOP#) then
      create buffer hBuffIOP# for table subst("&1._DbStatus", cDbIP#).
    
    hBuffIOP#:find-first("where _DbStatus-NumLocks > 0", no-lock) no-error.
    
    if hBuffIOP#:available then iReturn# = hBuffIOP#::_DbStatus-NumLocks. 
    
    return iReturn#.  
  
  end method. /* GetLocktableCountExt */
  
end class.

/* EOF */ 
