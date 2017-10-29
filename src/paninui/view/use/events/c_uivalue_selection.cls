{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
{paninui/logic/includes/preproc_dotnetclasses.i &class=class}

using paninui.view.interfaces.*.
using paninui.view.use.events.*.
&if opsys = "unix" or "{&window-system}" = "tty" &then
  &glob Generic_Object Progress.Lang.Object
&else
  &glob Generic_Object System.Object
&endif

class paninui.view.use.events.c_uivalue_selection 
  inherits   c_uivalue
  &if not {&paninui_tty} &then
  implements i_uivalue
  &endif
    : 

  /****************************** Source Header ********************************\

      Description: Represents the screen value of generic selection (i.e. number of 
                   selected rows in a grid)

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define public property iSelectionID_Rows as int64 no-undo extent get. set.
  define public property iSelectionID_Columns as int64 no-undo extent get. set.
  define public property iSelectionID_Cells as int64 no-undo extent get. set.

  constructor public c_uivalue_selection(cNameIP# as character, bEnabledIP# as logical, bVisibleIP# as logical):
    
    super().
    
    assign 
      cName    = cNameIP#
      bEnabled = bEnabledIP#
      bVisible = bVisibleIP#. 
    
  end constructor.
  
  
  destructor c_uivalue_selection():
  
    if extent(iSelectionID_Rows)    > 0 then extent(iSelectionID_Rows)    = ?.
    if extent(iSelectionID_Columns) > 0 then extent(iSelectionID_Columns) = ?.
    if extent(iSelectionID_Cells)   > 0 then extent(iSelectionID_Cells)   = ?.
  
  end destructor.
  
end class.

/* EOF */ 
