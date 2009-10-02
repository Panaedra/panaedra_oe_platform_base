/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_win32_sub.p $ 
        Version: $Revision: 1 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-10-02 11:47:19+02:00 $ 
  Date Modified: $Modtime: 2009-10-02 11:46:49+02:00 $ 

    Description: Hulpprocedure bij sc_win32.cls, omdat external niet kan in classes.

\**************************** End of Dvcs_ Header ****************************/
&scop dvcs_proc procedure dvcs__panaedra_msroot_msutil_logic_sc_win32_sub_p: return "$Revision: 1 $". end.
{&dvcs_proc}
/******************************* $NoKeywords:  $ *****************************/

procedure ShellExecuteA external "shell32" :
   def input param IntPtr as long no-undo.
   def input param lpOperation as char no-undo.
   def input param lpFile as char no-undo.
   def input param lpParameters as char no-undo.
   def input param lpDirectory as char no-undo.
   def input param ShowCommands as long no-undo.
end procedure.



/* EOF */
