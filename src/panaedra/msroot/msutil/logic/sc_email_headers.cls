{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_email_headers   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_email_headers.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-12 11:35:56+02:00 $ 
    Date Modified: $Modtime: 2009-10-12 11:35:08+02:00 $ 

      Description: Functionality for sending raw e-mails to a socket or unix file

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_email_headers(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

method public static character EmailHeaderStrictDate ():
  
  define variable dtmNow# as datetime-tz no-undo.
  
  dtmNow# = now.
  
  /* Todo: EnglishAbvDate moet nog worden doorgelust */
    
  return subst("&1 &2 &3",
    sc_date_timestamp:EnglishAbvDate(dtmNow#), 
    substring(iso-date(dtmNow#),12,8),
    replace(substring(iso-date(dtmNow#),24,6),":","")).

end method. /* EmailHeaderStrictDate */


end class.

/* EOF */ 
