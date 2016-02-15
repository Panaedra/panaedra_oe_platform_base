{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_data: 

  /****************************** Source Header ********************************\

      Description: Generic data methods

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define public static variable iMinInt as integer no-undo init -2147483648.
  define public static variable iMaxInt as integer no-undo init 2147483647.
  
  method public static logical HasValue(
  
    input cStringIP# as character
    ):
  
    return (cStringIP# <> ?) and (length(trim(cStringIP#)) > 0).
  
  end method. /* HasValue */
 
end class.

/* EOF */ 