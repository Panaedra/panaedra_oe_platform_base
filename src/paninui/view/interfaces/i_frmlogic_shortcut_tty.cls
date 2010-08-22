{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 


interface paninui.view.interfaces.i_frmlogic_shortcut_tty: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/interfaces/i_frmlogic_shortcut_tty.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-08-22 15:30:38+02:00 $ 
    Date Modified: $Modtime: 2010-08-22 14:44:15+02:00 $ 

      Description: TTY interface for i_frmlogic_shortcut

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method public void SetUiValue(
    cWidgetNameIP#  as character, 
    cPropertyIP#    as character, 
    cValueIP#       as character).
    
  method public void SetUiValue(
    oObjectIP#      as Progress.Lang.Object, 
    cWidgetNameIP#  as character, 
    cPropertyIP#    as character, 
    lValueIP#       as logical).

  method public void SetUiValue(
    oObjectIP#      as Progress.Lang.Object, 
    cWidgetNameIP#  as character, 
    cPropertyIP#    as character, 
    cValueIP#       as character).

end interface.


/* EOF */ 
