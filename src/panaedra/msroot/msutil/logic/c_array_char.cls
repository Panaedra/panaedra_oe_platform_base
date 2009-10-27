{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.c_array_char   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/c_array_char.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-27 04:58:36+01:00 $ 
    Date Modified: $Modtime: 2009-10-27 04:58:17+01:00 $ 

      Description: This class makes a variable sized array of strings, wrapping
                   the variable extent functionality of ABL.
                   
                   You can ask for any extent index, it will return "" when not
                   existent.
                   
                   You can set any extent index, it will resize (in blocks of 
                   -a multitude of- 25) when needed, automatically.
                   
  \*****************************  Include Files ********************************/
  {panaedra/msroot/msutil/logic/c_array_generic.i 
    &ClassType=c_array_char 
    &VarPre=c 
    &VarType=character 
    &VarNull="''"}

  /************************  Source control constructor ************************/
  constructor public c_array_char(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  constructor public c_array_char():

  end constructor.
  
  
  destructor public c_array_char():
    
    OnDestructor().
    
  end destructor.
  
end class.

/* EOF */ 
