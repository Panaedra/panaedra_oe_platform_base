{panaedra/msroot/msutil/logic/top_i/ctop_class.i}

class panaedra.msroot.msutil.logic.sc_boot:

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_boot.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:39:42+01:00 $ 

      Description: Algemene sessie opstart functionaliteit.
                   Class implementatie van boot.p  

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_boot(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 4 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define static temp-table t-sesspara no-undo
    field cToken as char
    field cValue as char
    index cToken is primary unique cToken.
  
  define public static variable cBootSessionParameter as character no-undo.
    
  /******************************* Methods *************************************/
    
  method public static char SessionParameter (cTokenIP# as char):
    
    if not can-find (first t-sesspara) then buildTsesspara().
  
    find first t-sesspara where t-sesspara.cToken = cTokenIP# no-error.
  
    return if avail t-sesspara then t-sesspara.cValue else ?.
  
  end method.
   
   
  method static private void buildTsesspara ():

    define variable iTell as integer   no-undo.
    define variable cPara as character no-undo.
    define variable cEntr as character no-undo.

    empty temp-table t-sesspara.

    cPara = cBootSessionParameter.
       
    if cPara = "" and session:parameter matches "*[*" then
      cPara = session:parameter.
    
    do iTell = 1 to num-entries(cPara,"["):
      cEntr = entry(iTell,cPara,"[").
      if cEntr = "" then next.
      create t-sesspara.
      t-sesspara.cToken = trim(entry(1,cEntr,"]")).
      t-sesspara.cValue = trim(entry(2,cEntr,"]")) no-error.
    end.

  end method.
  
  
end class.

/* EOF */

