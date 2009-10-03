{panaedra/msi/logic/ctop_class.i}        
using Progress.Data.BindingSource.

class paninui.view.init.display.c_bindingsource inherits BindingSource : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/init/display/c_bindingsource.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-03 22:39:49+02:00 $ 
    Date Modified: $Modtime: 2009-10-03 19:17:06+02:00 $ 

    Description:  _CMPNY_ inheritance van de progress DataSource. 
                  Bedoeld om onvolkomenheden van de progress DataSource
                  in te vullen. Geen data access.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_bindingsource(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 4 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected variable hCustomBuffer as handle    no-undo.
  define protected variable hCustomQuery  as handle    no-undo.
  define protected variable cLocalName    as character no-undo.
  
  
  constructor protected c_bindingsource():
    
    super ().
    
  end constructor.
        

  constructor protected c_bindingsource(hQueryIP# as handle):
    
    super (hQueryIP#).
    
    cLocalName = hQueryIP#:name.
    
  end constructor.

  
  constructor public c_bindingsource(oBufferOVIP# as paninui.view.init.display.i_bindingsourcetype_buffer, hBufferIP# as handle ):
    
    this-object(hBufferIP#).
    
    cLocalName = hBufferIP#:name.
    
  end constructor.      


  constructor public c_bindingsource(oQueryOVIP# as paninui.view.init.display.i_bindingsourcetype_query, hBufferOrQueryIP# as handle ):

    this-object().
    
    define variable hQuery# as handle no-undo.
    
    if hBufferOrQueryIP#:type = "buffer" then 
    do:
      create buffer hCustomBuffer for table hBufferOrQueryIP#:table-handle buffer-name hBufferOrQueryIP#:name.
      create query hCustomQuery.
      hCustomQuery:set-buffers(hCustomBuffer).
      hCustomQuery:query-prepare(subst("for each &1", hCustomBuffer:name)).
      hCustomQuery:query-open.
      hQuery# = hCustomQuery.    
    end.
    else
      hQuery# = hBufferOrQueryIP#.    
    
    this-object:handle = hQuery#.
    
    cLocalName = hBufferOrQueryIP#:name.

  end constructor.      
  
  
  method public override character ToString():
    
    define variable cReturn# as character no-undo.
    
    cReturn# = subst("&1@&2",cLocalName, super:ToString()).
    
    return cReturn#.
    
  end method.


  destructor public c_bindingsource ( ):
    
    delete object hCustomQuery  no-error.
    delete object hCustomBuffer no-error.
    
  end destructor.


end class. /* c_bindingsource */

/* EOF  */

