{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.


interface panaedra.msroot.msutil.interfaces.i_modalitydata:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_modalitydata.cls $ 
          Version: $Revision: 6 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:17+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 20:31:31+01:00 $ 

      Description: Data for the ModalityResponse call.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property oModalityClient  as i_modalityclient     no-undo get.
  define property cName            as character            no-undo get.
  define property oCallData        as Progress.Lang.Object no-undo get. set.
  define property oResponseData    as Progress.Lang.Object no-undo get. set.
  define property o_CMPNY_Exception as c__FCMPNY_exception    no-undo get. set.

  method void FireModalityResponse().

end interface.

/* EOF */ 
