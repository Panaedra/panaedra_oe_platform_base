using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using paninui.view.use.analyze.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
{paninui/logic/includes/preproc_dotnetclasses.i} 

class paninui.view.use.display.sc_displayproperty_renamebytechnology: 

  /****************************** Source Header ********************************\

      Description: Rename properties from the logic layer (framework independent) to the currently used widget technology (for example Forms or WPF).

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method public static void RenameWidgetPropertyByUiTechnology(
  
    /* For example: "Enabled" must be renamed to "IsEnabled" for WPF widgets */
    
    input        oWidgetIP#    as Progress.Lang.Object, 
    input-output cPropertyIOP# as character,
    input-output cValueIOP#    as character,
    output       oValueOP#     as Progress.Lang.Object):

    &if {&paninui_tty} = false &then

    /* Abstraction of widget properties (Note: syntax Ctrl-I formatting is a bit hayward here, can't be helped.) */
    case sc_analyzewidget:IsOfUiTechnology(oWidgetIP#):
        
      when "windows_wpf" then 
        do: 
          case cPropertyIOP#:
            when "Enabled" then 
              cPropertyIOP# = "IsEnabled".
            when "Checked" then 
              cPropertyIOP# = "IsChecked".
            when "BarCode" then /* Only for backward compatibility */
              cPropertyIOP# = "Text".
            when "ImageLocation" then 
              cPropertyIOP# = "Source".
          end case.
          case true:
            when type-of(oWidgetIP#, System.Windows.Controls.PasswordBox) then 
              do:
                case cPropertyIOP#:
                  when "Text" then 
                    cPropertyIOP# = "Password".
                end case.
              end.
          end case.
        end.
        
      when "windows_forms" then
        case  cPropertyIOP#:
          when "Dock" then 
            case cValueIOP#:
              when "Bottom" then 
                oValueOP# = System.Windows.Forms.DockStyle:Bottom.
              when "Top" then 
                oValueOP# = System.Windows.Forms.DockStyle:Top.
              when "Left" then 
                oValueOP# = System.Windows.Forms.DockStyle:Left.
              when "Right" then 
                oValueOP# = System.Windows.Forms.DockStyle:Right.
            end case.
        end case. 
        
      otherwise sc_messagebox:Show(sc_messageboxtype:oDebug,
        sc_analyzewidget:IsOfUiTechnology(oWidgetIP#),
        "is not implemented.").
                
    end case. /* IsOfUiTechnology ; Abstraction of widget properties  */

    &endif /* {&paninui_tty} = false */
    
  end method. /* RenameWidgetPropertyByUiTechnology */
  
end class.

/* EOF */ 
