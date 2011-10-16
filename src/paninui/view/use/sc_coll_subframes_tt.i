/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Subframe collection temp-table

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__paninui_view_use_sc_coll_subframes_tt_i}" = "" &then
&glob dvcs__paninui_view_use_sc_coll_subframes_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | paninui_view_use_sc_coll_subframes_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__paninui_view_use_sc_coll_subframes_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/
  define {&protected} {&static} temp-table ttSubframe no-undo /*rcode-information*/
    field iIDSubframe      as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=Subframe " 
    field dtmCreSubframe   as datetime-tz          format "99-99-9999 hh:mm:ss" initial ? xml-node-type "attribute" 

    field iPackID          as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute"
    field iSubframeID      as int64                format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute"

    field oSubframe        as Progress.Lang.Object  
    field cSubframeName    as character            format "x(50)" xml-node-type "attribute" 
    
    index iIDSubframe      is unique iIDSubframe ascending 
    
    index iPackID          is unique iPackID cSubframeName iIDSubframe
    .

&endif /* {&dvcs__paninui_view_use_sc_coll_subframes_tt_i} */

/* EOF : paninui/view/use/sc_coll_subframes_tt.i */
