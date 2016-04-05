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

  define protected static variable bVirtualDateInUse as logical no-undo init ?. 
  define protected static variable dtVirtualDate     as date    no-undo.

  define public static property dtToday as date no-undo 
    get:
      define variable cVirtualSystemDateParam# as character no-undo.
      
      if bVirtualDateInUse = ? then
      do:
        cVirtualSystemDateParam# = sc_boot:SessionParameter("VirtualSystemDate").

        bVirtualDateInUse = sc_data:HasValue(cVirtualSystemDateParam#).
        if bVirtualDateInUse then
        do on error undo, throw:
          dtVirtualDate = date(cVirtualSystemDateParam#).
          catch oError# as Progress.Lang.Error:
            sc_showexception:ShowException(oError#).
            bVirtualDateInUse = false.  /* vanaf nu niet meer proberen om foute datum te gebruiken */
          end catch.
        end.
      end.
      if bVirtualDateInUse then
        return dtVirtualDate.
      else
        return today.
    end get. 
    protected set. 

  
  define public static property dtmNow as datetime-tz no-undo 
    get:
      return now.   
    end get. 
    protected set. 
  
  
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

