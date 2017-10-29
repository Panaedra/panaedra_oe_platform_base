{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
{paninui/logic/includes/preproc_dotnetclasses.i &class=class}

using {&paninui.view.interfaces.}*.
using paninui.view.use.events.*.


class paninui.view.use.events.c_uivalue_button 
  inherits   c_uivalue
  implements i_uivalue: 

  /****************************** Source Header ********************************\

      Description: Represents the screen value of a button or checkbox (which is also a button)

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define public property bChecked as logical no-undo get. set.

  constructor public c_uivalue_button(cNameIP# as character, bEnabledIP# as logical, bVisibleIP# as logical, bCheckedIP# as logical):
    
    super().
    
    assign 
      cName    = cNameIP#
      bEnabled = bEnabledIP#
      bVisible = bVisibleIP#
      bChecked = bCheckedIP#. 
    
  end constructor.

end class.

/* EOF */ 
