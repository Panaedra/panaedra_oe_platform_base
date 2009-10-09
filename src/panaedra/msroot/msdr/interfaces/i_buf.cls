{panaedra/msi/logic/ctop_interface.i} 

interface panaedra.msroot.msdr.interfaces.i_buf:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msdr/interfaces/i_buf.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-09 23:01:41+02:00 $ 
    Date Modified: $Modtime: 2009-10-09 15:27:20+02:00 $ 

      Description: Interface for a simple class that wraps a single ABL query handle

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define property hBuffer as handle no-undo get. set.

  define property oBindingSource as paninui.view.init.display.c_bindingsource no-undo get. set.

end interface.

/* EOF */ 
