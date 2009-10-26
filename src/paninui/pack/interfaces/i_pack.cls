{panaedra/msi/logic/ctop_interface.i}
using paninui.view.interfaces.*.

interface paninui.pack.interfaces.i_pack:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/pack/interfaces/i_pack.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-26 14:56:39+01:00 $ 
    Date Modified: $Modtime: 2009-10-26 14:03:58+01:00 $ 

      Description: add_your_comments_here

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method logical LoadPack (oMdiWindowIP# as i_masterwindow).
  method logical ShowPack (oMdiWindowIP# as i_masterwindow).
  
  define property UniqueInstanceID as int64 get.
  
end interface.

/* EOF */
