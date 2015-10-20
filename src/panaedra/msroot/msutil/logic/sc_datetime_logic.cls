using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_datetime_logic: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Generic methods for datetime and datetime-tz

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_datetime_logic(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  
  constructor protected sc_datetime_logic(
    input oParamIP# as i_unittest_param):
  end constructor.  
  /******************************* $NoKeywords:  $ *****************************/
 
  method public static int GetTime(dtmInputIP# as datetime-tz):
    
    return integer(truncate(mtime(dtmInputIP#) / 1000.0, 0)).
  
  end method. /* GetTime */


  method public static character GetTimeHHMM(dtmInputIP# as datetime-tz):
  
    return string(GetTime(dtmInputIP#),"hh:mm").
  
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
  
  
  @panaedraannotation file(unittest="yes").
  method public static datetime-tz GetNextWorkday(
    /* returns the next workday, in other words: skips the weekends */
    dtmValueIP# as datetime-tz
    ):
      
    define variable dtmReturn# as datetime-tz no-undo.
    
    dtmReturn# = add-interval(dtmValueIP#, 1, "days").
    
    /* skip saturday/sunday */
    do while lookup(string(weekday(dtmReturn#)), "1,7") > 0 :
      dtmReturn# = add-interval(dtmReturn#, 1, "days").
    end.
    
    return dtmReturn#.
  
  end method. /* GetNextWorkday */   
  
  
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
  
end class.

/* EOF */ 
