using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_string_analysis: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_string_analysis.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:13+01:00 $ 

      Description: String analysys ; i.e. does a string contain numbers

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_string_analysis(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  constructor protected sc_string_analysis(
    input oParamIP# as i_unittest_param):
  end constructor.  

  method public static logical ContainsNumbers(
    
    /* Does a string contain numbers? I.E.: myprer0g4tive */
    
    cInputIP# as character):
    
    define variable iChar# as integer no-undo.
    
    do iChar# = 0 to 9:
      if index(cInputIP#, chr(asc("0") + iChar#)) > 0 then return true. 
    end.
    
    return false.

  end method. /* ContainsNumbers */
  

  method public static logical ContainsOnlyNumbers(
  
    /* Does a string contain only numbers? I.E.: '12345' (not: ' 12345' / '-12345' / 'myprer0g4tive') */
    
    cInputIP# as character):
    
    define variable iChar#  as integer   no-undo.
    define variable cLett#  as character no-undo.
    define variable iAscii# as integer   no-undo.
    
    do iChar# = 1 to length(cInputIP#):
      cLett# = substring(cInputIP#,iChar#,1). 
      if index("1234567890", cLett#) = 0 then return false. 
    end.
    
    return true.

  end method. /* ContainsOnlyNumbers */
  

  method public static logical ContainsChars(
    
    /* Does a string contain any of the supplied characters? I.E.: mypre.r0g4tive ., -> true */
    
    cInputIP#  as character,
    cTokensIP# as character):
    
    define variable iToken#    as integer no-undo.
    define variable iHasToken# as logical no-undo. 
    
    do iToken# = 1 to length(cTokensIP#) while not iHasToken#:
      if index(cInputIP#, substring(cTokensIP#, iToken#, 1)) > 0 then iHasToken# = true. 
    end.
    
    return iHasToken#.

  end method. /* ContainsChars */
  
  
  method public static logical ContainsNonAscii(
    input  cInputIP# as character
    ):
      
    define variable iDummy as integer no-undo.
    
    return ContainsNonAscii(input cInputIP#, output iDummy).
  
  end method. /* ContainsNonAscii */
  
  
  method public static logical ContainsNonAscii(
    
    /* Does a string contain a character with an ascii code higher then 127? I.E. "谷" -> true. If so output its index*/
    
    input  cInputIP#         as character,
    output iCharPositionOP#  as integer):
    
    define variable iChar#        as integer no-undo.
    define variable bHasNonAscii# as logical no-undo. 
    
    do iChar# = 1 to length(cInputIP#) while not bHasNonAscii#:
      if asc(substring(cInputIP#, iChar#, 1)) > 127 then 
        assign 
          iCharPositionOP# = iChar#
          bHasNonAscii#    = true. 
    end.
    
    return bHasNonAscii#.

  end method. /* ContainsNonAscii */
  
  
  method public static logical HasInvalidChars(
  
    /* Checks if the input string contains any of the specified invalid characters in this method */ 
    input cStringIP# as character  
    ):
  
    /* Default specified set with invalid characters */ 
    define variable cInvalidChars# as character initial " ~~!@#$%^&*()_+~}~{|~":?><`-=[]';/~\," no-undo.
    
    /* Call ContainsChars method to perform the search for invalid characters according to the input cInvalidChars# set */ 
    return ContainsChars(input cStringIP#, input cInvalidChars#).
      
  end method. /* HasInValidChars */ 


  @panaedraannotation file(unittest="yes").
  method public static logical IsInteger(
  
    /* Determine if a string contains an integer:
     - ?      returns false
     - 123.45 returns false
     - 123,45 returns false
     - abcdef returns false, etcetera 
     
     Exception for leading/trailing spaces and leading zeros:
     - "0012" returns true
     - "  12" returns true
     - " 012" returns true
     - "12  " returns true, etcetera */

    input cValueIP# as character
    ):
    
    define variable cValue# as character no-undo.
    define variable iValue# as integer   no-undo.
    
    cValue# = cValueIP#.
    
    /* we accept " - 12" as integer, so we have to check for the minus first: */
    if trim(cValue#) begins "-" then
    do:
      cValue# = left-trim(trim(cValue#),"-").
      if trim(cValue#) begins "-" then /* not another minus! */ 
        return false.
    end.
    
    iValue# = int(cValue#) no-error.
    if error-status:error or
      cValue# = ? or
      (trim(cValue#) <> "0" and
      string(iValue#) <> left-trim(trim(cValue#),"0")) then
      return false.
      
    return true.
  
  end method. /* IsInteger */


  method public static logical ContainsOnlySuppliedChars(
    /* Does a string contain only the supplied characters? */
    cStringIP#        as character,
    cSuppliedCharsIP# as character):
    
    define variable iCount#                     as integer no-undo.
    define variable bContainsOnlySuppliedChars# as logical no-undo init true. 
    
    do iCount# = 1 to length(cStringIP#):
      if index(cSuppliedCharsIP#, substring(cStringIP#,iCount#,1)) = 0 then 
      do:
        bContainsOnlySuppliedChars# = false.
        leave.
      end. 
    end.
    
    return bContainsOnlySuppliedChars#.

  end method. /* ContainsOnlySuppliedChars */
      
end class.

/* EOF */ 

