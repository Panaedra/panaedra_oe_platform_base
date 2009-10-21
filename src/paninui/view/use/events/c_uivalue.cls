{panaedra/msi/logic/ctop_class.i} 
using paninui.view.interfaces.*.
&if opsys = "unix" or "{&window-system}" = "tty" &then
  &glob Generic_Object Progress.Lang.Object
&else
  &glob Generic_Object System.Object
&endif

class paninui.view.use.events.c_uivalue inherits {&Generic_Object}
  implements 
  paninui.view.interfaces.i_uivalue: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/events/c_uivalue.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-21 16:02:53+02:00 $ 
    Date Modified: $Modtime: 2009-10-21 16:00:31+02:00 $ 

      Description: Represents the screen value of any widget. Can be used as a
                   base class for specific widgets.
                

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_uivalue(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define public property cName    as character no-undo get. set.
  
  define public property bEnabled as logical   no-undo get:
      return bEnabled.
    end get.
    set(input bValueIP# as logical):
      bEnabled = bValueIP#.
    end set.
    
  define public property bVisible as logical   no-undo get:
      return bVisible.
    end get.
    set(input bValueIP# as logical):
      bVisible = bValueIP#.
    end set.

    
  constructor public c_uivalue():
  
  end constructor.


  constructor public c_uivalue(cNameIP# as character):
  
    cName = cNameIP#.
    
  end constructor.

end class.

/* EOF */ 
