{panaedra/msi/logic/ctop_interface.i} 

interface panaedra.msroot.msdr.interfaces.i_qry:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msdr/interfaces/i_qry.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-30 13:36:41+02:00 $ 
    Date Modified: $Modtime: 2009-09-30 13:36:41+02:00 $ 

      Description: Interface for a simple class that wraps a single ABL query handle

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define property hQuery as handle no-undo get. set.

end interface.

/* EOF */ 
