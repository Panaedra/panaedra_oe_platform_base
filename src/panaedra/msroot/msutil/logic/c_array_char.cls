{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.c_array_char
  implements
  i_array_generic: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/c_array_char.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:11+01:00 $ 

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
  constructor public c_array_char(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 4 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  constructor public c_array_char():

  end constructor.
  
  
  destructor public c_array_char():
    
    OnDestructor().
    
  end destructor.
  
end class.

/* EOF */ 
