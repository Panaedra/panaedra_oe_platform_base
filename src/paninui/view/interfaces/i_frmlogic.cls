{panaedra/msi/logic/ctop_interface.i}
interface paninui.view.interfaces.i_frmlogic:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/interfaces/i_frmlogic.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-08-31 10:37:54+02:00 $ 
    Date Modified: $Modtime: 2009-08-30 14:09:06+02:00 $ 

      Description: add_your_comments_here

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property iPackID as int64 get.
  method logical  InitializeFrameLogic().
  method void     SetPackID (oPackIP# as paninui.view.interfaces.i_pack).
      
end interface.

/* EOF */
