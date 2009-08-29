{panaedra/msi/logic/ctop_class.i}
using paninui.view.interfaces.*.
/*using paninui.view.interfaces.helpers.*.*/

class paninui.view.interfaces.sc_widgettype: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/interfaces/sc_widgettype.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-08-29 23:05:42+02:00 $ 
    Date Modified: $Modtime: 2009-08-29 23:05:03+02:00 $ 

      Description: Helper class for overload ID interfaces. 
                   
                   Force the compiler to use the correct overload.
                   
                   No real objects are created nor returned.
                    
                   This construct is more flexible and efficient than enums,
                   plus there's the small fact that enums don't exist in progress.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_widgettype(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define public static property i_Button   as i_widgettype_button   no-undo get.
  define public static property i_Combobox as i_widgettype_combobox no-undo get.
  define public static property i_Grid     as i_widgettype_grid     no-undo get.
  define public static property i_Tree     as i_widgettype_tree     no-undo get.

end class.

/* EOF */
