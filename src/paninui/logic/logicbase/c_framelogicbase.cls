{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
{paninui/logic/includes/preproc_dotnetclasses.i &class=class}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using paninui.view.interfaces.*.

class paninui.logic.logicbase.c_framelogicbase 
  inherits
  &if {&paninui_tty} &then
  Progress.Lang.Object
  &else
  /* Reason inheritance: for event binding. We could also have used a paninui.dll interface for this. */
  System.Object
  &endif
  implements 
  i_frmlogic,
  i_scopetableclient: 

  /****************************** Source Header ********************************\

      Description: Baseclass for frame logic classes.

  \*****************************  Include Files ********************************/
  {paninui/logic/includes/preproc_dotnetclasses.i &class=class}
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected        variable i_p_PackID           as int64 no-undo.
  define protected static variable iFrmLogicIDStatic    as int64 no-undo.
  define protected        variable iFrmLogicIDProtected as int64 no-undo.

  define public property bFrameLogicInitialized     as logical no-undo get. set.
  define public property bFrameEventsInitialized    as logical no-undo get. set.
  define public property bFrameViewInitialized      as logical no-undo get. set.
  define public property bFrameViewShownInitialized as logical no-undo get. set.
  
  define property oUI as {&i_frmlogic_shortcut}
    no-undo 
    public get. 
    protected set.

  define property oPack as paninui.pack.interfaces.i_pack no-undo 
    public get. 
    protected set.

  define property iPackID as int64 no-undo
    public get:
      return i_p_PackID.
    end get.


  define property iFrmLogicID as int64 no-undo
    public get:
      return iFrmLogicIDProtected.
    end get.
  

  constructor public c_framelogicbase():
    assign 
      iFrmLogicIDStatic    = iFrmLogicIDStatic + 1
      iFrmLogicIDProtected = iFrmLogicIDStatic.
    
    &if not {&paninui_tty} &then
    /* ShouldHave: oUI shortcut support for unix */
    oUI = new paninui.logic.logicbase.c_framelogic_shortcut(this-object).
    &endif
    
  end constructor.


  method public void SetPack (oPackIP# as paninui.pack.interfaces.i_pack):
    
    assign 
      oPack      = oPackIP#
      i_p_PackID = oPackIP#:iPackID.

  end method. /* SetPack */ 


  method public logical InitializeFrameLogic():
    
    bFrameLogicInitialized = true.  
    return true.
    
  end method. /* InitializeFrameLogic */


  method public logical InitializeFrameEvents():

    bFrameEventsInitialized = true. 
    return true.
    
  end method. /* InitializeFrameEvents */


  method public logical InitializeFrameView():

    bFrameViewInitialized = true.   
    return true.
    
  end method. /* InitializeFrameView */


  method public void InitializeFrameViewShown():
    
    bFrameViewShownInitialized = true.  
    return.
    
  end method. /* InitializeFrameViewShown */


end class.

/* EOF */
