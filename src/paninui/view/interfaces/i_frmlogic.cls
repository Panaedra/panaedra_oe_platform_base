{panaedra/msi/logic/ctop_interface.i}
interface paninui.view.interfaces.i_frmlogic:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/interfaces/i_frmlogic.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-05 16:15:08+02:00 $ 
    Date Modified: $Modtime: 2009-09-05 16:10:22+02:00 $ 

      Description: add_your_comments_here

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property iPackID as int64 get.
  method logical  InitializeFrameLogic().
  method void     SetPackID (oPackIP# as paninui.pack.interfaces.i_pack).
      
end interface.

/* EOF */
