{panaedra/msi/logic/ctop_class.i} 
using paninui.view.interfaces.*.
using paninui.view.use.events.*.
&if opsys = "unix" or "{&window-system}" = "tty" &then
  &glob Generic_Object Progress.Lang.Object
&else
  &glob Generic_Object System.Object
&endif

class paninui.view.use.events.c_uivalue_combobox 
  inherits   c_uivalue
  implements i_uivalue: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/events/c_uivalue_combobox.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-21 13:32:59+02:00 $ 
    Date Modified: $Modtime: 2009-10-21 13:32:25+02:00 $ 

      Description: Represents the screen value of an editor, combobox, textbox 
                   or even a simple label

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_uivalue_combobox(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define public property cText as character no-undo get. set.

  constructor public c_uivalue_combobox(cNameIP# as character, bEnabledIP# as logical, bVisibleIP# as logical, cTextIP# as character):
    
    super().
    
    assign 
      cName    = cNameIP#
      bEnabled = bEnabledIP#
      bVisible = bVisibleIP#
      cText    = cTextIP#. 
    
  end constructor.

end class.

/* EOF */ 
