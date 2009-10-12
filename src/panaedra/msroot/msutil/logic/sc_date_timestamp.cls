{panaedra/msi/logic/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_date_timestamp   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_date_timestamp.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-12 11:35:56+02:00 $ 
    Date Modified: $Modtime: 2009-10-12 11:35:08+02:00 $ 

      Description: Date and time timestamp functionality

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_date_timestamp(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/


  method public static character EnglishAbvDate (dtmWhenIP# as datetime-tz):
    
    /* Overload for easy acces date version below */
    
    return EnglishAbvDate(date(dtmWhenIP#)).
    
  end method. /* EnglishAbvDate; datetime-tz */


  method public static character EnglishAbvDate (dtWhenIP# as date):
    
    /* Returns a string like "6 Oct 2010". 
       Format is protected for i.e. E-mail headers, so don't change the format. 
    */
    
    return dynamic-function("englishAbvDate", date(dtWhenIP#)).
    
  end method. /* EnglishAbvDate; date */


end class.

/* EOF */ 
