/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/tt/sc_dbtrigrelations_tt.i $ 
        Version: $Revision: 3 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-01-31 20:53:50+01:00 $ 
  Date Modified: $Modtime: 2010-01-31 17:18:22+01:00 $ 

    Description: Temp-table definities

\**************************** End of Dvcs_ Header ****************************/
&if '{&dvcs__panaedra_msd_logic_sc_dbtrigrelations_tt_i}' = '' &then
&glob dvcs__panaedra_msd_logic_sc_dbtrigrelations_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msd_logic_sc_dbtrigrelations_tt_i $Revision: 3 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msd_logic_sc_dbtrigrelations_tt_i: 
  return "$Revision: 3 $". 
end.
&endif
/******************************* $NoKeywords:  $ *****************************/


&if defined(static) > 0 and defined(reference-only) > 0 &then
/* Dit wordt in OE10.2A nog niet ondersteund, hopelijk later wel */
/* Kan helaas niet in include                                    */
&undefine reference-only
&endif

/* Temp-tables */
define {&protected} {&static} temp-table ttMsdrTriggerLink no-undo {&reference-only} rcode-information
  field cPath as character xml-node-type "attribute"
  index cPath is primary unique cPath
  .

define {&protected} {&static} temp-table ttMsdrDbtrigTables no-undo {&reference-only} rcode-information
  field cTable  as char
  field cCased  as char xml-node-type "attribute"
  field cModule as char xml-node-type "attribute"
  index cTable is primary unique cTable
  index cModule_cTable cModule cTable
  .

define {&protected} {&static} temp-table ttMsdrDbtrigRelations no-undo {&reference-only} rcode-information
  field iOrder             as int  xml-node-type "attribute"
  field cMultiplicity      as char xml-node-type "attribute"
  field cChildMultiplicity as char xml-node-type "attribute"
  field cTable             as char
  field cChildTable        as char
  index cTable_iOrder is primary unique cTable iOrder.


/* Datasets */
define {&protected} {&static} dataset dsDbRelations    {&reference-only} for ttMsdrTriggerLink, ttMsdrDbtrigTables, ttMsdrDbtrigRelations.

/* Make a "Part" deep copy definition, for reading/writing parts of the dataset from/to file */
define {&protected} {&static} temp-table ttPartTriggerLink no-undo {&reference-only} like ttMsdrTriggerLink.
define {&protected} {&static} temp-table ttPartMsdrDbtrigTables no-undo {&reference-only} like ttMsdrDbtrigTables.
define {&protected} {&static} temp-table ttPartMsdrDbtrigRelations no-undo {&reference-only} like ttMsdrDbtrigRelations.
define {&protected} {&static} dataset dsPartDbRelations    {&reference-only} for ttPartTriggerLink, ttPartMsdrDbtrigTables, ttPartMsdrDbtrigRelations.
  
  
&endif
