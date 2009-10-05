{panaedra/msi/logic/ctop_class.i} 

class panaedra.msroot.msas.logic.sc_proxycontext : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msas/logic/sc_proxycontext.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-05 16:10:49+02:00 $ 
    Date Modified: $Modtime: 2009-10-05 16:09:41+02:00 $ 

      Description: Api-proxy functionaliteit: generieke methods die client-side (proxy)
                   worden aangeroepen.

  \*****************************  Include Files ********************************/
  
  {panaedra/msroot/msas/logic/ds/ascontext_ds.i &protected=protected &static=static &class=class}
  &undefine TtAllDefined
   
  /************************  Source control constructor ************************/
  constructor public sc_proxycontext(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable hDsContext as handle no-undo.

  method public static logical BeginProxyCall(dataset dsContext /* by ref */):
    
    return true.
    
  end method. /* BeginProxyCall */


  method public static void ExceptionsProxyCall(oExceptionIP# as Progress.Lang.Error, dataset dsContext /* by ref */):

    if valid-object(oExceptionIP#) then    
      undo, throw oExceptionIP#.
      
  /* Alternatief _PPL_UNDISCLOSED_/TW: Doe geen throw, maar maak een nieuwe ttExceptions regel aan. Die wordt afgevangen in de finally. */  
    
  end method. /* ExceptionsProxyCall */


  method public static void FinallyProxyCall(dataset dsContext /* by ref */):
    
    /* Als error table niet leeg is, throw dan een nieuwe _FCMPNY_exception */
    if can-find(first ttExceptions) then
      undo, throw (new panaedra.msex.logic.c__FCMPNY_exception(999001, 'Proxy/api caught exception', dataset dsContext)).
     
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
