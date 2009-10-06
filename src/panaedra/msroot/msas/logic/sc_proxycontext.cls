{panaedra/msi/logic/ctop_class.i} 

class panaedra.msroot.msas.logic.sc_proxycontext : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msas/logic/sc_proxycontext.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-06 21:50:54+02:00 $ 
    Date Modified: $Modtime: 2009-10-06 17:28:21+02:00 $ 

      Description: Api-proxy functionaliteit: generieke methods die client-side (proxy)
                   worden aangeroepen.

  \*****************************  Include Files ********************************/
  
  {panaedra/msroot/msas/logic/ds/ascontext_ds.i &protected=protected &static=static &class=class}
  &undefine TtAllDefined
   
  /************************  Source control constructor ************************/
  constructor public sc_proxycontext(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable hDsContext  as handle  no-undo.
  define public static    variable bExceptions as logical no-undo.
  
  
  method public static logical BeginProxyCall(dataset dsContext /* by ref */):
    
    /* Remove previous exception messages */
    empty temp-table ttExceptions.
    empty temp-table ttCallStack.
    
    return true.
    
  end method. /* BeginProxyCall */


  method public static void ExceptionsProxyCall(oExceptionIP# as Progress.Lang.Error, dataset dsContext /* by ref */):
    
    bExceptions = true.
    
    panaedra.msex.logic.sc_exception:FillTtExceptionTtCallstack(oExceptionIP#, dataset dsContext by-reference).
    
  end method. /* ExceptionsProxyCall */


  method public static void FinallyProxyCall(dataset dsContext /* by ref */):
    
    /* If an exception has occurred, always throw a new Exception */
    if bExceptions then 
    do:
      
      find first ttExceptions no-error.
      
      if not avail ttExceptions then
        panaedra.msex.logic.sc_exception:FillTtExceptionTtCallstack(?, dataset dsContext by-reference).
      
      find first ttExceptions no-error.
      
      undo, throw (new panaedra.msex.logic.c__FCMPNY_exception(999001, subst("Api/proxy exception: &1", if not avail ttExceptions then "Unknown Exception" else ttExceptions.cError), dataset dsContext /* ->not<- by-reference */ )).
        
    end.
     
  end method. /* FinallyProxyCall */


  method public static handle GetDefaultDsContext ():
    
    if hDsContext = ? then 
    do:
      create dataset hDsContext.
    
      hDsContext:create-like(dataset dsContext:handle).
      
    end.
    
    return hDsContext.
    
  end method. /* BeginProxyCall */



end class.



/* EOF */ 
