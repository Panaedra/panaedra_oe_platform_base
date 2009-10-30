{panaedra/msi/logic/ctop_class.i}
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.interfaces.sc_stringtype_endofline: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/interfaces/sc_stringtype_endofline.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-30 09:08:42+01:00 $ 
    Date Modified: $Modtime: 2009-10-30 09:07:39+01:00 $ 

      Description: OVID# static class

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_stringtype_endofline(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define public static property oInternal      as i_stringtype_endofline_internal      no-undo get.
  define public static property oMac           as i_stringtype_endofline_mac           no-undo get.
  define public static property oUnix          as i_stringtype_endofline_unix          no-undo get.
  define public static property oUserInterface as i_stringtype_endofline_userinterface no-undo get.
  define public static property oWindows       as i_stringtype_endofline_windows       no-undo get.

end class.

/* EOF */ 
