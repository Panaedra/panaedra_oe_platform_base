using paninui.view.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i}

class paninui.view.interfaces.sc_widgettype: 

  /****************************** Source Header ********************************\

      Description: OVID# static class.
      
                   Helper class for overload ID interfaces. 
                   
                   Force the compiler to use the correct overload.
                   
                   No real objects are created nor returned.
                    
                   This construct is more flexible and efficient than enums,
                   plus there's the small fact that enums don't exist in progress.
                   -> Note 2017Q4: they do now, oe11+.
                   
  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define public static property i_Any        as i_widgettype_any        no-undo get.
  define public static property i_Button     as i_widgettype_button     no-undo get.
  define public static property i_Combobox   as i_widgettype_combobox   no-undo get.
  define public static property i_DataSource as i_widgettype_datasource no-undo get.
  define public static property i_Form       as i_widgettype_form       no-undo get.
  define public static property i_Grid       as i_widgettype_grid       no-undo get.
  define public static property i_GridItem   as i_widgettype_griditem   no-undo get.
  define public static property i_GroupFrame as i_widgettype_groupframe no-undo get.
  define public static property i_Query      as i_widgettype_query      no-undo get.
  define public static property i_Toolbar    as i_widgettype_toolbar    no-undo get.
  define public static property i_Tree       as i_widgettype_tree       no-undo get.
  
end class.

/* EOF */
