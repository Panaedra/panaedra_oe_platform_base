{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
{paninui/logic/includes/preproc_dotnetclasses.i &class=class}

&if {&paninui_tty} &then
  &glob Generic_Object Progress.Lang.Object
&else
  using paninui.view.interfaces.*.
  &glob Generic_Object System.Object
&endif

class paninui.view.use.events.c_uivalue inherits {&Generic_Object}
  &if not {&paninui_tty} &then
  implements 
  paninui.view.interfaces.i_uivalue
  &endif
  : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/events/c_uivalue.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-08-22 15:30:38+02:00 $ 
    Date Modified: $Modtime: 2010-08-22 02:43:18+02:00 $ 

      Description: Represents the screen value of any widget. Can be used as a
                   base class for specific widgets.
                

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_uivalue(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 4 $', '{&sourcecontrolversions}').
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
