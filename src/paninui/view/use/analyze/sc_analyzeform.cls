{panaedra/msi/logic/ctop_class.i} 

class paninui.view.use.analyze.sc_analyzeform: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/analyze/sc_analyzeform.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-28 15:21:29+01:00 $ 
    Date Modified: $Modtime: 2009-10-28 15:21:29+01:00 $ 

      Description: Analyze a Form (of WPF window). For example getting the active
                   widget.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_analyzeform(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
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
    
    define variable oFormsChildContainer# as System.Windows.Forms.IContainerControl no-undo.
    define variable oLocalFocus#          as Progress.Lang.Object                   no-undo.
     
    oLocalFocus# = oFormsContainer#:ActiveControl. 
     
    if type-of(oLocalFocus#, System.Windows.Forms.IContainerControl) then 
    do:
      oFormsChildContainer# = cast(cast(oLocalFocus#,Progress.Lang.Object), System.Windows.Forms.IContainerControl).
      return GetFocusedRecursive(oFormsChildContainer#).
    end.
    
    return oLocalFocus#.

  end method. /* GetFocusedRecursive ; Forms container control */  

end class.

/* EOF */ 
