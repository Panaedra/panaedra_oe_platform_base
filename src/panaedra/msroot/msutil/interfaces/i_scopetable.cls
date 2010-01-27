{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

interface panaedra.msroot.msutil.interfaces.i_scopetable:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_scopetable.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:17+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:13+01:00 $ 

      Description: An i_scopetable object, controlled by an i_scopetablecontroller.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define property oScopeTableController as i_scopetablecontroller get.
  
  method handle ScopeTable(oScopeTableClientIP# as i_scopetableclient, cScopeIP# as character).

end interface.

/* EOF */ 
