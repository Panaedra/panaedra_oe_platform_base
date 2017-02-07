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
  
  
  method public static logical IsTrue(bBoolIP# as logical):
  
    return (bBoolIP# <> ?) and (bBoolIP# = true).
  
  end method. /* IsTrue ; logical */
 
  
  method public static logical ZeroOrPositive(fFloatIP# as decimal):
  
    return (fFloatIP# <> ?) and (fFloatIP# >= 0).
  
  end method. /* ZeroOrPositive */
  
  
  method public static logical ZeroOrPositive(iIntIP# as integer):
    
    return (iIntIP# <> ?) and (iIntIP# >= 0).
      
  end method. /* ZeroOrPositive */
  
  
  method public static character DecodeBase64(
    
    /* Convert a base64 string to a character string */
    
    cDataToDecodeIP# as character
    ):
  
    define variable cEncoded#    as character no-undo.
    define variable mDecoded#    as memptr    no-undo.
    define variable clobDecoded# as longchar  no-undo.
    define variable cDecoded#    as character no-undo.

    cEncoded# = cDataToDecodeIP#.
 
    mDecoded# = base64-decode(cEncoded#).
  
    copy-lob from mDecoded# to clobDecoded# no-convert.
      
    set-size(mDecoded#) = 0.
   
    cDecoded# = string(clobDecoded#).
    
    return cDecoded#.
    
  end method. /* DecodeBase64 */
 
end class.

/* EOF */ 
