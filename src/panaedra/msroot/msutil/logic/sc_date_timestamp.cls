{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_date_timestamp   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_date_timestamp.cls $ 
          Version: $Revision: 10 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-07-14 11:38:07+02:00 $ 
    Date Modified: $Modtime: 2010-07-14 11:37:28+02:00 $ 

      Description: Date and time timestamp functionality

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_date_timestamp(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 10 $', '{&sourcecontrolversions}').
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
function englishAbvDate returns character(dtWhenIP# as date) in super.

  method public static character EnglishAbvDate(dtmWhenIP# as datetime-tz):
    
    /* Overload for easy acces date version below */
    
    return EnglishAbvDate(date(dtmWhenIP#)).
    
  end method. /* EnglishAbvDate; datetime-tz */


  method public static character EnglishAbvDate(dtWhenIP# as date):
    
    /* Returns a string like "6 Oct 2010". 
       Format is protected for i.e. E-mail headers, so don't change the format. 
    */
    
    return englishAbvDate(date(dtWhenIP#)).
    
  end method. /* EnglishAbvDate; date */


  method public static character EmailHeaderStrictDate():
    
    /* Returns a date string suitable for e-mail headers */
    /* Is included in this class only for "easy finding" */
    /* Preferably use sc_email_header method directly    */
    
    return sc_email_headers:EmailHeaderStrictDate().
    
  end method. /* EmailHeaderStrictDate */
  

  method public static integer GetDateAsCCYYMMDD():
    
    /* Returns an integer in CCYYMMDD format; century, year, month, day */
  
    return GetDateAsCCYYMMDD(today).
  
  end method. /* GetDateAsCCYYMMDD: simple overload with 'today' */
  
  
  method public static integer GetDateAsCCYYMMDD(
    
    /* Returns an integer in CCYYMMDD format; century, year, month, day */
  
    dtInputIP# as date):

    return integer((year(dtInputIP#) * 10000) + (month(dtInputIP#) * 100) + day(dtInputIP#)).
  
  end method. /* GetDateAsCCYYMMDD: date input */


  method public static integer GetTimeAsHH_FCMPNY_S(
    
    /* Returns an integer in HH_FCMPNY_S format; hour, minutes, seconds  */
  
    iTimeIP# as integer  ):
      
    def var cTime# as char no-undo.
    cTime# = string(iTimeIP#, "HH:MM:SS").  

    return int(entry(1, cTime#, ":")) * 10000
           + int(entry(2, cTime#, ":")) * 100
           + int(entry(3, cTime#, ":")) 
           .
  
  end method. /* GetDateAsCCYYMMDD: date input */


  method public static integer GetTimeAsHHMM(
    
    /* Returns an integer in HH_FCMPNY_S format; hour, minutes, seconds  */
  
    iTimeIP# as integer  ):
      
    def var cTime# as char no-undo.
    cTime# = string(iTimeIP#, "HH:MM").  

    return int(entry(1, cTime#, ":")) * 100
           + int(entry(2, cTime#, ":")) * 1
           .
  
  end method. /* GetDateAsCCYYMMDD: date input */



end class.

/* EOF */ 
