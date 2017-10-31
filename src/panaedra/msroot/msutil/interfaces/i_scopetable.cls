{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

interface panaedra.msroot.msutil.interfaces.i_scopetable:  

  /****************************** Source Header ********************************\

      Description: An i_scopetable object, controlled by an i_scopetablecontroller.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define property oScopeTableController as i_scopetablecontroller no-undo get.
  
  method handle ScopeTable(oScopeTableClientIP# as i_scopetableclient, cScopeIP# as character).

end interface.

/* EOF */ 
