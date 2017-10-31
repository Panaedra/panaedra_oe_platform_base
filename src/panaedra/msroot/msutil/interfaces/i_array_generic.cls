{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 

interface panaedra.msroot.msutil.interfaces.i_array_generic:  

  /****************************** Source Header ********************************\

      Description: Interface for flexible size arrays who use c_array_generic.i.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define public property cDatatype as character no-undo get.
  define public property iExtent   as integer   no-undo get.

  method public handle CreateGenericFieldHandle().

end interface.

/* EOF */ 
