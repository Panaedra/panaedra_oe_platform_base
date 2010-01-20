{panaedra/msi/logic/ctop_class.i}

using paninui.view.interfaces.*.
using paninui.pack.interfaces.*.
using paninui.view.init.display.*.
using paninui.view.use.*.

using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msdr.logic.*.

class paninui.view.use.sc_coll_widgetdata   
  implements
  panaedra.msroot.msutil.interfaces.i_eventbroadcastclient:
  
  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/sc_coll_widgetdata.cls $ 
          Version: $Revision: 25 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-20 15:42:02+01:00 $ 
    Date Modified: $Modtime: 2010-01-20 15:18:43+01:00 $ 

      Description: Collection of widget data. "Collection" (_coll_) is used to 
                   indicate local storage of runtime data, normally in a temp-table.
      
  \*****************************  Include Files ********************************/

  {paninui/view/use/sc_coll_widgetdata_tt.i &class=true &protected=protected &static=static}

  /************************  Source control constructor ************************/
  constructor public sc_coll_widgetdata(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 25 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected static variable oSingleton as sc_coll_widgetdata no-undo.


  constructor protected sc_coll_widgetdata():
    
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@c_qry@querydelete").
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@c_buf@bufferdelete").
    sc_eventbroadcaster:SubscribeEvent(this-object,"evt@c_bindingsource@bindingsourcedelete").

  end constructor.
  
  
  constructor static sc_coll_widgetdata():
  
    oSingleton = new sc_coll_widgetdata().
  
  end constructor.
  
    
  method public static int64 FrameAdd (oPackIP# as i_pack, oUiFrameIP# as i_uiframe):
    
    /* TODO: perhaps use the overload with LinkFrameName (which was implemented when subframes were implemented) */
    FrameAdd (oPackIP#, oUiFrameIP#, "Initial").
    
  end method.
  

  method public static int64 FrameAdd (oPackIP# as i_pack, oUiFrameIP# as i_uiframe, cLinkFrameNameIP# as character):

    define variable bEclipseFix# as logical no-undo.  
    def buffer ttUIFrame for ttUIFrame.
    
    do for ttUIFrame:
      
      find first ttUIFrame where ttUIFrame.iIDUIFrame = oUiFrameIP#:iUiFrameID no-error.
      
      if not avail ttUIFrame then 
      do:
        create ttUIFrame.
        assign 
          ttUIFrame.iIDUIFrame = oUiFrameIP#:iUiFrameID.
        sc_dbtrig:OnWriteOrCreate(buffer ttUIFrame:handle ).
      end.
      
      assign
        ttUIFrame.iPackID        = oPackIP#:iPackID 
        ttUIFrame.cFrameName     = oUiFrameIP#:cUiFrameName
        ttUIFrame.cLinkFrameName = cLinkFrameNameIP#
        ttUIFrame.oFrame         = oUiFrameIP#.
      
      return ttUIFrame.iIDUIFrame.
      
    end.
    
  end method. /* FrameAdd */

  
  method public static void HidePackFrames (iPackIDIP# as int64):

    define variable bEclipseFix# as logical no-undo.  
    def buffer ttUIFrame for ttUIFrame.
    
    do for ttUIFrame:
      
      find first ttUIFrame where ttUIFrame.iPackID = iPackIDIP#  no-error.
      
      if avail ttUIFrame then 
      do:
        
        if valid-object(ttUIFrame.oFrame) and type-of(ttUIFrame.oFrame, System.Windows.Forms.Control) 
          then cast(ttUIFrame.oFrame, System.Windows.Forms.Control):Visible = false.
        
      end.
      
    end.
    
  end method. /* HidePackFrames */

  
  method public static int64 ItemAdd (
    input  oWidgettypeGridOVID# as i_widgettype_grid, /* *OVID# is not a real parameter, but an interface overload ID */
    input  iIDUIFrameIP#        as int64,
    input  cFullNameIP#         as character,
    input  cNameIP#             as character,
    input  iIDParentIP#         as int64,
    input  oParentIP#           as Progress.Lang.Object,
    input  oWidgetIP#           as Progress.Lang.Object):
    
    /* This method returns the new iID of the created ttWidgetData. */ 
    
    return ItemAddImplement(iIDUIFrameIP#, cFullNameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "grid"). 
    
    
  end method. /* ItemAdd */


  method public static int64 ItemAdd (
    input  oWidgettypeGriditemOVID# as i_widgettype_griditem, /* *OVID# is not a real parameter, but an interface overload ID */
    input  iIDUIFrameIP#            as int64,
    input  cFullNameIP#         as character,
    input  cNameIP#                 as character,
    input  iIDParentIP#             as int64,
    input  oParentIP#               as Progress.Lang.Object,
    input  oWidgetIP#               as Progress.Lang.Object):
    
    /* This method returns the new iID of the created ttWidgetData. */ 
    
    return ItemAddImplement(iIDUIFrameIP#, cFullNameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "griditem"). 
    
    
  end method. /* ItemAdd */


  method public static int64 ItemAdd (
    input  oWidgettypeComboboxOVID# as i_widgettype_combobox, /* *OVID# is not a real parameter, but an interface overload ID */
    input  iIDUIFrameIP#            as int64,
    input  cFullNameIP#         as character,
    input  cNameIP#                 as character,
    input  iIDParentIP#             as int64,
    input  oParentIP#               as Progress.Lang.Object,
    input  oWidgetIP#               as Progress.Lang.Object):

    return ItemAddImplement(iIDUIFrameIP#, cFullNameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "combobox"). 

  end method. /* ItemAdd */


  method public static int64 ItemAdd (
    input  oWidgettypeGroupframeOVID# as i_widgettype_groupframe, /* *OVID# is not a real parameter, but an interface overload ID */
    input  iIDUIFrameIP#            as int64,
    input  cFullNameIP#         as character,
    input  cNameIP#                 as character,
    input  iIDParentIP#             as int64,
    input  oParentIP#               as Progress.Lang.Object,
    input  oWidgetIP#               as Progress.Lang.Object):

    return ItemAddImplement(iIDUIFrameIP#, cFullNameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "groupframe"). 

  end method. /* ItemAdd */


  method public static int64 ItemAdd (
    input  oWidgettypeToolbarOVID# as i_widgettype_toolbar, /* *OVID# is not a real parameter, but an interface overload ID */
    input  iIDUIFrameIP#            as int64,
    input  cFullNameIP#         as character,
    input  cNameIP#                 as character,
    input  iIDParentIP#             as int64,
    input  oParentIP#               as Progress.Lang.Object,
    input  oWidgetIP#               as Progress.Lang.Object):

    return ItemAddImplement(iIDUIFrameIP#, cFullNameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "toolbar"). 

  end method. /* ItemAdd */


  method public static int64 ItemAdd (
    input  oWidgettypeButtonOVID# as i_widgettype_button, /* *OVID# is not a real parameter, but an interface overload ID */
    input  iIDUIFrameIP#          as int64,
    input  cFullNameIP#           as character,
    input  cNameIP#               as character,
    input  iIDParentIP#           as int64,
    input  oParentIP#             as Progress.Lang.Object,
    input  oWidgetIP#             as Progress.Lang.Object):

    return ItemAddImplement(iIDUIFrameIP#, cFullNameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "button"). 

  end method. /* ItemAdd */


  method public static int64 ItemAdd (
    input  oWidgettypeTreeOVID# as i_widgettype_tree, /* *OVID# is not a real parameter, but an interface overload ID */
    input  iIDUIFrameIP#        as int64,
    input  cFullNameIP#         as character,
    input  cNameIP#             as character,
    input  iIDParentIP#         as int64,
    input  oParentIP#           as Progress.Lang.Object,
    input  oWidgetIP#           as Progress.Lang.Object):

    return ItemAddImplement(iIDUIFrameIP#, cFullNameIP#, cNameIP#, iIDParentIP#, oParentIP#, oWidgetIP#, "tree"). 

  end method. /* ItemAdd */


  method protected static int64 ItemAddImplement(
    input  iIDUIFrameIP#        as int64,
    input  cFullNameIP#         as character,
    input  cNameIP#             as character,
    input  iIDParentIP#         as int64,
    input  oParentIP#           as Progress.Lang.Object,
    input  oWidgetIP#           as Progress.Lang.Object,
    input  cWidgetTypeIP#       as char):
    
    /* This method returns the new iID of the created ttWidgetData. */ 
    
    def buffer ttWidgetData          for ttWidgetData.
    def buffer b-parent-ttWidgetData for ttWidgetData.
    
    do for ttWidgetData, b-parent-ttWidgetData:
    
      create ttWidgetData.
      panaedra.msdr.logic.sc_dbtrig:OnWriteOrCreate(buffer ttWidgetData:handle ).
      assign 
        ttWidgetData.iIDUiFrame          = iIDUIFrameIP#
        ttWidgetData.cWidgetName         = cFullNameIP#
        ttWidgetData.iIDWidgetDataParent = iIDParentIP#
        ttWidgetData.cWidgetType         = cWidgetTypeIP#
        ttWidgetData.oWidget             = oWidgetIP#
        ttWidgetData.oParent             = oParentIP#. 
      
      case cWidgetTypeIP#:
        when "grid"       then 
          ttWidgetData.cLinkName = cNameIP#.
        when "griditem"   then 
          ttWidgetData.cLinkName = cNameIP#.
        when "combobox"   then 
          ttWidgetData.cLinkName = cNameIP#.
        when "button"     then 
          ttWidgetData.cLinkName = cNameIP#.
        when "tree"       then 
          ttWidgetData.cLinkName = cNameIP#.
        when "groupframe" then 
          ttWidgetData.cLinkName = cNameIP#.
        when "toolbar" then
          ttWidgetData.cLinkName = cNameIP#.
      end case.
      
      ttWidgetData.cLinkName = replace(ttWidgetData.cLinkName,"__",".").

      if ttWidgetData.cLinkName begins "." and iIDParentIP# <> 0 then 
      do:
        find b-parent-ttWidgetData where b-parent-ttWidgetData.iIDWidgetData = iIDParentIP# no-error.
        if avail b-parent-ttWidgetData and b-parent-ttWidgetData.cWidgetType = "toolbar" then 
        do:
          ttWidgetData.cLinkName = subst("&1&2", b-parent-ttWidgetData.cLinkName, ttWidgetData.cLinkName).
        end.  
      end.
      
      /* Always trim any start dots off the LinkName (Parent is already prepended here). */
      ttWidgetData.cLinkName = left-trim(ttWidgetData.cLinkName,".").

      return ttWidgetData.iIDWidgetData.
      
    end.
    
  end method. /* ItemAddImplement */
  
  
  method public static Progress.Lang.Object GetBindingSource(
    input  iPackIdIP#      as int64, 
    input  cWidgetTypeIP#  as character, 
    input  hBuffOrQueryIP# as handle,
    input  cDataRefIP#     as character):
      
    define variable cLinkName#    as character            no-undo.
    define variable cLinkNameAlt# as character            no-undo.
    define variable oReturn#      as Progress.Lang.Object no-undo.
    
    define buffer ttUIFrame    for ttUIFrame.
    define buffer ttWidgetData for ttWidgetData.
    
    do for ttUIFrame, ttWidgetData:
      
      GetLinkNameLinkNameAlt(cDataRefIP#, cWidgetTypeIP#, hBuffOrQueryIP#, output cLinkName#, output cLinkNameAlt#).
      
      b_getwidget:
      for each ttUIFrame where ttUIFrame.iPackID = iPackIdIP#,
        each ttWidgetData of ttUIFrame
        where ttWidgetData.cWidgetType = cWidgetTypeIP#
        and   ttWidgetData.cLinkName   = cLinkName#
        on error undo, throw:
        oReturn# = ttWidgetData.oBindingSource.
        if oReturn# <> ? then leave b_getwidget.
      end.
      
      if oReturn# = ? and cLinkNameAlt# > "" then
        b_getwidgetAlt:
        for each ttUIFrame where ttUIFrame.iPackID = iPackIdIP#,
          each ttWidgetData of ttUIFrame
          where ttWidgetData.cWidgetType = cWidgetTypeIP#
          and   ttWidgetData.cLinkName   = cLinkNameAlt#
          on error undo, throw:
          oReturn# = ttWidgetData.oBindingSource.
          if oReturn# <> ? then leave b_getwidgetAlt.
        end.
      
      if oReturn# = ? then 
      do:
        /* Find first widget of the same table, and assume 
           the bindingsource is registered on the buffer
           associated with that widget. 
        */
        b_getBuffOrQuery:
        for each ttWidgetData
          where ttWidgetData.hBufferOrQuery = hBuffOrQueryIP#
          and   ttWidgetData.oBindingSource <> ?
          on error undo, throw:
          oReturn# = ttWidgetData.oBindingSource.
          if oReturn# <> ? then leave b_getBuffOrQuery.
        end.
        
      end.
      
      return oReturn#.
        
    end.
          
  end method. /* GetBindingSource + BufferOrQuery*/
  
  
  method public static Progress.Lang.Object _sys_GetBindingSource(
    input  oWidgetIP#      as Progress.Lang.Object):

    define buffer ttUIFrame    for ttUIFrame.
    define buffer ttWidgetData for ttWidgetData.

    do for ttUIFrame, ttWidgetData:

      find first ttWidgetData where ttWidgetData.oWidget = oWidgetIP# no-error.

      return if avail ttWidgetData then ttWidgetData.oBindingSource else ?.

    end.

  end method. /* _sys_GetBindingSource , directly by Object */

  
  method public static void GetLinkNameLinkNameAlt(
    cDataRefIP#       as character, 
    cWidgetTypeIP#     as character, 
    hBuffOrQueryIP# as handle, 
    output cLinkNameOP# as character, 
    output cLinkNameAltOP# as character):
    
    define variable iIndex# as integer no-undo.
    
    if cDataRefIP# > "" then 
    do:
      cLinkNameOP# = cDataRefIP#.
    end.
    else
      case cWidgetTypeIP#:
        when "grid" or 
        when "bufferchilds" then 
          case hBuffOrQueryIP#:type:
            when "data-relation" then 
              do:
                assign
                  /* We first search for a widget with the exact buffer name.
                     If not found, we search for a widget with the temp-table name.
                   */
                  cLinkNameOP# = hBuffOrQueryIP#:child-buffer:name.
                cLinkNameAltOP# = hBuffOrQueryIP#:child-buffer:table-handle:name.
              end.
            otherwise 
            do:
              assign
                /* We first search for a widget with the exact buffer name.
                   If not found, we search for a widget with the temp-table name.
                 */
                cLinkNameOP# = hBuffOrQueryIP#:name.
              if hBuffOrQueryIP#:type = "buffer" then cLinkNameAltOP# = hBuffOrQueryIP#:table-handle:name.
            end.
          end case.
        otherwise
        cLinkNameOP# = cDataRefIP#.
      end case.
      
    /* Search the left 15 characters for a buffer temp-table prefix */
    iIndex# = r-index(cLinkNameOP#,"-tt",15).
    if iIndex# > 0 then 
    do:
      /* Translate example: b-xxx-ttYYY -> b_xxx_Yyy */
      substring(cLinkNameOP#,iIndex# + 1, 2) = "".
    end.
      
    /* Search the left 15 characters for a buffer temp-table prefix */
    iIndex# = r-index(cLinkNameAltOP#,"-tt",15).
    if iIndex# > 0 then 
    do:
      /* Translate example: b-xxx-ttYYY -> b_xxx_Yyy */
      substring(cLinkNameAltOP#,iIndex# + 1, 2) = "".
    end.
      
    /* Dash is not supported in dotnet, so they won't find a match. Must be translated to underscores. */
    cLinkNameOP#    = replace(cLinkNameOP#,"-","_").
    cLinkNameAltOP# = replace(cLinkNameAltOP#,"-","_").
      
    /* Hash is not supported in dotnet, so they won't find a match. Must be translated to underscores. */
    cLinkNameOP#    = replace(cLinkNameOP#,"#","_").
    cLinkNameAltOP# = replace(cLinkNameAltOP#,"#","_").
      
    /* Forced convention: "tt" is not needed in UI design and should be omitted. */
    if cLinkNameOP#    begins "tt" then cLinkNameOP#    = substring(cLinkNameOP#,3).
    if cLinkNameAltOP# begins "tt" then cLinkNameAltOP# = substring(cLinkNameAltOP#,3).
      
  end method. /* GetLinkNameLinkNameAlt */
  
  
  method public static Progress.Lang.Object GetWidget(
    input  iPackIdIP#      as int64, 
    input  cWidgetTypeIP#  as character, 
    input  hBuffOrQueryIP# as handle,
    input  cDataRefIP#     as character,
    output bIsDisplayLinkedOP# as logical):
    
    /* Get a grid-type widget from the widgetdata collection (filled by AnalyzeFrame). */
    
    define variable cLinkName#    as character no-undo.
    define variable cLinkNameAlt# as character no-undo.
    
    define buffer ttUIFrame    for ttUIFrame.
    define buffer ttWidgetData for ttWidgetData.
    
    do for ttUIFrame, ttWidgetData:
      
      GetLinkNameLinkNameAlt(cDataRefIP#, cWidgetTypeIP#, hBuffOrQueryIP#, output cLinkName#, output cLinkNameAlt#).
      
      b_getwidget:
      for each ttUIFrame where ttUIFrame.iPackID = iPackIdIP#,
        each ttWidgetData of ttUIFrame
        where ttWidgetData.cWidgetType = cWidgetTypeIP#
        and   ttWidgetData.cLinkName   = cLinkName#:
        bIsDisplayLinkedOP# = ttWidgetData.bIsDisplayLinked.
        return ttWidgetData.oWidget.
      end.
        
      if cLinkNameAlt# > "" then
        b_getwidgetAlt:
        for each ttUIFrame where ttUIFrame.iPackID = iPackIdIP#,
          each ttWidgetData of ttUIFrame
          where ttWidgetData.cWidgetType = cWidgetTypeIP#
          and   ttWidgetData.cLinkName   = cLinkNameAlt#:
          bIsDisplayLinkedOP# = ttWidgetData.bIsDisplayLinked.
          return ttWidgetData.oWidget.
        end.
        
    end.
    
  end method. /* GetWidget : with dataset */


  method public static Progress.Lang.Object GetWidget(
    input  iPackIdIP#      as int64, 
    input  cWidgetTypeIP#  as character, 
    input  cDataRefIP#     as character):
    
    define variable bDummy# as logical no-undo.
    
    return GetWidget(
      input  iPackIdIP#    , 
      input  cWidgetTypeIP#, 
      input  cDataRefIP#   ,
      output bDummy#).
      
  end method.  


  method public static Progress.Lang.Object GetWidget(
    input  iPackIdIP#      as int64, 
    input  cWidgetTypeIP#  as character, 
    input  cDataRefIP#     as character,
    output bIsDisplayLinkedOP# as logical):
    
    /* Get a specific widget from the widgetdata collection (filled by AnalyzeFrame). */

    define variable cLinkName# as character no-undo.

    define buffer ttUIFrame    for ttUIFrame.
    define buffer ttWidgetData for ttWidgetData.
    
    do for ttUIFrame, ttWidgetData:
      
      cLinkName# = cDataRefIP#.
      
      /* TODO: screen design follows two standards, with and without tt. Choose plz. (!) */
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
  
  
  method public static Progress.Lang.Object GetWidgetByHandle(
    input  oWidgetIP#   as Progress.Lang.Object,
    output iPackIDOP#   as int64,
    output cLinkNameOP# as character):
    
    /* Get a widget from the widgetdata collection (filled by AnalyzeFrame). */
    
    define buffer ttUIFrame    for ttUIFrame.
    define buffer ttWidgetData for ttWidgetData.
    
    do for ttWidgetData:
      
      find first ttWidgetData where ttWidgetData.oWidget = oWidgetIP# no-error.

      if available ttWidgetData then 
      do:
        cLinkNameOP# = ttWidgetData.cLinkName.
        find first ttUIFrame of ttWidgetData no-error.
        iPackIDOP# = if available ttUIFrame then ttUIFrame.iPackID else 0.
      end.       

      return if available ttWidgetData then ttWidgetData.oWidget else ?.
        
    end.
    
  end method. /* GetWidgetByHandle */

  
  method public static i_uiframe GetFrameByLinkName(cLinkNameIP# as character):
    
    /* Return frame object found by the linkname */
    
    define variable oUiFrame# as i_uiframe no-undo.
    define buffer b-ttUIFrame for ttUIFrame.
    
    find first b-ttUIFrame where b-ttUIFrame.cLinkFrameName = cLinkNameIP# no-error.
    
    if not available b-ttUIFrame then
      return ?.
    else
    do:
      oUiFrame# = cast(b-ttUIFrame.oFrame, i_uiframe).
      return oUiFrame#.   
    end.
      
  end method. /* GetFrameByLinkName */  

  
  method public static Progress.Lang.Object extent GetChildWidgets(
    input  iPackIdIP#      as int64, 
    input  iGroupOVID#     as i_widgettype_groupframe, 
    input  cDataRefIP#     as character,
    output cLinkNamesOP#   as character extent)
    :
    
    /* Get all the widgets from the widgetdata collection that have 
       the incoming widget as their direct logical parent. */

    define variable cLinkName#      as character            no-undo.
    define variable oParent#        as Progress.Lang.Object no-undo.
    define variable bDisplayLinked# as logical              no-undo.
    define variable iExtentSize#    as integer              no-undo.
    define variable oReturn#        as Progress.Lang.Object no-undo extent.
    define variable cSvWidgetTypes# as character            no-undo init "combobox". /* We will probable support other widget types in the future. */

    define buffer ttUIFrame    for ttUIFrame.
    define buffer ttWidgetData for ttWidgetData.
    
    oParent# = GetWidget(iPackIdIP#, "groupframe", cDataRefIP#, output bDisplayLinked#).
    
    if valid-object(oParent#) then 
    do for ttUIFrame, ttWidgetData:
      
      for  
        each  ttWidgetData
        where ttWidgetData.oParent     = oParent#
        and   lookup(cSvWidgetTypes#, ttWidgetData.cWidgetType) > 0 
        ,
        first ttUIFrame of ttWidgetData 
        where ttUIFrame.iPackID = iPackIdIP#
        :
        iExtentSize# = iExtentSize# + 1.
      end.
      
      if iExtentSize# > 0 then 
      do:
        assign
          extent(oReturn#)      = iExtentSize#
          extent(cLinkNamesOP#) = iExtentSize#.  
        iExtentSize# = 0.
        for  
          each  ttWidgetData
          where ttWidgetData.oParent = oParent#
          and   lookup(cSvWidgetTypes#, ttWidgetData.cWidgetType) > 0 
          ,
          first ttUIFrame of ttWidgetData 
          where ttUIFrame.iPackID = iPackIdIP#
          :
          assign
            iExtentSize#                = iExtentSize# + 1
            oReturn#[iExtentSize#]      = ttWidgetData.oWidget
            cLinkNamesOP#[iExtentSize#] = ttWidgetData.cLinkName.
        end.
      end.
      
    end.
    
    return oReturn#.

  end method.  /* GetChildWidgets */
  

  
  method public static void SetBindingSource (oWidgetIP# as Progress.Lang.Object, oBindingSourceIP# as Progress.Lang.Object, hBufferOrQueryIP# as handle):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttWidgetData for ttWidgetData.
    
    if oWidgetIP# <> ? and oBindingSourceIP# <> ? then 
    do for ttWidgetData:
      
      find first ttWidgetData where ttWidgetData.oWidget = oWidgetIP#.
      
      ttWidgetData.oBindingSource = oBindingSourceIP#.
      
    end.
    
  end method. /* SetBindingSource */
  

  
  /*  method public static void SetBindingSource(                                  */
  /*    oWidgetIP#        as Progress.Lang.Object,                                 */
  /*    oBindingSourceIP# as c_bindingsource,                                      */
  /*    hBufferOrQueryIP# as handle):                                              */
  /*                                                                               */
  /*    define variable bEclipseFix# as logical no-undo.                           */
  /*    define buffer ttWidgetData for ttWidgetData.                               */
  /*                                                                               */
  /*    if oWidgetIP# <> ? and oBindingSourceIP# <> ? then                         */
  /*    do for ttWidgetData:                                                       */
  /*                                                                               */
  /*      find first ttWidgetData where ttWidgetData.oWidget = oWidgetIP# no-error.*/
  /*                                                                               */
  /*      if not avail ttWidgetData then                                           */
  /*      do:                                                                      */
  /*        create ttWidgetData.                                                   */
  /*        assign                                                                 */
  /*          ttWidgetData.oWidget = oWidgetIP#.                                   */
  /*      end.                                                                     */
  /*                                                                               */
  /*      assign                                                                   */
  /*        ttWidgetData.hBufferOrQuery = hBufferOrQueryIP#                        */
  /*        ttWidgetData.oBindingSource = oBindingSourceIP#.                       */
  /*                                                                               */
  /*    end.                                                                       */
  /*                                                                               */
  /*  end method. /* SetBindingSource */                                           */
  /*                                                                               */
  
  method public static void SetDisplayLinked(oWidgetIP# as Progress.Lang.Object):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttWidgetData for ttWidgetData.
    
    if oWidgetIP# <> ? then 
    do for ttWidgetData:
      
      find first ttWidgetData where ttWidgetData.oWidget = oWidgetIP#.
      
      ttWidgetData.bIsDisplayLinked = true.
      
    end.
    
  end method. /* SetDisplayLinked */

  
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
    
  end method. /* GetGridColumns */


  method public static void RenameWidgetLinkNames(
    iPackIDIP#    as int64, 
    iIDUIFrameIP# as int64,
    cFromIP#      as character,
    cIntoIP#      as character):
      
    define buffer b-ttUIFrame    for ttUIFrame.
    define buffer b-ttWidgetData for ttWidgetData.

    for each b-ttUIFrame no-lock
      where  b-ttUIFrame.iPackID = iPackIDIP#
      and    b-ttUIFrame.iIDUIFrame = iIDUIFrameIP#,
      each   b-ttWidgetData no-lock
      of     b-ttUIFrame:
        
      b-ttWidgetData.cLinkName = replace(b-ttWidgetData.cLinkName, cFromIP#, cIntoIP#).
      
    end.

  end method. /* RenameWidgetLinkNames */  


  
  method public static void DebugShowData():

    if panaedra.msroot.msutil.logic.sc_html:TempTableToHTML(buffer ttWidgetData:handle, panaedra.msf.logic.sc_path:cTempDir + "ttWidgetData.html") then 
      panaedra.msroot.msutil.logic.sc_win32:ShellExecute(panaedra.msf.logic.sc_path:cTempDir + "ttWidgetData.html"). /* Open file */

  end method. /* DebugShowData */
  

  method public void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
    /* TODO: widgets opruimen / ontkoppelen voordat bindingsource wordt opgeruimd. */
    
    case oBroadcastDataIP#:cEventName:
      
      when "evt@c_qry@querydelete" then.
      when "evt@c_buf@bufferdelete" then.
      when "evt@c_bindingsource@bindingsourcedelete" then.
        
    end case.
    
  end method. /* OnEventBroadcast */
  
end class.

/* EOF */
