{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_email_headers   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_email_headers.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-13 10:22:19+01:00 $ 
    Date Modified: $Modtime: 2010-01-13 10:21:55+01:00 $ 

      Description: Functionality for sending raw e-mails to a socket or unix file

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_email_headers(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
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
