{panaedra/msi/logic/ctop_class.i}

class paninui.logic.logicbase.c_framelogicbase  implements paninui.view.interfaces.i_frmlogic : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/logic/logicbase/c_framelogicbase.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-08-31 10:34:56+02:00 $ 
    Date Modified: $Modtime: 2009-08-31 10:34:56+02:00 $ 

      Description: Baseclass for frame logic classes.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_framelogicbase(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected variable i_p_PackID as int64 no-undo.
  
  constructor public c_framelogicbase():
  end constructor.

  method public logical InitializeFrameLogic():
    
    undo, throw new Progress.Lang.AppError("Base class method should be overridden").
    
  end method.

  define property iPackID as int64 
    public get:
      return i_p_PackID.
    end get.
  
  method public void SetPackID (oPackIP# as paninui.view.interfaces.i_pack):
    
    i_p_PackID = oPackIP#:UniqueInstanceID.

  end method. /* SetIDPack */

end class.

/* EOF */
