/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Temp-tables for sc_dbtrig

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_tt_msdbtrig_tableinfo_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_tt_msdbtrig_tableinfo_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_tt_msdbtrig_tableinfo_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msutil_logic_tt_msdbtrig_tableinfo_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

define {&protected} {&static} temp-table ttTableInfo no-undo
  field cTempTableName   as character init ? /* either cTempTableName or cDbTableName is filled */
  field cDbTableName     as character init ? /* either cTempTableName or cDbTableName is filled */
  field cNonCased        as character
  field cCased           as character
  field cLabel           as character 
  field cDescription     as character
  field cNsSubroot       as character
  field cNsGroupdir      as character
  field cNsKey           as character
  field cNsDatabaseGroup as character /* namespace database group (4th entry in database table description) can be used for tables that reside in a different database, that must have its own onwriteordelete static trigger class (sc_*_onwriteordelete_u.cls) */
  field cNsPath          as character
  field cPersistencyMode as character
  index cCased is primary        cCased
  index cTempTableName is unique cTempTableName
  index cDbTableName is unique   cDbTableName
  .

define {&protected} {&static} temp-table ttCacheLogicLocations no-undo
  field cTable     as character
  field cType      as character init "wri"
  field cLogicVal  as character init "<none>"
  field cLogicCalc as character init "<none>"
  field bDummy     as logical   init ?
  /* The following index is a workaround on a OE10.2A01 bug.
     A direct/normal cTable cType index gets corrupted:
     Find statement on index doesn't work in tty (unix or win32). 
     Unique or not doesn't matter. 
  */
  index cTable_cType is primary unique cTable cType 
  . 

define {&protected} {&static} temp-table ttDbLogicLocations no-undo
  field cNamespace       as character
  field cNsDatabaseGroup as character
  field cClass           as character            init "<none>"
  field oDbTrigClass     as Progress.Lang.Object
  field oParamList       as Progress.Lang.Object
  index cNamespace_DbGroup is primary unique cNamespace cNsDatabaseGroup 
  . 

&endif /* {&dvcs__panaedra_msroot_msutil_logic_tt_msdbtrig_tableinfo_tt_i} */

/* EOF : panaedra/msroot/msutil/logic/tt/msdbtrig_tableinfo_tt.i */
