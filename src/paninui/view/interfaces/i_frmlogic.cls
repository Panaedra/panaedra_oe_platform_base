{panaedra/msi/logic/ctop_interface.i}
interface paninui.view.interfaces.i_frmlogic:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/interfaces/i_frmlogic.cls $ 
          Version: $Revision: 6 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-10 14:07:44+02:00 $ 
    Date Modified: $Modtime: 2009-10-10 13:52:31+02:00 $ 

      Description: Interface voor PaninUi Frame Logic Classes (*_frmlg_*.cls).

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property iPackID     as int64 get.
  define property iFrmLogicID as int64 get.
  
  method void     SetPackID (oPackIP# as paninui.pack.interfaces.i_pack).
      
  method logical  InitializeFrameLogic().
  method logical  InitializeFrameEvents().
  method logical  InitializeFrameView().
  method logical  InitializeFrameViewShown().
  
end interface.

/* EOF */
