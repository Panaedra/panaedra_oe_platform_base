/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: LooseFrame collection temp-table

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__paninui_view_use_sc_coll_looseframes_tt_i}" = "" &then
&glob dvcs__paninui_view_use_sc_coll_looseframes_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | paninui_view_use_sc_coll_looseframes_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__paninui_view_use_sc_coll_looseframes_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/
  define {&protected} {&static} temp-table ttLooseFrame no-undo /*rcode-information*/
    field iIDLooseFrame      as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=LooseFrame " 
    field dtmCreLooseFrame   as datetime-tz          format "99-99-9999 hh:mm:ss" initial ? xml-node-type "attribute" 

    field iPackID            as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute"
    field iLooseFrameID      as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute"
     
    field oLooseFrame        as Progress.Lang.Object  
    field cLooseFrameName    as character            format "x(50)" xml-node-type "attribute" 
    
    field cLooseFrameID      as character            xml-node-type "attribute"
    
    index iIDLooseFrame      is unique iIDLooseFrame ascending 
    
    index iPackID          is unique iPackID cLooseFrameName iIDLooseFrame
    .

&endif /* {&dvcs__paninui_view_use_sc_coll_looseframes_tt_i} */

/* EOF : paninui/view/use/sc_coll_looseframes_tt.i */
