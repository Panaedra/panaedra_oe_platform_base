{panaedra/msi/logic/ctop_interface.i} 

interface panaedra.msroot.msdr.interfaces.i_qry:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msdr/interfaces/i_qry.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-30 09:28:34+01:00 $ 
    Date Modified: $Modtime: 2009-10-30 04:06:31+01:00 $ 

      Description: Interface for a class that wraps an ABL query handle

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define public property iNumBuffers       as integer   no-undo get.
  define public property cPrepareString    as character no-undo get.
  define public property cName             as character no-undo get. set.

  define public property sys__hQuery       as handle    no-undo get. set.
  define public property sys__hQueryOnHold as handle    no-undo get. set.
  
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
  method public logical SetPrepareString(cPrepareStringIP# as character).
  method public logical SetWhere(iBufferIP# as integer, cWhereIP# as character).
  method public logical SetWhere(iBufferIP# as integer, cWhereIP# as character, bQueryOpenIP# as logical).
  method public void SyncLocal().
    
end interface.

/* EOF */ 
