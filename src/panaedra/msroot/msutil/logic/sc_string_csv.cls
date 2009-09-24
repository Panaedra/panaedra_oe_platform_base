{panaedra/msi/logic/ctop_class.i} 


class panaedra.msroot.msutil.logic.sc_string_csv: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_string_csv.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-24 16:51:54+02:00 $ 
    Date Modified: $Modtime: 2009-09-24 16:50:18+02:00 $ 

      Description: Class implementatie van de csvlib.
                   Bevat (C)omma (S)eparated (V)alue gerelateerde functionaliteit
                   (comma moet je breed zien).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_string_csv(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/




  method public static char GetParam
    (cParamIP# as char, cTokenIP# as char):
  
    /* Haalt waardes uit een goed te lezen string als " [Hallo] hoi [Bla] boe ".
       Trim vindt automatisch plaats.
       Dit formaat wordt ook bij session:parameter (de -param bij opstarten) gebruikt.
    */
  
    define variable iTell as integer   no-undo.
    define variable cPara as character no-undo.
    define variable cEntr as character no-undo.

    cPara = cParamIP#.

    do iTell = 1 to num-entries(cPara,"["):
      cEntr = entry(iTell,cPara,"[").
      if cEntr = "" then next.
      if cTokenIP# = trim(entry(1,cEntr,"]")) then
        return trim(entry(2,cEntr,"]")).
    end.
  
    return "".

  end method. /* GetParam */


end class. 

/* EOF */


