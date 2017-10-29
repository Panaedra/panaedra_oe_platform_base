{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.c_array_char
  implements
  i_array_generic: 

  /****************************** Source Header ********************************\

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

  /******************************* $NoKeywords:  $ *****************************/

  constructor public c_array_char():

  end constructor.
  
  
  destructor public c_array_char():
    
    OnDestructor().
    
  end destructor.
  
end class.

/* EOF */ 
