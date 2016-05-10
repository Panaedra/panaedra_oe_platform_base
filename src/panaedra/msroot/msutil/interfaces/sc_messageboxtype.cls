{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.interfaces.sc_messageboxtype: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/sc_messageboxtype.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:13+01:00 $ 

      Description: Overload ID static class

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_messageboxtype(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define public static property Simple       as i_messageboxtype_simple        no-undo get.
  define public static property Simple_OnTop as i_messageboxtype_simple_ontop  no-undo get.
  define public static property YesNo        as i_messageboxtype_yesno         no-undo get.
  define public static property YesNo_OnTop  as i_messageboxtype_yesno_ontop   no-undo get.
  define public static property oDebug       as i_messageboxtype_debug         no-undo get.
  define public static property AsAlertBox   as i_messageboxtype_asalertbox    no-undo get.
  define public static property YesNoCancel  as i_messageboxtype_yesnocancel   no-undo get.

end class.

/* EOF */ 
