using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msutil.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_string_analysis_unittests
  inherits panaedra.msroot.msutil.logic.sc_string_analysis
  implements panaedra.msroot.msutil.interfaces.i_unittest_client:    

  /******************************  Source Header *******************************\

      Description: unittests for sc_string_analysis
      
       
  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_string_analysis_unittests(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    super(o-sourcecontrol, this-object).
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.


  constructor public sc_string_analysis_unittests(
    input oParamIP# as i_unittest_param):
    super(oParamIP#).
  end constructor.

  
  method public void GetUnittests(
    output cSvUnittestsOP# as character):
     
    cSvUnittestsOP# = "UT_IsInteger".
    
  end method. /* GetUnittests */
 

  method public void ExecuteUnittest(
    cUnittestIP# as character):

    case cUnittestIP#:

      when "UT_IsInteger" then UT_IsInteger(cUnittestIP#).

      otherwise
      undo, throw new c_panaedraexception(
        55582911,
        sc_lang:oEnglish,
        substitute("Unknown unit test: '&1'", cUnittestIP#)).      
        
    end case.
    
  end method. /* ExecuteUnittest */
  
  
  method public void UT_IsInteger(
    cUnittestIP# as character):
    
    sc_unittest:UnittestInit(this-object, cUnittestIP#).
    
    unittest1:
    do transaction on error undo, throw:
      
      sc_unittest:Assert(
        "IsInteger_00001_01",
        "nul",
        sc_string_analysis:IsInteger("0"),
        true
        ).
      
      sc_unittest:Assert(
        "IsInteger_00001_02",
        "min",
        sc_string_analysis:IsInteger("-"),
        false
        ).
      
      sc_unittest:Assert(
        "IsInteger_00001_03",
        "plus",
        sc_string_analysis:IsInteger("+"),
        false
        ).
      
      sc_unittest:Assert(
        "IsInteger_00001_04",
        "a",
        sc_string_analysis:IsInteger("a"),
        false
        ).
      
      sc_unittest:Assert(
        "IsInteger_00001_05",
        "9999999999",
        sc_string_analysis:IsInteger("9999999999"),
        false
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_06",
        "1",
        sc_string_analysis:IsInteger("1"),
        true
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_07",
        "-1",
        sc_string_analysis:IsInteger("-1"),
        true
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_08",
        "The unkown value ? is no integer",
        sc_string_analysis:IsInteger(?),
        false
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_09",
        "Value with a point, like 123.45, is no integer",
        sc_string_analysis:IsInteger("123.45"),
        false
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_10",
        "Value with a comma, like 123,45, is no integer",
        sc_string_analysis:IsInteger("123,45"),
        false
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_11",
        "A single point is no integer",
        sc_string_analysis:IsInteger("."),
        false
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_12",
        "A single comma is no integer",
        sc_string_analysis:IsInteger(","),
        false
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_13",
        "Value with leading zeros we call an integer",
        sc_string_analysis:IsInteger("0012"),
        true
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_14",
        "Value with leading spaces we call an integer",
        sc_string_analysis:IsInteger("  12"),
        true
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_15",
        "Value with leading spaces and zeros we call an integer",
        sc_string_analysis:IsInteger("  0012"),
        true
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_16",
        "Value with trailing zeros we call an integer",
        sc_string_analysis:IsInteger("12  "),
        true
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_17",
        "Value with leading zeros and trailing spaces we call an integer",
        sc_string_analysis:IsInteger("0012  "),
        true
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_18",
        "Value with leading zeros and spaces and trailing spaces we call an integer",
        sc_string_analysis:IsInteger("  0012  "),
        true
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_19",
        "Value with trailing minus we don't call an integer",
        sc_string_analysis:IsInteger("12-"),
        false
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_20",
        "Value with minus, space, integer, we call an integer",
        sc_string_analysis:IsInteger("- 12"),
        true
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_21",
        "Value with minus, space, minus, integer, we don't call an integer",
        sc_string_analysis:IsInteger("- -12"),
        false
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_22",
        "Value with spaces, minus, spaces, minus, integer, we don't call an integer",
        sc_string_analysis:IsInteger("  -   -12"),
        false
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_23",
        "Value with spaces, minus, spaces, integer, we call an integer",
        sc_string_analysis:IsInteger("  -  12  "),
        true
        ).
      
      sc_unittest:Assert(
        "IsInteger_00001_24",
        "Value with spaces, minus, spaces, minus, spaces, integer, we don't call an integer",
        sc_string_analysis:IsInteger("  -   -  12"),
        false
        ).
        
      sc_unittest:Assert(
        "IsInteger_00001_25",
        "Value with plus sign we don't call an integer",
        sc_string_analysis:IsInteger("+12"),
        false
        ).
      
      undo unittest1, leave unittest1.
    
    end.
    
    sc_unittest:UnittestFinish(this-object, cUnittestIP#).

    catch oError# as Progress.Lang.Error:
      sc_unittest:OnException(cUnittestIP#,oError#).
    end catch.

  end method. /* UT_IsInteger */   
  
  
end class.

/* EOF */