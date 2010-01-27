{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

interface panaedra.msroot.msutil.interfaces.i_scopetablecontroller:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_scopetablecontroller.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:17+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:11+01:00 $ 

      Description: Controls the scope in a c_scopetable object

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method void ScopeTableControl(oScopeTableIP# as i_scopetable, oScopeTableClientIP# as i_scopetableclient, input-output cScopeIOP# as character).

end interface.

/* EOF */ 
