{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_date_timestamp   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_date_timestamp.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-13 10:22:19+01:00 $ 
    Date Modified: $Modtime: 2010-01-13 10:21:43+01:00 $ 

      Description: Date and time timestamp functionality

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_date_timestamp(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 4 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define public static property cTimeStamp_Short_Date as character no-undo get:
      return replace(replace(replace(substring(iso-date(now),1,10),":",""),".",""),"-","").
    end get.

  define public static property cTimeStamp_Short_DateAndTime as character no-undo get:
      return replace(replace(replace(substring(iso-date(now),1,23),":",""),".",""),"-","").
    end get.

  define public static property cTimeStamp_Readable_Date as character no-undo get:
      return replace(replace(replace(substring(iso-date(now),1,10),":","_"),".","_"),"-","_").
    end get.

  define public static property cTimeStamp_Readable_DateAndTime as character no-undo get:
      return replace(replace(replace(substring(iso-date(now),1,23),":","_"),".","_"),"-","_").
    end get.

  
/* TODO: function in class moet weg */
function englishAbvDate returns character (dtWhenIP# as date) in super.

  method public static character EnglishAbvDate (dtmWhenIP# as datetime-tz):
    
    /* Overload for easy acces date version below */
    
    return EnglishAbvDate(date(dtmWhenIP#)).
    
  end method. /* EnglishAbvDate; datetime-tz */


  method public static character EnglishAbvDate (dtWhenIP# as date):
    
    /* Returns a string like "6 Oct 2010". 
       Format is protected for i.e. E-mail headers, so don't change the format. 
    */
    
    return englishAbvDate(date(dtWhenIP#)).
    
  end method. /* EnglishAbvDate; date */


  method public static character EmailHeaderStrictDate ():
    
    /* Returns a date string suitable for e-mail headers */
    /* Is included in this class only for "easy finding" */
    /* Preferably use sc_email_header method directly    */
    
    return sc_email_headers:EmailHeaderStrictDate().
    
  end method. /* GetRfc821Date */
  
end class.

/* EOF */ 
