using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
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
  
  define public static property cBootPack as character no-undo init ?
    get:
      if cBootPack = ? then 
      do:
        cBootPack = SessionParameter("BootPack").
      end.
      return cBootPack.
    end.
    protected set.
    
  /******************************* Methods *************************************/
    
  constructor static sc_boot():
    
    &if opsys = "win32" &then
    
    if not sc_environment:bBatchMode then 
    do:
      assign
        session:system-alert-boxes = true
        session:appl-alert-boxes   = true.
    end.
    
    &endif
    
  end constructor.
  

  method public static char SessionParameter (cTokenIP# as char):
    
    if not can-find (first t-sesspara) then BuildTsesspara().
  
    find first t-sesspara where t-sesspara.cToken = cTokenIP# no-error.
  
    return if avail t-sesspara then t-sesspara.cValue else ?.
  
  end method. /* SessionParameter */


  method static public void _sys_BuildTsesspara ():

    if not sc_environment:IsIdeRunning() then
      undo, throw new c_panaedraexception(
        99458271,
        sc_lang:oEnglish,
        "_sys_BuildTsesspara should not be run outside of IDE"
        ).
    
    BuildTsesspara().    
        
  end method. /* _sys_BuildTsesspara */
  
   
  method static protected void BuildTsesspara ():

    define variable iTell as integer   no-undo.
    define variable cPara as character no-undo.
    define variable cEntr as character no-undo.

    empty temp-table t-sesspara.
    
    cPara = cBootSessionParameter.
       
    if cPara = "" and session:parameter matches "*[*" then
      cPara = sc_string_substitute:ExpandOsEnv(session:parameter).
    
    do iTell = 1 to num-entries(cPara,"["):
      cEntr = entry(iTell,cPara,"[").
      if cEntr = "" then next.
      create t-sesspara.
      t-sesspara.cToken = trim(entry(1,cEntr,"]")).
      t-sesspara.cValue = trim(entry(2,cEntr,"]")) no-error.
    end.

  end method. /* BuildTsesspara */
  
  
  method public static void SetBootPack(
    
    /* Set the boot pack dynamically, with the Lang.Class class.
       
       Is used from Eclipse IDE.
       
       A full path or relative path is converted to an abl 
       class name (dots).
     */
    
    cPackCfgIP# as character):
    
    define buffer b-ttSessPara for t-sesspara.
    define variable cBootPack# as character no-undo.
    
    if not can-find (first b-ttSessPara) then BuildTsesspara().
    
    find first b-ttSessPara where b-ttSessPara.cToken = "BootPack" no-error.
    
    if not avail b-ttSessPara then 
    do:
      create b-ttSessPara.
      b-ttSessPara.cToken = "BootPack".
    end.
    
    if replace(cPackCfgIP#,"~\","/") matches "*/*" then 
    do:
      cPackCfgIP# = sc_path:Full2PartialPath(cPackCfgIP#).
      cBootPack# = replace(cPackCfgIP#,"/",".").
      entry(num-entries(cBootPack#,"."),cBootPack#,".") = "".
      cBootPack# = right-trim(cBootPack#,".").
    end.
    else
      cBootPack# = cPackCfgIP#.
    
    b-ttSessPara.cValue = cBootPack#.
    
    release b-ttSessPara.
      
  end method. /* SetBootPack */
  
end class.

/* EOF */

