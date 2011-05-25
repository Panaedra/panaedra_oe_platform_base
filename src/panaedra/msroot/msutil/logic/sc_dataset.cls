using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_dataset: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Entry points for generic dataset functionality

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_dataset(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  method public static logical IsDataSetEmpty(
    
    /* Determine if every (temp-)table in this dataset is empty.
    
       If it's not important that you loose the rowid's of buffers
       in the dataset, use true for bUseDsBuffersIP#.
       Otherwise, use false, so temporary buffers are created 
       and destroyed inside this method.
     */
    
    input hDataSetIP#      as handle,
    input bUseDsBuffersIP# as logical):
      
    return sc_data_analysis:IsDataSetEmpty(
      hDataSetIP#,    
      bUseDsBuffersIP#).  
      
  end method. /* IsDataSetEmpty */
  
  
  method public static logical DatasetCompare(
    
    /* Compare the complete contents of two datasets.
       We do an xml comparison and a json comparison.
       We could implement a query-parsing buffer-compare comparison later.
     */
  
    dataset-handle hDatasetOneIP#, 
    dataset-handle hDatasetTwoIP#):
      
    return sc_data_analysis:DatasetCompare(
      dataset-handle hDatasetOneIP#, 
      dataset-handle hDatasetTwoIP#).  

  end method. /* DatasetCompare */  
 
end class.

/* EOF */ 
