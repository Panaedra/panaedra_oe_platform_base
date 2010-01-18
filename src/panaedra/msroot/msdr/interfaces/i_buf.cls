{panaedra/msi/logic/ctop_interface.i} 

interface panaedra.msroot.msdr.interfaces.i_buf:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msdr/interfaces/i_buf.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-18 09:50:30+01:00 $ 
    Date Modified: $Modtime: 2010-01-18 09:27:06+01:00 $ 

      Description: Interface for a simple class that wraps a single ABL query handle

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define property hBuffer as handle no-undo get. set.

  define property oBindingSource as 
    &if opsys="unix" &then
    /* Unix compatibility isn't complete yet, this is a stub. */
    Progress.Lang.Object
    &else
    paninui.view.init.display.c_bindingsource
    &endif 
    no-undo get. set.

  method public void UiRefreshRecord().

end interface.

/* EOF */ 
