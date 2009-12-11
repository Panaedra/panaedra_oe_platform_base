{panaedra/msi/logic/ctop_interface.i}
interface paninui.view.interfaces.i_frmlogic:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/interfaces/i_frmlogic.cls $ 
          Version: $Revision: 7 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-12-11 01:17:59+01:00 $ 
    Date Modified: $Modtime: 2009-12-10 22:40:44+01:00 $ 

      Description: Interface voor PaninUi Frame Logic Classes (*_frmlg_*.cls).

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property oPack       as paninui.pack.interfaces.i_pack no-undo get.
  define property iPackID     as int64 no-undo get.
  define property iFrmLogicID as int64 no-undo get.
  
  method void     SetPack(oPackIP# as paninui.pack.interfaces.i_pack).
      
  method logical  InitializeFrameLogic().
  method logical  InitializeFrameEvents().
  method logical  InitializeFrameView().
  method logical  InitializeFrameViewShown().
  
end interface.

/* EOF */
