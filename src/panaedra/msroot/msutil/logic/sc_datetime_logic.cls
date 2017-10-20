{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_datetime_logic: 

  /****************************** Source Header ********************************\

      Description: Generic methods for datetime and datetime-tz

  \*****************************  Include Files ********************************/

  constructor protected sc_datetime_logic(
    input oParamIP# as i_unittest_param):
  end constructor.
    
  /******************************* $NoKeywords:  $ *****************************/

{panaedra/msroot/msutil/logic/def/def_weekdays.i &class=class} 

  define static property bVirtualDateInUse as logical no-undo init ?
    public get:
      /* Quick test:
         EXTRAPARAM='[VirtualSystemDate] 1-1-2015' $SCRIPTS/TestTTest -c "message sc_datetime_logic:bVirtualDateInUse view-as alert-box. "
      */
      define variable cVirtualSystemDateParam# as character no-undo.
      if bVirtualDateInUse = ? then
        assign
          cVirtualSystemDateParam# = sc_boot:SessionParameter("VirtualSystemDate")
          bVirtualDateInUse        = sc_data:HasValue(cVirtualSystemDateParam#).
      return bVirtualDateInUse.
    end get.
    public set.
  
   
  define static property dtVirtualDate as date no-undo initial ?
    public get:
      /* Quick test:
         EXTRAPARAM='[VirtualSystemDate] 1-1-2015' $SCRIPTS/TestTTest -c "message sc_datetime_logic:dtVirtualDate view-as alert-box. "
      */
      define variable cVirtualSystemDateParam# as character no-undo.
      if dtVirtualDate = ? then 
      do:
        cVirtualSystemDateParam# = sc_boot:SessionParameter("VirtualSystemDate").
        do on error undo, throw:
          dtVirtualDate = date(cVirtualSystemDateParam#).
          catch oError# as Progress.Lang.Error:
            sc_showexception:ShowException(oError#).
            bVirtualDateInUse = false.  /* From now on, don't try to use this invalid virtual date */
          end catch.
        end.
      end.
      return dtVirtualDate.
    end get.
    public set.


  define static property dtToday as date no-undo initial ? 
    public get:
      /* Quick test:
         EXTRAPARAM='[VirtualSystemDate] 1-1-2015' $SCRIPTS/TestTTest -c "message sc_datetime_logic:dtToday view-as alert-box. "
      */
      if bVirtualDateInUse and dtVirtualDate <> ? then return dtVirtualDate.
      else return today.
    end get. 
    protected set. 

  
  define public static property dtmNow as datetime-tz no-undo 
    get:
      return now.   
    end get. 
    protected set. 
  
  method public static logical IsWorkday(
  
    input iWeekdayIP# as integer 
    ):
      
    return iWeekdayIP# >= {&monday} and iWeekdayIP# <= {&friday}.   
  
  end method. /* IsWorkday */
  
  
  method public static int GetTime(dtmInputIP# as datetime-tz):
    
    return integer(truncate(mtime(dtmInputIP#) / 1000.0, 0)).
  
  end method. /* GetTime */


  method public static character GetTimeHHMM(dtmInputIP# as datetime-tz):
  
    return string(GetTime(dtmInputIP#),"hh:mm").
  
  end method. /* GetTimeHHMM */

  
  method public static void GetTimeHHMM(
    input  dtmInputIP# as datetime-tz,
    output iUrenOP#    as integer,
    output iMinutenOP# as integer
    ):
      
    define variable cDateTime# as character no-undo.
    
    assign
      cDateTime#  = string(dtmInputIP#)
      iUrenOP#    = integer(substring(cDateTime#, 12, 2))
      iMinutenOP# = integer(substring(cDateTime#, 15, 2))
      .
  
  end method. /* GetTimeHHMM */
  
  
  method public static character GetTimeHH_FCMPNY_S(dtmInputIP# as datetime-tz):
  
    return string(GetTime(dtmInputIP#),"hh:mm:ss").
  
  end method. /* GetTimeHH_FCMPNY_S */
  
  
  method public static character GetTimeHH_FCMPNY_SFFF(dtmInputIP# as datetime-tz):
  
    return replace(replace(substring(string(dtmInputIP#,"99/99/9999 HH:MM:SS.SSS"),12),":",""),",","").
  
  end method. /* GetTimeHH_FCMPNY_SFFF */
  
  
  method public static character GetDateYYMMDD (input dtValueIP# as date) :
      
    if dtValueIP# <> ? then  
      return substring(string(year(dtValueIP#)), 3)
        + string(month(dtValueIP#), "99")
        + string(day(dtValueIP#), "99").
        
  end method. /* GetDateYYMMDD */
  
  
  method public static character GetDateDDMMYY (input dtValueIP# as date) :
      
    if dtValueIP# <> ? then  
      return 
        string(day(dtValueIP#), "99")
        + string(month(dtValueIP#), "99")
        + substring(string(year(dtValueIP#)), 3).
        
  end method. /* GetDateDDMMYY */
  
  
  method public static character GetDateCCYYMMDD (input dtValueIP# as date) :
      
    if dtValueIP# <> ? then  
      return string(year(dtValueIP#), "9999")
        + string(month(dtValueIP#), "99")
        + string(day(dtValueIP#), "99").
        
  end method. /* GetDateCCYYMMDD */


  method public static character GetDateDDMM(
    
    /* Returns an character in DD-MM format */
    
    dtInputIP# as datetime-tz):

    return GetDateDDMM(dtInputIP#, "-").
  
  end method. /* GetDateDDMM */

  
  method public static character GetDateDDMM(
    
    /* Returns an character in DD-MM format; with specified seperator */
  
    dtmInputIP# as datetime-tz, cSepIP# as character):

    return 
      if dtmInputIP# <> ? then
      string(day(dtmInputIP#), "99")
      + cSepIP#
      + string(month(dtmInputIP#), "99")
      else "".
  
  end method. /* GetDateDDMM */
  


  method public static character GetDateDDMMYY(
    
    /* Returns an character in DD-MM-YY format */
    
    dtInputIP# as datetime-tz):

    return GetDateDDMMYY(dtInputIP#, "-").
  
  end method. /* GetDateDDMMYY */

  
  method public static character GetDateDDMMYY(
    
    /* Returns an character in DD-MM-YY format; with specified seperator */
  
    dtmInputIP# as datetime-tz, cSepIP# as character):

    return string(day(dtmInputIP#), "99")
      + cSepIP#
      + string(month(dtmInputIP#), "99")
      + cSepIP#
      + substring(string(year(dtmInputIP#), "9999"), 3)
      .
  
  end method. /* GetDateDDMMYY */
  
  
  method public static integer GetDateCCYYWW(
    /* was: dat2week() uit datelib.p 
       returns year and week number */
    dtDateIP# as date
    ):
  
    if dtDateIP# = ? then return 0.
    
    return integer(1 +
      if dtDateIP# - weekday(dtDateIP# - 1) + 8 > date(1,4,year(dtDateIP#) + 1)
      then ((year(dtDateIP#) + 1) * 100)
      else if dtDateIP# - weekday(dtDateIP# - 1) + 8 <= date(1,4,year(dtDateIP#))
      then (truncate((dtDateIP# - date(1,1,year(dtDateIP#) - 1) + 4 -
      weekday(dtDateIP# - 1)) / 7,0) + (year(dtDateIP#) - 1) * 100)
      else (truncate((dtDateIP# - date(1,1,year(dtDateIP#)) + 4 -
      weekday(dtDateIP# - 1)) / 7,0) + year(dtDateIP#) * 100)
      ).
  
  end method. /* GetDateCCYYWW */
  
  
  method public static character GetReadableDelta(input dtmDateTimeIP# as datetime):
    
    define variable cReturn#   as character no-undo.    
    define variable cDateTime# as character no-undo.
    
    cDateTime# = string(dtmDateTimeIP#,"99-99-9999 HH:MM:SS.SSS").
    
    cReturn# = 
      subst("&1d &2h&3m&4s&5",
      string(day(dtmDateTimeIP#) - day(sc_date_timestamp:dtDeltaNull),"999"),
      string(substring(string(cDateTime#),12,2),"99"),
      string(substring(string(cDateTime#),15,2),"99"),
      string(substring(string(cDateTime#),18,2),"99"),
      if substring(string(cDateTime#),21,3) = "000" then "" else substring(string(cDateTime#),21,3) + "ms"). 
    
    return cReturn#.
    
  end method. /* GetReadableDelta */  
  
  
  method public static character GetReadableDelta(
    input dtmOneIP# as datetime-tz, 
    input dtmTwoIP# as datetime-tz):
    
    define variable iMs#      as integer   no-undo.
    define variable dtmDelta# as datetime  no-undo.
    define variable cReturn#  as character no-undo.    
    
    iMs# = interval(dtmTwoIP#,dtmOneIP#,"milliseconds").
    
    dtmDelta# = sc_date_timestamp:TimezoneInterval(iMs#).
    
    return GetReadableDelta(dtmDelta#).
    
  end method. /* GetReadableDelta */
  

  method public static character DutchAbvMonth(
    input dtmInputIP# as datetime-tz
    ):
    
    define variable iMonth#  as integer   no-undo.
    define variable cReturn# as character no-undo.
    
    iMonth# = month(dtmInputIP#). 
    case iMonth#:
      
      when 1 then 
        cReturn# = "Jan".
      when 2 then 
        cReturn# = "Feb".
      when 3 then 
        cReturn# = "Mrt".
      when 4 then 
        cReturn# = "Apr".
      when 5 then 
        cReturn# = "Mei".
      when 6 then 
        cReturn# = "Jun".
      when 7 then 
        cReturn# = "Jul".
      when 8 then 
        cReturn# = "Aug".
      when 9 then 
        cReturn# = "Sep".
      when 10 then 
        cReturn# = "Okt".
      when 11 then 
        cReturn# = "Nov".
      when 12 then 
        cReturn# = "Dec".
      
    end case. 
    
    return cReturn#.
  
  end method. /* DutchAbvDate */
  
  
  method public static date StringCCYYMMDD2Date(
    input cValueIP# as character
    ):
      
    define variable dtReturn# as date no-undo.  
      
    assign 
      dtReturn# = date(
        int(substring(cValueIP#, 5, 2)),
        int(substring(cValueIP#, 7, 2)),
        int(substring(cValueIP#, 1, 4))
        ) no-error.  
    return dtReturn#.    
  
  end method. /* StringCCYYMMDD2Date */
      

  method public static date GetThisWeeksMonday(
    dtDateIP# as date
    ):
    
    define variable dtReturn# as date no-undo.  
    
    case weekday(dtDateIP#):
    
      /* Weekday 1 is a sunday */
      when 1 then 
        dtReturn# = dtDateIP# + 1.
      when 2 then 
        dtReturn# = dtDateIP# .
      otherwise 
      dtReturn# = dtDateIP# - weekday(dtDateIP# - 2).
    
    end. /* weekday */
      
    return dtReturn#.
    
  end method. /* GetThisWeeksMonday */  


  method public static date GetThisWeeksFriday(
    dtDateIP# as date
    ):
    
    define variable dtReturn# as date no-undo.

    case weekday(dtDateIP#):
    
      /* Weekday 1 is a sunday */
      when 1 then 
        dtReturn# = dtDateIP# + 5.
      when 2 then 
        dtReturn# = dtDateIP# + 4.
      when 3 then 
        dtReturn# = dtDateIP# + 3.
      when 4 then 
        dtReturn# = dtDateIP# + 2.
      when 5 then 
        dtReturn# = dtDateIP# + 1.
      when 6 then 
        dtReturn# = dtDateIP# .
      when 7 then 
        dtReturn# = dtDateIP# - 1.  
    
    end. /* weekday */
    
    return dtReturn#.
    
  end method. /* GetThisWeeksFriday */
  
  
  method public static date GetLastFriday(dtDateIP# as date):
      
    define variable dtLastFriday# as date no-undo.  
      
    dtLastFriday# = dtDateIP# - ((weekday(dtDateIP#) modulo 7) + 1).
    
    return dtLastFriday#.
    
  end method. /* GetLastFriday */ 
  
   
  @panaedraannotation file(unittest="yes").
  method public static date GetNextWorkday(
    /* returns the next workday, in other words: skips the weekends */
    dtValueIP# as date
    ):
      
    define variable dtReturn# as date no-undo.
    
    dtReturn# = add-interval(dtValueIP#, 1, "days").
    
    /* skip saturday/sunday */
    do while lookup(string(weekday(dtReturn#)), "1,7") > 0 :
      dtReturn# = add-interval(dtReturn#, 1, "days").
    end.
    
    return dtReturn#.
  
  end method. /* GetNextWorkday */   
  
  
  method public static date GetPreviousWorkday(
    /* returns the previous workday, in other words: skips the weekends going backwards */
    dtValueIP# as date
    ):
      
    define variable dtReturn# as date no-undo.
    
    dtReturn# = add-interval(dtValueIP#, -1, "days").
    
    /* skip saturday/sunday */
    do while lookup(string(weekday(dtReturn#)), "1,7") > 0 :
      dtReturn# = add-interval(dtReturn#, -1, "days").
    end.
    
    return dtReturn#.
  
  end method. /* GetPreviousWorkday */

     
  method public static character GetWeekdayChar(
    /* Return a character representing today (ma di wo do.....) */
    input dtDateIP#       as date,
    input cLanguageIP#    as character,
    input bAbbreviatedIP# as logical
    ):
    
    return GetWeekdayChar(weekday(dtDateIP#),cLanguageIP#,bAbbreviatedIP#).
        
  end method. /* GetWeekdayChar */
  
      
  method public static character GetWeekdayChar(
    /* Return a character representing today (ma di wo do.....) */
    input iWeekdayIP#     as integer,
    input cLanguageIP#    as character,
    input bAbbreviatedIP# as logical
    ):
    
    define variable cToday# as character no-undo.
    
    if cLanguageIP# = "EN" then
      case iWeekdayIP#:
      
        when 1 then
          cToday# = if bAbbreviatedIP# then "Sun" else "Sunday".
         
        when 2 then
          cToday# = if bAbbreviatedIP# then "Mon" else "Monday".
         
        when 3 then
          cToday# = if bAbbreviatedIP# then "Tue" else "Tuesday".
         
        when 4 then
          cToday# = if bAbbreviatedIP# then "Wed" else "Wednesday".
         
        when 5 then
          cToday# = if bAbbreviatedIP# then "Thu" else "Thu_TERM_UNDISCLOSED_ay".
         
        when 6 then
          cToday# = if bAbbreviatedIP# then "Fri" else "Friday".
         
        when 7 then
          cToday# = if bAbbreviatedIP# then "Sat" else "Saturday".
         
      end case.  
    else if cLanguageIP# = "NL" then
        case iWeekdayIP#:
      
          when 1 then
            cToday# = if bAbbreviatedIP# then "Zo" else "Zondag".
         
          when 2 then
            cToday# = if bAbbreviatedIP# then "Ma" else "Maandag".
         
          when 3 then
            cToday# = if bAbbreviatedIP# then "Di" else "Dinsdag".
         
          when 4 then
            cToday# = if bAbbreviatedIP# then "Wo" else "Woensdag".
         
          when 5 then
            cToday# = if bAbbreviatedIP# then "Do" else "Donderdag".
         
          when 6 then
            cToday# = if bAbbreviatedIP# then "Vr" else "Vrijdag".
         
          when 7 then
            cToday# = if bAbbreviatedIP# then "Za" else "Zaterdag".
         
        end case.      
      else 
        sc_showexception:ShowException(
          new c_panaedraexception(
          55550981,
          sc_lang:oEnglish,
          subst("Unknown language for GetWeekdayChar: &1 ",cLanguageIP#))).
        
    return cToday#.
    
  end method. /* GetWeekdayChar */
  
  
  @panaedraannotation file(unittest="yes").
  method public static logical IsLastDayOfMonth(input dtDateIP# as date):
    
    define variable bIsLastDayOfMonth# as logical no-undo.
    
    bIsLastDayOfMonth# = day(dtDateIP# + 1) = 1.
    
    return bIsLastDayOfMonth#.
    
  end method. /* IsLastDayOfMonth */


  @panaedraannotation file(unittest="yes").
  method public static date GetLastDateOfMonth(
    input iYearIP# as integer,
    input iMonthIP# as integer
    ):
    
    define variable dLastDateOfMonth# as date    no-undo.
    define variable dDate#            as date    no-undo.
    define variable iDay#             as integer no-undo.
    
    do iDay# = 27 to 31:
      
      dDate# = date(iMonthIP#,iDay#,iYearIP#).  

      if day(dDate# + 1) = 1 then 
      do:
        dLastDateOfMonth# = dDate#.
        leave.     
      end.  
      
    end.

    return dLastDateOfMonth#.
    
  end method. /* IsLastDayOfMonth */
  
  
  method public static character GetDateMMDDCCYY(
    
    /* Returns an character in MM-DD-CCYY format; with specified seperator */
  
    dtmInputIP# as datetime-tz, 
    cSepIP#     as character):

    return string(month(dtmInputIP#), "99")
      + cSepIP#
      + string(day(dtmInputIP#), "99")
      + cSepIP#
      + string(year(dtmInputIP#), "9999")
      .
  
  end method. /* GetDateMMDDCCYY */
  
  
  method public static date GetDateByYYYYMMDD(cDateIP# as character):
  
    if sc_data:HasValue(cDateIP#) then 
      return date(
        integer(substring(cDateIP#, 5, 2)),
        integer(substring(cDateIP#, 7, 2)),
        integer(substring(cDateIP#, 1, 4))
        ). 
  
  end method. /* GetDateByYYYYMMDD */
  
  
  method public static datetime-tz GetNextDatetimeForHour(
    /* Gives back a datetime-tz for the next time provided hour will take place. 
       
       For example you put in 02 and current time is 18:00 01/21/16.
       Then the next time 02 will happen is 02:00 01/22/16
       
       For example you put in 02 and current time is 01:00 01/21/16.
       Then the next time 02 will happen is 02:00 01/21/16
       
       */ 
       
    input iHourIP# as integer
       
    ):
    
    define variable dtmNextDatetimeForHour# as datetime-tz no-undo.
    define variable iCurrentHour#           as integer     no-undo.
    
    iCurrentHour# = GetCurrentHour().
    
    if iCurrentHour# = iHourIP# then 
      dtmNextDatetimeForHour# = add-interval(now, 24, "hours").
      
    else if iCurrentHour# > iHourIP# then
        dtmNextDatetimeForHour# = add-interval(now, 24 - iCurrentHour# + iHourIP#, "hours").
        
      else
        dtmNextDatetimeForHour# = add-interval(now, iHourIP# - iCurrentHour#, "hours").
    
    dtmNextDatetimeForHour# = datetime-tz(month(dtmNextDatetimeForHour#), day(dtmNextDatetimeForHour#), year(dtmNextDatetimeForHour#), GetHourFromTime(GetTime(dtmNextDatetimeForHour#)), 0).
               
    return dtmNextDatetimeForHour#.
      
  end method. /* GetNextDatetimeForHour */
    
  
  method public static integer GetCurrentHour():
    
    define variable iCurrentHour# as integer no-undo.
    
    iCurrentHour# = GetHourFromTime(time).
    
    return iCurrentHour#.
      
  end method. /* GetCurrentHour */  

    
  method public static integer GetHourFromTime(
    iTimeIP# as integer):
    
    define variable iHour# as integer no-undo.
    
    iHour# = integer(entry(1, string(iTimeIP#,"hh:mm"), ":")).
    
    return iHour#.
      
  end method. /* GetCurrentHour */  
  
  
  method public static integer WeekNumber(
  
    input  dtDateIP             as date,
    output iYearOfWeekNumberOP# as integer
    ):
    
    define variable iDummy# as integer no-undo.
    
    return WeekNumber(dtDateIP, output iDummy#, output iYearOfWeekNumberOP#).     
      
  end method. /* WeekNumber */  
  
  
  @panaedraannotation file(unittest="yes").
  method public static integer WeekNumber(
  
    /* Return the week number of the provided date, based on that the 1st day of the week is a monday. */
  
    input  dtDateIP                as date,
    output iDutchWeekdayOfDateOP#  as integer,  
    output iYearOfWeekNumberOP#    as integer 
    ):
    
    define variable iReturnWeekNumber# as integer no-undo.
    define variable iYearOfDateFixed#  as integer no-undo.
    define variable dtVariable#        as date    no-undo.
    define variable dtWeek#            as date    no-undo.
    define variable iMonthOfDate#      as integer no-undo.
    define variable iVariableWeekday#  as integer no-undo.
    define variable bFirstdayIsSunday# as logical no-undo. 
    
    assign 
      iDutchWeekdayOfDateOP# = weekday(dtDateIP)           /* 1=sunday;2=monday;... 7=saturday */
      iYearOfWeekNumberOP#   = year   (dtDateIP)
      iMonthOfDate#          = month  (dtDateIP)
      iDutchWeekdayOfDateOP# = iDutchWeekdayOfDateOP# - 1  /* 1=monday;2=tuesday;...7=sunday */
      iDutchWeekdayOfDateOP# = (if iDutchWeekdayOfDateOP# = 0 then 7 else iDutchWeekdayOfDateOP#)
      .        

    /* Determine the first monday of weekno 1. Weekno determination always start on monday.  */
    assign 
      iYearOfDateFixed# = year    (dtDateIP)                 /* Jaar input */
      dtVariable#       = date    (1, 1, iYearOfDateFixed#)  /* Datum 01-01-jaar */
      iVariableWeekday# = weekday (dtVariable#) - 1          /* Dagnr v/d week, MAANDAG = DAG 1 */
      iVariableWeekday# = (if  iVariableWeekday# = 0 then 7 else iVariableWeekday#)
      .
    
    if iVariableWeekday# > 4 then  /* Dayno. of 1-JAN., 1st day of the year. */
      /* Falls within the last 3 days of the week, before monday=day 1. */
      dtVariable# = dtVariable# + 7 - iVariableWeekday# + 1.  
    else
      /* 1-JAN. Fals withinout the first 4 days of the week (before monday = day 1) */
      dtVariable# = dtVariable# - iVariableWeekday# + 1.

    /* _TOOLING_ ional weeknum */ 
    iReturnWeekNumber#  = truncate((dtDateIP - dtVariable#) / 7,0) + 1.

    /* Correct for period 1/1 / YYYY to the first Monday in year week 1; 52 of 53 */
    if dtDateIP < dtVariable# then /* It's in week 52 or 53 of the previous year. */   
    do:                          
      /* Determine the 1e monday of the previous year. */
      assign 
        dtWeek#           = date(1, 1, iYearOfDateFixed# - 1)
        iVariableWeekday# = weekday (dtWeek#) - 1
        iVariableWeekday# = (if iVariableWeekday# = 0 then 7 else iVariableWeekday#)
        .
      if iVariableWeekday# > 4 then  /* Dayno. of 1-JAN., the first day of the year. */
        /* 1-JAN. It's in the last 3 days of the week. (before monday = day 1 ). */
        dtWeek# = dtWeek# + 7 - iVariableWeekday# + 1.
      else
        /* 1-JAN. It's on the first 4 days of the week (before monday = day 1). */
        dtWeek# = dtWeek# - iVariableWeekday# + 1.

      /* Determine the weeknumber of the last of of the previous year. */ 
      assign 
        iReturnWeekNumber#   = truncate( (date(12, 31, iYearOfDateFixed# - 1) - dtWeek#) / 7,0) + 1
        iYearOfWeekNumberOP# = iYearOfDateFixed# - 1
        .
    end.

    /* Correct for the period of the first monday the year of week 52/53 till the date of 1-jan. */ 
    else
    do: 
      assign 
        dtWeek#           = date (1, 1, iYearOfDateFixed# + 1)
        iVariableWeekday# = weekday (dtWeek#) - 1
        iVariableWeekday# = (if  iVariableWeekday# = 0 then 7 else iVariableWeekday#)
        .
      if iVariableWeekday# > 4 then /* Dayno of 1-jan., the first day of the year. */
        /* 1-JAN. Is in the last 3 days of the week (before monday = day 1) */ 
        dtWeek# = dtWeek# + 7 - iVariableWeekday# + 1.
      else
        /* 1-JAN. Is during the 1st 4 days of the week (before monday = day 1). */ 
        dtWeek# = dtWeek# - iVariableWeekday# + 1.

      if dtDateIP >= dtWeek# then /* Date is with the next year. */
        assign 
          iReturnWeekNumber#   = 1
          iYearOfWeekNumberOP# = iYearOfWeekNumberOP# + 1
          .
    end.
    
    return iReturnWeekNumber#. 
    
  end method. /* WeekNumber */
  
  
  method public static datetime-tz TimeTodayAsDatetimeTz(
    input iHourIP#    as integer,
    input iMinutesIP# as integer
    ):
    
    return datetime-tz(month(today), day(today), year(today), iHourIP#, iMinutesIP#). 
  
  end method. /* TimeTodayAsDatetimeTz */

    
  method public static logical PointOfTimeHasPassed(
    input iHourIP#    as integer,
    input iMinutesIP# as integer
    ):
  
    return now > sc_datetime_logic:TimeTodayAsDatetimeTz(iHourIP#, iMinutesIP#). 
  
  end method. /* PointOfTimeHasPassed */
  
end class.

/* EOF */ 

