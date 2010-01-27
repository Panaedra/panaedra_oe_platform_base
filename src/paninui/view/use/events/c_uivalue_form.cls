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

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/events/c_uivalue_form.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:13+01:00 $ 

      Description: Represents the screen value of an editor, combobox, textbox 
                   or even a simple label

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_uivalue_form(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
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
