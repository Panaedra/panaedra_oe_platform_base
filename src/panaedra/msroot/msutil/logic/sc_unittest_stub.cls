using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_unittest_stub implements i_unittest_client: 

  /****************************** Source Header ********************************\

      Description: Stub for old-style unittests. Only to be used by sc_unittest.cls.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  constructor public sc_unittest_stub():
  end constructor.

  method public void GetUnittests(output cSvUnittestsOP# as character):
    cSvUnittestsOP# = "".
  end method.
  
  method public void ExecuteUnittest(input cUnittestIP# as character):
    
  end method.

end class.

/* EOF */ 
