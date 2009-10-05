/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/paninui/view/use/sc_coll_eventdata_tt.i $ 
        Version: $Revision: 3 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-10-05 19:48:09+02:00 $ 
  Date Modified: $Modtime: 2009-10-05 18:19:37+02:00 $ 

    Description: Temp-table definitions

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__paninui_view_use_sc_coll_eventdata_tt_i}" = "" &then
&glob dvcs__paninui_view_use_sc_coll_eventdata_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | paninui_view_use_sc_coll_eventdata_tt_i $Revision: 3 $
&if '{&class}' = '' &then
procedure dvcs__paninui_view_use_sc_coll_eventdata_tt_i: return "$Revision: 3 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

  define {&protected} {&static} temp-table ttUiEvent no-undo rcode-information
    field dtmCreUiEvent    as datetime-tz          format "99-99-9999 hh:mm:ss" initial ? xml-node-type "attribute" 
    field iIDUiEvent       as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" 

    field iPackID          as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute"
    field iFrmLogicID      as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute"
    field iDelegateID      as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" 

    field oWidget          as Progress.Lang.Object  
    field hWidget          as handle  
    field cWidgetName      as character            format "x(50)" xml-node-type "attribute" 
    
    field cEventName       as character            format "x(50)"               xml-node-type "attribute"
    field cEventType       as character            format "x(50)"               xml-node-type "attribute"

    index iIDUiEvent       is unique iIDUiEvent ascending 
    
    index oWidget_EventType_Delegate     is primary unique oWidget cEventType iDelegateID
    index hWidget_EventType_Delegate     is         unique hWidget cEventType iDelegateID
    index oWidget_EventNameType_Delegate is         unique oWidget cEventName cEventType iDelegateID
    
    .


  define {&protected} {&static} temp-table ttEventsSuspend no-undo rcode-information
    field dtmCreEventsSuspend    as datetime-tz          format "99-99-9999 hh:mm:ss" initial ? xml-node-type "attribute" 
    field iIDEventsSuspend       as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" 

    field iPackID          as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute"
    field iFrmLogicID      as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute"

    field oWidget          as Progress.Lang.Object  
    field hWidget          as handle  
    field cWidgetName      as character            format "x(50)" xml-node-type "attribute" 
    
    field cEventName       as character            format "x(50)"               xml-node-type "attribute"
    field cEventType       as character            format "x(50)"               xml-node-type "attribute"
    
    field bSuspendAll      as logical

    index iIDEventsSuspend       is unique iIDEventsSuspend ascending 
    
    index iPack_iLogic_cEventType iPackID iFrmLogicID cEventType
    
    .


&endif /* {&dvcs__paninui_view_use_sc_coll_eventdata_tt_i} */

/* EOF : paninui/view/use/sc_coll_eventdata_tt.i */
