/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/top_i/ctop_interface.i $ 
        Version: $Revision: 2 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
  Date Modified: $Modtime: 2010-01-27 19:30:14+01:00 $ 

    Description: Include die in iedere _CMPNY_ Panaedra interface gebruikt moet worden.
                 "ctop" betekent: Aan het begin, voor de interface definitie.

\**************************** End of Dvcs_ Header ****************************/
&if '{&dvcs__panaedra_msi_logic_ctop_interface_i}' = '' &then
&glob dvcs__panaedra_msi_logic_ctop_interface_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msi_logic_ctop_interface_i $Revision: 2 $
/******************************* $NoKeywords:  $ *****************************/

using Progress.Lang.*.

&endif

/* EOF */
