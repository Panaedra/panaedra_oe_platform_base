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

  /****************************** Source Header ********************************\

      Description: Represents the screen value of any widget. Can be used as a
                   base class for specific widgets.
                

  \*****************************  Include Files ********************************/

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
