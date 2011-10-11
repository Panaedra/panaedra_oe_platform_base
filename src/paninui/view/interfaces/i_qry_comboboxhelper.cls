{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 

interface paninui.view.interfaces.i_qry_comboboxhelper:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Interface for oQry object returned by sc_comboboxhelper

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  method public void RefreshCsvData(cSsvIP# as character).
  method public handle GetBuffer(iBufferIP# as integer).

end interface.

/* EOF */ 
