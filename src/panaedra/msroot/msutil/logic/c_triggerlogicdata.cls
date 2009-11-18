{panaedra/msi/logic/ctop_class.i}

class panaedra.msdr.logic.c_triggerlogicdata   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msdr/logic/c_triggerlogicdata.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-11-18 11:36:26+01:00 $ 
    Date Modified: $Modtime: 2009-11-18 09:49:33+01:00 $ 

      Description: Bevat data en methods voor de communicatie van trigger logic en sc_dbtrig.

  \*****************************  Include Files ********************************/
  
  {panaedra/msdr/logic/c_triggerlogicdata_tt.i &class=class &protected=protected}
  
  /************************  Source control constructor ************************/
  constructor public c_triggerlogicdata(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  constructor public c_triggerlogicdata():
  end constructor.

  
  define protected variable iOrderCounter as integer no-undo.
  
  
  method public void FieldError (iErrorIP# as int, cErrorIP# as char ):
    
    define variable bEclipseFix# as logical no-undo.
    
    define buffer b-ttTriggerLogicData for ttTriggerLogicData.
    define buffer b_ttTriggerLogicData for ttTriggerLogicData.
    
    create b-ttTriggerLogicData.
    
    assign 
      iOrderCounter                     = iOrderCounter + 1
      b-ttTriggerLogicData.iOrder       = iOrderCounter
      b-ttTriggerLogicData.bShowAsError = true
      b-ttTriggerLogicData.iError       = iErrorIP#
      b-ttTriggerLogicData.cError       = cErrorIP#.

  end method. /* FieldError */
  

  method public void FieldWarning (iErrorIP# as int, cErrorIP# as char ):
    
    define variable bEclipseFix# as logical no-undo.
    
    define buffer b-ttTriggerLogicData for ttTriggerLogicData.
    define buffer b_ttTriggerLogicData for ttTriggerLogicData.
    
    create b-ttTriggerLogicData.
    
    assign 
      iOrderCounter                       = iOrderCounter + 1
      b-ttTriggerLogicData.iOrder         = iOrderCounter
      b-ttTriggerLogicData.bShowAsWarning = true
      b-ttTriggerLogicData.iError         = iErrorIP#
      b-ttTriggerLogicData.cError         = cErrorIP#.

  end method. /* FieldWarning */
  

  method public void FieldConfirmation (iErrorIP# as int, cErrorIP# as char ):
    
    define variable bEclipseFix# as logical no-undo.
    
    define buffer b-ttTriggerLogicData for ttTriggerLogicData.
    define buffer b_ttTriggerLogicData for ttTriggerLogicData.
    
    create b-ttTriggerLogicData.
    
    assign 
      iOrderCounter                            = iOrderCounter + 1
      b-ttTriggerLogicData.iOrder              = iOrderCounter
      b-ttTriggerLogicData.bShowAsConfirmation = true
      b-ttTriggerLogicData.iError              = iErrorIP#
      b-ttTriggerLogicData.cError              = cErrorIP#.

  end method. /* FieldConfirmation */


  method public void _sys_SetBuffers (hBuffIP# as handle, hBuffOldIP# as handle):
    
    define variable bEclipseFix# as logical no-undo.
    
    define buffer b-ttTriggerLogicData for ttTriggerLogicData. 
    
    for each b-ttTriggerLogicData where not b-ttTriggerLogicData.bBuffersAreSet:
      assign
        b-ttTriggerLogicData.bBuffersAreSet = true
        b-ttTriggerLogicData.hBuff          = hBuffIP#
        b-ttTriggerLogicData.hBuffOld       = hBuffOldIP#.
    end.
    
  end method. /* _sys_SetBuffers */
  

  method public logical _sys_HasErrorText ():
    
    define variable bEclipseFix# as logical no-undo.
    
    define buffer b-ttTriggerLogicData for ttTriggerLogicData.
    
    return can-find(first b-ttTriggerLogicData where b-ttTriggerLogicData.cError > ""). 
    
  end method. /* _sys_HasErrorText */
  
  
  method public character _sys_FirstErrorText ():
    
    define variable bEclipseFix# as logical no-undo.
    
    define buffer b-ttTriggerLogicData for ttTriggerLogicData.
    
    find first b-ttTriggerLogicData where b-ttTriggerLogicData.cError > "".
    
    return b-ttTriggerLogicData.cError. 
    
  end method. /* _sys_FirstErrorText */
  

end class. /* panaedra.msdr.logic.c_triggerlogicdata */

/* EOF */
