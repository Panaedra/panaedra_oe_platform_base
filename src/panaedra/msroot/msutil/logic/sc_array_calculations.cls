{panaedra/msi/logic/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_array_calculations   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_array_calculations.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-11-02 14:28:58+01:00 $ 
    Date Modified: $Modtime: 2009-11-02 14:28:27+01:00 $ 

      Description: Calculations for abl arrays with flexible extent.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_array_calculations(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  method public static void ArrayRemoveDuplicates(iSourceIP# as integer extent, output iCleanOP# as integer extent):
    
    /* An array with { ? , 4 , 3 , 6 , 3 , ? , 4 } becomes { 4 , 6 } */
    
    define variable iTell#           as integer no-undo.
    define variable iTellSearch#     as integer no-undo.
    define variable iTellSearchSub#  as integer no-undo.
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
/*          do iTellSearch# = 1 to iTell# - 1:*/
            do iTellSearchSub# = 1 to iTellCalc#:
              if iCalc#[iTellSearchSub#] =  iSourceIP#[iTell#] then next b_WalkExtent.
            end.
/*          end.*/
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

  end method. /* ArrayRemoveDuplicates */

end class.

/* EOF */ 
