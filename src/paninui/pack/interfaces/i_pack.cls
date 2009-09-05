{panaedra/msi/logic/ctop_interface.i}
using paninui.view.interfaces.*.

interface paninui.pack.interfaces.i_pack:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/pack/interfaces/i_pack.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-05 16:14:33+02:00 $ 
    Date Modified: $Modtime: 2009-09-05 16:14:24+02:00 $ 

      Description: add_your_comments_here

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method logical LoadPack ( oMdiWindowIP# as i_masterwindow).
  
  define property UniqueInstanceID as int64 get.
  
end interface.

/* EOF */
