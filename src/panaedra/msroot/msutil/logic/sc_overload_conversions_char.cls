{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_overload_conversions_char: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_overload_conversions_char.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:12+01:00 $ 

      Description: Provides methods to reduce the amount of code in "facilitating"
                   overloads.
                   
                   for example:
                     
                   DoSomething(int)  
                   DoSomething(int,int)  
                   DoSomething(int,int,int)  

                   maps to:
                   DoSomething(int extent)  
                   
                   Note:
                   Waiting for generics in ABL, as of 10.2A02.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_overload_conversions_char(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 4 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  method public static character extent MapCharacter(c01IP# as character):
    
    define variable cReturn# as character no-undo extent 1.
    
    assign 
      cReturn#[1] = c01IP#.
    
    return cReturn#.

  end method. /* Show; type_debug , 1 character input */


  method public static character extent MapCharacter(c01IP# as character, c02IP# as character):

    define variable cReturn# as character no-undo extent 2.

    assign
      cReturn#[1] = c01IP#
      cReturn#[2] = c02IP#
      .

    return cReturn#.

  end method. /* Show; type_debug , 2 character inputs */


  method public static character extent MapCharacter(c01IP# as character, c02IP# as character, c03IP# as character):

    define variable cReturn# as character no-undo extent 3.

    assign
      cReturn#[1] = c01IP#
      cReturn#[2] = c02IP#
      cReturn#[3] = c03IP#
      .

    return cReturn#.

  end method. /* Show; type_debug , 3 character inputs */


  method public static character extent MapCharacter(c01IP# as character, c02IP# as character, c03IP# as character, c04IP# as character):

    define variable cReturn# as character no-undo extent 4.

    assign
      cReturn#[1] = c01IP#
      cReturn#[2] = c02IP#
      cReturn#[3] = c03IP#
      cReturn#[4] = c04IP#
      .

    return cReturn#.

  end method. /* Show; type_debug , 4 character inputs */


  method public static character extent MapCharacter(c01IP# as character, c02IP# as character, c03IP# as character, c04IP# as character, c05IP# as character):

    define variable cReturn# as character no-undo extent 5.

    assign
      cReturn#[1] = c01IP#
      cReturn#[2] = c02IP#
      cReturn#[3] = c03IP#
      cReturn#[4] = c04IP#
      cReturn#[5] = c05IP#
      .

    return cReturn#.

  end method. /* Show; type_debug , 5 character inputs */


  method public static character extent MapCharacter(c01IP# as character, c02IP# as character, c03IP# as character, c04IP# as character, c05IP# as character, c06IP# as character):

    define variable cReturn# as character no-undo extent 6.

    assign
      cReturn#[1] = c01IP#
      cReturn#[2] = c02IP#
      cReturn#[3] = c03IP#
      cReturn#[4] = c04IP#
      cReturn#[5] = c05IP#
      cReturn#[6] = c06IP#
      .

    return cReturn#.

  end method. /* Show; type_debug , 6 character inputs */


  method public static character extent MapCharacter(c01IP# as character, c02IP# as character, c03IP# as character, c04IP# as character, c05IP# as character, c06IP# as character, c07IP# as character):

    define variable cReturn# as character no-undo extent 7.

    assign
      cReturn#[1] = c01IP#
      cReturn#[2] = c02IP#
      cReturn#[3] = c03IP#
      cReturn#[4] = c04IP#
      cReturn#[5] = c05IP#
      cReturn#[6] = c06IP#
      cReturn#[7] = c07IP#
      .

    return cReturn#.

  end method. /* Show; type_debug , 7 character inputs */


  method public static character extent MapCharacter(c01IP# as character, c02IP# as character, c03IP# as character, c04IP# as character, c05IP# as character, c06IP# as character, c07IP# as character, c08IP# as character):

    define variable cReturn# as character no-undo extent 8.

    assign
      cReturn#[1] = c01IP#
      cReturn#[2] = c02IP#
      cReturn#[3] = c03IP#
      cReturn#[4] = c04IP#
      cReturn#[5] = c05IP#
      cReturn#[6] = c06IP#
      cReturn#[7] = c07IP#
      cReturn#[8] = c08IP#
      .

    return cReturn#.

  end method. /* Show; type_debug , 8 character inputs */


  method public static character extent MapCharacter(c01IP# as character, c02IP# as character, c03IP# as character, c04IP# as character, c05IP# as character, c06IP# as character, c07IP# as character, c08IP# as character, c09IP# as character):

    define variable cReturn# as character no-undo extent 9.

    assign
      cReturn#[1] = c01IP#
      cReturn#[2] = c02IP#
      cReturn#[3] = c03IP#
      cReturn#[4] = c04IP#
      cReturn#[5] = c05IP#
      cReturn#[6] = c06IP#
      cReturn#[7] = c07IP#
      cReturn#[8] = c08IP#
      cReturn#[9] = c09IP#
      .

    return cReturn#.

  end method. /* Show; type_debug , 9 character inputs */

end class.

/* EOF */ 
