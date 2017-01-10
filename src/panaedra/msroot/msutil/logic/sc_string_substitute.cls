using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_string_substitute: 

  /****************************** Source Header ********************************\

      Description: String substitution, for example os-environment vars inside strings

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/


  method public static character ExpandOsEnv
    
    /* See other overload. */
       
    (cInputIP# as character):
    
    return ExpandOsEnv(cInputIP#, false).
    
  end method. /* ExpandOsEnv , with 'strip unset' to false */


  method public static character ExpandOsEnv
    
    /* This method first tries explicit unix syntax. 
       Example: "sometext$~{MyVar~}and$~{MySecondVar~}lorumipsum"
       If unix syntax is not found, "%"'s (windows standard) are tried.
       
       If bStripUnsetOsEnvIP# is false, "%MyVar%" will return "%MyVar%" if the environment variable is not set.
       If bStripUnsetOsEnvIP# is true , "%MyVar%" will return ""        if the environment variable is not set.
       
    */
    
    (cInputIP#           as character,
     bStripUnsetOsEnvIP# as logical):   
    
    define variable iIndex#      as integer   no-undo.
    define variable iIndexStart# as integer   no-undo.
    define variable iIndexEnd#   as integer   no-undo.
    define variable iEnd#        as integer   no-undo.
    define variable cOsEnv#      as character no-undo.
    
    iIndex# = index(cInputIP#,'$').
    
    if iIndex# > 0 then 
    do on error undo, throw:
    
      b_walkdollar:
      do while iIndex# > 0:
      
        assign
          iEnd#   = index(cInputIP#,'~}', iIndex#).
          
        if ((iIndex# + 2) <= 0) or ((iEnd# - iIndex# - 2) <= 0) then leave b_walkdollar. /* This can happen if string ends with (literal) dollar sign */
          
        assign
          cOsEnv# = os-getenv(substring(cInputIP#, iIndex# + 2, iEnd# - iIndex# - 2)).
        
        if cOsEnv# = ? then do:
          if bStripUnsetOsEnvIP# then cOsEnv# = "". 
          else cOsEnv# = substring(cInputIP#, iIndex# + 2, iEnd# - iIndex# - 2).
        end.
        
        if (iIndex# <= 0 ) or ((iEnd# - iIndex# + 1) <= 0) then leave b_walkdollar.  /* This can happen if string ends with (literal) dollar sign */
        
        substring(cInputIP#, iIndex#, iEnd# - iIndex# + 1) = cOsEnv#.
      
        iIndex# = index(cInputIP#,'$').
       
      end.
      
      catch oError# as Progress.Lang.Error:
        /* Nothing to do. Extra safety, this happened once during an exceptional error flow, hiding original error. */
      end catch.
     
    end. /* dollar sign found */
    else 
    do:
      
      iIndexStart# = index(cInputIP#,'%').
      
      if iIndexStart# > 0 then
      b_search_dollar: 
      do on error undo, throw:
        
        do while iIndexStart# > 0:
          
          iIndexEnd# = index(cInputIP#,'%',iIndexStart# + 1).
          
          if iIndexEnd# = 0 then leave b_search_dollar.
          
          else 
          do:
            
            cOsEnv# = os-getenv(substring(cInputIP#, iIndexStart# + 1, iIndexEnd# - iIndexStart# - 1)).
            
            if sc_data:HasValue(cOsEnv#) or bStripUnsetOsEnvIP# then do: 
              if not sc_data:HasValue(cOsEnv#) then cOsEnv# = "".
              substring(cInputIP#, iIndexStart#, iIndexEnd# - iIndexStart# + 1) = cOsEnv#.
            end.
           
            assign
              iIndexStart# = index(cInputIP#,'%',iIndexEnd# + 1).
            iIndexEnd#   = 0.
          end.
          
        end.
        
        catch oError# as Progress.Lang.Error:
          /* Nothing to do. Extra safety, this happened once during an exceptional error flow, hiding original error. */
        end catch.
        
      end.
      
    end.
    
    return cInputIP#.
  
  end method. /* ExpandOsEnv , with bStripUnsetOsEnvIP# */

end class.

/* EOF */
