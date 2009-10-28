{panaedra/msi/logic/ctop_class.i}

class paninui.logic.logicbase.c_framelogicbase 
  inherits 
  paninui.view.framebase.c_uiframe 
  implements 
  paninui.view.interfaces.i_frmlogic: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/logic/logicbase/c_framelogicbase.cls $ 
          Version: $Revision: 9 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-28 15:00:50+01:00 $ 
    Date Modified: $Modtime: 2009-10-28 14:39:29+01:00 $ 

      Description: Baseclass for frame logic classes.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_framelogicbase(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 9 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected        variable i_p_PackID           as int64 no-undo.
  define protected static variable iFrmLogicIDStatic    as int64 no-undo.
  define protected        variable iFrmLogicIDProtected as int64 no-undo.
  
  define public property oUI as paninui.logic.logicbase.c_framelogic_shortcut no-undo get. protected set.

  define property iPackID as int64 
    public get:
      return i_p_PackID.
    end get.


  define property iFrmLogicID as int64 
    public get:
      return iFrmLogicIDProtected.
    end get.
  

  constructor public c_framelogicbase():
    assign 
      iFrmLogicIDStatic    = iFrmLogicIDStatic + 1
      iFrmLogicIDProtected = iFrmLogicIDStatic.
    oUI = new paninui.logic.logicbase.c_framelogic_shortcut(this-object).
  end constructor.


  method public void SetPackID (oPackIP# as paninui.pack.interfaces.i_pack):
    
    i_p_PackID = oPackIP#:UniqueInstanceID.

  end method. /* SetIDPack */ 


  method public logical InitializeFrameLogic():
    
    return true.
    
  end method. /* InitializeFrameLogic */


  method public logical InitializeFrameEvents():
    
    return true.
    
  end method. /* InitializeFrameEvents */


  method public logical InitializeFrameView():
    
    return true.
    
  end method. /* InitializeFrameView */


  method public logical InitializeFrameViewShown():
    
    return true.
    
  end method. /* InitializeFrameViewShown */


end class.

/* EOF */
