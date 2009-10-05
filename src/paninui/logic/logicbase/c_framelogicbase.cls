{panaedra/msi/logic/ctop_class.i}

class paninui.logic.logicbase.c_framelogicbase 
  inherits 
  paninui.view.framebase.c_uiframe 
  implements 
  paninui.view.interfaces.i_frmlogic,  
  tool.i-frm-join_base: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/logic/logicbase/c_framelogicbase.cls $ 
          Version: $Revision: 5 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-05 14:48:49+02:00 $ 
    Date Modified: $Modtime: 2009-10-05 11:57:59+02:00 $ 

      Description: Baseclass for frame logic classes.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_framelogicbase(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 5 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected        variable i_p_PackID           as int64 no-undo.
  define protected static variable iFrmLogicIDStatic    as int64 no-undo.
  define protected        variable iFrmLogicIDProtected as int64 no-undo.
  

  constructor public c_framelogicbase():
    assign 
      iFrmLogicIDStatic    = iFrmLogicIDStatic + 1
      iFrmLogicIDProtected = iFrmLogicIDStatic.
  end constructor.


  define property iPackID as int64 
    public get:
      return i_p_PackID.
    end get.


  define property iFrmLogicID as int64 
    public get:
      return iFrmLogicIDProtected.
    end get.
  

  define property UniqueUiLogicName as character no-undo 
    public get:
      return subst("&1_&2", this-object:ToString(), trim(string(iFrmLogicIDProtected))).
    end get.


  define property oJoiner as tool.c-ui_joiner no-undo 
    public get. 
    public set.


  method public void SetPackID (oPackIP# as paninui.pack.interfaces.i_pack):
    
    i_p_PackID = oPackIP#:UniqueInstanceID.

  end method. /* SetIDPack */ 


  method public logical InitializeFrameLogic():
    
    /* A better implementation would be the "virtual" keyword, but ABL 10.2A doesn't support that. */
    undo, throw new Progress.Lang.AppError(subst("Base class method '&1' should be overridden",program-name(1))).
    
  end method. /* InitializeFrameLogic */


  method public logical InitializeFrameEvents():
    
    /* A better implementation would be the "virtual" keyword, but ABL 10.2A doesn't support that. */
    undo, throw new Progress.Lang.AppError(subst("Base class method '&1' should be overridden",program-name(1))).
    
  end method. /* InitializeFrameEvents */


  method public logical InitializeFrameView():
    
    /* A better implementation would be the "virtual" keyword, but ABL 10.2A doesn't support that. */
    undo, throw new Progress.Lang.AppError(subst("Base class method '&1' should be overridden",program-name(1))).
    
  end method. /* InitializeFrameView */


end class.

/* EOF */
