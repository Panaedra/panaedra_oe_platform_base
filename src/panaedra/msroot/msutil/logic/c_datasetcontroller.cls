{panaedra/msi/logic/ctop_class.i} 
using paninui.pack.interfaces.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.c_datasetcontroller: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/c_datasetcontroller.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-12-16 15:34:14+01:00 $ 
    Date Modified: $Modtime: 2009-12-16 13:50:09+01:00 $ 

      Description: A dataset controller provides extra functionality for a dataset.
      
                   It always controls only 1 dataset.
                   
                   The dataset controller is independent of the dataset pool.
                   
                   It's mainly used in frame logic procedures, but can be used
                   anywhere.
                   
                   Since it's only a controller, deleting the controller does
                   not delete the dataset. Delete them seperately.
                   
  Technical notes: The c_datasetcontroller exists, because you don't want to
                   make a c_dataset class which supercedes a dataset (like we
                   *do* have a c_bindingsource class which supercedes a 
                   bindingsource). The dataset is used everywhere in Panaedra to 
                   pass blocks of data (by reference or by value).
                   
                   So the dataset controller object only provides "helper methods
                   and properties" which you can use to facilitate some dataset 
                   related functionality.
                   
                   You can inherit from c_datasetcontroller to provide custom
                   functionality.
                   
                   "datasetcontroller" may be abbreviated to "dsctrl" or "DsCtrl".

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_datasetcontroller(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define public property hDataset as handle no-undo
    public get.
    protected set.
  
  define public property bTrackingChangesAnywhere as logical no-undo
    public get:
      return sc_datasetcontroller:IsTrackingChangesEnabled(this-object).
    end get.
  
  define public property bAsyncAllowed as logical no-undo
    public get.
    public set.

  define public property cName as character no-undo
    public get:
      if valid-handle(hDataset) then return hDataset:name.
      else return "".
    end get.

  define public property oPack as i_pack no-undo
    public get.
    protected set.


  constructor public c_datasetcontroller(dataset-handle hDatasetIP# bind):
    
    hDataset = hDatasetIP#.
    
  end constructor.


  constructor public c_datasetcontroller(dataset-handle hDatasetIP# bind, oPackIP# as i_pack):
    
    assign
      hDataset = hDatasetIP#
      oPack    = oPackIP#.
    
  end constructor.


  method public void TrackingChangesEnable():
    
    /* The default is to enable tracking-changes on all temp-tables.
       Override for different behaviour. 
    */
    sc_datasetcontroller:TrackingChangesEnableAll(this-object).

  end method. /* TrackingChangesEnable */   
  
  
  method public void TrackingChangesDisable():

    /* The default is to disable tracking-changes on all temp-tables.
       Override for different behaviour. 
    */
    sc_datasetcontroller:TrackingChangesDisableAll(this-object).

  end method. /* TrackingChangesDisable */
  
  
  method public void WaitForAsyncCompletion(oModalityResponse as i_modality_response):

  /* The default is to do nothing and return immediately.
     Override for different behaviour. 
  */

  end method. /* TrackingChangesDisable */
  
  
  method public override character ToString():
    
    return substitute("&1 [&2]", hDataset:name, super:ToString()).
    
  end method. /* ToString */
  
end class.

/* EOF */ 
