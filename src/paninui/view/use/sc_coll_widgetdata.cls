{panaedra/msi/logic/ctop_class.i}
using paninui.view.interfaces.*.
using panaedra.msdr.logic.*.

class paninui.view.use.sc_coll_widgetdata   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/sc_coll_widgetdata.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-08-29 23:08:22+02:00 $ 
    Date Modified: $Modtime: 2009-08-29 23:08:22+02:00 $ 

      Description: Collection of widget data. "Collection" (_coll_) is used to 
                   indicate local storage of child data, normally in a temp-table.
      
  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_coll_widgetdata(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  {paninui/view/use/sc_coll_widgetdata_tt.i &class=true}
  
  method public static int64 FrameAdd (oUiFrameIP# as i_uiframe):
    
    def buffer ttUIFrame for ttUIFrame.
    
    do for ttUIFrame:
      
      create ttUIFrame.
      assign ttUIFrame.iIDUIFrame = oUiFrameIP#:UniqueInstanceID.
      sc_dbtrig:OnWriteOrCreate(buffer ttUIFrame:handle ).
      assign ttUIFrame.cFrameName = oUiFrameIP#:UniqueFrameName
             ttUIFrame.oFrame     = oUiFrameIP#.
      
      return ttUIFrame.iIDUIFrame.
      
    end.
    
  end method. /* FrameAdd */
  
  method public static int64 ItemAdd (
    input  oWidgettypeGridOVID# as i_widgettype_grid, /* *OVID# is not a real parameter, but an interface overload ID */
    input  iIDUIFrameIP#        as int64,
    input  cNameIP#             as char,
    input  iIDParentIP#         as int64,
    input  oParentIP#           as Progress.Lang.Object,
    input  oWidgetIP#           as Progress.Lang.Object):
    
    /* This method returns the new iID of the created ttWidgetData. */ 
    
    return ItemAdd(iIDUIFrameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "grid"). 
    
    
  end method. /* ItemAdd */

  method public static int64 ItemAdd (
    input  oWidgettypeComboboxOVID# as i_widgettype_combobox, /* *OVID# is not a real parameter, but an interface overload ID */
    input  iIDUIFrameIP#            as int64,
    input  cNameIP#                 as char,
    input  iIDParentIP#             as int64,
    input  oParentIP#               as Progress.Lang.Object,
    input  oWidgetIP#               as Progress.Lang.Object):

    return ItemAdd(iIDUIFrameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "combobox"). 

  end method. /* ItemAdd */

  method protected static int64 ItemAdd (
    input  iIDUIFrameIP#        as int64,
    input  cNameIP#             as char,
    input  iIDParentIP#         as int64,
    input  oParentIP#           as Progress.Lang.Object,
    input  oWidgetIP#           as Progress.Lang.Object,
    input  cWidgetTypeIP#       as char):
    
    /* This method returns the new iID of the created ttWidgetData. */ 
    
    def buffer ttWidgetData for ttWidgetData.
    
    do for ttWidgetData:
    
      create ttWidgetData.
      panaedra.msdr.logic.sc_dbtrig:OnWriteOrCreate(buffer ttWidgetData:handle ).
      assign ttWidgetData.iIDUiFrame          = iIDUIFrameIP#
             ttWidgetData.cWidgetName         = cNameIP#
             ttWidgetData.iIDWidgetDataParent = iIDParentIP#
             ttWidgetData.cWidgetType         = cWidgetTypeIP#
             ttWidgetData.oWidget             = oWidgetIP#
             ttWidgetData.oParent             = oParentIP#. 
      
      return ttWidgetData.iIDWidgetData.
      
    end.
    
  end method. /* ItemAdd */
  
  
  method public static void DebugShowData():

    if tool.sc-html:TempTableToHTML(buffer ttWidgetData:handle, tool.sc-path:cTempDir + "ttWidgetData.html") then 
      tool.sc-win32:ShellExecute(tool.sc-path:cTempDir + "ttWidgetData.html"). /* Open bestandje */

  end method. /* DebugShowData */

end class.

/* EOF */
