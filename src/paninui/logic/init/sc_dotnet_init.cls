using System.Windows.*. 
using System.Globalization.*.
using System.ComponentModel.*.
using System.Windows.Markup.*.
using Progress.Util.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class paninui.logic.init.sc_dotnet_init: 

  /****************************** Source Header ********************************\

      Description: Initialization code for any .NET environment from the ABL (WPF, Forms, No-GUI, etc etc)

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable bInitialized as logical no-undo.
  
  method public static void DotnetInit():
  
    if not bInitialized then 
    do:
      bInitialized = true.

      FrameworkElement:LanguageProperty:OverrideMetadata(
        TypeHelper:GetType("System.Windows.FrameworkElement"),
        new FrameworkPropertyMetadata(
        XmlLanguage:GetLanguage(
        CultureInfo:CurrentCulture:IetfLanguageTag
        ))).
    end.
  
  end method. /* DotnetInit */

end class.

/* EOF */ 
