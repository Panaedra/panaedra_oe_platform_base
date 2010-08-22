{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
{paninui/logic/includes/preproc_dotnetclasses.i &class=class}

using {&paninui.view.interfaces.}*.
using paninui.view.use.events.*.


class paninui.view.use.events.c_uivalue_button 
  inherits   c_uivalue
  implements i_uivalue: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/events/c_uivalue_button.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-08-22 15:30:38+02:00 $ 
    Date Modified: $Modtime: 2010-08-22 04:30:02+02:00 $ 

      Description: Represents the screen value of a button or checkbox (which is also a button)

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_uivalue_button(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
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
