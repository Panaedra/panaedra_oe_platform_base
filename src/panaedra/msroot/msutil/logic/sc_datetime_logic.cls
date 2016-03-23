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
{panaedra/msroot/msutil/logic/def/def_weekdays.i &class=class} 
  /************************  Source control constructor ************************/
  constructor public sc_datetime_logic(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  
  constructor protected sc_datetime_logic(
    input oParamIP# as i_unittest_param):
  end constructor.  
  /******************************* $NoKeywords:  $ *****************************/
 
 
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
