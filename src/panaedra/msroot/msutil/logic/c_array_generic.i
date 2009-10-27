/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/c_array_generic.i $ 
        Version: $Revision: 5 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-10-27 05:06:59+01:00 $ 
  Date Modified: $Modtime: 2009-10-27 05:03:27+01:00 $ 

      Description: This include makes a variable sized array of any datatype, wrapping
                   the variable extent functionality of ABL.
                   
                   You can ask for any extent index, it will return {&VarNull} when not
                   existent.
                   
                   You can set any extent index, it will resize (in blocks of 
                   -a multitude of- 25) when needed, automatically.
                   
                   Note: first attempt was to use a property "{&VarPre}Value" with
                   variable extent. Due to progress language limitations this
                   was not possible - progress fails on the extent size
                   before the setter executes.
                   
                   The code looked something like this:

                   define public property {&VarPre}Value as {&VarType} extent
                   get(iIndexIP# as int):
                     define variable cReturn# as {&VarType} no-undo extent.
                     cReturn# = GetValueLocal(input-output {&VarPre}Value, input-output iIndexIP#).
                     return cReturn#[iIndexIP#].
                   end get.
                   set(iIndexIP# as int, {&VarPre}ValueIP# as char extent):
                     ...code...
                   end set.

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_c_array_generic_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_c_array_generic_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_c_array_generic_i $Revision: 5 $
/******************************* $NoKeywords:  $ *****************************/

  define protected static variable iDefaultExtentSizeInitial   as integer   no-undo init 25.
  define protected static variable iDefaultExtentSizeIncrement as integer   no-undo init 25.
  
  /* These two data members should be protected, but static methods need to be able to access them.
     Not possible yet at OE10.2A02.
   */
  define public           variable sys__{&VarPre}ValuePrimary          as {&VarType} no-undo extent.
  define public           variable sys__{&VarPre}ValueSecondary        as {&VarType} no-undo extent.
  
  define protected        variable bUseSecondary               as logical   no-undo.

  define public           variable iAddPosition                as integer   no-undo.
  
  define public property iExtent as integer 
    get:
      return GetLastUsedIndex(this-object, bUseSecondary).
    end get.
  
  
  method public void AddLast({&VarPre}ValueIP# as {&VarType}):
    
    iAddPosition = iAddPosition + 1.

    SetValueImplement(this-object, {&VarPre}ValueIP#, iAddPosition, input-output bUseSecondary).

  end method. /* AddLast */
    

  method public void SetValue(iIndexIP# as integer, {&VarPre}ValueIP# as {&VarType}):
    
    iAddPosition = max(iAddPosition, iIndexIP#).

    SetValueImplement(this-object, {&VarPre}ValueIP#, iIndexIP#, input-output bUseSecondary).
    
  end method. /* SetValue */
    

  method public {&VarType} GetValue(iIndexIP# as integer):

    return GetValueImplement(this-object, bUseSecondary, iIndexIP#).

  end method. /* GetValue */

  
  method protected static {&VarType} GetValueImplement(
    oThisIP#  as {&ClassType}, 
    bUseSecondaryIP# as logical,
    iIndexIP# as integer):

    if iIndexIP# <= 0 or iIndexIP# = ? then 
    do:
      undo, throw new Progress.Lang.AppError(subst("'&1' uses a wrong index of '&2'",program-name(3), iIndexIP#),99950101).
    end.
    
    if extent(oThisIP#:sys__{&VarPre}ValuePrimary) = ? and extent(oThisIP#:sys__{&VarPre}ValueSecondary) = ? then 
    do:
      return {&VarNull}.
    end.
    
    if not bUseSecondaryIP# then 
    do:
      if extent(oThisIP#:sys__{&VarPre}ValuePrimary) < iIndexIP# then 
        return {&VarNull}.
      else return oThisIP#:sys__{&VarPre}ValuePrimary[iIndexIP#].
    end.
    
    if bUseSecondaryIP# then 
    do:
      if extent(oThisIP#:sys__{&VarPre}ValueSecondary) < iIndexIP# then 
        return {&VarNull}.
      else return oThisIP#:sys__{&VarPre}ValueSecondary[iIndexIP#].
    end.
    
  end method. /* GetValueImplement */  
  
  
  method protected static void SetValueImplement(
    oThisIP#           as {&ClassType},
    {&VarPre}SetIP#            as {&VarType}, 
    iIndexIP#          as integer,
    input-output bUseSecondaryIOP#  as logical
    ):
      
    if not bUseSecondaryIOP#  then 
    do:
      if extent(oThisIP#:sys__{&VarPre}ValuePrimary) = 0 or extent(oThisIP#:sys__{&VarPre}ValuePrimary) = ?
        then SetNewExtentSize(oThisIP#, bUseSecondaryIOP#, iIndexIP#).
      if extent(oThisIP#:sys__{&VarPre}ValuePrimary) >= iIndexIP# then 
      do:
        oThisIP#:sys__{&VarPre}ValuePrimary[iIndexIP#] = {&VarPre}SetIP#.
      end.
      else 
      do:
        /* Doesn't fit, so use secondary array */
        extent(oThisIP#:sys__{&VarPre}ValueSecondary) = ?.
        SetNewExtentSize(oThisIP#, not bUseSecondaryIOP#, iIndexIP#).
        CopyArray(oThisIP#, bUseSecondaryIOP#).
        extent(oThisIP#:sys__{&VarPre}ValuePrimary) = ?.
        oThisIP#:sys__{&VarPre}ValueSecondary[iIndexIP#] = {&VarPre}SetIP#.
        bUseSecondaryIOP# = true.
      end.
    end.  

    else
    do:
      if extent(oThisIP#:sys__{&VarPre}ValueSecondary) = 0 or extent(oThisIP#:sys__{&VarPre}ValueSecondary) = ?
        then SetNewExtentSize(oThisIP#, bUseSecondaryIOP#, iIndexIP#).
      if extent(oThisIP#:sys__{&VarPre}ValueSecondary) >= iIndexIP# then
      do:
        oThisIP#:sys__{&VarPre}ValueSecondary[iIndexIP#] = {&VarPre}SetIP#.
      end.
      else
      do:
        /* Doesn't fit, so use primary array */
        extent(oThisIP#:sys__{&VarPre}ValuePrimary) = ?.
        SetNewExtentSize(oThisIP#, not bUseSecondaryIOP#, iIndexIP#).
        CopyArray(oThisIP#, bUseSecondaryIOP#).
        extent(oThisIP#:sys__{&VarPre}ValueSecondary) = ?.
        oThisIP#:sys__{&VarPre}ValuePrimary[iIndexIP#] = {&VarPre}SetIP#.
        bUseSecondaryIOP# = false.
      end.
    end.

  end method. /* SetValueImplement */  
  
  
  method protected static integer SetNewExtentSize(oThisIP# as {&ClassType}, bUseSecondaryIP# as logical, iNewSizeIP# as int):
    
    define variable iSize#          as integer no-undo.
    define variable iNumIncrements# as integer no-undo.
    
    iSize# = iDefaultExtentSizeInitial.
    
    if iNewSizeIP# > iSize# then 
    do:
      iNumIncrements# = trunc(dec(iNewSizeIP# - iSize# - 1) / iDefaultExtentSizeIncrement, 0) + 1.
      iSize# = iSize# + (iNumIncrements# * iDefaultExtentSizeIncrement).
    end.
    
    if not bUseSecondaryIP# then 
      extent(oThisIP#:sys__{&VarPre}ValuePrimary) = iSize#.
    else 
      extent(oThisIP#:sys__{&VarPre}ValueSecondary) = iSize#.
    
  end method. /* SetNewExtentSize */
  
  
  method protected static void CopyArray(oThisIP# as {&ClassType}, bUseSecondaryIP# as logical):
    
    define variable iTell# as integer no-undo.
    
    if not bUseSecondaryIP# then 
    do iTell# = 1 to extent(oThisIP#:sys__{&VarPre}ValuePrimary):
      oThisIP#:sys__{&VarPre}ValueSecondary[iTell#] = oThisIP#:sys__{&VarPre}ValuePrimary[iTell#].
    end.
    else 
    do iTell# = 1 to extent(oThisIP#:sys__{&VarPre}ValueSecondary):
      oThisIP#:sys__{&VarPre}ValuePrimary[iTell#] = oThisIP#:sys__{&VarPre}ValueSecondary[iTell#].
    end.

  end method. /* CopyArray */


  method protected static integer GetLastUsedIndex(oThisIP# as {&ClassType}, bUseSecondaryIP# as logical):

    define variable iTell#   as integer no-undo.
    define variable iReturn# as integer no-undo.
    define variable iExtent# as integer no-undo.
    
    if not bUseSecondaryIP# then
    b_LastIndexPri: 
    do iTell# = extent(oThisIP#:sys__{&VarPre}ValuePrimary) to 1 by -1:
      if oThisIP#:sys__{&VarPre}ValuePrimary[iTell#] <> ? 
      and oThisIP#:sys__{&VarPre}ValuePrimary[iTell#] <> {&VarNull} 
      then do:
        iReturn# = iTell#.
        leave b_LastIndexPri.
      end.
    end.
    else
    b_LastIndexSec: 
    do iTell# = extent(oThisIP#:sys__{&VarPre}ValueSecondary) to 1 by -1:
      if  oThisIP#:sys__{&VarPre}ValueSecondary[iTell#] <> ? 
      and oThisIP#:sys__{&VarPre}ValueSecondary[iTell#] <> {&VarNull} 
      then do:
        iReturn# = iTell#.
        leave b_LastIndexSec.
      end.
    end.
    
    if iReturn# >= 1 then.
    else iReturn# = 0.
    
    return iReturn#.
    
  end method. /* GetLastUsedIndex */

  
  method public void ClearAll():
    
    extent(sys__{&VarPre}ValuePrimary)   = ?.
    extent(sys__{&VarPre}ValueSecondary) = ?.
    iAddPosition = 0.
    
  end method. /* OnDestructor */


  method protected void OnDestructor():
    
    ClearAll().
    
  end method. /* OnDestructor */

&endif /* {&dvcs__panaedra_msroot_msutil_logic_c_array_generic_i} */

/* EOF : panaedra/msroot/msutil/logic/c_array_generic.i */ 
