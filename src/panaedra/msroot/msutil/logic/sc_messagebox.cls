{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
class panaedra.msroot.msutil.logic.sc_messagebox   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_messagebox.cls $ 
          Version: $Revision: 5 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-25 10:52:51+02:00 $ 
    Date Modified: $Modtime: 2009-09-25 10:52:23+02:00 $ 

      Description: Replacement for the ABL "message" statement.
      
                   Example:
                     
                   (Eclipse macro 'bbuse_msutil'):
                   using panaedra.msroot.msutil.logic.*.
                   using panaedra.msroot.msutil.interfaces.*.
                   
                   (Eclipse macro 'bbmes'):
                   sc_messagebox_win32:Show(sc_messagebox_win32type:Simple, "Here's my message").

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_messagebox(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 5 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/


  method public static void Show (cMsgIP# as character):
    
    Show(sc_messageboxtype:Simple, cMsgIP#).

  end method. /* Show; simple */


  method public static void Show (oTypeOVID# as i_messageboxtype_simple, cMsgIP# as character):
    
    message cMsgIP#
      view-as alert-box.

  end method. /* Show; simple */


  method public static void Show (oTypeOVID# as i_messageboxtype_simple_ontop, cMsgIP# as character):
    
    &if opsys <> "unix" &then
    define variable oForm as panaedra.msroot.msutil.view.c_messagebox_win32 no-undo.
    &endif
    
    &if opsys = "unix" &then
      message cMsgIP#
        view-as alert-box.
    &else
      oForm = new panaedra.msroot.msutil.view.c_messagebox_win32(true, cMsgIP#).
      wait-for oForm:ShowDialog().
    &endif

  end method. /* Show; simple_ontop */


  method public static logical Show (oTypeOVID# as i_messageboxtype_yesno, cMsgIP# as character):
    
    return Show(sc_messageboxtype:YesNo, cMsgIP#, true).

  end method. /* Show; yesno, default=true */


  method public static logical Show (oTypeOVID# as i_messageboxtype_yesno, cMsgIP# as character, bDefaultOkayIP# as logical):

    message cMsgIP#
      view-as alert-box buttons yes-no update bDefaultOkayIP#.
      
    return bDefaultOkayIP#.
    
  end method. /* Show; yesno */


  method public static logical Show (oTypeOVID# as i_messageboxtype_yesno_ontop, cMsgIP# as character, bDefaultOkayIP# as logical):

    message "Not yet implemented" skip program-name(1) skip program-name(2) skip(2) cMsgIP#.
    
    return false.

  end method. /* Show; yesno_ontop */


end class.

/* EOF */ 
