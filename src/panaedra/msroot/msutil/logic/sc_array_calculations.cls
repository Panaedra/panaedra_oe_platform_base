{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_array_calculations   : 

  /****************************** Source Header ********************************\

      Description: Calculations for abl arrays with flexible extent.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/


  method public static void ArrayRemoveDuplicates(iSourceIP# as integer extent, output iCleanOP# as integer extent):
    
    /* An array with { ? , 4 , 3 , 3 , 6 , 3 , ? , 4 } becomes { 4 , 3 , 6 } */
    
    define variable iTell#           as integer no-undo.
    define variable iTellSearch#     as integer no-undo.
    define variable iTellCalc#       as integer no-undo.
    define variable iCalc#           as integer no-undo extent.
    define variable bDuplicateFound# as logical no-undo.
    
    extent(iCalc#) = extent(iSourceIP#).
    iCalc# = ?.
    
    b_WalkExtent:
    do iTell# = 1 to extent(iSourceIP#):
      
      if iSourceIP#[iTell#] <> ? then 
      do:
        
        if iCalc#[1] = ? then 
        do:
          /* Assign the first value in the array */
          assign
            iTellCalc#         = iTellCalc# + 1
            iCalc#[iTellCalc#] = iSourceIP#[iTell#].
        end.
        else 
        do:
          /* Look for duplicates */
          do iTellSearch# = 1 to iTellCalc#:
            if iCalc#[iTellSearch#] =  iSourceIP#[iTell#] then next b_WalkExtent.
          end.
          /* Assign a new value in the array */
          assign
            iTellCalc#         = iTellCalc# + 1
            iCalc#[iTellCalc#] = iSourceIP#[iTell#].
        end.
      end.
        
    end.
    
    extent(iCleanOP#) = iTellCalc#.
    
    do iTell# = 1 to iTellCalc#:
      iCleanOP#[iTell#] = iCalc#[iTell#].
    end. 
    
    extent(iCalc#) = ?.

  end method. /* ArrayRemoveDuplicates ; integer */
  

  method public static int64 extent ArrayRemoveDuplicates(iSourceIP# as int64 extent):
    
    /* An array with { ? , 4 , 3 , 3 , 6 , 3 , ? , 4 } becomes { 4 , 3 , 6 } */
    
    define variable iTell#           as integer no-undo.
    define variable iTellSearch#     as integer no-undo.
    define variable iTellCalc#       as integer no-undo.
    define variable iCalc#           as int64   no-undo extent.
    define variable iCleanOP#        as int64   no-undo extent.
    
    extent(iCalc#) = extent(iSourceIP#).
    iCalc# = ?.
    
    b_WalkExtent:
    do iTell# = 1 to extent(iSourceIP#):
      
      if iSourceIP#[iTell#] <> ? then 
      do:
        
        if iCalc#[1] = ? then 
        do:
          /* Assign the first value in the array */
          assign
            iTellCalc#         = iTellCalc# + 1
            iCalc#[iTellCalc#] = iSourceIP#[iTell#].
        end.
        else 
        do:
          /* Look for duplicates */
          do iTellSearch# = 1 to iTellCalc#:
            if iCalc#[iTellSearch#] =  iSourceIP#[iTell#] then next b_WalkExtent.
          end.
          /* Assign a new value in the array */
          assign
            iTellCalc#         = iTellCalc# + 1
            iCalc#[iTellCalc#] = iSourceIP#[iTell#].
        end.
      end.
        
    end.
    
    extent(iCleanOP#) = iTellCalc#.
    
    do iTell# = 1 to iTellCalc#:
      /* Copy each value to the return parameter with the correct extent */
      iCleanOP#[iTell#] = iCalc#[iTell#].
    end. 
    
    /* Cleanup resources */
    extent(iCalc#) = ?.
    
    return iCleanOP#.

  end method. /* ArrayRemoveDuplicates ; int64 */

end class.

/* EOF */ 
