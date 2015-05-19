using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_unittest_stub implements i_unittest_client: 

  /******************************  Dvcs_ Header ********************************\

      Description: Stub for old-style unittests. Only to be used by sc_unittest.cls.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_unittest_stub(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
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
