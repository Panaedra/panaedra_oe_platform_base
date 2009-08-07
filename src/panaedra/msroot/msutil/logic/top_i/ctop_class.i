/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msi/logic/ctop_class.i $ 
        Version: $Revision: 1 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-08-07 21:22:38+02:00 $ 
  Date Modified: $Modtime: 2009-08-07 21:22:38+02:00 $ 

    Description: Include die in iedere _CMPNY_ Panaedra class gebruikt moet worden.
                 "ctop" betekent: Aan het begin, voor de class definitie.

\**************************** End of Dvcs_ Header ****************************/
&if '{&dvcs__panaedra_msi_logic_ctop_class_i}' = '' &then
&glob dvcs__panaedra_msi_logic_ctop_class_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msi_logic_ctop_class_i $Revision: 1 $
/******************************* $NoKeywords:  $ *****************************/

using Progress.Lang.*.
routine-level on error undo, throw.

&endif

/* EOF */
