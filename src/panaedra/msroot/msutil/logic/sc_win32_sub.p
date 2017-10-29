/****************************** Source Header ********************************\

    Description: Externals for sc_win32.cls

\*****************************  Include Files ********************************/

/******************************* $NoKeywords:  $ *****************************/

procedure ShellExecuteA external "shell32":U :
  def input param IntPtr as long no-undo.
  def input param lpOperation as char no-undo.
  def input param lpFile as char no-undo.
  def input param lpParameters as char no-undo.
  def input param lpDirectory as char no-undo.
  def input param ShowCommands as long no-undo.
end procedure.

procedure MessageBoxA external "user32":U :
  def input param hWnd as long no-undo.
  def input param lpText as char no-undo.
  def input param lpCaption as char no-undo.
  def input param wType as long no-undo.
  def return param lReturn as long no-undo.
end procedure.

procedure GetKeyState external "user32":U :
  def input  param nVirtKey as long no-undo.
  def return param lReturn  as short no-undo.
end procedure.

procedure Sleep external "kernel32":U persistent:
  def input param iMillisecondsIP# as long.
end procedure.

procedure GetCurrentProcessId external "kernel32":U:
  define return parameter iPidOP# as long.
end procedure.

procedure LoadLibraryA external "kernel32":U:
  define input  parameter cFileNameIP# as character.
  define return parameter iDllIdOP#   as short.
end procedure.

procedure FreeLibraryA external "kernel32":U:
  define input  parameter iDllIdIP# as short.
end procedure.

/* EOF */
