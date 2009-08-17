{panaedra/msi/logic/ctop_class.i}

class panaedra.msdr.logic.c_triggerlogicdata   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msdr/logic/c_triggerlogicdata.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-08-17 13:40:12+02:00 $ 
    Date Modified: $Modtime: 2009-08-17 13:31:10+02:00 $ 

      Description: Bevat data en methods voor de communicatie van trigger logic en sc_dbtrig.

  \*****************************  Include Files ********************************/
  
  {panaedra/msdr/logic/c_triggerlogicdata_tt.i &class=class &protected=protected}
  
  /************************  Source control constructor ************************/
  constructor public c_triggerlogicdata(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
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


  method public void ZyzSetBuffers (hBuffIP# as handle, hBuffOldIP# as handle):
    
    define variable bEclipseFix# as logical no-undo.
    
    define buffer b-ttTriggerLogicData for ttTriggerLogicData. 
    
    for each b-ttTriggerLogicData where not b-ttTriggerLogicData.bBuffersAreSet:
      assign
        b-ttTriggerLogicData.bBuffersAreSet = true
        b-ttTriggerLogicData.hBuff          = hBuffIP#
        b-ttTriggerLogicData.hBuffOld       = hBuffOldIP#.
    end.
    
  end method. /* ZyzSetBuffers */
  

  method public logical ZyzHasErrorText ():
    
    define variable bEclipseFix# as logical no-undo.
    
    define buffer b-ttTriggerLogicData for ttTriggerLogicData.
    
    return can-find(first b-ttTriggerLogicData where b-ttTriggerLogicData.cError > ""). 
    
  end method. /* ZyzHasErrorText */
  
  
  method public character ZyzFirstErrorText ():
    
    define variable bEclipseFix# as logical no-undo.
    
    define buffer b-ttTriggerLogicData for ttTriggerLogicData.
    
    find first b-ttTriggerLogicData where b-ttTriggerLogicData.cError > "".
    
    return b-ttTriggerLogicData.cError. 
    
  end method. /* ZyzFirstErrorText */
  

end class. /* panaedra.msdr.logic.c_triggerlogicdata */

/* EOF */
