{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 
using paninui.view.init.display.*.

interface panaedra.msroot.msdr.interfaces.i_qry:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msdr/interfaces/i_qry.cls $ 
          Version: $Revision: 10 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-02-05 13:57:09+01:00 $ 
    Date Modified: $Modtime: 2010-02-04 13:56:27+01:00 $ 

      Description: Interface for a class that wraps an ABL query handle

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define public property iNumBuffers         as integer   no-undo get.
  define public property cPrepareString      as character no-undo get.
  define public property bIsOpen             as logical   no-undo get.

  define public property sys__hQuery         as handle    no-undo get. set.
  define public property sys__hQueryOnHold   as handle    no-undo get. set.
  define public property sys__oParentQry     as panaedra.msroot.msdr.interfaces.i_qry no-undo get. set.
  define public property sys__oBindingSource as c_bindingsource no-undo get. set.
  
  define public property hDisplayField       as handle extent no-undo get. set.
  define public property hKeyField           as handle extent no-undo get. set. 
  define public property iUiRowPosition      as integer no-undo get. set.
  
  method public c_bindingsource GetActiveBindingsource().
  method public widget-handle GetBuffer(iBufferIP# as integer).
  method public void PrepareStringGenSimple().
  method public void QueryClose().
  method public logical GetNext().
  method public logical GetPrev().
  method public logical QueryOffEnd().
  method public logical QueryOpen().
  method public logical QueryOpen(bPointerBeforeFirstIP# as logical).
  method public logical QueryOpen(cPrepareStringIP# as character).
  method public logical QueryOpen(cPrepareStringIP# as character, bPointerBeforeFirstIP# as logical).
  method public logical QueryOpenAndReposition().
  method public logical SetPrepareString(cPrepareStringIP# as character).
  method public logical SetWhere(iBufferIP# as integer, cWhereIP# as character).
  method public logical SetWhere(iBufferIP# as integer, cWhereIP# as character, bQueryOpenIP# as logical).
  method public logical SetBy(cByIP# as character).
  method public void SyncLocal().

  method public void UiRefreshRecord().
  method public void UiRefreshRecord(iRowIP# as integer).
  method public void UiRefreshAll().
  method public void UiRefreshAll(cOptionIP# as character).
  method public void UiAddNewRow().
  method public void UiDeleteNewRow().
  method public void UiResetCurrentItem().
    
end interface.

/* EOF */ 
