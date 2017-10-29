{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.interfaces.sc_stringtype_endofline: 

  /****************************** Source Header ********************************\

      Description: OVID# static class

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define public static property oInternal      as i_stringtype_endofline_internal      no-undo get. /* Internal is always chr(10) */
  define public static property oMac           as i_stringtype_endofline_mac           no-undo get.
  define public static property oOsFile        as i_stringtype_endofline_osfile        no-undo get. /* Follow the osfile formaat of the current session */
  define public static property oUnix          as i_stringtype_endofline_unix          no-undo get.
  define public static property oUserInterface as i_stringtype_endofline_userinterface no-undo get. /* Format a string for showing in the UI */
  define public static property oWindows       as i_stringtype_endofline_windows       no-undo get.

end class.

/* EOF */ 
