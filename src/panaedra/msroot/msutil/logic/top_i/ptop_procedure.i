/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msi/logic/ptop_procedure.i $ 
        Version: $Revision: 1 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-08-07 21:22:38+02:00 $ 
  Date Modified: $Modtime: 2009-08-07 21:22:38+02:00 $ 

    Description: Include die bovenaan in iedere procedure moet worden gebruikt.

\**************************** End of Dvcs_ Header ****************************/
&if '{&dvcs__panaedra_msi_logic_ptop_procedure_i}' = '' &then
&glob dvcs__panaedra_msi_logic_ptop_procedure_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msi_logic_ptop_procedure_i $Revision: 1 $

routine-level on error undo, throw.

&if '{&class}' = '' &then
procedure dvcs__panaedra_msi_logic_ptop_procedure_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&endif
