{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 

interface paninui.view.interfaces.i_uiframe_tty:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/interfaces/i_uiframe_tty.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-08-22 15:30:38+02:00 $ 
    Date Modified: $Modtime: 2010-08-22 02:34:40+02:00 $ 

      Description: paninui.dll i_uiframe stub for tty/unix

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define property iUiFrameID as int64 no-undo
    public get.
    public set.
    
  define property cUiFrameName as character no-undo
    public get.
    public set.
      
  method public void OnShown().

end interface.

/* EOF */ 
