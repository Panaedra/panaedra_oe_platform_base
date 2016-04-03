{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.mspy.logic.c_mspython_call
  inherits
  panaedra.msroot.mspy.logic.c_mspython_sys_base: 

  /****************************** Source Header ********************************\

      Description: Standard python call object to external python script

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  constructor public c_mspython_call(
  
    cIdIP#        as character,
    cClassIP#     as character,
    cMethodIP#    as character,
    cNamespaceIP# as character
    ):
   
    super(cIdIP#,cClassIP#,cMethodIP#,cNamespaceIP#).
   
  end constructor.

end class.

/* EOF */
