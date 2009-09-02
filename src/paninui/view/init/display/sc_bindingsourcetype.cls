{panaedra/msi/logic/ctop_class.i}
using paninui.view.init.display.*.

class paninui.view.init.display.sc_bindingsourcetype: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/init/display/sc_bindingsourcetype.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-02 16:45:02+02:00 $ 
    Date Modified: $Modtime: 2009-09-02 16:44:55+02:00 $ 

      Description: Helper class for overload ID interfaces for c_bindingsource. 

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_bindingsourcetype(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define public static property i_Buffer as i_bindingsourcetype_buffer no-undo get.
  define public static property i_Query  as i_bindingsourcetype_query  no-undo get.

end class.

/* EOF */
