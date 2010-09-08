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
    
    /* This method expects explicit unix syntax. 
       Example: "sometext$~{MyVar~}and$~{MySecondVar~}lorumipsum" */
       
    (cInputIP# as character):   
    
    define variable iIndex# as integer   no-undo.
    define variable iEnd#   as integer   no-undo.
    define variable cOsEnv# as character no-undo.
    
    iIndex# = index(cInputIP#,'$').
    
    do while iIndex# > 0:
      
      assign
        iEnd#   = index(cInputIP#,'~}', iIndex#)
        cOsEnv# = os-getenv(substring(cInputIP#, iIndex# + 2, iEnd# - iIndex# - 2)).
        
      if cOsEnv# = ? then 
        cOsEnv# = substring(cInputIP#, iIndex# + 2, iEnd# - iIndex# - 2).
        
      substring(cInputIP#, iIndex#, iEnd# - iIndex# + 1) = cOsEnv#.
      
      iIndex# = index(cInputIP#,'$').
      
    end.
    
    return cInputIP#.
  
  end method. /* ExpandOsEnv */

end class.

/* EOF */ 
