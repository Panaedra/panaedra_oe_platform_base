{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using paninui.view.interfaces.*.
using paninui.view.use.events.*.
&if opsys = "unix" or "{&window-system}" = "tty" &then
  &glob Generic_Object Progress.Lang.Object
&else
  &glob Generic_Object System.Object
&endif

class paninui.view.use.events.c_uivalue_griditem 
  inherits   c_uivalue
  implements i_uivalue: 

  /****************************** Source Header ********************************\

      Description: Represents the screen value of generic selection (i.e. number of 
                   selected rows in a grid)

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define public property cItemName     as character no-undo extent get. set.
  define public property cItemNewValue as character no-undo extent get. set.

  constructor public c_uivalue_griditem(cNameIP# as character, bEnabledIP# as logical, bVisibleIP# as logical):
    
    super().
    
    assign 
      cName    = cNameIP#
      bEnabled = bEnabledIP#
      bVisible = bVisibleIP#. 
    
  end constructor.
  
  
end class.

/* EOF */ 
