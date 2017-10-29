{panaedra/msroot/msutil/logic/top_i/ctop_class.i}

class panaedra.msroot.msutil.logic.c_triggerlogicdata: 

  /****************************** Source Header ********************************\

      Description: Data and methods for communication between trigger logic and sc_dbtrig.

  \*****************************  Include Files ********************************/
  {panaedra/msroot/msutil/logic/tt/c_triggerlogicdata_tt.i &class=class &protected=protected}
  /******************************* $NoKeywords:  $ *****************************/

  constructor public c_triggerlogicdata():
  end constructor.

  
  define protected variable iOrderCounter as integer no-undo.
  
  
  method public void FieldError (iErrorIP# as int, cErrorIP# as char ):
    
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
    
    define buffer b-ttTriggerLogicData for ttTriggerLogicData. 
    
    for each b-ttTriggerLogicData where not b-ttTriggerLogicData.bBuffersAreSet
      on error undo, throw:
      assign
        b-ttTriggerLogicData.bBuffersAreSet = true
        b-ttTriggerLogicData.hBuff          = hBuffIP#
        b-ttTriggerLogicData.hBuffOld       = hBuffOldIP#.
    end.
    
  end method. /* _sys_SetBuffers */
  

  method public logical _sys_HasErrorText ():
    
    define buffer b-ttTriggerLogicData for ttTriggerLogicData.
    
    return can-find(first b-ttTriggerLogicData where b-ttTriggerLogicData.cError > "" and length(b-ttTriggerLogicData.cError) > 0). /* codeQok#7122 */ 
    
  end method. /* _sys_HasErrorText */
  
  
  method public character _sys_FirstErrorText ():
    
    define buffer b-ttTriggerLogicData for ttTriggerLogicData.
    
    find first b-ttTriggerLogicData where b-ttTriggerLogicData.cError > "" and length(b-ttTriggerLogicData.cError) > 0. /* codeQok#7122 */
    
    return b-ttTriggerLogicData.cError. 
    
  end method. /* _sys_FirstErrorText */
  

  method public integer _sys_FirstErrorNum ():
    
    define buffer b-ttTriggerLogicData for ttTriggerLogicData.
    
    find first b-ttTriggerLogicData where b-ttTriggerLogicData.cError > "" and length(b-ttTriggerLogicData.cError) > 0. /* codeQok#7122 */
    
    return b-ttTriggerLogicData.iError. 
    
  end method. /* _sys_FirstErrorText */
  

end class. /* panaedra.msroot.msutil.logic.c_triggerlogicdata */

/* EOF */
