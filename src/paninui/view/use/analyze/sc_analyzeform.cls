{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class paninui.view.use.analyze.sc_analyzeform: 

  /****************************** Source Header ********************************\

      Description: Analyze a Form (or WPF window). For example getting the active
                   widget.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/


  method public static Progress.Lang.Object GetFocus():
    
    define variable oMdiWindow#      as paninui.view.interfaces.i_masterwindow no-undo.
    define variable oFormsContainer# as System.Windows.Forms.IContainerControl no-undo.
    define variable oFocus#          as Progress.Lang.Object                   no-undo.
    
    oMdiWindow# = paninui.view.init.events.sc_sgt_masterwindow_eventhandler:oMdiWindow.
    
    if type-of(oMdiWindow#, System.Windows.Forms.IContainerControl) then 
    do:
      oFormsContainer# = cast(cast(oMdiWindow#,Progress.Lang.Object), System.Windows.Forms.IContainerControl).
      oFocus# = GetFocusedRecursive(oFormsContainer#).
    end.
    else 
      oFocus# = oMdiWindow#.
    
    return oFocus#.

  end method. /* GetFocus */
  
  
  method protected static Progress.Lang.Object GetFocusedRecursive(oFormsContainer# as System.Windows.Forms.IContainerControl):
    
    define variable oFormsChildContainer# as System.Windows.Forms.IContainerControl       no-undo.
    define variable oWpfElementHost#      as System.Windows.Forms.Integration.ElementHost no-undo.
    define variable oWpfElementChild#     as System.Windows.UIElement                     no-undo.
    define variable oLocalFocus#          as Progress.Lang.Object                         no-undo.
     
    oLocalFocus# = oFormsContainer#:ActiveControl. 
    
    case true:
     
      when type-of(oLocalFocus#, System.Windows.Forms.IContainerControl) then 
        do:
          oFormsChildContainer# = cast(cast(oLocalFocus#,Progress.Lang.Object), System.Windows.Forms.IContainerControl).
          return GetFocusedRecursive(oFormsChildContainer#).
        end.
      
      when type-of(oLocalFocus#, System.Windows.Forms.Integration.ElementHost) then 
        do:
          assign
            oWpfElementHost#  = cast(oLocalFocus#, System.Windows.Forms.Integration.ElementHost)
            oWpfElementChild# = oWpfElementHost#:Child.
          return System.Windows.Input.Keyboard:FocusedElement.
        end.
    
    end case.
    
    return oLocalFocus#.

  end method. /* GetFocusedRecursive ; Forms or WPF container control */  

end class.

/* EOF */ 
