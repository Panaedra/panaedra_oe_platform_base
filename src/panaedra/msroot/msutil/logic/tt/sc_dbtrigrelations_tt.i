/****************************** Source Header ********************************\

    Description: Temp-table definitions + dataset for ttMsdr (main system data relations)

\**************************** End of Source Header ***************************/

&if '{&dvcs__panaedra_msd_logic_sc_dbtrigrelations_tt_i}' = '' &then
&glob dvcs__panaedra_msd_logic_sc_dbtrigrelations_tt_i yes

/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then
/* OE10.2A limitation */
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

/* EOF : panaedra/msroot/msutil/logic/tt/sc_dbtrigrelations_tt.i */
