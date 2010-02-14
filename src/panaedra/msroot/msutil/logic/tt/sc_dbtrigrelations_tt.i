/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/tt/sc_dbtrigrelations_tt.i $ 
        Version: $Revision: 4 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-02-14 23:32:42+01:00 $ 
  Date Modified: $Modtime: 2010-02-14 23:15:50+01:00 $ 

    Description: Temp-table definitions

\**************************** End of Dvcs_ Header ****************************/
&if '{&dvcs__panaedra_msd_logic_sc_dbtrigrelations_tt_i}' = '' &then
&glob dvcs__panaedra_msd_logic_sc_dbtrigrelations_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msd_logic_sc_dbtrigrelations_tt_i $Revision: 4 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msd_logic_sc_dbtrigrelations_tt_i: 
  return "$Revision: 4 $". 
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
  field cPath    as character xml-node-type "attribute"
  field bHandled as logical   xml-node-type "hidden"
  index bHandled_cPath is primary unique bHandled cPath
  .

define {&protected} {&static} temp-table ttMsdrDbtrigTables no-undo {&reference-only} rcode-information
  field cTable   as character xml-node-type "element" 
  field cCased   as character xml-node-type "attribute"
  field cModule  as character xml-node-type "attribute"
  field bHandled as logical   xml-node-type "hidden"
  index cTable is primary unique cTable
  index bHandled_cModule_cTable bHandled cModule cTable
  .

define {&protected} {&static} temp-table ttMsdrDbtrigRelations no-undo {&reference-only} rcode-information
  field iOrder             as integer   xml-node-type "attribute"
  field cMultiplicity      as character xml-node-type "attribute"
  field cChildMultiplicity as character xml-node-type "attribute"
  field cTable             as character xml-node-type "element"
  field cChildTable        as character xml-node-type "element"
  field bHandled           as logical   xml-node-type "hidden"
  index bHandled_cTable_iOrder is primary unique bHandled cTable iOrder.


/* Datasets */
define {&protected} {&static} dataset dsDbRelations    {&reference-only} for ttMsdrTriggerLink, ttMsdrDbtrigTables, ttMsdrDbtrigRelations.

/* Make a "Part" deep copy definition, for reading/writing parts of the dataset from/to file */
define {&protected} {&static} temp-table ttPartTriggerLink no-undo {&reference-only} like ttMsdrTriggerLink.
define {&protected} {&static} temp-table ttPartMsdrDbtrigTables no-undo {&reference-only} like ttMsdrDbtrigTables.
define {&protected} {&static} temp-table ttPartMsdrDbtrigRelations no-undo {&reference-only} like ttMsdrDbtrigRelations.
define {&protected} {&static} dataset dsPartDbRelations    {&reference-only} for ttPartTriggerLink, ttPartMsdrDbtrigTables, ttPartMsdrDbtrigRelations.
  
  
&endif
