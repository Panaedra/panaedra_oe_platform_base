{panaedra/msi/logic/ctop_interface.i}
interface paninui.view.interfaces.i_frmlogic:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/interfaces/i_frmlogic.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-03 22:39:49+02:00 $ 
    Date Modified: $Modtime: 2009-10-03 14:16:40+02:00 $ 

      Description: add_your_comments_here

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property iPackID     as int64 get.
  define property iFrmLogicID as int64 get.
  method logical  InitializeFrameLogic().
  method void     SetPackID (oPackIP# as paninui.pack.interfaces.i_pack).
      
end interface.

/* EOF */
