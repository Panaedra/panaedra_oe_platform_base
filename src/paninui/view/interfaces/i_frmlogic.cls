{panaedra/msroot/msutil/logic/top_i/ctop_interface.i}
using paninui.pack.interfaces.*.

interface paninui.view.interfaces.i_frmlogic:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/interfaces/i_frmlogic.cls $ 
          Version: $Revision: 10 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:11+01:00 $ 

      Description: Interface voor PaninUi Frame Logic Classes (*_frmlg_*.cls).

  \*****************************  Include Files ********************************/
  {paninui/logic/includes/preproc_dotnetclasses.i &class=class}
  /******************************* $NoKeywords:  $ *****************************/

  define property oPack       as i_pack no-undo get.
  define property iPackID     as int64 no-undo get.
  define property iFrmLogicID as int64 no-undo get.
  
  method void     SetPack(oPackIP# as i_pack).
      
  method logical  InitializeFrameLogic().
  method logical  InitializeFrameEvents().
  method logical  InitializeFrameView().
  method void     InitializeFrameViewShown().
  
end interface.

/* EOF */
