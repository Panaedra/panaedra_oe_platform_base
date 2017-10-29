using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.c_apiproxyexception inherits c_panaedraexception: 

  /****************************** Source Header ********************************\

      Description: Special exception class for api-proxy exceptions

  \*****************************  Include Files ********************************/
  
  {panaedra/msroot/msas/logic/ds/ascontext_ds.i &protected=protected &class=class}
  
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


  constructor public c_apiproxyexception ( iErrorIP# as int , cErrorIP# as char):

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


  define public property ApiproxyExceptions as character no-undo
    get():
      
      define variable cReturn#        as character no-undo.
      define variable cErrorLocation# as character no-undo.
      define variable bOk#            as logical   no-undo.
      
      define buffer b-ttExceptions for ttExceptions.
      define buffer b-ttCallstack  for ttCallstack.
      
      find first b-ttCallstack no-error.
      
      if available b-ttCallstack then
      do:
        cErrorLocation# = trim(b-ttCallStack.cCallStack).
        cErrorLocation# = replace(cErrorLocation#, chr(13) + chr(10), chr(10)).
        cErrorLocation# = entry(num-entries(cErrorLocation#, chr(10)), cErrorLocation#, chr(10)).
      end.  
            
      for each b-ttExceptions on error undo, throw:
        cReturn# = cReturn# + chr(10) + subst("&1: (&2) &3",  b-ttExceptions.iOrder, b-ttExceptions.iError, b-ttExceptions.cError ).
      end.
    
      cReturn# = substitute("&1 ~n &2", cErrorLocation#, substring(cReturn#,3)).
      
      return cReturn#.
      
    end get.
    
  
  constructor public c_apiproxyexception ( iErrorIP# as int , cErrorIP# as char, dataset dsContext append /* Note: no bind or reference here */):
    
    super (iErrorIP#, sc_lang:oEnglish, cErrorIP#). 
    
    do on error undo, throw:
    
      bUsesDataset = true.
      
      define buffer b-ttExceptions for ttExceptions.
  
      do for b-ttExceptions:
        create b-ttExceptions.
        assign 
          b-ttExceptions.iOrder = -100
          b-ttExceptions.cError = cErrorIP#.
        release b-ttExceptions.
      end.
      
      super:AddMessageSuper(ApiproxyExceptions, 99958788).
      
      catch ex as Progress.Lang.Error :
        sc_showexception:ShowException(ex).  
      end catch.
      
    
    end.

  end constructor.

  
  method public override char GetMessage(iErrorIP# as int):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer b-ttExceptions for ttExceptions.
    
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
