/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Definition of ttPersistentThings

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_tt_mspersistencyinfo_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_tt_mspersistencyinfo_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_tt_mspersistencyinfo_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msutil_logic_tt_mspersistencyinfo_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/
&endif /* {&dvcs__panaedra_msroot_msutil_logic_tt_mspersistencyinfo_tt_i} */

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if defined(ttPersistentThings{&ttSuffix}) = 0 &then
&glob ttPersistentThings{&ttSuffix} true
define {&protected} {&static} temp-table ttPersistentThings{&ttSuffix} no-undo {&reference-only} rcode-info
  field cType              as char      xml-node-type "attribute"
  field cName              as char      xml-node-type "attribute"
  field iVersion           as integer   xml-node-type "attribute"
  field cInstantiatingProc as char      xml-node-type "attribute"
  field hHandle            as handle    xml-node-type "attribute"
  field cPrivateData       as character xml-node-type "attribute"
  {&ttExtraFields}
  index cType_cName cType cName.
  {&ttExtraIndices}
&endif

/* EOF : panaedra/msroot/msutil/logic/tt/mspersistencyinfo_tt.i */
