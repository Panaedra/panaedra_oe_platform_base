using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i}

&if opsys = "win32" and not "{&window-system}" = "tty" &then
using System.Windows.Forms.*.
using Progress.Windows.Form.
&endif

class panaedra.msroot.msutil.view.c_dotnetformshowexception &if opsys = "win32" &then inherits Form implements panaedra.msroot.msutil.interfaces.i_apiproxyexception &endif : 

  /****************************** Source Header ********************************\

      Description: Show any progress or dotnet exception to the user.

  \*****************************  Include Files ********************************/
  
  {panaedra/msroot/msas/logic/ds/ascontext_ds.i &protected=protected &class=class}

  /******************************* $NoKeywords:  $ *****************************/
  
  define protected temp-table ttAblExceptions no-undo like ttExceptions.
  define protected temp-table ttAblCallStack no-undo like ttCallStack.
  

  &if opsys = "win32" and not "{&window-system}" = "tty" &then
  
  define private   variable components   as System.ComponentModel.IContainer no-undo.
  
  define protected variable bShowDetails as logical                          no-undo.

  define private   variable tbStack      as System.Windows.Forms.TextBox     no-undo.
  define private   variable btnOK        as System.Windows.Forms.Button      no-undo.
  define private   variable tbinfo       as System.Windows.Forms.TextBox     no-undo.
  define private   variable btnDetails   as System.Windows.Forms.Button      no-undo.
      
  constructor public c_dotnetformshowexception (  ):
    
    super().
    InitializeComponent().
    
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.

  end constructor.
  
 
  @VisualDesigner.
  method private void btnDetails_Click( input sender as System.Object, input e as System.EventArgs ):
  
    define variable nestedvar as System.Windows.Forms.AnchorStyles no-undo.
  
    /* Do once if details aren't shown yet */
    if not bShowDetails then 
    do:
      /* tbInfo anchor bottom off */
      nestedvar = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:tbinfo:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
    
      /* button anchor to top */
      this-object:btnOK:Anchor = System.Windows.Forms.AnchorStyles:Top.
      this-object:btnDetails:Anchor = System.Windows.Forms.AnchorStyles:Top.
      
      /* Move tbstack */
      this-object:Height             = this-object:Height + 300.
      this-object:tbStack:Location   = new System.Drawing.Point(2, this-object:ClientSize:height - 298).
      this-object:tbStack:ClientSize = new System.Drawing.Size(this-object:ClientSize:width - 6, this-object:height - 302).
      
      /* Anchor tbStack */
      nestedvar = cast(Progress.Util.EnumHelper:Or(cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:tbStack:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      
      /* tbStack visible */
      this-object:tbStack:visible = true.
      
      bShowDetails = true.
    end.
    
  end method.


  @VisualDesigner.
  method private void btnOK_Click( input sender as System.Object, input e as System.EventArgs ):
    
    this-object:Close().

  end method.


  @VisualDesigner.
  method private void c_dotnetformshowexception_KeyPress( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs ):
    
    if e:KeyChar = chr(3) /* Ctrl+C */ then 
    do:
      e:Handled = true.
      clipboard:value = substitute("&2&1&1&3&1&1&4", chr(10), 
        this-object:Text, 
        tbInfo:Text, 
        tbStack:Text).
    end.
      
  end method.


  method private void InitializeComponent(  ):
    
    /* NOTE: The following method is automatically generated.
    
    We strongly suggest that the contents of this method only be modified using the
    Visual Designer to avoid any incompatible modifications.
    
    Modifying the contents of this method using a code editor will invalidate any support for this file. */
    @VisualDesigner.FormMember (NeedsInitialize="true").
    define variable resources as System.Resources.ResXResourceSet no-undo.
    resources = Progress.Util.ResourceHelper:Load("panaedra\msroot\msutil\view\c_dotnetformshowexception.resx", propath).
    this-object:tbStack = new System.Windows.Forms.TextBox().
    this-object:btnOK = new System.Windows.Forms.Button().
    this-object:tbinfo = new System.Windows.Forms.TextBox().
    this-object:btnDetails = new System.Windows.Forms.Button().
    this-object:SuspendLayout().
    /*  */
    /* tbStack */
    /*  */
    this-object:tbStack:Anchor = System.Windows.Forms.AnchorStyles:None.
    this-object:tbStack:BorderStyle = System.Windows.Forms.BorderStyle:FixedSingle.
    this-object:tbStack:Location = new System.Drawing.Point(2, 234).
    this-object:tbStack:Margin = new System.Windows.Forms.Padding(5).
    this-object:tbStack:Multiline = true.
    this-object:tbStack:Name = "tbStack".
    this-object:tbStack:ReadOnly = true.
    this-object:tbStack:Size = new System.Drawing.Size(103, 23).
    this-object:tbStack:TabIndex = 0.
    this-object:tbStack:Visible = false.
    this-object:tbStack:TextChanged:subscribe(this-object:tbStack_TextChanged).
    /*  */
    /* btnOK */
    /*  */
    this-object:btnOK:Anchor = System.Windows.Forms.AnchorStyles:Bottom.
    this-object:btnOK:DialogResult = System.Windows.Forms.DialogResult:Cancel.
    this-object:btnOK:Location = new System.Drawing.Point(191, 234).
    this-object:btnOK:Name = "btnOK".
    this-object:btnOK:Size = new System.Drawing.Size(80, 23).
    this-object:btnOK:TabIndex = 3.
    this-object:btnOK:Text = "&OK".
    this-object:btnOK:UseCompatibleTextRendering = true.
    this-object:btnOK:UseVisualStyleBackColor = true.
    this-object:btnOK:Click:subscribe(this-object:btnOK_Click).
    /*  */
    /* tbinfo */
    /*  */
    define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
    nestedvar0 = cast(Progress.Util.EnumHelper:Or(cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
    this-object:tbinfo:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
    this-object:tbinfo:Location = new System.Drawing.Point(2, 3).
    this-object:tbinfo:Multiline = true.
    this-object:tbinfo:Name = "tbinfo".
    this-object:tbinfo:ReadOnly = true.
    this-object:tbinfo:Size = new System.Drawing.Size(538, 225).
    this-object:tbinfo:TabIndex = 5.
    /*  */
    /* btnDetails */
    /*  */
    this-object:btnDetails:Anchor = System.Windows.Forms.AnchorStyles:Bottom.
    this-object:btnDetails:Location = new System.Drawing.Point(277, 234).
    this-object:btnDetails:Name = "btnDetails".
    this-object:btnDetails:Size = new System.Drawing.Size(75, 23).
    this-object:btnDetails:TabIndex = 6.
    this-object:btnDetails:Text = "Details...".
    this-object:btnDetails:UseCompatibleTextRendering = true.
    this-object:btnDetails:UseVisualStyleBackColor = true.
    this-object:btnDetails:Click:subscribe(this-object:btnDetails_Click).
    /*  */
    /* c_dotnetformshowexception */
    /*  */
    this-object:AutoSizeMode = System.Windows.Forms.AutoSizeMode:GrowAndShrink.
    this-object:ClientSize = new System.Drawing.Size(542, 260).
    this-object:Controls:Add(this-object:btnDetails).
    this-object:Controls:Add(this-object:tbinfo).
    this-object:Controls:Add(this-object:btnOK).
    this-object:Controls:Add(this-object:tbStack).
    this-object:Icon = cast(resources:GetObject("$this.Icon"), System.Drawing.Icon).
    this-object:MinimumSize = new System.Drawing.Size(302, 95).
    this-object:Name = "c_dotnetformshowexception".
    this-object:SizeGripStyle = System.Windows.Forms.SizeGripStyle:Show.
    this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterScreen.
    this-object:Text = "Panaedra exception".
    this-object:KeyPreview = true.
    this-object:KeyPress:subscribe(this-object:c_dotnetformshowexception_KeyPress).
    this-object:ResumeLayout(false).
    this-object:PerformLayout().
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.
  end method.


  method public void ShowException(
  
    ex as Progress.Lang.Error):
      
    ShowException("",ex).  
  
  end method. /* ShowException ; simple overload */


  method public void ShowException(
  
    cExtraMessageIP# as character,
    oErrorIP#        as Progress.Lang.Error):
    
    assign
      this-object:Text = "Panaedra " + string(now, "99-99-9999 hh:mm:ss")
      tbInfo:Text      = ""
      tbStack:Text     = "".
    
    empty temp-table ttAblExceptions.
    empty temp-table ttAblCallstack.
    
    if type-of(oErrorIP#, c_apiproxyexception) then 
    do:
      
      def var oApiProxyException# as c_apiproxyexception no-undo.
      
      oApiProxyException# = cast(oErrorIP#, c_apiproxyexception).
      
      /* Check if dsContext is used
         (api/proxy)*/
      if oApiProxyException#:bUsesDataset then      
        /* Get dataset dsContext, use callback methods of this form */
        oApiProxyException#:GetDsContext(this-object).
      else
      do:
        ExceptionToTtAblException(oErrorIP#).
        CallstackToTtAblCallstack(oErrorIP#).
        /* Call the same method as used by the callback, but now with different (local) temp-tables. */
        CallbackDsContextStrong(table ttAblExceptions, table ttAblCallStack).
      end.    
    end.
    else 
    do:
      ExceptionToTtAblException(oErrorIP#).
      CallstackToTtAblCallstack(oErrorIP#).
      /* Call the same method as used by the callback, but now with different (local) temp-tables. */
      CallbackDsContextStrong(table ttAblExceptions, table ttAblCallStack).
    end.
    
    if cExtraMessageIP# > "" then 
    do:
      tbInfo:Text = subst("&1" + chr(13) + chr(10)  + chr(13) + chr(10) + "&2",cExtraMessageIP#,tbInfo:Text).
    end.
    
    EclipseTopMost().
    
  end method. /* ShowException */
  
  
  method protected void EclipseTopMost():

    if    (not this-object:TopMost) 
      and (sc_environment:IsIdeRunning()) 
      then 
      this-object:TopMost = true.
    
  end method. /* EclipseTopMost */
  
  
  method protected void ExceptionToTtAblException(oErrorIP# as Progress.Lang.Error):
    
    define variable iTell#           as integer          no-undo.
    define variable oPanaedraException# as c_panaedraexception no-undo.
    
    define buffer ttAblExceptions for ttAblExceptions.
    
    do for ttAblExceptions iTell# = 1 to oErrorIP#:NumMessages:
      create ttAblExceptions.
      ttAblExceptions.cError = oErrorIP#:GetMessage(iTell#).
      if index(ttAblExceptions.cError, subst("(&1)", oErrorIP#:GetMessageNum(iTell#))) = 0
        then ttAblExceptions.cError = ttAblExceptions.cError + subst(" (&1)", oErrorIP#:GetMessageNum(iTell#)).
    end.
    
    if type-of(oErrorIP#, c_panaedraexception) then 
    do:
      oPanaedraException# = cast(oErrorIP#, c_panaedraexception).
      if valid-object(oPanaedraException#:oInnerException) then 
      do for ttAblExceptions iTell# = 1 to oPanaedraException#:oInnerException:NumMessages:
        create ttAblExceptions.
        ttAblExceptions.cError = oPanaedraException#:oInnerException:GetMessage(iTell#).
        if index(ttAblExceptions.cError, subst("(&1)", oPanaedraException#:oInnerException:GetMessageNum(iTell#))) = 0
          then ttAblExceptions.cError = ttAblExceptions.cError + subst(" (&1)", oPanaedraException#:oInnerException:GetMessageNum(iTell#)).
      end.
    end.
    
  end method. /* ExceptionToTtAblException */
  
  
  method protected void CallstackToTtAblCallstack(oErrorIP# as Progress.Lang.Error):
    
    define variable bEclipseFix#     as logical          no-undo.  
    define variable oPanaedraException# as c_panaedraexception no-undo.
    
    define buffer b-ttAblCallStack for ttAblCallStack.
    
    do for b-ttAblCallStack:
      create b-ttAblCallStack.
      if oErrorIP#:CallStack > "" then /* codeQok#7120 */ 
        b-ttAblCallStack.cCallStack = oErrorIP#:CallStack. /* codeQok#7120 */
      else 
        b-ttAblCallStack.cCallStack = sc_showexception:GetSessionCallStack().

      if type-of(oErrorIP#, c_panaedraexception) then 
      do:
        oPanaedraException# = cast(oErrorIP#, c_panaedraexception).
        if valid-object(oPanaedraException#:oInnerException) then 
        do:
          if oPanaedraException#:oInnerException:CallStack > "" then /* codeQok#7120 */ 
            b-ttAblCallStack.cCallStack = b-ttAblCallStack.cCallStack + "~n:INNER-CALLSTACK:~n" + oPanaedraException#:oInnerException:CallStack. /* codeQok#7120 */
        end.
      end.
    end.
    
  end method. /* CallstackToTtAblCallstack */
  
  
  method public void CallbackDsContext (dataset-handle hDsContext# /* by-ref */):
    
    /* Krijgt dsContext binnen van c_apiproxyexception via by-reference callback */
    
    define variable hTt# as handle no-undo extent 2.
    
    hTt#[1] = hDsContext#:get-buffer-handle("ttExceptions"):table-handle. 
    hTt#[2] = hDsContext#:get-buffer-handle("ttCallStack"):table-handle. 
    
    CallbackDsContextStrong(
      table-handle hTt#[1] by-reference,
      table-handle hTt#[2] by-reference).    
    
  end method. /* CallbackDsContext */


  method public void CallbackDsContextStrong(table ttExceptions, table ttCallStack):

    /* dataset dsconfig is available in this method. */
    
    define variable cError# as character no-undo.
    define variable iOrder# as integer   no-undo.
    
    define buffer b-ttCallStack for ttCallStack.
    define query hQuery# for b-ttCallStack.
    
    tbInfo:Text = "".
    if can-find(first ttExceptions) then 
      for each ttExceptions on error undo, throw:
        cError# = replace(ttExceptions.cError, chr(10), chr(13) + chr(10)).
        iOrder# = ttExceptions.iOrder. /* For easy debugging */
        tbInfo:Text = tbInfo:Text + cError# + chr(13) + chr(10) + chr(13) + chr(10).
      end.
    else 
      tbInfo:Text = "Unknown error.".
    
    /* Put last procedure of first callstack in top textbox.     codeQok#7120 */
    find first ttCallstack no-error.
    if avail ttCallStack and ttCallStack.cCallStack > "" then
      tbInfo:Text = tbInfo:Text + entry(num-entries(ttCallStack.cCallStack,chr(10)),ttCallStack.cCallStack,chr(10)) + chr(13) + chr(10) + chr(13) + chr(10).
    
    /* Adjust order of complete callstack       codeQok#7120*/
    open query hQuery# for each b-ttCallStack.
    get last hQuery#.
    
    /* Fill "Details" textbox with complete stack */
    tbStack:Text = "".
    if can-find(first ttCallstack) then 
    do while not query-off-end ("hQuery#"):
      tbStack:Text = tbStack:Text + replace(b-ttCallStack.cCallStack, chr(10), chr(13) + chr(10)) + chr(13) + chr(10). 
      get prev hQuery#.
    end.
    else 
      tbStack:Text = "Unknown stack.".
    
  end method. /* CallbackDsContextStrong */


  @VisualDesigner.
  method private void tbStack_TextChanged( input sender as System.Object, input e as System.EventArgs ):
    
    return.

  end method.


  destructor public c_dotnetformshowexception ( ):

    if valid-object(components) then 
    do:
      cast(components, System.IDisposable):Dispose().
    end.

  end destructor.
  
  &endif
  
end class.

/* EOF */
