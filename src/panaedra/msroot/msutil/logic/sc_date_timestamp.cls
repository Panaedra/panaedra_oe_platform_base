{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_date_timestamp   : 

  /****************************** Source Header ********************************\

      Description: Date and time timestamp functionality
      
                   Shouldhave: some of these methods should be moved to the newer class sc_datetime_logic.cls.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define public static property cTimeStamp_Short_Date as character no-undo get:
      return replace(replace(replace(substring(iso-date(now),1,10),":",""),".",""),"-","").
    end get.

  define public static property cTimeStamp_Short_DateAndTime as character no-undo get:
      return replace(replace(replace(substring(iso-date(now),1,23),":",""),".",""),"-","").
    end get.

  define public static property cTimeStamp_Short_CCYYMMDDmmssuuu as character no-undo get:
      /* Same as cTimeStamp_Short_DateAndTime, but without the 'T' in the middle. For backward compatibility with the old datelib.p dynamic-function("TimeStamp",today,"DTM","") */
      return replace(replace(replace(replace(substring(iso-date(now),1,23),":",""),".",""),"-",""),"T","").
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
    

  method public static character EnglishAbvDate(dtmWhenIP# as datetime-tz):
    
    /* Overload for easy acces date version below */
    
    return EnglishAbvDate(date(dtmWhenIP#)).
    
  end method. /* EnglishAbvDate; datetime-tz */


  method public static character EnglishAbvDate(dtWhenIP# as date):
    
    /* Returns a string like "6 Oct 2010". 
       Format is protected for i.e. E-mail headers, so don't change the format. 
    */
    
    define variable cMonth# as character no-undo.
        
    case month(dtWhenIP#):
      when 1  then 
        cMonth# = "Jan".
      when 2  then 
        cMonth# = "Feb".
      when 3  then 
        cMonth# = "Mar".
      when 4  then 
        cMonth# = "Apr".
      when 5  then 
        cMonth# = "May".
      when 6  then 
        cMonth# = "Jun".
      when 7  then 
        cMonth# = "Jul".
      when 8  then 
        cMonth# = "Aug".
      when 9  then 
        cMonth# = "Sep".
      when 10 then 
        cMonth# = "Oct".
      when 11 then 
        cMonth# = "Nov".
      when 12 then 
        cMonth# = "Dec".
    end.
    
    return 
      trim(string(day(dtWhenIP#),">9")) 
      + " " 
      + cMonth# 
      + " " 
      + string(year(dtWhenIP#),"9999").
    
  end method. /* EnglishAbvDate; date */


  method public static character EmailHeaderStrictDate():
    
    /* Returns a date string suitable for e-mail headers */
    /* Is included in this class only for "easy finding" */
    /* Preferably use sc_email_header method directly    */
    
    return sc_email_headers:EmailHeaderStrictDate().
    
  end method. /* EmailHeaderStrictDate */
  
  
  method public static character GetDateAsCCYYMMDDString(
    
    /* Returns an character in CCYYMMDD format; century, year, month, day */
  
    dtInputIP# as date):
  
    return string(GetDateAsCCYYMMDD(dtInputIP#),"99999999").
  
  end method. /* GetDateAsCCYYMMDDString */
  

  method public static integer GetDateAsCCYYMMDD():
    
    /* Returns an integer in CCYYMMDD format; century, year, month, day */
  
    return GetDateAsCCYYMMDD(today).
  
  end method. /* GetDateAsCCYYMMDD: simple overload with 'today' */
  
  
  method public static integer GetDateAsCCYYMMDD(
    
    /* Returns an integer in CCYYMMDD format; century, year, month, day */
  
    dtInputIP# as date):

    return integer((year(dtInputIP#) * 10000) + (month(dtInputIP#) * 100) + day(dtInputIP#)).
  
  end method. /* GetDateAsCCYYMMDD: date input */


  method public static integer GetDateAsYYMMDD():
    
    /* Returns an integer in YYMMDD format; year 2-digit, month, day */
  
    return GetDateAsYYMMDD(today).
  
  end method. /* GetDateAsYYMMDD: simple overload with 'today' */
  
  
  method public static integer GetDateAsYYMMDD(
    
    /* Returns an integer in YYMMDD format; year 2-digit, month, day */
  
    dtInputIP# as date):

    return integer(((year(dtInputIP#) mod 100) * 10000) + (month(dtInputIP#) * 100) + day(dtInputIP#)).
  
  end method. /* GetDateAsYYMMDD: date input */


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


  method public static character GetDateTimeAsStringYYYYMMDDHHMM():
  
    /* Get the current date time in the order of year, month, day, hour and minute as YYYYMMDDUUMM */

    define variable cDateTime# as character no-undo. 
    define variable cYear#     as character no-undo. 
    define variable cMonth#    as character no-undo. 
    define variable cDay#      as character no-undo. 
    define variable cHour#     as character no-undo. 
    define variable cMinute#   as character no-undo. 

    /* Get the current system date and time as: 27/06/2014 16:05:03,991+02:00
       and extract the date and time elements into descriptive named variables */ 
    assign 
      cDateTime# = string(now)
      cYear#     = substring(cDateTime#,7,4)  
      cDay#      = substring(cDateTime#,1,2)
      cMonth#    = substring(cDateTime#,4,2)
      cHour#     = substring(cDateTime#,12,2)
      cMinute#   = substring(cDateTime#,15,2).

    /* return the datetime variable elements into a string in the shape of YYYYMMDDHHMM 
       for example 27/06/2014 15:58:33,072 results in the character string output 201406271558  */  
    return substitute("&1&2&3&4&5", cYear#, cMonth#, cDay#, cHour#, cMinute#).    
  
  end method. /* GetDateTimeAsStringYYYYMMDDHHMM */
  
  
  
  method public static character GetDateTimeAsStringYYYYMMDD_HH_FCMPNY_S(cDateTimeSeparatorIP# as character):
  
    /* Get the current date time in the order of year, month, day, hour and minute as YYYYMMDD__HH_FCMPNY_S */

    define variable cDateTime#          as character no-undo. 
    define variable cDateTimeSeparator# as character no-undo. 
    define variable cYear#              as character no-undo. 
    define variable cMonth#             as character no-undo. 
    define variable cDay#               as character no-undo. 
    define variable cHour#              as character no-undo. 
    define variable cMinute#            as character no-undo. 
    define variable cSecond#            as character no-undo. 
    
    /* Get the current system date and time as: 27/06/2014 16:05:03,991+02:00
       and extract the date and time elements into descriptive named variables */ 
    assign 
      cDateTime# = string(now)
      cYear#     = substring(cDateTime#,7,4)  
      cDay#      = substring(cDateTime#,1,2)
      cMonth#    = substring(cDateTime#,4,2)
      cHour#     = substring(cDateTime#,12,2)
      cMinute#   = substring(cDateTime#,15,2)
      cSecond#   = substring(cDateTime#,18,2).

    /* return the datetime variable elements into a string in the shape of YYYYMMDDHHMM 
       for example 27/06/2014 15:58:33,072 results in the character string output 201406271558  */  
    return substitute("&1&2&3&7&4&5&6", cYear#, cMonth#, cDay#, cHour#, cMinute#, cSecond#, cDateTimeSeparatorIP#).    
  
  end method. /* GetDateTimeAsStringYYYYMMDDHHMM */
  
  
  
  
  
  
  method public static character GetTimeAsStringHH_FCMPNY_S():
  
    /* Get the current time in the order of hour, minute and seconds as HH_FCMPNY_S */

    define variable cDateTime# as character no-undo. 
    define variable cHour#     as character no-undo. 
    define variable cMinute#   as character no-undo. 
    define variable cSecond#   as character no-undo. 

    /* Get the current system date and time as: 27/06/2014 16:05:03,991+02:00
       and extract the date and time elements into descriptive named variables */ 
    assign 
      cDateTime# = string(now)
      cHour#     = substring(cDateTime#,12,2)
      cMinute#   = substring(cDateTime#,15,2)
      cSecond#   = substring(cDateTime#,18,2).
     
    return substitute("&1&2&3", cHour#, cMinute#, cSecond#).    
  
  end method. /* GetTimeAsStringHH_FCMPNY_S */


  method public static datetime TimezoneInterval(
    input iMillisecondsIP# as int64):
    
    return TimezoneInterval(0,0,iMillisecondsIP#).
  
  end method. /* TimezoneInterval */

  
  method public static datetime TimezoneInterval(
    input iSecondsIP# as integer,
    input iMilliSecondsIP# as int64
    ):
  
    return TimezoneInterval(0, iSecondsIP#, iMilliSecondsIP#).
  
  end method. /* TimezoneInterval */
  
  
  define public static property dtDeltaNull as date no-undo
    get:
      return 1/1/0001.
    end get.
  
  method public static datetime TimezoneInterval(
    input iMinutesIP# as integer, 
    input iSecondsIP# as integer,
    input iMilliSecondsIP# as int64
    ):
    
    /* Returns a time interval starting count on 1/1/0001 */
    
    define variable dtInterval#    as date    no-undo init 1/1/0001.
    define variable iMilliSeconds# as int64   no-undo.
    define variable iDays#         as integer no-undo.
    define variable iMsPerDay#     as int64   no-undo.
    
    assign     
      iMilliSeconds# = iMilliSecondsIP#
      iMsPerDay#     = 24 * 3600 * 1000. 

    if iMinutesIP# <> 0 then iMilliSeconds# = iMilliSeconds# + 60000 * iMinutesIP#.
    if iSecondsIP# <> 0 then iMilliSeconds# = iMilliSeconds# +  1000 * iSecondsIP#.

    assign     
      iDays#      = truncate(dec(iMilliSeconds#) / iMsPerDay#, 0)
      dtInterval# = dtDeltaNull + iDays#. 
  
    return datetime(dtInterval#, iMilliSeconds# mod iMsPerDay#).
  
  end method. /* TimezoneInterval */


  method public static datetime-tz DateTimeNowMinusDelta(
    dtmDateIP# as datetime):

    return TimezoneInterval(0, 0, datetime-tz(now) - datetime-tz(dtmDateIP#) ).
    
  end method. /* DateTimeNowMinusDelta */


  method public static datetime-tz GetEndOfDay(dtmDayIP# as datetime-tz):

    return add-interval(
      add-interval(datetime-tz(date(dtmDayIP#)), +1, "day"),
      -1,
      "milliseconds"
      ).

  end method. /* GetEndOfDay */
  

  method public static datetime-tz GetBeginOfDay(dtmDayIP# as datetime-tz):

    return datetime-tz(date(dtmDayIP#)).

  end method. /* GetEndOfDay */

  
  method public static datetime DatetimeDeltaFromString(cFormatIP# as character, cDatetimeIP# as character):
    
    define variable dtmReturn# as datetime no-undo.
    define variable iDtm#      as integer  no-undo extent 8.
    
    case cFormatIP#:
      
      when "iso-date"    /* Normal ABL conversion also supported */ 
      then 
        do:
          IsoDatetimeExplodeToInts(cDatetimeIP#, output iDtm#).
          dtmReturn# = datetime(iDtm#[2],iDtm#[3],iDtm#[1],iDtm#[4],iDtm#[5],iDtm#[6],iDtm#[7]).
          return dtmReturn#.
        end.
        
      otherwise
      undo, throw new c_panaedraexception(
        99909103,
        sc_lang:oEnglish,
        subst("Unsupported DatetimeDeltaFromString format: '&1'", cFormatIP#)
        ).
      
    end. /* case cFormatIP# */
    
  end method. /* DatetimeDeltaFromString */
    
    
  method public static datetime-tz DatetimeFromString(cFormatIP# as character, cDatetimeIP# as character):
    
    define variable dtmReturn# as datetime-tz no-undo.
    define variable iDtm#      as integer     no-undo extent 8.
    
    case cFormatIP#:
      
      when "rfc3339date" /* Used by EDI and raw e-mail headers   */
      then 
        do:
          IsoDatetimeExplodeToInts(cDatetimeIP#, output iDtm#).
          /* Without time-zone, revert to system default */
          if iDtm#[8] = ? then dtmReturn# = datetime-tz(iDtm#[2],iDtm#[3],iDtm#[1],iDtm#[4],iDtm#[5],iDtm#[6],iDtm#[7]).
          /* Else use time-zone in string */
          else dtmReturn# = datetime-tz(iDtm#[2],iDtm#[3],iDtm#[1],iDtm#[4],iDtm#[5],iDtm#[6],iDtm#[7],iDtm#[8] * 60 /* offset in minutes */).
          return dtmReturn#.
        end.
        
      when "iso-date"    /* Normal ABL conversion also supported */ 
      then 
        do:
          IsoDatetimeExplodeToInts(cDatetimeIP#, output iDtm#).
          /* Without time-zone, revert to system default */
          if iDtm#[8] = ? then dtmReturn# = datetime-tz(iDtm#[2],iDtm#[3],iDtm#[1],iDtm#[4],iDtm#[5],iDtm#[6],iDtm#[7]).
          /* Else use time-zone in string */
          else dtmReturn# = datetime-tz(iDtm#[2],iDtm#[3],iDtm#[1],iDtm#[4],iDtm#[5],iDtm#[6],iDtm#[7],iDtm#[8] * 60 /* offset in minutes */).
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
