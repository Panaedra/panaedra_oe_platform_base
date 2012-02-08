{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.c_apiproxyexception inherits Progress.Lang.AppError: 

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
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 10 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
 
  define public variable bUsesDataset as logical no-undo.


  constructor public c_apiproxyexception (cErrorIP# as char):

    super (cErrorIP#, 0). /* Note: The ABL string-only constructor has a bug (OE10.2A01) - it hides the GetMessage(1) ! So we use a different constructor. */
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

    super (cErrorIP#, iErrorIP#).
    bUsesDataset = false.
		
    define buffer b-ttExceptions for ttExceptions.
    
    do for b-ttExceptions:
      create b-ttExceptions.
      assign 
        b-ttExceptions.iOrder = -100
        b-ttExceptions.cError = cErrorIP#.
    end.

  end constructor.


  constructor public c_apiproxyexception ( iErrorIP# as int , cErrorIP# as char, dataset dsContext append /* Dus niet bind of reference */):
    
    super (cErrorIP#, iErrorIP#).
    bUsesDataset = true.
    
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
  
  
  method public override char GetMessage(iErrorIP# as int):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer b-ttExceptions for ttExceptions.
      
    if iErrorIP# = 1 and can-find(first b-ttExceptions) then 
    do:
      return ApiproxyExceptions.
    end.
    else 
      return super:getMessage(iErrorIP#).
      
  end method. /* GetMessage */

  
  method public void GetDsContext (oCallerIP# as panaedra.msroot.msutil.interfaces.i_apiproxyexception):
    
    /* By this callback we can use by-reference, while the dataset resides in this class
       instead of the calling class.
       We couldn't use bind, because there is no "unbind". That could mess with the GC.
    */

    oCallerIP#:CallbackDsContext (dataset dsContext by-reference).
     
  end method. /* GetDsContext */  


  method public void GetExceptionTables(output table ttExceptions, output table ttCallstack):
    
    /* No logic necessary */    

  end method.

  
end class.


/* EOF */