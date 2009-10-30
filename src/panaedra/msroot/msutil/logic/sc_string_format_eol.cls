{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_string_format_eol   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_string_format_eol.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-30 09:28:34+01:00 $ 
    Date Modified: $Modtime: 2009-10-30 01:04:19+01:00 $ 

      Description: Formats EOL (end of line) characters in multi-line strings; 
                   chr(10) and chr(13)

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_string_format_eol(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/


  method public static character CleanupEolAndTrimPerLine(
  
    /* Turns a dirty string like:
       " lineOne <chr-13> lineTwo    <chr-13><chr-10><chr-10> yup <chr-13> "  
       into a string like:
       " lineOne<chr-10>lineTwo<chr-10>yup "  
    */
  
    cInputIP# as character):
    
    define variable cTemp#   as longchar  no-undo.
    define variable cReturn# as character no-undo.
    
    assign
      cTemp#   = cInputIP#
      cTemp#   = CleanupEolAndTrimPerLineImplement(cTemp#)
      cReturn# = cTemp#.
    
    return cReturn#.
    
  end method. /* CleanupEolAndTrimPerLine ; character version */


  method public static longchar CleanupEolAndTrimPerLine(
  
    /* Turns a dirty string like:
       " lineOne <chr-13> lineTwo    <chr-13><chr-10><chr-10> yup <chr-13> "  
       into a string like:
       " lineOne<chr-10>lineTwo<chr-10>yup "  
    */
  
    cInputIP# as longchar):
    
    return CleanupEolAndTrimPerLineImplement(cInputIP#).
    
  end method. /* CleanupEolAndTrimPerLine ; longchar version */


  method protected static longchar CleanupEolAndTrimPerLineImplement(
  
    /* Turns a dirty string like:
       " lineOne <chr-13> lineTwo    <chr-13><chr-10><chr-10> yup <chr-13> "  
       into a string like:
       " lineOne<chr-10>lineTwo<chr-10>yup "  
    */
  
    cInputIP# as longchar):
    
    define variable cReturn# as longchar no-undo.

    /* First a few simple checks */    
    if cInputIP# = ? then return ?.
    
    /* First a few simple checks */    
    cReturn# = trim(cInputIP#).
    if num-entries(cReturn#, chr(10)) <= 1 then return cReturn#.
      
    /* Set start marker for easy replace. chr(13) is replaced by chr(10). */
    cReturn# = chr(10) + replace(cReturn#,chr(13),chr(10)).
    
    /* We don't encourage use of tab characters, so we replace them by spaces. */    
    cReturn# = replace(cReturn#, "~t","  ").
    
    /* Cleanup starting spaces */
    do while 
      index(cReturn#, chr(10) + " ") > 0:
      cReturn# = replace(cReturn#, chr(10) + " ", chr(10)).
    end.
    
    /* Cleanup trailing spaces */
    do while 
      index(cReturn#, " " + chr(10)) > 0:
      cReturn# = replace(cReturn#, " " + chr(10), chr(10)).
    end.
    
    /* Cleanup empty lines */
    do while 
      index(cReturn#, chr(10) + chr(10)) > 0:
      cReturn# = replace(cReturn#, chr(10) + chr(10), chr(10)).
    end.
    
    /* Remove start marker and return*/
    return trim(cReturn#).
    
  end method. /* CleanupEolAndTrimPerLineImplement */


  method public static longchar CorrectEndOfLine(

    /* To be used for convertion of end of lines that need to be displayed
       in the user interface.
    */
  
    oUserInterfaceOVID# as i_stringtype_endofline_userinterface,
    cInputIP# as longchar):

    define variable cReturn# as longchar no-undo.
    
    /* First a few simple checks */    
    if cInputIP# = ? then return cInputIP#.
    
    /* First a few simple checks */    
    if 
      index(cInputIP#, chr(10)) = 0 and 
      index(cInputIP#, chr(13)) = 0 then return cInputIP#.
    
    cReturn# = CorrectEndOfLine(sc_stringtype_endofline:oInternal, cInputIP#).
    
    return replace(cReturn#,chr(10), chr(13) + chr(10)).
    
  end method. /* CorrectEOL ; longchar + userinterface */
  

  method public static longchar CorrectEndOfLine(

    /* To be used for convertion of end of lines that need to put 
       in a windows os-file.
    */
  
    oUserInterfaceOVID# as i_stringtype_endofline_windows,
    cInputIP# as longchar):

    define variable cReturn# as longchar no-undo.
    
    /* First a few simple checks */    
    if cInputIP# = ? then return cInputIP#.
    
    /* First a few simple checks */    
    if 
      index(cInputIP#, chr(10)) = 0 and 
      index(cInputIP#, chr(13)) = 0 then return cInputIP#.
    
    cReturn# = CorrectEndOfLine(sc_stringtype_endofline:oInternal, cInputIP#).
    
    return replace(cReturn#,chr(10), chr(13) + chr(10)).
    
  end method. /* CorrectEOL ; longchar + windows */
  
  
  method public static longchar CorrectEndOfLine(

    /* To be used for convertion of end of lines that need to put 
       in a unix os-file.
    */
  
    oUserInterfaceOVID# as i_stringtype_endofline_unix,
    cInputIP# as longchar):

    /* First a few simple checks */    
    if cInputIP# = ? then return cInputIP#.
    
    /* First a few simple checks */    
    if 
      index(cInputIP#, chr(10)) = 0 and 
      index(cInputIP#, chr(13)) = 0 then return cInputIP#.
    
    return CorrectEndOfLine(sc_stringtype_endofline:oInternal, cInputIP#).
    
  end method. /* CorrectEOL ; longchar + unix */
  

  method public static longchar CorrectEndOfLine(

    /* To be used for convertion of end of lines that need to put 
       in a mac os-file.
    */
  
    oUserInterfaceOVID# as i_stringtype_endofline_mac,
    cInputIP# as longchar):

    define variable cReturn# as longchar no-undo.
    
    /* First a few simple checks */    
    if cInputIP# = ? then return cInputIP#.
    
    /* First a few simple checks */    
    if 
      index(cInputIP#, chr(10)) = 0 and 
      index(cInputIP#, chr(13)) = 0 then return cInputIP#.
    
    cReturn# = CorrectEndOfLine(sc_stringtype_endofline:oInternal, cInputIP#).
    
    return replace(cReturn#,chr(10), chr(13)).
    
  end method. /* CorrectEOL ; longchar + mac */
  

  method public static longchar CorrectEndOfLine(   
  
    /* To be used for convertion of end of lines that need to be stored
       internally; in a temp-table, variable or database.
    */
  
    oUserInterfaceOVID# as i_stringtype_endofline_internal,
    cInputIP# as longchar):
      
    define variable cReturn# as longchar no-undo.
  
    /* First a few simple checks */    
    if cInputIP# = ? then return cInputIP#.
    
    /* First a few simple checks */    
    if 
      index(cInputIP#, chr(10)) = 0 and 
      index(cInputIP#, chr(13)) = 0 then return cInputIP#.
    
    /* First convert windows to standard internal format chr(10) */
    cReturn# = replace(cInputIP#, chr(13) + chr(10), chr(10)).

    /* Then convert mac to standard internal format chr(10) */
    cReturn# = replace(cInputIP#, chr(13), chr(10)).
    
    return cReturn#.
    
  end method. /* CorrectEOL ; longchar + internal */


  method public static character CorrectEndOfLine(

    /* To be used for convertion of end of lines that need to be displayed
       in the user interface.
    */
  
    oUserInterfaceOVID# as i_stringtype_endofline_userinterface,
    cInputIP# as character):

    define variable cReturn# as character no-undo.
    
    /* First a few simple checks */    
    if cInputIP# = ? then return cInputIP#.
    
    /* First a few simple checks */    
    if 
      index(cInputIP#, chr(10)) = 0 and 
      index(cInputIP#, chr(13)) = 0 then return cInputIP#.
    
    cReturn# = CorrectEndOfLine(sc_stringtype_endofline:oInternal, cInputIP#).
    
    return replace(cReturn#, chr(10), chr(13) + chr(10)).
    
  end method. /* CorrectEOL ; character + userinterface */
  

  method public static character CorrectEndOfLine(

    /* To be used for convertion of end of lines that need to put 
       in a windows os-file.
    */
  
    oUserInterfaceOVID# as i_stringtype_endofline_windows,
    cInputIP# as character):

    define variable cReturn# as character no-undo.
    
    /* First a few simple checks */    
    if cInputIP# = ? then return cInputIP#.
    
    /* First a few simple checks */    
    if 
      index(cInputIP#, chr(10)) = 0 and 
      index(cInputIP#, chr(13)) = 0 then return cInputIP#.
    
    cReturn# = CorrectEndOfLine(sc_stringtype_endofline:oInternal, cInputIP#).
    
    return replace(cReturn#,chr(10), chr(13) + chr(10)).
    
  end method. /* CorrectEOL ; character + windows */
  
  
  method public static character CorrectEndOfLine(

    /* To be used for convertion of end of lines that need to put 
       in a unix os-file.
    */
  
    oUserInterfaceOVID# as i_stringtype_endofline_unix,
    cInputIP# as character):

    /* First a few simple checks */    
    if cInputIP# = ? then return cInputIP#.
    
    /* First a few simple checks */    
    if 
      index(cInputIP#, chr(10)) = 0 and 
      index(cInputIP#, chr(13)) = 0 then return cInputIP#.
    
    return CorrectEndOfLine(sc_stringtype_endofline:oInternal, cInputIP#).
    
  end method. /* CorrectEOL ; character + unix */
  

  method public static character CorrectEndOfLine(

    /* To be used for convertion of end of lines that need to put 
       in a mac os-file.
    */
  
    oUserInterfaceOVID# as i_stringtype_endofline_mac,
    cInputIP# as character):

    define variable cReturn# as character no-undo.
    
    /* First a few simple checks */    
    if cInputIP# = ? then return cInputIP#.
    
    /* First a few simple checks */    
    if 
      index(cInputIP#, chr(10)) = 0 and 
      index(cInputIP#, chr(13)) = 0 then return cInputIP#.
    
    cReturn# = CorrectEndOfLine(sc_stringtype_endofline:oInternal, cInputIP#).
    
    return replace(cReturn#,chr(10), chr(13)).
    
  end method. /* CorrectEOL ; character + mac */
  

  method public static character CorrectEndOfLine(   
  
    /* To be used for convertion of end of lines that need to be stored
       internally; in a temp-table, variable or database.
    */
  
    oUserInterfaceOVID# as i_stringtype_endofline_internal,
    cInputIP# as character):
      
    define variable cReturn# as character no-undo.
  
    /* First a few simple checks */    
    if cInputIP# = ? then return cInputIP#.
    
    /* First a few simple checks */    
    if 
      index(cInputIP#, chr(10)) = 0 and 
      index(cInputIP#, chr(13)) = 0 then return cInputIP#.
    
    /* First convert windows to standard internal format chr(10) */
    cReturn# = replace(cInputIP#, chr(13) + chr(10), chr(10)).

    /* Then convert mac to standard internal format chr(10) */
    cReturn# = replace(cInputIP#, chr(13), chr(10)).
    
    return cReturn#.
    
  end method. /* CorrectEOL ; character + internal */

end class.

/* EOF */ 
