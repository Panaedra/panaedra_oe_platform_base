{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_abl   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_abl.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-02-17 11:04:10+01:00 $ 
    Date Modified: $Modtime: 2010-02-17 11:01:29+01:00 $ 

      Description: Very generic functions for ABL behaviour

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_abl(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define public static variable iMinInt as integer no-undo init -2147483648.
  define public static variable iMaxInt as integer no-undo init 2147483647.

end class.

/* EOF */ 
