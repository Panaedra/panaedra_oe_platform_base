using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.c_apiproxyexception inherits c_panaedraexception: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/c_apiproxyexception.cls $ 
          Version: $Revision: 10 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:35:56+01:00 $ 

      Description: Special exception class for api-proxy exceptions

  \*****************************  Include Files ********************************/
  
{panaedra/msroot/msas/logic/ds/ascontext_ds.i &protected=protected &class=class}
  
  /************************  Source control constructor ************************/
  constructor public c_apiproxyexception(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    super(o-sourcecontrol, this-object).
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 10 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
 
  define public variable bUsesDataset as logical no-undo.


  constructor public c_apiproxyexception (cErrorIP# as char):
  
    super (99959890, sc_lang:oEnglish, cErrorIP#). 
    
    bUsesDataset = false.

    define buffer b-ttExceptions for ttExceptions.
    
    do for b-ttExceptions:
      create b-ttExceptions.
      assign 
        b-ttExceptions.iOrder = -100
        b-ttExceptions.cError = cErrorIP#.
    end.

  end constructor.


  constructor public c_apiproxyexception (iErrorIP# as int , cErrorIP# as char):

    super (iErrorIP#, sc_lang:oEnglish, cErrorIP#). 
    
    bUsesDataset = false.

    define buffer b-ttExceptions for ttExceptions.
    
    do for b-ttExceptions:
      create b-ttExceptions.
      assign 
        b-ttExceptions.iOrder = -100
        b-ttExceptions.cError = cErrorIP#.
    end.

  end constructor.

  
  method public override char GetMessage(iErrorIP# as int):

    return super:GetMessage(iErrorIP#).
      
  end method. /* GetMessage */

  
  method public void GetDsContext (oCallerIP# as panaedra.msroot.msutil.interfaces.i_apiproxyexception):
    
    /* By this callback we can use by-reference, while the dataset resides in this class
       instead of the calling class.
       We couldn't use bind, because there is no "unbind". That could mess with the GC.
    */

    oCallerIP#:CallbackDsContext (dataset dsContext by-reference).
     
  end method. /* GetDsContext */  


  method public handle GetDsContextHandle():
    return dataset dsContext:handle.
  end method. /* GetDsContextHandle */
  
  
  method public void GetExceptionTables(output table ttExceptions, output table ttCallstack):
    
    /* No logic necessary */    

  end method.

  
end class.


/* EOF */
