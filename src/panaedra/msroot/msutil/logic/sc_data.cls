{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_data: 

  /****************************** Source Header ********************************\

      Description: Generic data methods

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define public static variable iMinInt as integer no-undo init -2147483648.
  define public static variable iMaxInt as integer no-undo init 2147483647.
  
  
  method public static logical HasValue(cStringIP# as character):
  
    return (cStringIP# <> ?) and (length(trim(cStringIP#)) > 0).
  
  end method. /* HasValue ; character */
 
 
  method public static logical HasValue(clobStringIP# as longchar):
  
    return (clobStringIP# <> ?) and (length(trim(clobStringIP#)) > 0).
  
  end method. /* HasValue ; longchar */
  
 
  method public static logical HasValue(fFloatIP# as decimal):
  
    return (fFloatIP# <> ?) and (fFloatIP# <> 0).
  
  end method. /* HasValue ; decimal */
 
 
  method public static logical HasValue(iIntIP# as integer):
  
    return (iIntIP# <> ?) and (iIntIP# <> 0).
  
  end method. /* HasValue ; integer */
  
 
  method public static logical HasValue(iIntIP# as int64):
  
    return (iIntIP# <> ?) and (iIntIP# <> 0).
  
  end method. /* HasValue ; int64 */
 
end class.

/* EOF */ 
