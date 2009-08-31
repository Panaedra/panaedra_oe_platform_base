
/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/paninui/view/use/sc_coll_widgetdata_tt.i $ 
        Version: $Revision: 2 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-08-31 10:37:54+02:00 $ 
  Date Modified: $Modtime: 2009-08-30 17:45:55+02:00 $ 

    Description: add_your_comments_here

\**************************** End of Dvcs_ Header ****************************/
&if '{&dvcs__paninui_view_use_sc_coll_widgetdata_tt_i}' = '' &then
&glob dvcs__paninui_view_use_sc_coll_widgetdata_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | paninui_view_use_sc_coll_widgetdata_tt_i $Revision: 2 $
&if '{&class}' = '' &then
procedure dvcs__paninui_view_use_sc_coll_widgetdata_tt_i: return "$Revision: 2 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

  define {&protected} {&static} temp-table ttUIFrame no-undo rcode-information
    field cGUIDUIFrame     as character            format "x(50)"               initial ? xml-node-type "attribute" 
    field dtmCreUIFrame    as datetime-tz          format "99-99-9999 hh:mm:ss" initial ? xml-node-type "attribute" 
    field dtmModUIFrame    as datetime-tz          format "99-99-9999 hh:mm:ss" initial ? xml-node-type "attribute"
    field iPackID          as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" 
    field iIDUIFrame       as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" 
    field cFrameName       as char                 format "x(50)"               xml-node-type "attribute"
    field oFrame           as Progress.Lang.Object
    index iPackID          is primary unique iPackID iIDUIFrame ascending 
    index iIDUIFrame       is unique iIDUIFrame ascending 
    index dtmCreUIFrame    dtmCreUIFrame ascending 
    index dtmModUIFrame    dtmModUIFrame ascending 
    .
  
  /* This temp-table stores the logical tree of widget data. The visual tree is irrelevant. */
  define {&protected} {&static} temp-table ttWidgetData no-undo rcode-information
    field cGUIDWidgetData     as character            format "x(50)"               initial ? xml-node-type "attribute" 
    field dtmCreWidgetData    as datetime-tz          format "99-99-9999 hh:mm:ss" initial ? xml-node-type "attribute" 
    field dtmModWidgetData    as datetime-tz          format "99-99-9999 hh:mm:ss" initial ? xml-node-type "attribute"

    field iIDUiFrame          as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" 
    field iIDWidgetDataParent as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute"
    field iIDWidgetData       as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" 

    field oParent             as Progress.Lang.Object
    field oWidget             as Progress.Lang.Object  
    field cWidgetType         as character            format "x(50)" xml-node-type "attribute" 
    field cWidgetName         as character            format "x(50)" xml-node-type "attribute" 
    field cLinkName           as character            format "x(50)" xml-node-type "attribute" 

    field bIsDisplayLinked    as logical              xml-node-type "attribute" 

    index iIDWidgetData       is unique iIDWidgetData ascending 
    index i_frame_parent_self is primary iIDUiFrame ascending iIDWidgetDataParent descending iIDWidgetData descending 
    index iIDUIFrame          iIDUIFrame cWidgetType cLinkName ascending 
    index dtmCreWidgetData    dtmCreWidgetData ascending 
    index dtmModWidgetData    dtmModWidgetData ascending 
    index oWidget             oWidget          ascending
    index oParent             oParent          ascending
    .

&endif

/* EOF : paninui/view/use/sc_coll_widgetdata_tt.i */
    