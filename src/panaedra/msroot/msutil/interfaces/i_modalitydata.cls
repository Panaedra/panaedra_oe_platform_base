{panaedra/msi/logic/ctop_interface.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msex.logic.*.

interface panaedra.msroot.msutil.interfaces.i_modalitydata:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_modalitydata.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-06 15:36:13+01:00 $ 
    Date Modified: $Modtime: 2010-01-06 15:12:03+01:00 $ 

      Description: Data for the ModalityResponse call.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property cName            as character            no-undo get.
  define property oModalityClient  as i_modalityclient     no-undo get. set.
  define property oCallData        as Progress.Lang.Object no-undo get. set.
  define property oResponseData    as Progress.Lang.Object no-undo get. set.
  define property o_CMPNY_Exception as c__FCMPNY_exception    no-undo get. set.

end interface.

/* EOF */ 
