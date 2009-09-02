{panaedra/msi/logic/ctop_class.i}
using paninui.view.interfaces.*.
using panaedra.msdr.logic.*.

class paninui.view.use.sc_coll_widgetdata   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/sc_coll_widgetdata.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-02 16:47:42+02:00 $ 
    Date Modified: $Modtime: 2009-09-01 09:50:30+02:00 $ 

      Description: Collection of widget data. "Collection" (_coll_) is used to 
                   indicate local storage of child data, normally in a temp-table.
      
  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_coll_widgetdata(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  {paninui/view/use/sc_coll_widgetdata_tt.i &class=true &protected=protected &static=static}
  
  method public static int64 FrameAdd (oPackIP# as i_pack, oUiFrameIP# as i_uiframe):

    define variable bEclipseFix# as logical no-undo.  
    def buffer ttUIFrame for ttUIFrame.
    
    do for ttUIFrame:
      
      create ttUIFrame.
      assign 
        ttUIFrame.iIDUIFrame = oUiFrameIP#:UniqueInstanceID.
      sc_dbtrig:OnWriteOrCreate(buffer ttUIFrame:handle ).
      assign
        ttUIFrame.iPackID    = oPackIP#:UniqueInstanceID 
        ttUIFrame.cFrameName = oUiFrameIP#:UniqueFrameName
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
    input  oWidgettypeGridOVID# as i_widgettype_griditem, /* *OVID# is not a real parameter, but an interface overload ID */
    input  iIDUIFrameIP#        as int64,
    input  cNameIP#             as char,
    input  iIDParentIP#         as int64,
    input  oParentIP#           as Progress.Lang.Object,
    input  oWidgetIP#           as Progress.Lang.Object):
    
    /* This method returns the new iID of the created ttWidgetData. */ 
    
    return ItemAdd(iIDUIFrameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "griditem"). 
    
    
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

  method public static int64 ItemAdd (
    input  oWidgettypeComboboxOVID# as i_widgettype_groupframe, /* *OVID# is not a real parameter, but an interface overload ID */
    input  iIDUIFrameIP#            as int64,
    input  cNameIP#                 as char,
    input  iIDParentIP#             as int64,
    input  oParentIP#               as Progress.Lang.Object,
    input  oWidgetIP#               as Progress.Lang.Object):

    return ItemAdd(iIDUIFrameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "groupframe"). 

  end method. /* ItemAdd */

  method public static int64 ItemAdd (
    input  oWidgettypeComboboxOVID# as i_widgettype_button, /* *OVID# is not a real parameter, but an interface overload ID */
    input  iIDUIFrameIP#            as int64,
    input  cNameIP#                 as char,
    input  iIDParentIP#             as int64,
    input  oParentIP#               as Progress.Lang.Object,
    input  oWidgetIP#               as Progress.Lang.Object):

    return ItemAdd(iIDUIFrameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "button"). 

  end method. /* ItemAdd */

  method public static int64 ItemAdd (
    input  oWidgettypeComboboxOVID# as i_widgettype_tree, /* *OVID# is not a real parameter, but an interface overload ID */
    input  iIDUIFrameIP#            as int64,
    input  cNameIP#                 as char,
    input  iIDParentIP#             as int64,
    input  oParentIP#               as Progress.Lang.Object,
    input  oWidgetIP#               as Progress.Lang.Object):

    return ItemAdd(iIDUIFrameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "tree"). 

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
      assign 
        ttWidgetData.iIDUiFrame          = iIDUIFrameIP#
        ttWidgetData.cWidgetName         = cNameIP#
        ttWidgetData.iIDWidgetDataParent = iIDParentIP#
        ttWidgetData.cWidgetType         = cWidgetTypeIP#
        ttWidgetData.oWidget             = oWidgetIP#
        ttWidgetData.oParent             = oParentIP#. 
      
      case cWidgetTypeIP#:
        when "grid"       then 
          ttWidgetData.cLinkName = substring(ttWidgetData.cWidgetName,7).
        when "griditem"   then 
          ttWidgetData.cLinkName = ttWidgetData.cWidgetName.
        when "combobox"   then 
          ttWidgetData.cLinkName = substring(ttWidgetData.cWidgetName,3).
        when "button"     then 
          ttWidgetData.cLinkName = substring(ttWidgetData.cWidgetName,4).
        when "tree"       then 
          ttWidgetData.cLinkName = substring(ttWidgetData.cWidgetName,5).
        when "groupframe" then 
          ttWidgetData.cLinkName = substring(ttWidgetData.cWidgetName,6).
      end case.
      
      ttWidgetData.cLinkName = replace(ttWidgetData.cLinkName,"__",".").

      return ttWidgetData.iIDWidgetData.
      
    end.
    
  end method. /* ItemAdd */
  
  
  method public static Progress.Lang.Object GetWidget(
    input  iPackIdIP#      as int64, 
    input  cWidgetTypeIP#  as char, 
    input  hBuffOrQueryIP# as handle,
    input  cDataRefIP#     as character,
    output bIsDisplayLinkedOP# as logical):
    
    define variable cLinkName# as character no-undo.

    define buffer ttUIFrame    for ttUIFrame.
    define buffer ttWidgetData for ttWidgetData.
    
    do for ttUIFrame, ttWidgetData:
      
      
      case cWidgetTypeIP#:
        when "grid" then 
          cLinkName# = hBuffOrQueryIP#:name.
        otherwise 
          cLinkName# = cDataRefIP#.
      end case.
      
      if cLinkName# begins "tt" then cLinkName# = substring(cLinkName#,3).
      
      b_getwidget:
      for each ttUIFrame where ttUIFrame.iPackID = iPackIdIP#,
        each ttWidgetData of ttUIFrame
        where ttWidgetData.cWidgetType = cWidgetTypeIP#
        and   ttWidgetData.cLinkName   = cLinkName#:
        bIsDisplayLinkedOP# = ttWidgetData.bIsDisplayLinked.
        return ttWidgetData.oWidget.
      end.
        
    end.
    
    
  end method. /* GetWidget : with dataset */
  
  
  method public static Progress.Lang.Object GetWidget(
    input  iPackIdIP#      as int64, 
    input  cWidgetTypeIP#  as char, 
    input  cDataRefIP#     as character,
    output bIsDisplayLinkedOP# as logical):
    
    define variable cLinkName# as character no-undo.

    define buffer ttUIFrame    for ttUIFrame.
    define buffer ttWidgetData for ttWidgetData.
    
    do for ttUIFrame, ttWidgetData:
      
      cLinkName# = cDataRefIP#.
      
/*      if cLinkName# begins "tt" then cLinkName# = substring(cLinkName#,3).*/
      
      if cWidgetTypeIP# = "any" then
      b_getwidget_all:
      for each ttUIFrame where ttUIFrame.iPackID = iPackIdIP#,
        each ttWidgetData of ttUIFrame
        where ttWidgetData.cLinkName   = cLinkName#:
        bIsDisplayLinkedOP# = ttWidgetData.bIsDisplayLinked.
        return ttWidgetData.oWidget.
      end.
        
      else
      b_getwidget_type:
      for each ttUIFrame where ttUIFrame.iPackID = iPackIdIP#,
        each ttWidgetData of ttUIFrame
        where ttWidgetData.cWidgetType = cWidgetTypeIP#
        and   ttWidgetData.cLinkName   = cLinkName#:
        bIsDisplayLinkedOP# = ttWidgetData.bIsDisplayLinked.
        return ttWidgetData.oWidget.
      end.
        
    end.
    
  end method. /* GetWidget : only by type (or any type) and name */
  
  
  method public static void SetDisplayLinked(oWidgetIP# as Progress.Lang.Object):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttWidgetData for ttWidgetData.
    
    if oWidgetIP# <> ? then do for ttWidgetData:
      
      find first ttWidgetData where ttWidgetData.oWidget = oWidgetIP#.
      
      ttWidgetData.bIsDisplayLinked = true.
      
    end.
    
  end method.
  
  method public static void GetGridColumns(
    oGridIP# as Progress.Lang.Object, 
    output oGridColumnsOP# as Progress.Lang.Object extent):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttWidgetData for ttWidgetData.
    
    define variable iExtentSize# as integer no-undo.
    define variable iTell#       as integer no-undo.
    
    do for ttWidgetData:
      
      for each ttWidgetData where ttWidgetData.oParent = oGridIP#:
        iExtentSize# = iExtentSize# + 1.
      end.
      
      extent(oGridColumnsOP#) = iExtentSize#.
      
      iTell# = 0.
      for each ttWidgetData where ttWidgetData.oParent = oGridIP#:
        iTell# = iTell# + 1.
        oGridColumnsOP#[iTell#] = ttWidgetData.oWidget.
      end.
      
    end.
    
    
  end method.
  
  
  method public static void DebugShowData():

    if tool.sc-html:TempTableToHTML(buffer ttWidgetData:handle, tool.sc-path:cTempDir + "ttWidgetData.html") then 
      tool.sc-win32:ShellExecute(tool.sc-path:cTempDir + "ttWidgetData.html"). /* Open bestandje */

  end method. /* DebugShowData */

end class.

/* EOF */
