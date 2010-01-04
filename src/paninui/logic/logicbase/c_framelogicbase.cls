{panaedra/msi/logic/ctop_class.i}

class paninui.logic.logicbase.c_framelogicbase 
  inherits
  &if opsys = "unix" &then
  Progress.Lang.Object
  &else
  /* TODO: Eens goed naar kijken... vind het vreemd dat framelogicbase overerft van c_uiframe... */
  paninui.view.framebase.c_uiframe
  &endif
  implements 
  paninui.view.interfaces.i_frmlogic: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/logic/logicbase/c_framelogicbase.cls $ 
          Version: $Revision: 14 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-04 12:13:50+01:00 $ 
    Date Modified: $Modtime: 2010-01-04 12:11:22+01:00 $ 

      Description: Baseclass for frame logic classes.

  \*****************************  Include Files ********************************/
  {paninui/logic/includes/preproc_dotnetclasses.i &class=class}
  /************************  Source control constructor ************************/
  constructor public c_framelogicbase(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 14 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected        variable i_p_PackID           as int64 no-undo.
  define protected static variable iFrmLogicIDStatic    as int64 no-undo.
  define protected        variable iFrmLogicIDProtected as int64 no-undo.
  
  define property oUI as
    &if {&paninui_tty} &then
    /* TODO: oUI shortcut support for unix */
    Progress.Lang.Object
    &else
    paninui.logic.logicbase.c_framelogic_shortcut
    &endif 
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
    /* TODO: oUI shortcut support for unix */
    oUI = new paninui.logic.logicbase.c_framelogic_shortcut(this-object).
    &endif
    
  end constructor.


  method public void SetPack (oPackIP# as paninui.pack.interfaces.i_pack):
    assign 
      oPack      = oPackIP#
      i_p_PackID = oPackIP#:iPackID.

  end method. /* SetPack */ 


  method public logical InitializeFrameLogic():
    
    return true.
    
  end method. /* InitializeFrameLogic */


  method public logical InitializeFrameEvents():
    
    return true.
    
  end method. /* InitializeFrameEvents */


  method public logical InitializeFrameView():
    
    return true.
    
  end method. /* InitializeFrameView */


  method public void InitializeFrameViewShown():
    
    return.
    
  end method. /* InitializeFrameViewShown */


end class.

/* EOF */
