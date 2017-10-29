{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using paninui.view.interfaces.*.
using paninui.view.use.events.*.
&if opsys = "unix" or "{&window-system}" = "tty" &then
  &glob Generic_Object Progress.Lang.Object
&else
  &glob Generic_Object System.Object
&endif

class paninui.view.use.events.c_uivalue_form 
  inherits   c_uivalue
  implements i_uivalue: 

  /****************************** Source Header ********************************\

      Description: Represents the screen value of an editor, combobox, textbox 
                   or even a simple label

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define public property cTitle as character no-undo get. set.
  define public property cFocus as character no-undo get. set.
 
  constructor public c_uivalue_form(cNameIP# as character, bEnabledIP# as logical, bVisibleIP# as logical, cTitleIP# as character, cFocusIP# as character):
    
    super().
    
    assign 
      cName    = cNameIP#
      bEnabled = bEnabledIP#
      bVisible = bVisibleIP#
      cTitle   = cTitleIP#
      cFocus   = cFocusIP#. 
    
  end constructor.

end class.

/* EOF */ 
