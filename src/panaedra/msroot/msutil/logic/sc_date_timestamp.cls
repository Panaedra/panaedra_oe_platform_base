{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_date_timestamp   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_date_timestamp.cls $ 
          Version: $Revision: 14 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-08-22 16:56:23+02:00 $ 
    Date Modified: $Modtime: 2010-08-22 16:53:56+02:00 $ 

      Description: Date and time timestamp functionality
      
                   TODO: some of these methods should be moved to the newer class sc_datetime.cls.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_date_timestamp(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 14 $', '{&sourcecontrolversions}').
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
    
  
  define public static variable iMsInDay    as int64 no-undo init 86400000.  
  define public static variable iMsInHour   as int64 no-undo init 3600000.  
  define public static variable iMsInMinute as int64 no-undo init 60000.  
    

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
  
  end method. /* GetTimeAsHH_FCMPNY_S: time input */


  method public static character GetTimeAsStringHHMM(
    
    /* Returns an integer in HH:MM format; hour, minutes */
  
    dtmDateIP# as datetime-tz):
    
    def var cTime# as character no-undo.
    
    cTime# = string(substring(string(dtmDateIP#), 12,5), "99999").  
    
    return cTime#.
  
  end method. /* GetTimeAsStringHHMM: datetime-tz input */


  method public static integer GetTimeAsHHMM(
    
    /* Returns an integer in HHMM format; hour, minutes */
  
    iTimeIP# as integer  ):
      
    def var cTime# as char no-undo.
    cTime# = string(iTimeIP#, "HH:MM").  
    
    return int(entry(1, cTime#, ":")) * 100
      + int(entry(2, cTime#, ":")) * 1
      .
  
  end method. /* GetTimeAsHHMM: time input */


  method public static datetime-tz TimezoneInterval(
    input iMillisecondsIP# as int64):
      
    return TimezoneInterval(0,0,iMillisecondsIP#).
  
  end method. /* TimezoneInterval */

  
  method public static datetime-tz TimezoneInterval(
    input iSecondsIP# as integer,
    input iMilliSecondsIP# as int64
    ):
  
    return TimezoneInterval(0, iSecondsIP#, iMilliSecondsIP#).
  
  end method. /* TimezoneInterval */
  
  
  method public static datetime-tz TimezoneInterval(
    input iMinutesIP# as integer, 
    input iSecondsIP# as integer,
    input iMilliSecondsIP# as int64
    ):
    
    /* Returns a time interval starting count on 1/1/0001 */
    
    define variable dInterval#     as date    no-undo init 1/1/0001.
    define variable iMilliSeconds# as int64   no-undo.
    define variable iDays#         as integer no-undo.
    define variable iMsPerDay#     as int64   no-undo.
    
    assign     
      iMilliSeconds# = iMilliSecondsIP#
      iMsPerDay#     = 24 * 3600 * 1000. 

    if iMinutesIP# <> 0 then iMilliSeconds# = iMilliSeconds# + 60000 * iMinutesIP#.
    if iSecondsIP# <> 0 then iMilliSeconds# = iMilliSeconds# +  1000 * iSecondsIP#.

    assign     
      iDays#     = truncate(dec(iMilliSeconds#) / iMsPerDay#, 0)
      dInterval# = dInterval# + iDays#. 
  
    return datetime-tz(dInterval#, iMilliSeconds# mod iMsPerDay#).
  
  end method. /* TimezoneInterval */


  method public static datetime-tz DateTimeNowMinusDelta(
    dtmDateIP# as datetime-tz):

    return TimezoneInterval(0, 0, datetime-tz(now) - dtmDateIP# ).
    
  end method. /* DateTimeNowMinusDelta */


  method public static datetime-tz GetEndOfDay(dtmDay# as datetime-tz):

    return add-interval(add-interval(dtmDay#, 1, "days"), -1, "milliseconds").

  end method. /* GetEndOfDay */
  
  
  method public static datetime-tz DatetimeFromString(cFormatIP# as character, cDatetimeIP# as character):
    
    define variable dtmReturn# as datetime-tz no-undo.
    define variable iDtm#      as integer     no-undo extent 8.
    
    case cFormatIP#:
      
      when "rfc3339date" then 
        do:
          IsoDatetimeExplodeToInts(cDatetimeIP#, output iDtm#).
          /* Without time-zone, revert to system default */
          if iDtm#[8] = ? then dtmReturn# = datetime-tz(iDtm#[2],iDtm#[3],iDtm#[1],iDtm#[4],iDtm#[5],iDtm#[6],iDtm#[7]).
          /* Else use time-zone in string */
          else dtmReturn# = datetime-tz(iDtm#[2],iDtm#[3],iDtm#[1],iDtm#[4],iDtm#[5],iDtm#[6],iDtm#[7],iDtm#[8]).
          return dtmReturn#.
        end.
        
      otherwise 
      undo, throw 
        new Progress.Lang.AppError(subst("Unsupported DatetimeFromString format: '&1'", cFormatIP#), 9990311).
        
    end. /* case cFormatIP# */
  
  end method. /* DatetimeFromString */


  method public static void DatetimeExplodeToInts(input dtmInput# as datetime-tz, output iDtmOP# as integer extent 8):
  
    define variable cIso# as character no-undo.
    
    cIso# = iso-date(dtmInput#).
    IsoDatetimeExplodeToInts(cIso#, output iDtmOP#).

  end method. /* DatetimeExplodeToInts */
  

  method public static void IsoDatetimeExplodeToInts(input cIsoIP# as character, output iDtmOP# as integer extent 8):
  
    iDtmOP#[1] = int(substring(cIsoIP#,1,4)) no-error.
    if iDtmOP#[1] = ? then iDtmOP#[1] = year(today).
    iDtmOP#[2] = int(substring(cIsoIP#,6,2)) no-error.
    if iDtmOP#[2] = ? then iDtmOP#[2] = month(today).
    iDtmOP#[3] = int(substring(cIsoIP#,9,2)) no-error.
    if iDtmOP#[3] = ? then iDtmOP#[3] = day(today).
      
    iDtmOP#[4] = int(substring(cIsoIP#,12,2))no-error.
    if iDtmOP#[4] = ? then iDtmOP#[4] = 0.
    iDtmOP#[5] = int(substring(cIsoIP#,15,2))no-error.
    if iDtmOP#[5] = ? then iDtmOP#[5] = 0.
    iDtmOP#[6] = int(substring(cIsoIP#,18,2))no-error.
    if iDtmOP#[6] = ? then iDtmOP#[6] = 0.
    iDtmOP#[7] = int(substring(cIsoIP#,21,3))no-error.
    if iDtmOP#[7] = ? then iDtmOP#[7] = 0.
    
    if length(trim(cIsoIP#)) < 25 then iDtmOP#[8] = ?.
    else iDtmOP#[8] = int(substring(cIsoIP#,25,2))no-error.
    /* Important: if no timezone info, don't return zero. That's somewhere in england. */
    if error-status:num-messages > 0 then iDtmOP#[8] = ?.
  
  end method. /* DatetimeExplodeToInts */
  
end class.

/* EOF */ 
