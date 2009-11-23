{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
class panaedra.msroot.msutil.logic.sc_messagebox   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_messagebox.cls $ 
          Version: $Revision: 12 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-11-23 13:25:06+01:00 $ 
    Date Modified: $Modtime: 2009-11-23 13:23:46+01:00 $ 

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
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 12 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/


  method public static void Show(cMsgIP# as character):
    
    Show(sc_messageboxtype:Simple, cMsgIP#).

  end method. /* Show; simple */


  method public static void Show(oTypeOVID# as i_messageboxtype_simple, cMsgIP# as character):
    

    &if opsys = "unix" or "{&window-system}" = "tty" &then

    message 
      cMsgIP#
      view-as alert-box title
      subst("Panaedra &1", substring(iso-date(now),1,23)
      ).    
      
    &else

    if panaedra.msb.logic.sc_environment:IsIdeRunning() then
    do:
      /* First this was the sc_win32 api, but it crashed sometimes. 
         The .net messagebox is safe. */
      System.Windows.Forms.MessageBox:Show(subst("&1", cMsgIP#),
        subst("Panaedra &1", substring(iso-date(now),1,23)),
        System.Windows.Forms.MessageBoxButtons:OK, 
        System.Windows.Forms.MessageBoxIcon:Information
        ).    
    end.
    else
    do:
      System.Windows.Forms.MessageBox:Show(subst("&1", cMsgIP#),
        subst("Panaedra &1", substring(iso-date(now),1,23)),
        System.Windows.Forms.MessageBoxButtons:OK, 
        System.Windows.Forms.MessageBoxIcon:Information
        ).    
    end.
     &endif

    
  end method. /* Show; simple */


  method public static void Show(oTypeOVID# as i_messageboxtype_simple_ontop, cMsgIP# as character):
    
    &if opsys = "unix" or "{&window-system}" = "tty" &then

    message cMsgIP#
      view-as alert-box.

    &else

    define variable oForm as panaedra.msroot.msutil.view.c_messagebox_win32 no-undo.

    oForm = new panaedra.msroot.msutil.view.c_messagebox_win32(true, cMsgIP#).
    wait-for oForm:ShowDialog().

    &endif

  end method. /* Show; simple_ontop */


  method public static logical Show(oTypeOVID# as i_messageboxtype_yesno, cMsgIP# as character):
    
    return Show(sc_messageboxtype:YesNo, cMsgIP#, true).

  end method. /* Show; yesno, default=true */


  method public static logical Show(oTypeOVID# as i_messageboxtype_yesno, cMsgIP# as character, bDefaultOkayIP# as logical):

    message cMsgIP#
      view-as alert-box buttons yes-no update bDefaultOkayIP#.
      
    return bDefaultOkayIP#.
    
  end method. /* Show; yesno */


  method public static logical Show(oTypeOVID# as i_messageboxtype_yesno_ontop, cMsgIP# as character, bDefaultOkayIP# as logical):

    message "Not yet implemented" skip program-name(1) skip program-name(2) skip(2) cMsgIP#.
    
    return false.

  end method. /* Show; yesno_ontop */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP#)).

  end method. /* Show; type_debug , 1 character input */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#)).

  end method. /* Show; type_debug , 2 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#)).

  end method. /* Show; type_debug , 3 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character, cMsgIP_004# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#, cMsgIP_004#)).

  end method. /* Show; type_debug , 4 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character, cMsgIP_004# as character, cMsgIP_005# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#, cMsgIP_004#, cMsgIP_005#)).

  end method. /* Show; type_debug , 5 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character, cMsgIP_004# as character, cMsgIP_005# as character, cMsgIP_006# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#, cMsgIP_004#, cMsgIP_005#, cMsgIP_006#)).

  end method. /* Show; type_debug , 6 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character, cMsgIP_004# as character, cMsgIP_005# as character, cMsgIP_006# as character, cMsgIP_007# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#, cMsgIP_004#, cMsgIP_005#, cMsgIP_006#, cMsgIP_007#)).

  end method. /* Show; type_debug , 7 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character, cMsgIP_004# as character, cMsgIP_005# as character, cMsgIP_006# as character, cMsgIP_007# as character, cMsgIP_008# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#, cMsgIP_004#, cMsgIP_005#, cMsgIP_006#, cMsgIP_007#, cMsgIP_008#)).

  end method. /* Show; type_debug , 8 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP_001# as character, cMsgIP_002# as character, cMsgIP_003# as character, cMsgIP_004# as character, cMsgIP_005# as character, cMsgIP_006# as character, cMsgIP_007# as character, cMsgIP_008# as character, cMsgIP_009# as character):
    
    Show(oTypeOVID#, sc_overload_conversions_char:MapCharacter(cMsgIP_001#, cMsgIP_002#, cMsgIP_003#, cMsgIP_004#, cMsgIP_005#, cMsgIP_006#, cMsgIP_007#, cMsgIP_008#, cMsgIP_009#)).

  end method. /* Show; type_debug , 9 character inputs */


  method public static void Show(oTypeOVID# as i_messageboxtype_debug, cMsgIP# as character extent):
    
    define variable cProgramName# as character no-undo.
    
    cProgramName# = if program-name(2) matches "*sc_messagebox*" then program-name(3) else program-name(2).
    
    &if opsys = "unix" or "{&window-system}" = "tty" &then
    
    if length(cProgramName#) > 40
      then cProgramName# = substring(cProgramName#, length(cProgramName#) - 39).

    message 
      cProgramName# skip
      cMsgIP#[1]    skip
      if extent(cMsgIP#) < 2 or cMsgIP#[2] = "" then "" else cMsgIP#[2] + "~n"
      if extent(cMsgIP#) < 3 or cMsgIP#[3] = "" then "" else cMsgIP#[3] + "~n"
      if extent(cMsgIP#) < 4 or cMsgIP#[4] = "" then "" else cMsgIP#[4] + "~n"
      if extent(cMsgIP#) < 5 or cMsgIP#[5] = "" then "" else cMsgIP#[5] + "~n"
      if extent(cMsgIP#) < 6 or cMsgIP#[6] = "" then "" else cMsgIP#[6] + "~n"
      if extent(cMsgIP#) < 7 or cMsgIP#[7] = "" then "" else cMsgIP#[7] + "~n"
      if extent(cMsgIP#) < 8 or cMsgIP#[8] = "" then "" else cMsgIP#[8] + "~n"
      if extent(cMsgIP#) < 9 or cMsgIP#[9] = "" then "" else cMsgIP#[9]
      view-as alert-box title
      subst("Panaedra Debug &1", substring(iso-date(now),1,23)
      ).    
      
    &else

    System.Windows.Forms.MessageBox:Show(cProgramName# + "~n" + subst("01: &1~n02: &2~n03: &3~n04: &4~n05: &5~n06: &6~n07: &7~n08: &8~n09: &9",
      cMsgIP#[1],
      if extent(cMsgIP#) < 2 then "" else cMsgIP#[2],
      if extent(cMsgIP#) < 3 then "" else cMsgIP#[3],
      if extent(cMsgIP#) < 4 then "" else cMsgIP#[4],
      if extent(cMsgIP#) < 5 then "" else cMsgIP#[5],
      if extent(cMsgIP#) < 6 then "" else cMsgIP#[6],
      if extent(cMsgIP#) < 7 then "" else cMsgIP#[7],
      if extent(cMsgIP#) < 8 then "" else cMsgIP#[8],
      if extent(cMsgIP#) < 9 then "" else cMsgIP#[9]
      ),
      subst("Panaedra Debug &1", substring(iso-date(now),1,23)),
      System.Windows.Forms.MessageBoxButtons:OK, 
      System.Windows.Forms.MessageBoxIcon:Asterisk
      ).    
      
  &endif /* unix or tty */
     
  end method. /* Show; type_debug , variable extent */

end class.

/* EOF */ 
