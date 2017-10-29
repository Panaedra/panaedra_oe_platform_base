{panaedra/msroot/msutil/logic/top_i/ctop_class.i}

using paninui.view.interfaces.*.
using paninui.pack.interfaces.*.
using paninui.view.init.display.*.
using paninui.view.use.*.

using panaedra.msroot.msdr.logic.*.
using panaedra.msroot.msdr.interfaces.*.
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class paninui.view.use.sc_coll_widgetdata   
  implements
  panaedra.msroot.msutil.interfaces.i_eventbroadcastclient:
  
  /****************************** Source Header ********************************\

      Description: Collection of widget data. "Collection" (_coll_) is used to 
                   indicate local storage of runtime data, normally in a temp-table.
      
  \*****************************  Include Files ********************************/
  {paninui/logic/includes/preproc_dotnetclasses.i &class=class}
  {paninui/view/use/sc_coll_widgetdata_tt.i &class=true &protected=protected &static=static}
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
  
    
  method public static int64 FrameAdd (oPackIP# as i_pack, oUiFrameIP# as {&i_uiframe}):
    
    /* Shouldhave: perhaps use the overload with LinkFrameName (which was implemented when subframes were implemented) */
    FrameAdd (oPackIP#, oUiFrameIP#, "Initial").
    
  end method.
  

  method public static int64 FrameAdd (oPackIP# as i_pack, oUiFrameIP# as {&i_uiframe}, cLinkFrameNameIP# as character):
    
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
        
      for each ttUIFrame 
        where ttUIFrame.iPackID = iPackIDIP#
        on error undo, throw:
      
        if avail ttUIFrame then 
        do:
        &if not {&paninui_tty} &then
          if valid-object(ttUIFrame.oFrame) and type-of(ttUIFrame.oFrame, System.Windows.Forms.Control) 
            then cast(ttUIFrame.oFrame, System.Windows.Forms.Control):Visible = false.
        &endif
        end.
      
      end. /* for each ttUiFrame */
      
    end. /* do for ttUiFrame */
    
  end method. /* HidePackFrames */

  
  method public static void ShowPackFrames (iPackIDIP# as int64):

    def buffer ttUIFrame for ttUIFrame.
    
    do for ttUIFrame:
      
      find first ttUIFrame where ttUIFrame.iPackID = iPackIDIP#  no-error.
      
      if avail ttUIFrame then 
      do:
        &if not {&paninui_tty} &then
        if valid-object(ttUIFrame.oFrame) and type-of(ttUIFrame.oFrame, System.Windows.Forms.Control) 
          then 
        do:
          cast(ttUIFrame.oFrame, System.Windows.Forms.Control):Visible = true.
          cast(ttUIFrame.oFrame, System.Windows.Forms.Control):BringToFront().
        end.
        &endif
      end.
      
    end.
    
  end method. /* ShowPackFrames */

  
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
    
    define variable cLinkPrefix# as character no-undo.
    
    define buffer ttWidgetData          for ttWidgetData.
    define buffer b-parent-ttWidgetData for ttWidgetData.
    define buffer b-ttUIFrame           for ttUIFrame.
    
    do for ttWidgetData, b-parent-ttWidgetData:
    
      create ttWidgetData.
      panaedra.msroot.msutil.logic.sc_dbtrig:OnWriteOrCreate(buffer ttWidgetData:handle ).
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
      
      
      cLinkPrefix# = "".
      
      if ttWidgetData.cLinkName begins "__" and iIDParentIP# <> 0 then 
      do:
        find b-parent-ttWidgetData where b-parent-ttWidgetData.iIDWidgetData = iIDParentIP# no-error.
        if avail b-parent-ttWidgetData and b-parent-ttWidgetData.cWidgetType = "toolbar" then 
        do:
          cLinkPrefix# = b-parent-ttWidgetData.cLinkName.
        end.  
      end.
      
      ttWidgetData.cLinkName = WidgetNameToLinkName(?, ttWidgetData.cLinkName, cLinkPrefix#).
      
      find first b-ttUIFrame where b-ttUIFrame.iIDUiFrame = iIDUIFrameIP#.

      ttWidgetData.iFramePackId = b-ttUIFrame.iPackID.

      return ttWidgetData.iIDWidgetData.
      
    end.
    
  end method. /* ItemAddImplement */


  method public static character WidgetNameToLinkName(
    
    /* Simple method that replaces __ to dot, and optionally adds a prefix. */
    oWidgetIP#     as Progress.Lang.Object, /* Send ? if you want a simple text replace */
    cWidgetNameIP# as character, 
    cLinkPrefixIP# as character):
    
    define variable cReturn# as character no-undo.
    
    /* Make a linkname from the prefix name if necessary */
    if cLinkPrefixIP# matches "*__*"
      /* One time recursive call */ 
      then cLinkPrefixIP# = WidgetNameToLinkName(?, cLinkPrefixIP#, "").
    
    /* Make sure there will be a dot between prefix and linkname */  
    if length(trim(cLinkPrefixIP#)) > 0 
      and substring(cLinkPrefixIP#,length(cLinkPrefixIP#),1) <> "." 
      and (not cWidgetNameIP# begins "__") 
      then cWidgetNameIP# = "__" + cWidgetNameIP#.
    
    cReturn# = subst("&1&2", cLinkPrefixIP#, replace(cWidgetNameIP#,"__",".")).
    
    /* Always trim any start dots off the cLinkName. */
    cReturn# = left-trim(cReturn#,".").
    
    return cReturn#.

  end method. /* WidgetNameToLinkName */    
  
  
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
        and   ttWidgetData.cLinkName   = cLinkName#
        on error undo, throw:
        bIsDisplayLinkedOP# = ttWidgetData.bIsDisplayLinked.
        return ttWidgetData.oWidget.
      end.
        
      if cLinkNameAlt# > "" then 
      do:
        b_getwidgetAlt:
        for each ttUIFrame where ttUIFrame.iPackID = iPackIdIP#,
          each ttWidgetData of ttUIFrame
          where ttWidgetData.cWidgetType = cWidgetTypeIP#
          and   ttWidgetData.cLinkName   = cLinkNameAlt#
          on error undo, throw:
          bIsDisplayLinkedOP# = ttWidgetData.bIsDisplayLinked.
          return ttWidgetData.oWidget.
        end.
      end.
      
      &if not {&paninui_tty} &then
      if sc_environment:IsIdeRunning() and length(trim(sc_environment:cDeployID)) = 0 then 
        sc_developerfeedback:DevMsg(
          subst("Not necessarily a bug: Widget '&1/&2/&3/&4' requested but not present.",
          iPackIdIP#,     
          cWidgetTypeIP#,
          hBuffOrQueryIP#,
          cDataRefIP#)
          , sc_showexception:GetSessionCallStack()).
      &endif
        
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
      
      /* Shouldhave: screen design follows two standards, with and without tt. Choose plz. (!) */
      /*      if cLinkName# begins "tt" then cLinkName# = substring(cLinkName#,3).*/
      
      if cWidgetTypeIP# = "any" then
        b_getwidget_all:
        for each ttUIFrame where ttUIFrame.iPackID = iPackIdIP#,
          each ttWidgetData of ttUIFrame
          where ttWidgetData.cLinkName   = cLinkName#
          on error undo, throw:
          bIsDisplayLinkedOP# = ttWidgetData.bIsDisplayLinked.
          return ttWidgetData.oWidget.
        end.
        
      else
        b_getwidget_type:
        for each ttUIFrame where ttUIFrame.iPackID = iPackIdIP#,
          each ttWidgetData of ttUIFrame
          where ttWidgetData.cWidgetType = cWidgetTypeIP#
          and   ttWidgetData.cLinkName   = cLinkName#
          on error undo, throw:
          bIsDisplayLinkedOP# = ttWidgetData.bIsDisplayLinked.
          return ttWidgetData.oWidget.
        end.
        
    end.

    &if not {&paninui_tty} &then
    if sc_environment:IsIdeRunning() and length(trim(sc_environment:cDeployID)) = 0 then
      sc_developerfeedback:DevMsg(
        subst("Not necessarily a bug: Widget '&1/&2/&3/&4' requested but not present.",
        iPackIdIP#,     
        cWidgetTypeIP#,
        cDataRefIP#)
        , sc_showexception:GetSessionCallStack()).
    &endif
    
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

  
  method public static Progress.Lang.Object GetWidgetByHandleAndSuffix(
    input  oWidgetIP#   as Progress.Lang.Object,
    input  cSuffixIP#   as character):
    
    /* Get a widget that is a sub-widget of the widget, by handle and suffix. 
       Example: Pass a XX.btnMyRadioButton and "Text" to return the XX.btnMyRadioButton.Text widget. 
    */

    define variable iPackID#         as int64                no-undo.
    define variable cLinkName#       as character            no-undo.
    
    define buffer ttUIFrame    for ttUIFrame.
    define buffer ttWidgetData for ttWidgetData.
    
    do for ttWidgetData:
      
      find first ttWidgetData where ttWidgetData.oWidget = oWidgetIP# no-error.

      if available ttWidgetData then 
      do:
        cLinkName# = substitute("&1.&2", ttWidgetData.cLinkName, cSuffixIP#).
        find first ttUIFrame of ttWidgetData no-error.
        iPackID# = if available ttUIFrame then ttUIFrame.iPackID else 0.
      end.

      find first ttWidgetData 
        where ttWidgetData.iFramePackId = iPackID#
        and   ttWidgetData.cLinkName    = cLinkName# no-error.

      return if available ttWidgetData then ttWidgetData.oWidget else ?.
        
    end.
    
  end method. /* GetWidgetByHandleAndSuffix */

  
  method public static {&i_uiframe} GetFrameByLinkName(cLinkNameIP# as character):
    return GetFrameByLinkName(?, cLinkNameIP#).
  end method. /* GetFrameByLinkName */
    
  method public static {&i_uiframe} GetFrameByLinkName(iPackIDIP# as int64, cLinkNameIP# as character):
    
    /* Return frame object found by the linkname */
    
    define variable oUiFrame# as {&i_uiframe} no-undo.
    define buffer b-ttUIFrame for ttUIFrame.
    
    /* Shouldhave: always supply packid, don't accept '?' */
    if iPackIDIP# = ? then
      find first b-ttUIFrame 
        where b-ttUIFrame.cLinkFrameName = cLinkNameIP# no-error. 
    else
      find first b-ttUIFrame 
        where b-ttUIFrame.cLinkFrameName = cLinkNameIP# 
        and   b-ttUIFrame.iPackID = iPackIDIP# no-error.
    
    if not available b-ttUIFrame then
      return ?.
    else
    do:
      oUiFrame# = cast(b-ttUIFrame.oFrame, {&i_uiframe}).
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
        on error undo, throw:
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
          on error undo, throw:
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
      
      for each ttWidgetData where ttWidgetData.oParent = oGridIP# on error undo, throw:
        iExtentSize# = iExtentSize# + 1.
      end.
      
      extent(oGridColumnsOP#) = iExtentSize#.
      
      iTell# = 0.
      for each ttWidgetData where ttWidgetData.oParent = oGridIP# on error undo, throw:
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
      of     b-ttUIFrame
      on error undo, throw:
        
      b-ttWidgetData.cLinkName = replace(b-ttWidgetData.cLinkName, cFromIP#, cIntoIP#).
      
    end.

  end method. /* RenameWidgetLinkNames */  


  method public static void GetGridWidgetsByQry(oQryIP# as i_qry, output cSvPackIDOP# as character, output cSvGridnamesOP# as character):
    
    define variable oBindingSource# as c_bindingsource no-undo.

    define buffer b-ttUIFrame    for ttUIFrame.
    define buffer b-ttWidgetData for ttWidgetData.

    oBindingSource# = oQryIP#:GetActiveBindingsource().      

    if oBindingSource# <> ? then 
    do:
      
      for each   b-ttWidgetData no-lock
        where b-ttWidgetData.oBindingSource = oBindingSource# /* This field is indexed */
        and   b-ttWidgetData.cWidgetType = "grid",
        first b-ttUIFrame of b-ttWidgetData
        on error undo, throw:
      
        assign
          cSvPackIDOP#    = cSvPackIDOP# + "," + trim(string(b-ttUIFrame.iPackID))
          cSvGridnamesOP# = cSvGridnamesOP# + "," + b-ttWidgetData.cLinkName.
        
      end. /* for each grid */
      
    end. /* valid bindingsource */
    
    assign
      cSvPackIDOP#    = substring(cSvPackIDOP#,2)
      cSvGridnamesOP# = substring(cSvGridnamesOP#,2).  

  end method. /* GetGridWidgetsByQry */
  
  
  method public static void DebugShowData():

    if panaedra.msroot.msutil.logic.sc_html:TempTableToHTML(buffer ttWidgetData:handle, panaedra.msroot.msutil.logic.sc_path:cTempDir + "ttWidgetData.html") then 
      panaedra.msroot.msutil.logic.sc_win32:ShellExecute(panaedra.msroot.msutil.logic.sc_path:cTempDir + "ttWidgetData.html"). /* Open file */

  end method. /* DebugShowData */

  
  method public static void GetTtWidgetData(
    output table ttWidgetData):
  
  end method. /* GetTtWidgetData */
  

  method public static void GetTtUiFrame(
    output table ttUiFrame):
  
  end method. /* GetTtUiFrame */
  

  method public void OnEventBroadcast(oBroadcastDataIP# as i_eventbroadcastdata):
    
    /* Shouldhave: widgets opruimen / ontkoppelen voordat bindingsource wordt opgeruimd. */
    
    case oBroadcastDataIP#:cEventName:
      
      when "evt@c_qry@querydelete" then.
      when "evt@c_buf@bufferdelete" then.
      when "evt@c_bindingsource@bindingsourcedelete" then.
        
    end case.
    
  end method. /* OnEventBroadcast */
  
end class.

/* EOF */
