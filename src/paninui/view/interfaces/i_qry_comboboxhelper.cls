{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 

interface paninui.view.interfaces.i_qry_comboboxhelper

  /* This is what we want, will be supported in a future OE release:
  inherits panaedra.msroot.msdr.interfaces.i_qry */
  :  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Interface for oQry object returned by sc_comboboxhelper

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  method public void      RefreshCsvData(cSsvIP# as character).
  method public void      RefreshCsvData(cSsvIP# as character,cSeperatorIP# as character, cValueSeperatorIP# as character).
  method public handle    GetBufferHandle().
  method public logical   FindByID(iIdIP# as int64).
  method public character GetDisplayValue().
  method public logical   BufferAvailable().
  method public logical   RepositionByValue(input cValueIP# as character).
  
  /* i_qry methods: */
  method public logical QueryOpen().
  method public logical QueryOpenAndReposition().
  method public void QueryClose().
  method public void UiRefreshAll().
  method public handle GetBuffer(iBufferIP# as integer).
  method public logical QueryRepositionToBuffers().
  
end interface.

/* EOF */ 
