{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

&if opsys <> "unix" &then
using System.Windows.Forms.*.
&endif

class panaedra.msroot.msutil.view.sc_trayicon_win32 implements i_eventbroadcastclient:

  /****************************** Source Header ********************************\

      Description: Display a message by an Panaedra tray icon          codeQok#7222 
                   (static, so one per progress session)

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
    
  &if opsys <> "unix" &then
  
  define private static variable notifyIcon1                       as System.Windows.Forms.NotifyIcon        no-undo.
  define private static variable components                        as System.ComponentModel.IContainer       no-undo.
  define private static variable contextMenuStrip1                 as System.Windows.Forms.ContextMenuStrip  no-undo.
  define private static variable exitToolStripMenuItem             as System.Windows.Forms.ToolStripMenuItem no-undo.
  define private static variable showLastToolStripMenuItem         as System.Windows.Forms.ToolStripMenuItem no-undo.
  define private static variable putClipboardLastToolStripMenuItem as System.Windows.Forms.ToolStripMenuItem no-undo.
  define private static variable ShowLogToolStripMenuItem          as System.Windows.Forms.ToolStripMenuItem no-undo.
  define private static variable ClearLogToolStripMenuItem         as System.Windows.Forms.ToolStripMenuItem no-undo.
  
  define private static variable oSingleton as panaedra.msroot.msutil.view.sc_trayicon_win32 no-undo.
  
  constructor protected sc_trayicon_win32():
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@SessionClose").
  end constructor.
  
  destructor sc_trayicon_win32():
    sc_eventbroadcaster:UnSubscribeAllEvents(this-object).
    CloseAndErase().
  end destructor.
  
  def protected static temp-table ttLog no-undo rcode-info
    field dtmDate as datetime-tz format "99-99-9999 HH:MM:SS"
    field cSource as char        help " [HtmlBackColor] green "
    field cMsg    as char        help " [HtmlBackColor] yellow "
    index dtmDate is primary dtmDate.
    
  
  method public static void ShowTrayIconMessage(cMsgIP# as char, cSourceNameIP# as char):
    
    define buffer b-ttLog for ttLog.
    
    if panaedra.msroot.msutil.logic.sc_boot:SessionParameter("EclipseOptions") matches "*TrayIconMessage=no*" then 
      return.
    
    if oSingleton = ? then 
      oSingleton = new panaedra.msroot.msutil.view.sc_trayicon_win32().
    
    create b-ttLog.
    assign
      b-ttLog.dtmDate = now
      b-ttLog.cMsg    = cMsgIP#
      b-ttLog.cSource = cSourceNameIP#.
    
    if not valid-object(notifyIcon1) then 
    do:
      
      components = new System.ComponentModel.Container().
      define variable resources as System.Resources.ResXResourceSet no-undo.
      resources = Progress.Util.ResourceHelper:Load("panaedra/msroot/msutil/view/sc_trayicon_win32.resx", propath).
      notifyIcon1 = new System.Windows.Forms.NotifyIcon(components).
      notifyIcon1:Icon = cast(resources:GetObject("notifyIcon1.Icon"), System.Drawing.Icon).
      notifyIcon1:Text = "Panaedra Info".

      contextMenuStrip1 = new System.Windows.Forms.ContextMenuStrip(components).
      exitToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem().
      showLastToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem().
      putClipboardLastToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem().
      ShowLogToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem().
      ClearLogToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem().

      define variable arrayvar0 as System.Windows.Forms.ToolStripItem extent 5 no-undo.
      arrayvar0[1] = showLastToolStripMenuItem.
      arrayvar0[2] = putClipboardLastToolStripMenuItem.
      arrayvar0[3] = ShowLogToolStripMenuItem.
      arrayvar0[4] = ClearLogToolStripMenuItem.
      arrayvar0[5] = exitToolStripMenuItem.
      
      contextMenuStrip1:Items:AddRange(arrayvar0).

      exitToolStripMenuItem:Text = "&Exit".
      exitToolStripMenuItem:Click:subscribe(exitToolStripMenuItem_Click).

      showLastToolStripMenuItem:Text = "&Show last message". /* codeQok#7222 */
      showLastToolStripMenuItem:Click:subscribe(showLastToolStripMenuItem_Click).
      
      putClipboardLastToolStripMenuItem:Text = "&Put last message on clipboard". /* codeQok#7222 */
      putClipboardLastToolStripMenuItem:Click:subscribe(putClipboardLastToolStripMenuItem_Click).

      ShowLogToolStripMenuItem:Text = "&Show logfile".
      ShowLogToolStripMenuItem:Click:subscribe(ShowLogToolStripMenuItem_Click).
      
      ClearLogToolStripMenuItem:Text = "&Clear logfile".
      ClearLogToolStripMenuItem:Click:subscribe(ClearLogToolStripMenuItem_Click).
      
      notifyIcon1:ContextMenuStrip = contextMenuStrip1.

    end.
    
    /* Show last message in a baloon tip    codeQok#7222 */
    notifyIcon1:Visible = true.
    notifyIcon1:ShowBalloonTip(500, "Panaedra Info", cMsgIP#, ToolTipIcon:None).
    
  end method.

  method protected static void exitToolStripMenuItem_Click( input sender as System.Object, input e as System.EventArgs ):
    CloseAndErase().
  end method.
  
  method public static void CloseAndErase():
    
    if valid-object(notifyIcon1) then notifyIcon1:Dispose().
    notifyIcon1 = ?.
    
    if valid-object(exitToolStripMenuItem) then exitToolStripMenuItem:Dispose().
    exitToolStripMenuItem = ?.
    
    if valid-object(showLastToolStripMenuItem) then showLastToolStripMenuItem:Dispose().
    showLastToolStripMenuItem = ?.
    
    if valid-object(putClipboardLastToolStripMenuItem) then putClipboardLastToolStripMenuItem:Dispose().
    putClipboardLastToolStripMenuItem = ?.
    
    if valid-object(ShowLogToolStripMenuItem) then ShowLogToolStripMenuItem:Dispose().
    ShowLogToolStripMenuItem= ?.
    
    if valid-object(ClearLogToolStripMenuItem) then ClearLogToolStripMenuItem:Dispose().
    ClearLogToolStripMenuItem= ?.
    
    if valid-object(contextMenuStrip1) then contextMenuStrip1:Dispose().
    contextMenuStrip1 = ?.
    
    ClearLog().

  end method.
  
  
  method protected static void showLastToolStripMenuItem_Click( input sender as System.Object, input e as System.EventArgs ):
    
    find last ttLog use-index dtmDate no-error.
    
    if available ttLog
      and ttLog.cMsg > "" and length(ttLog.cMsg) > 0 /* codeQok#7122 */
      and valid-object(notifyIcon1) then
      notifyIcon1:ShowBalloonTip(30000, "Panaedra Info", ttLog.cMsg, ToolTipIcon:None).
        
  end method. /* showLastToolStripMenuItem_Click */


  method protected static void putClipboardLastToolStripMenuItem_Click( input sender as System.Object, input e as System.EventArgs ):
    
    find last ttLog use-index dtmDate no-error. 
    
    if avail ttLog then
      clipboard:value = ttLog.cMsg.
    
  end method.


  method protected static void ShowLogToolStripMenuItem_Click( input sender as System.Object, input e as System.EventArgs ):
    
    /* Create html and open */
    if panaedra.msroot.msutil.logic.sc_html:TempTableToHTML(temp-table ttLog:default-buffer-handle, panaedra.msroot.msutil.logic.sc_path:cTempDir + "trayiconlog.html") then 
      panaedra.msroot.msutil.logic.sc_win32:ShellExecute(panaedra.msroot.msutil.logic.sc_path:cTempDir + "trayiconlog.html"). /* Open bestandje */
    else
      notifyIcon1:ShowBalloonTip(500, "Panaedra Info", "Error occured, no log file made.", ToolTipIcon:None).
      
  end method.


  method protected static void ClearLogToolStripMenuItem_Click( input sender as System.Object, input e as System.EventArgs ):
   
   ClearLog().    
      
  end method.


  method protected static void ClearLog():
    
    empty temp-table ttLog.
    
  end method.

  method public void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
    case oBroadcastDataIP#:cEventName:
      
      when "evt@SessionClose" then CloseAndErase().
      
    end case.
    
  end method. /* OnEventBroadcast */

  &endif /* not unix */
  

end class.

/* EOF */

