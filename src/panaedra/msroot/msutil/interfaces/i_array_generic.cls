{panaedra/msi/logic/ctop_interface.i} 

interface panaedra.msroot.msutil.interfaces.i_array_generic:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/i_array_generic.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-27 09:51:50+01:00 $ 
    Date Modified: $Modtime: 2009-10-27 09:51:11+01:00 $ 

      Description: Interface for flexible size arrays who use c_array_generic.i.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define public property cDatatype as character get.
  define public property iExtent   as integer   get.

  method public handle CreateGenericFieldHandle().

end interface.

/* EOF */ 
