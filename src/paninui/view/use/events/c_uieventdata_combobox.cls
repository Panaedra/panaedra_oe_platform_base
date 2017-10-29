{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class paninui.view.use.events.c_uieventdata_combobox
  inherits 
  paninui.view.use.events.c_uieventdata
  implements
  paninui.view.interfaces.i_uieventdata: 

  /****************************** Source Header ********************************\

      Description: 

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  /******************************* $NoKeywords:  $ *****************************/

  &if opsys = "unix" or "{&window-system}" = "tty" &then
    &glob Generic_Object Progress.Lang.Object
  &else
    &glob Generic_Object System.Object
  &endif
  
  define public property bForceTextUpdate as logical no-undo get. set.
  
  constructor public c_uieventdata_combobox(
  
    cInfoIP#        as character, 
    cDataIP#        as character, 
    oObjectIP#      as {&Generic_Object}, 
    iPackIdIP#      as int64, 
    iFocusPackIdIP# as int64, 
    oUiValueIP#     as paninui.view.interfaces.i_uivalue):

    super(cInfoIP#,cDataIP#,oObjectIP#,iPackIdIP#,iFocusPackIdIP#,oUiValueIP#).
    
  end constructor.

end class.

/* EOF */ 
