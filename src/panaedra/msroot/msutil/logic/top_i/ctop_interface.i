/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msi/logic/ctop_interface.i $ 
        Version: $Revision: 1 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-08-07 21:22:38+02:00 $ 
  Date Modified: $Modtime: 2009-08-07 21:22:38+02:00 $ 

    Description: Include die in iedere _CMPNY_ Panaedra interface gebruikt moet worden.
                 "ctop" betekent: Aan het begin, voor de interface definitie.

\**************************** End of Dvcs_ Header ****************************/
&if '{&dvcs__panaedra_msi_logic_ctop_interface_i}' = '' &then
&glob dvcs__panaedra_msi_logic_ctop_interface_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msi_logic_ctop_interface_i $Revision: 1 $
/******************************* $NoKeywords:  $ *****************************/

using Progress.Lang.*.

&endif

/* EOF */
