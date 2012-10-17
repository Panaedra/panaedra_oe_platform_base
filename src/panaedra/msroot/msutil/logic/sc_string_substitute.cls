using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_string_substitute: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: String substitution, for example os-environment vars inside strings

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_string_substitute(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/


  method public static character ExpandOsEnv
    
    /* This method first tries explicit unix syntax. 
       Example: "sometext$~{MyVar~}and$~{MySecondVar~}lorumipsum"
       If unix syntax is not found, "%"'s (windows standard) are tried.
    */
       
    (cInputIP# as character):   
    
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
        
        if cOsEnv# = ? then 
          cOsEnv# = substring(cInputIP#, iIndex# + 2, iEnd# - iIndex# - 2).
        
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

            if cOsEnv# > "" then 
              substring(cInputIP#, iIndexStart#, iIndexEnd# - iIndexStart# + 1) = cOsEnv#.
           
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
  
  end method. /* ExpandOsEnv */

end class.

/* EOF */
