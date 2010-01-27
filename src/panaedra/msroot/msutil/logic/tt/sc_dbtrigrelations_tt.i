/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/tt/sc_dbtrigrelations_tt.i $ 
        Version: $Revision: 2 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
  Date Modified: $Modtime: 2010-01-27 19:45:10+01:00 $ 

    Description: Temp-table definities

\**************************** End of Dvcs_ Header ****************************/
&if '{&dvcs__panaedra_msd_logic_sc_dbtrigrelations_tt_i}' = '' &then
&glob dvcs__panaedra_msd_logic_sc_dbtrigrelations_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msd_logic_sc_dbtrigrelations_tt_i $Revision: 2 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msd_logic_sc_dbtrigrelations_tt_i: 
  return "$Revision: 2 $". 
end.
&endif
/******************************* $NoKeywords:  $ *****************************/


&if defined(static) > 0 and defined(reference-only) > 0 &then
/* Dit wordt in OE10.2A nog niet ondersteund, hopelijk later wel */
/* Kan helaas niet in include                                    */
&undefine reference-only
&endif

/* Temp-tables */
define {&protected} {&static} temp-table ttMsdrDbtrigTables no-undo {&reference-only} rcode-information
  field cTable  as char
  field cCased  as char
  field cModule as char
  index cTable is primary unique cTable
  index cModule_cTable cModule cTable
  .

define {&protected} {&static} temp-table ttMsdrDbtrigRelations no-undo {&reference-only} rcode-information
  field cTable             as char
  field iOrder             as int
  field cMultiplicity      as char
  field cChildTable        as char
  field cChildMultiplicity as char
  index cTable_iOrder is primary unique cTable iOrder.


/* Datasets */
define {&protected} {&static} dataset dsDbRelations    {&reference-only} for ttMsdrDbtrigTables, ttMsdrDbtrigRelations.

/*define {&static} buffer b-ttExceptions for ttExceptions.                                               */
/*define {&static} buffer b-ttCallstack  for ttcallstack.                                                */
/*define {&protected} {&static} dataset dsExceptions {&reference-only} for b-ttExceptions, b-ttCallstack.*/
  
  
&endif
