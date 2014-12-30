using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.msutil.logic.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_string_csv_unittests
  inherits panaedra.msroot.msutil.logic.sc_string_csv
  implements panaedra.msroot.msutil.interfaces.i_unittest_client:    

  /******************************  Dvcs_ Header ********************************\

      Description: unittests for sc_string_csv
      
      
  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_string_csv_unittests(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    super(o-sourcecontrol, this-object).
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.

  constructor public sc_string_csv_unittests(
    input oParamIP# as i_unittest_param):
    super(oParamIP#).
  end constructor.

  
  method public void GetUnittests(
    output cSvUnittestsOP# as character):
     
    cSvUnittestsOP# = "UT_CsvGetJoinList,UT_CsvRemoveValue,UT_CsvRemoveLastValue".
    
  end method. /* GetUnittests */
 

  method public void ExecuteUnittest(
    cUnittestIP# as character):

    case cUnittestIP#:
      when "UT_CsvGetJoinList" then UT_CsvGetJoinList(cUnittestIP#).
      when "UT_CsvRemoveValue"    then UT_CsvRemoveValue(cUnittestIP#).
      when "UT_CsvRemoveLastValue"    then UT_CsvRemoveLastValue(cUnittestIP#).
    end case.
    
  end method. /* ExecuteUnittest */
  
  
  method public void UT_CsvGetJoinList(
    cUnittestIP# as character):
      
    define variable cSvList1# as character no-undo.  
    define variable cSvList2# as character no-undo.  
    define variable cResult#  as character no-undo.
    
    sc_unittest:UnittestInit(this-object, cUnittestIP#).
    
    unittest1:
    do transaction on error undo, throw:
      
      assign 
        cSvList1# = "abc,def"
        cSvList2# = "ghi,jkl".
      
      cResult# = sc_string_csv:CsvGetJoinList(cSvList1#, cSvList2#, ',', '').
      
      sc_unittest:Assert(
        "CsvGetJoinList_00001_01",
        "2 simple lists",
        cResult#,
        "abc,def,ghi,jkl"
        ).

      assign 
        cSvList1# = ""
        cSvList2# = "ghi,jkl".
      
      cResult# = sc_string_csv:CsvGetJoinList(cSvList1#, cSvList2#, ',', '').
      
      sc_unittest:Assert(
        "CsvGetJoinList_00001_02",
        "2 simple lists, 1 empty",
        cResult#,
        "ghi,jkl"
        ).

      assign 
        cSvList1# = "abc,def"
        cSvList2# = "".
      
      cResult# = sc_string_csv:CsvGetJoinList(cSvList1#, cSvList2#, ',', '').
      
      sc_unittest:Assert(
        "CsvGetJoinList_00001_03",
        "2 simple lists, the other one empty",
        cResult#,
        "abc,def"
        ).

      assign 
        cSvList1# = ?
        cSvList2# = "ghi,jkl".
      
      cResult# = sc_string_csv:CsvGetJoinList(cSvList1#, cSvList2#, ',', '').
      
      sc_unittest:Assert(
        "CsvGetJoinList_00001_04",
        "2 simple lists, one of them unknown",
        cResult#,
        "ghi,jkl"
        ).

      assign 
        cSvList1# = "abc,def"
        cSvList2# = ?.
      
      cResult# = sc_string_csv:CsvGetJoinList(cSvList1#, cSvList2#, ',', '').
      
      sc_unittest:Assert(
        "CsvGetJoinList_00001_05",
        "2 simple lists, the other one unknown",
        cResult#,
        "abc,def"
        ).
        
      assign 
        cSvList1# = "abc,def"
        cSvList2# = "def,jkl".
      
      cResult# = sc_string_csv:CsvGetJoinList(cSvList1#, cSvList2#, ',', '').
      
      sc_unittest:Assert(
        "CsvGetJoinList_00001_06",
        "2 simple lists, avoiding double entries",
        cResult#,
        "abc,def,jkl"
        ).

      undo unittest1, leave unittest1.
    
    end.
    
    sc_unittest:UnittestFinish(this-object, cUnittestIP#).

    catch oError# as Progress.Lang.Error:
      sc_unittest:OnException(cUnittestIP#,oError#).
    end catch.

  end method. /* UT_CsvGetJoinList */   
  
  
  method public void UT_CsvRemoveLastValue(
    cUnittestIP# as character):
    
    sc_unittest:Assert(
      "UT_CsvRemoveLastValue_00001_01",
      "Remove last entry",
      sc_string_csv:CsvRemoveLastValue("AAA,BBB,CCC,DDD", ","),      
      "AAA,BBB,CCC"
      ).
    
    sc_unittest:Assert(
      "UT_CsvRemoveLastValue_00001_02",
      "Remove last entry",
      sc_string_csv:CsvRemoveLastValue("AAA,BBB", ","),      
      "AAA"
      ).
    
    sc_unittest:Assert(
      "UT_CsvRemoveLastValue_00001_03",
      "Remove last entry",
      sc_string_csv:CsvRemoveLastValue("AAA", ","),      
      ""
      ).
    
    sc_unittest:Assert(
      "UT_CsvRemoveLastValue_00001_04",
      "Remove last entry",
      sc_string_csv:CsvRemoveLastValue("AAA;BBB;CCC;DDD", ";"),      
      "AAA;BBB;CCC"
      ).
    
  end method.  /* UT_CsvRemoveLastValue */
  
  
  method public void UT_CsvRemoveValue(
    cUnittestIP# as character):
    
    sc_unittest:Assert(
      "CsvRemoveValue_00001_01",
      "Remove first entry",
      sc_string_csv:CsvRemoveValue("AAA,BBB,CCC,DDD", "AAA"),      
      "BBB,CCC,DDD"
      ).
    
    sc_unittest:Assert(
      "CsvRemoveValue_00001_02",
      "Remove middle entry",
      sc_string_csv:CsvRemoveValue("AAA,BBB,CCC,DDD", "BBB"),      
      "AAA,CCC,DDD"
      ).
    
    sc_unittest:Assert(
      "CsvRemoveValue_00001_03",
      "Remove last entry",
      sc_string_csv:CsvRemoveValue("AAA,BBB,CCC,DDD", "DDD"),      
      "AAA,BBB,CCC"
      ).
    
    sc_unittest:Assert(
      "CsvRemoveValue_00001_04",
      "Remove nothing",
      sc_string_csv:CsvRemoveValue("AAA,BBB,CCC,DDD", ""),      
      "AAA,BBB,CCC,DDD"
      ).
        
    sc_unittest:Assert(
      "CsvRemoveValue_00001_05",
      "Remove from pipe-separated list",
      sc_string_csv:CsvRemoveValue("AAA|BBB|CCC|DDD", "BBB", "|"),      
      "AAA|CCC|DDD"
      ).
        
    sc_unittest:Assert(
      "CsvRemoveValue_00001_05",
      "Remove all entries",
      sc_string_csv:CsvRemoveValue("AAA|BBB|CCC|DDD", "AAA|BBB|CCC|DDD"),      
      ""
      ).

  end method.  /* UT_CsvRemoveValue */


  method protected void CreateUnittestData(input cUnittestIP# as character):
    
    case cUnittestIP#:
      
    end case.
        
  end method. /* CreateUnittestData */

end class.

/* EOF */ 
