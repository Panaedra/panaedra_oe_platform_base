using panaedra.msex.logic.*.
{panaedra/msi/logic/ctop_interface.i} 

interface panaedra.msroot.msutil.interfaces.i_modalitydata:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_modalitydata.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-12-31 11:32:31+01:00 $ 
    Date Modified: $Modtime: 2009-12-29 09:54:29+01:00 $ 

      Description: Data for the ModalityResponse call.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property cName            as character         no-undo get.
  define property cResponse        as character         no-undo get.
  define property o_CMPNY_Exception as c__FCMPNY_exception no-undo get.

end interface.

/* EOF */ 
