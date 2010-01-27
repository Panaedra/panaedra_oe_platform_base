{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

using Progress.Windows.Form.

class panaedra.msroot.msutil.view.c_messagebox_win32 inherits form   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/view/c_messagebox_win32.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:13+01:00 $ 

      Description: add_your_comments_here

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_messagebox_win32(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 4 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define private variable components as System.ComponentModel.IContainer no-undo.

  define private variable btnOK as System.Windows.Forms.Button no-undo.

  define private variable tbMessage as System.Windows.Forms.TextBox no-undo.

  constructor public c_messagebox_win32 (bAlwaysOnTopIP# as logical, cMessageIP# as character):
		
    super().
    InitializeComponent().
    
    this-object:TopMost = bAlwaysOnTopIP#.
    tbMessage:Text = cMessageIP#.
    
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.

  end constructor.

	
  @VisualDesigner.
  method private void c_messagebox_win32_Load( input sender as System.Object, input e as System.EventArgs ):
		
    return.

  end method.


  method private void InitializeComponent(  ):
		
    /* NOTE: The following method is automatically generated.
    
    We strongly suggest that the contents of this method only be modified using the
    Visual Designer to avoid any incompatible modifications.
    
    Modifying the contents of this method using a code editor will invalidate any support for this file. */
    this-object:btnOK = new System.Windows.Forms.Button().
    this-object:tbMessage = new System.Windows.Forms.TextBox().
    this-object:SuspendLayout().
    /*  */
    /* btnOK */
    /*  */
    this-object:btnOK:Anchor = System.Windows.Forms.AnchorStyles:Bottom.
    this-object:btnOK:DialogResult = System.Windows.Forms.DialogResult:OK.
    this-object:btnOK:Location = new System.Drawing.Point(359, 229).
    this-object:btnOK:Name = "btnOK".
    this-object:btnOK:Size = new System.Drawing.Size(75, 23).
    this-object:btnOK:TabIndex = 1.
    this-object:btnOK:Text = "OK".
    this-object:btnOK:UseCompatibleTextRendering = true.
    this-object:btnOK:UseVisualStyleBackColor = true.
    /*  */
    /* tbMessage */
    /*  */
    define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
    nestedvar0 = cast(Progress.Util.EnumHelper:Or(cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
    this-object:tbMessage:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
    this-object:tbMessage:Location = new System.Drawing.Point(3, 4).
    this-object:tbMessage:Multiline = true.
    this-object:tbMessage:Name = "tbMessage".
    this-object:tbMessage:ReadOnly = true.
    this-object:tbMessage:Size = new System.Drawing.Size(786, 221).
    this-object:tbMessage:TabIndex = 2.
    /*  */
    /* c_messagebox_win32 */
    /*  */
    this-object:AcceptButton = this-object:btnOK.
    this-object:AutoSizeMode = System.Windows.Forms.AutoSizeMode:GrowAndShrink.
    this-object:CancelButton = this-object:btnOK.
    this-object:ClientSize = new System.Drawing.Size(792, 264).
    this-object:Controls:Add(this-object:tbMessage).
    this-object:Controls:Add(this-object:btnOK).
    this-object:Name = "c_messagebox_win32".
    this-object:Tag = "".
    this-object:Text = "Message".
    this-object:Load:subscribe(this-object:c_messagebox_win32_Load).
    this-object:ResumeLayout(false).
    this-object:PerformLayout().
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.
  end method.


  destructor public c_messagebox_win32 ( ):

    if valid-object(components) then 
    do:
      cast(components, System.IDisposable):Dispose().
    end.

  end destructor.


end class.

/* EOF */ 

