{panaedra/msi/logic/ctop_class.i} 

class paninui.view.use.analyze.sc_analyzewidget   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/analyze/sc_analyzewidget.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-09 14:37:48+01:00 $ 
    Date Modified: $Modtime: 2010-01-09 14:36:48+01:00 $ 

      Description: Analysis on widgets of any UI technology

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_analyzewidget(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  method public static character IsOfUiTechnology(oWidgetIP# as Progress.Lang.Object):
    
    /* Returns an identifier to the used UI technology.
       For now: "windows_forms" and "windows_wpf" is supported (and "progress_class" if something strange happens). 
    */
    
    define variable bDetermined# as logical   no-undo.
    define variable cReturn#     as character no-undo.
    
    /* Check for WPF */
    if not bDetermined# and type-of(oWidgetIP#, System.Windows.UIElement) then 
      assign
        bDetermined# = true 
        cReturn#     = "windows_wpf".
    
    /* Check for WPF */
    if not bDetermined# and type-of(oWidgetIP#, System.Windows.UIElement3D) then 
      assign
        bDetermined# = true 
        cReturn#     = "windows_wpf".
    
    /* Keep this last for namespace "System.*" */
    if not bDetermined# and type-of(oWidgetIP#, System.Object) then 
      assign
        bDetermined# = true 
        cReturn#     = "windows_forms".
      
    /* We don't know what this is, must be non-dotnet */
    if not bDetermined# then 
      assign
        bDetermined# = true 
        cReturn#     = "progress_class".
    
    return cReturn#.

  end method. /* IsOfUiTechnology */

end class.

/* EOF */ 
