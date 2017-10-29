{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_email_headers   : 

  /****************************** Source Header ********************************\

      Description: Functionality for sending raw e-mails to a socket or unix file

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method public static character EmailHeaderStrictDate ():
  
    /* Returns a date string suitable for e-mail headers */
  
    define variable dtmNow# as datetime-tz no-undo.
  
    dtmNow# = now.
  
    return subst("&1 &2 &3",
      sc_date_timestamp:EnglishAbvDate(dtmNow#), 
      substring(iso-date(dtmNow#),12,8),
      replace(substring(iso-date(dtmNow#),24,6),":","")).

  end method. /* EmailHeaderStrictDate */

end class.

/* EOF */ 
