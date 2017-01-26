{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.


class panaedra.msroot.msutil.logic.sc_messagebox
  implements panaedra.msroot.msutil.interfaces.i_eventbroadcastclient
  : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_messagebox.cls $ 
          Version: $Revision: 15 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 20:27:12+01:00 $ 

      Description: Replacement for the ABL "message" statement.
      
                   Example:
                     
                   (Eclipse macro 'bbuse_msutil'):
                   using panaedra.msroot.msutil.logic.*.
                   using panaedra.msroot.msutil.interfaces.*.
                   
                   (Eclipse macro 'bbmes'):
                   sc_messagebox:Show(sc_messageboxtype:Simple, "Here's my message").

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_messagebox(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 15 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected variable hAblWindow as handle no-undo.

  define private frame frmMsgLibPS#
    with 1 down no-box keep-tab-order overlay 
    side-labels no-underline three-d 
    at col 1 row 1
    size 44.8 by 7.43.

  define protected static property oSingleton as panaedra.msroot.msutil.logic.sc_messagebox no-undo
    get:
      if oSingleton = ? then oSingleton = new panaedra.msroot.msutil.logic.sc_messagebox().
      return oSingleton.
    end get.
    set.
  
  constructor protected sc_messagebox 
    
    /* This constructor is for the MsgBox functionality only.
       We need a singleton for the "frame" abl definition.
     */
    
    ():

    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@SessionClose").
    
    if session:display-type = "gui":u then
      create window hAblWindow assign
        hidden             = yes
        title              = "MsgLib"
        height             = 7.43
        width              = 44.8
        max-height         = 16
        max-width          = 80
        virtual-height     = 16
        virtual-width      = 80
        resize             = yes
        scroll-bars        = no
        status-area        = no
        bgcolor            = ?
        fgcolor            = ?
        keep-frame-z-order = yes
        three-d            = yes
        message-area       = no
        sensitive          = yes.
    else hAblWindow = current-window.

    if session:display-type = "gui":u and valid-handle(hAblWindow)
      then hAblWindow:hidden = no.

    if not session:batch-mode then 
    do:

      on end-error of hAblWindow 
        or endkey  of hAblWindow 
        do:
          /* This case occurs when the user presses the "Esc" key.
             In a persistently run window, just ignore this.  If we did not, the
             application would exit. */
          return no-apply.
        end.
  
      on window-close of hAblWindow 
        do:
          OnClose().
          return no-apply.
        end.

      /* Set current-window: this will parent dialog-boxes and frames.        */
      assign current-window            = hAblWindow.

    end.

    /* Best default for gui applications is...                              */
    pause 0 before-hide.

    /* Now enable the interface and wait for the exit condition.            */
    /* (note: handle error and end-key so cleanup code will always fire.    */
    if session:window-system <> "tty" then
    main-block:
    do on error   undo main-block, leave main-block
      on end-key undo main-block, leave main-block:
      if not session:batch-mode then 
      do:
        view frame frmMsgLibPS# in window hAblWindow.
        view hAblWindow.
        hAblWindow:hidden = yes.
      end.
    end.

    &scop msgStack _sys_MsgBox(subst("&1~~n&2~~n&3~~n&4~~n&5~~n&6~~n&7~~n&8~~n&9",~
                         program-name(2),~
                         program-name(3),~
                         program-name(4),~
                         program-name(5),~
                         program-name(6),~
                         program-name(7),~
                         program-name(8),~
                         program-name(9),~
                         program-name(10)~
                         )).
    
  end.


  method public static void Show(cMsgIP# as character):
    
    Show(sc_messageboxtype:Simple, cMsgIP#).

  end method. /* Show; simple */


  method public static void Show(oTypeOVID# as i_messageboxtype_simple, cMsgIP# as character):
    
    sc_environment:SetWaitState("panaedra.msroot.msutil.logic.sc_messagebox", false).
    
    &if opsys = "unix" or "{&window-system}" = "tty" &then
    
    MsgBox(cMsgIP#).
      
    &else

    if panaedra.msroot.msutil.logic.sc_environment:IsIdeRunning() then
    do:
      /* First this was the sc_win32 api, but it crashed sometimes. 
         The .net messagebox is safe. */
      System.Windows.Forms.MessageBox:Show(subst("&1", cMsgIP#),
        subst("Panaedra &1", substring(iso-date(now),1,23)),
        System.Windows.Forms.MessageBoxButtons:OK, 
        System.Windows.Forms.MessageBoxIcon:Information
        ).    
    end.
    else
    do:
      System.Windows.Forms.MessageBox:Show(subst("&1", cMsgIP#),
        subst("Panaedra &1", substring(iso-date(now),1,23)),
        System.Windows.Forms.MessageBoxButtons:OK, 
        System.Windows.Forms.MessageBoxIcon:Information
        ).    
    end.
     &endif

    
  end method. /* Show; simple */


  method public static void Show(oTypeOVID# as i_messageboxtype_asalertbox, cMsgIP# as character):
    
    message cMsgIP#
      view-as alert-box.
    
  end method. /* Show; simple */


  method public static void Show(oTypeOVID# as i_messageboxtype_simple_ontop, cMsgIP# as character):

    sc_environment:SetWaitState("panaedra.msroot.msutil.logic.sc_messagebox", false).
    
    &if opsys = "unix" or "{&window-system}" = "tty" &then

    MsgBox(cMsgIP#).

    &else

    define variable oForm as panaedra.msroot.msutil.view.c_messagebox_win32 no-undo.

    oForm = new panaedra.msroot.msutil.view.c_messagebox_win32(true, cMsgIP#).
    wait-for oForm:ShowDialog().

    &endif

  end method. /* Show; simple_ontop */


  method public static logical Show(oTypeOVID# as i_messageboxtype_yesno, cMsgIP# as character):
    
    return Show(sc_messageboxtype:YesNo, cMsgIP#, true).

  end method. /* Show; yesno, default=true */


  method public static logical Show(oTypeOVID# as i_messageboxtype_yesno, cMsgIP# as character, bDefaultOkayIP# as logical):

    sc_environment:SetWaitState("panaedra.msroot.msutil.logic.sc_messagebox", false).

    message cMsgIP#
      view-as alert-box buttons yes-no update bDefaultOkayIP#.
      
    return bDefaultOkayIP#.
    
  end method. /* Show; yesno */


  method public static logical Show(oTypeOVID# as i_messageboxtype_yesnocancel, cMsgIP# as character):

    return Show(oTypeOVID#, cMsgIP#, true).
    
  end method. /* Show; yesnocancel, default=true */


  method public static logical Show(oTypeOVID# as i_messageboxtype_yesnocancel, cMsgIP# as character, bDefaultOkayIP# as logical):

    sc_environment:SetWaitState("panaedra.msroot.msutil.logic.sc_messagebox", false).

    message cMsgIP#
      view-as alert-box buttons yes-no-cancel update bDefaultOkayIP#.
      
    return bDefaultOkayIP#.
    
  end method. /* Show; yesnocancel */


  method public static logical Show(oTypeOVID# as i_messageboxtype_yesno_ontop, cMsgIP# as character, bDefaultOkayIP# as logical):

    message "Not yet implemented" skip program-name(1) skip program-name(2) skip(2) cMsgIP#.
    
    return false.

  end method. /* Show; yesno_ontop */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP#)).

  end method. /* Show; type_debug , 1 character input */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#)).

  end method. /* Show; type_debug , 2 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#)).

  end method. /* Show; type_debug , 3 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character, cMsgIP_004# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#, cMsgIP_004#)).

  end method. /* Show; type_debug , 4 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character, cMsgIP_004# as character, cMsgIP_005# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#, cMsgIP_004#, cMsgIP_005#)).

  end method. /* Show; type_debug , 5 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character, cMsgIP_004# as character, cMsgIP_005# as character, cMsgIP_006# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#, cMsgIP_004#, cMsgIP_005#, cMsgIP_006#)).

  end method. /* Show; type_debug , 6 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character, cMsgIP_004# as character, cMsgIP_005# as character, cMsgIP_006# as character, cMsgIP_007# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#, cMsgIP_004#, cMsgIP_005#, cMsgIP_006#, cMsgIP_007#)).

  end method. /* Show; type_debug , 7 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character, cMsgIP_004# as character, cMsgIP_005# as character, cMsgIP_006# as character, cMsgIP_007# as character, cMsgIP_008# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#, cMsgIP_004#, cMsgIP_005#, cMsgIP_006#, cMsgIP_007#, cMsgIP_008#)).

  end method. /* Show; type_debug , 8 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character, cMsgIP_004# as character, cMsgIP_005# as character, cMsgIP_006# as character, cMsgIP_007# as character, cMsgIP_008# as character, cMsgIP_009# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#, cMsgIP_004#, cMsgIP_005#, cMsgIP_006#, cMsgIP_007#, cMsgIP_008#, cMsgIP_009#)).

  end method. /* Show; type_debug , 9 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP# as character extent):
    
    define variable cProgramName# as character no-undo.
    
    cProgramName# = if program-name(2) matches "*sc_messagebox*" then program-name(3) else program-name(2).
    
    sc_environment:SetWaitState("panaedra.msroot.msutil.logic.sc_messagebox", false).

    &if opsys = "unix" or "{&window-system}" = "tty" &then
    
    if (not session:batch-mode) and length(cProgramName#) > 40
      then cProgramName# = substring(cProgramName#, length(cProgramName#) - 39).

    MsgBox(
      subst("&1~n&2~n&3~n&4~n&5~n&6~n&7~n&8~n&9~n",
      cProgramName# ,
      cMsgIP#[1]    ,
      if extent(cMsgIP#) < 2 or cMsgIP#[2] = "" then "" else cMsgIP#[2] + "~n" ,
      if extent(cMsgIP#) < 3 or cMsgIP#[3] = "" then "" else cMsgIP#[3] + "~n" ,
      if extent(cMsgIP#) < 4 or cMsgIP#[4] = "" then "" else cMsgIP#[4] + "~n" ,
      if extent(cMsgIP#) < 5 or cMsgIP#[5] = "" then "" else cMsgIP#[5] + "~n" ,
      if extent(cMsgIP#) < 6 or cMsgIP#[6] = "" then "" else cMsgIP#[6] + "~n" ,
      if extent(cMsgIP#) < 7 or cMsgIP#[7] = "" then "" else cMsgIP#[7] + "~n" ,
      if extent(cMsgIP#) < 8 or cMsgIP#[8] = "" then "" else cMsgIP#[8] + "~n" +
      if extent(cMsgIP#) < 9 or cMsgIP#[9] = "" then "" else cMsgIP#[9]
      )).

    &else

    System.Windows.Forms.MessageBox:Show(cProgramName# + "~n" + subst("01: &1~n02: &2~n03: &3~n04: &4~n05: &5~n06: &6~n07: &7~n08: &8~n09: &9",
      cMsgIP#[1],
      if extent(cMsgIP#) < 2 then "" else cMsgIP#[2],
      if extent(cMsgIP#) < 3 then "" else cMsgIP#[3],
      if extent(cMsgIP#) < 4 then "" else cMsgIP#[4],
      if extent(cMsgIP#) < 5 then "" else cMsgIP#[5],
      if extent(cMsgIP#) < 6 then "" else cMsgIP#[6],
      if extent(cMsgIP#) < 7 then "" else cMsgIP#[7],
      if extent(cMsgIP#) < 8 then "" else cMsgIP#[8],
      if extent(cMsgIP#) < 9 then "" else cMsgIP#[9]
      ),
      subst("Panaedra Debug &1", substring(iso-date(now),1,23)),
      System.Windows.Forms.MessageBoxButtons:OK, 
      System.Windows.Forms.MessageBoxIcon:Asterisk
      ).    
      
  &endif /* unix or tty */
     
  end method. /* Show; type_debug , variable extent */


  method public static void Show(hBufferIP# as handle):

    define variable iTel# as integer   no-undo.
    define variable cMsg# as character no-undo.

    if valid-handle(hBufferIP#) and hBufferIP#:type = "BUFFER" then
    do:
  
      cMsg# = substitute("Inhoud buffer &1:", hBufferIP#:name).
  
      if hBufferIP#:available then  
        do iTel# = 1 to hBufferIP#:num-fields:
          cMsg# = cMsg# + substitute("~n&1: &2", hBufferIP#:buffer-field(iTel#):name, hBufferIP#:buffer-field(iTel#):buffer-value).  
        end.    
      
      else
        cMsg# = cMsg# + "~nnot available".

    end.

    else 
      cMsg# = "Invalid parameter".

    Show(sc_messageboxtype:oDebug, cMsg#). 
         
  end method. /* Show; type_debug , variable extent */


  method public void _sys_MsgBoxDbg(

    cMsgIP# as char ):
  
    message cMsgIP# view-as alert-box.
    
  end method. /* MsgBoxDbg */


  method public static void MsgBox(
    
    /* Use MsgBox for a simple message box.
       The content is scrollable and selectable.
       Does not use .NET.
       Unix compatible.
     */
  
    cMsgIP# as character):
      
    /* oSingleton:_sys_MsgBox(cMsgIP#). */
    
    /* Because of recurring memory violation, keep it simple for now and see if the mem violation stops coming */
    if session:batch-mode then 
    do:
      message cMsgIP#.
    end.  
    else
    do on error undo, throw:
      
      /* Errors need to be logged to file as well */
      output to value(sc_path:cLogDir + substitute("usermessagelog_&1.log", sc_environment:cSessionGuidShort)) append.
      put unformatted cMsgIP#.
      
      message MessageToDisplayableMessage(cMsgIP#)
        view-as alert-box.
      
      finally:
        output close.  
      end finally.
        
    end.
    
    catch ex as Progress.Lang.Error:
      
      /* On errors (like input blocking), just show the message in the simplest way possible */
      
      message MessageToDisplayableMessage(cMsgIP#)
        view-as alert-box title "Progress" + string(now,"9999-99-99 hh:mm:ss") .
        
    end catch.
    
  end method. /* MsgBox */
  

  method public void _sys_MsgBox(
  
    cMsgIP# as character):
  
    if session:batch-mode then 
    do:
      message cMsgIP#.
      return.
    end.  
  
    def var cMsg# as char
      view-as editor no-box
      size 63 by 4.
       
    define button btnOk# auto-go 
      label "&OK" 
      size 15 by 1.14
      bgcolor ? .

    define button btnInfo# 
      label "&Info" 
      size 15 by 1.14
      bgcolor ? .
  
    define frame frmMsgBox
      cMsg#  at row 1.24 col 2 no-label
      skip(0.1)
      btnOk#   at row 5.29 col 26
      btnInfo# at row 5.29 col 46 
      skip(0.1)
      with view-as dialog-box keep-tab-order 
      side-labels no-underline three-d  scrollable 
      title "Progress"
      default-button btnOk#.
      
    assign 
      frame frmMsgBox:scrollable         = no
      frame frmMsgBox:hidden             = yes
      btnInfo#:hidden in frame frmMsgBox = (not session:debug-alert)
      &if opsys = "win32" &then
      cMsg#:read-only in frame frmMsgBox = if session:window-system = "tty" then no else yes
      &endif
      .
      
    if num-entries(cMsgIP#,chr(10)) > 3 or length(cMsgIP#) > 500 then 
    do:
      assign
        frame frmMsgBox:row    = 3
        frame frmMsgBox:column = 8
        frame frmMsgBox:height = frame frmMsgBox:height + 12
        cMsg#:height           = cMsg#:height + 12
        btnOk#:row             = btnOk#:row   + 12
        btnInfo#:row           = btnInfo#:row + 12.
    end. 
  
    &if "{&window-system}" = "tty" &then
    on tab of btnInfo# 
      do:
        cMsg#:read-only in frame frmMsgBox = yes.
        cMsg#:sensitive in frame frmMsgBox = yes.
        apply "entry" to cMsg#.
        return no-apply.
      end.
    &endif

    on window-close of frame frmMsgBox
      do:
        apply "end-error":u to self.
      end.
  
    on choose of btnInfo# oSingleton:{&msgStack}
  
    /* parent the dialog-box */
    frame frmMsgBox:parent = hAblWindow.
    frame frmMsgBox:hidden = false. /* Note: this was needed in some weird exceptional flow test (empty screen, space-press needed without reason, annoying) 2014Q4 OE102B */
  
    msg-block:
    do on error   undo msg-block, leave msg-block:
      cMsg# = cMsgIP#.     
      enable_block:
      do:
        display cMsg# 
          with frame frmMsgBox.
        enable cMsg# 
          when session:window-system <> "tty"
          btnInfo# 
          when (session:debug-alert)
          btnOk# 
          with frame frmMsgBox.
        frame frmMsgBox:title = frame frmMsgBox:title + " " + string(time,"hh:mm:ss") + "." + string(etime mod 1000,"999").
        if session:window-system = "tty"
          then frame frmMsgBox:title = " " + frame frmMsgBox:title + " ".
        view frame frmMsgBox.
      end.
      wait-for go of frame frmMsgBox focus btnOk#.
    end.

    hide frame frmMsgBox no-pause.

    if session:window-system <> "tty" and not default-window:hidden 
      then default-window:hidden = yes.
  
  end method /* _sys_MsgBox */.


  method public void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
    case oBroadcastDataIP#:cEventName:
      
      when "evt@SessionClose" then 
        do:
          OnClose().
        end.
        
    end case.
    
  end method. /* OnEventBroadcast */
  
  
  method public void OnClose():

    if session:display-type = "gui":u and valid-handle(hAblWindow)
      then delete widget hAblWindow.
      
    if valid-object(oSingleton) then 
      delete object oSingleton.
    
    finally:
      oSingleton = ?.
    end finally.
    
  end method. /* OnClose */
  
  
  method public static character MessageToDisplayableMessage(
  
    /* If a message with long words is displayed in a CHUI messagebox, Progress gives errors.
       MessageToDisplayableMessage strips short all undisplayable words.
       The end of words (normally class names) are considered most significant.
       Only has an effect on CHUI / TTY.
      */
    
    cMessageIP# as character):
      
    define variable cMsg#    as character no-undo.
    define variable cMsgOut# as character no-undo.
    define variable cWord#   as character no-undo.
    define variable iTell#   as integer   no-undo.
    
    if session:window-system = "tty"
      and 
      (not session:batch-mode) /* We want the "technical" batch-mode here, not the one from sc_environment. */
      then 
    do:

      cMsg# = substring(cMessageIP#,1,400).

      do iTell# = 1 to num-entries(cMsg#," "):
  
        cWord# = entry(iTell#,cMsg#," ").
  
        /* If message is to long we'll add extra linebreaks */
        if length(cWord#) > 75 then
        do:
          cWord# = "~n" + substring(cWord#, length(cWord#) - 75).
        end. /* length(cLine#) > 60 */  
  
        cMsgOut# = cMsgOut# + " " + cWord#.
  
      end. /* iTell# = 1 to num-entries(cMsg#," ") */

      cMsgOut# = substring(cMsgOut#,2). /* Strip first space that was added. */
    
    end.
    else 
      cMsgOut# = cMessageIP#.
    
    return cMsgOut#.
    
  end method. /* MessageToDisplayableMessage */

end class.

/* EOF */ 
