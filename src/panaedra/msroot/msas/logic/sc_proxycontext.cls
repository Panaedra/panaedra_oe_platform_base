{panaedra/msi/logic/ctop_class.i} 

class panaedra.msroot.msas.logic.sc_proxycontext : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msas/logic/sc_proxycontext.cls $ 
          Version: $Revision: 5 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-07 09:23:37+02:00 $ 
    Date Modified: $Modtime: 2009-10-07 09:09:42+02:00 $ 

      Description: Api-proxy functionaliteit: generieke methods die client-side (proxy)
                   worden aangeroepen.

  \*****************************  Include Files ********************************/
  
  {panaedra/msroot/msas/logic/ds/ascontext_ds.i &protected=protected &static=static &class=class}
  &undefine TtAllDefined
   
  /************************  Source control constructor ************************/
  constructor public sc_proxycontext(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 5 $', '{&sourcecontrolversions}').
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
    
    define variable bEclipseFix# as logical no-undo.
    define buffer b-ttExceptions for ttExceptions.
    
    /* If an exception has occurred locally (bExceptions) or on an AppServer (b-ttExceptions), 
       always throw a new Exception */
    if bExceptions or can-find(first b-ttExceptions) then 
    do:
      
      find first b-ttExceptions no-error.
      
      if not avail b-ttExceptions then
        panaedra.msex.logic.sc_exception:FillTtExceptionTtCallstack(?, dataset dsContext by-reference).
      
      find first b-ttExceptions no-error.
      
      undo, throw (new panaedra.msex.logic.c__FCMPNY_exception(99909002, 
        subst("Api/proxy exception&1 for: '&2' -> '&3'",
        if not avail b-ttExceptions then "" else " '" + b-ttExceptions.cError + "'",
        program-name(4), program-name(3)), 
        dataset dsContext /* ->not<- by-reference */ )).
        
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
