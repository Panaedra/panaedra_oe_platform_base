{panaedra/msi/logic/ctop_class.i}
using paninui.view.interfaces.*.
/*using paninui.view.interfaces.helpers.*.*/

class paninui.view.interfaces.sc_widgettype: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/interfaces/sc_widgettype.cls $ 
          Version: $Revision: 7 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-23 18:12:33+02:00 $ 
    Date Modified: $Modtime: 2009-10-23 14:42:20+02:00 $ 

      Description: Helper class for overload ID interfaces. 
                   
                   Force the compiler to use the correct overload.
                   
                   No real objects are created nor returned.
                    
                   This construct is more flexible and efficient than enums,
                   plus there's the small fact that enums don't exist in progress.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_widgettype(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 7 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define public static property i_Any        as i_widgettype_any        no-undo get.
  define public static property i_Button     as i_widgettype_button     no-undo get.
  define public static property i_Combobox   as i_widgettype_combobox   no-undo get.
  define public static property i_Grid       as i_widgettype_grid       no-undo get.
  define public static property i_GridItem   as i_widgettype_griditem   no-undo get.
  define public static property i_Tree       as i_widgettype_tree       no-undo get.
  define public static property i_GroupFrame as i_widgettype_groupframe no-undo get.
  define public static property i_Toolbar    as i_widgettype_toolbar    no-undo get.
  define public static property i_DataSource as i_widgettype_datasource no-undo get.
  define public static property i_Query      as i_widgettype_query      no-undo get.
  define public static property i_Form       as i_widgettype_form       no-undo get.

end class.

/* EOF */
