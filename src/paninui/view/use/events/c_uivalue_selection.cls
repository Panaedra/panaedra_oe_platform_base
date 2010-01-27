{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using paninui.view.interfaces.*.
using paninui.view.use.events.*.
&if opsys = "unix" or "{&window-system}" = "tty" &then
  &glob Generic_Object Progress.Lang.Object
&else
  &glob Generic_Object System.Object
&endif

class paninui.view.use.events.c_uivalue_selection 
  inherits   c_uivalue
  implements i_uivalue: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/events/c_uivalue_selection.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:11+01:00 $ 

      Description: Represents the screen value of generic selection (i.e. number of 
                   selected rows in a grid)

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_uivalue_selection(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
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
