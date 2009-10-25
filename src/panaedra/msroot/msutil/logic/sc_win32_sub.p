/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_win32_sub.p $ 
        Version: $Revision: 3 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-10-25 21:17:54+01:00 $ 
  Date Modified: $Modtime: 2009-10-25 16:16:33+01:00 $ 

    Description: Hulpprocedure bij sc_win32.cls, omdat external niet kan in classes.

\**************************** End of Dvcs_ Header ****************************/
&scop dvcs_proc procedure dvcs__panaedra_msroot_msutil_logic_sc_win32_sub_p: return "$Revision: 3 $". end.
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

procedure MessageBoxA external "user32" :
   def input param hWnd as long no-undo.
   def input param lpText as char no-undo.
   def input param lpCaption as char no-undo.
   def input param wType as long no-undo.
   def return param lReturn as long no-undo.
end procedure.

procedure GetKeyState external "user32" :
   def input  param nVirtKey as long no-undo.
   def return param lReturn  as short no-undo.
end procedure.



/* EOF */
