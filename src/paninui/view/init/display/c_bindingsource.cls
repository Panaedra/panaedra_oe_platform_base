{panaedra/msi/logic/ctop_class.i}        
using Progress.Data.BindingSource.

class paninui.view.init.display.c_bindingsource inherits BindingSource : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/init/display/c_bindingsource.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-08-31 10:32:19+02:00 $ 
    Date Modified: $Modtime: 2009-08-31 10:32:19+02:00 $ 

    Description:  _CMPNY_ inheritance van de progress DataSource. 
                  Bedoeld om onvolkomenheden van de progress DataSource
                  in te vullen. Geen data access.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_bindingsource(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  constructor public c_bindingsource (  ):
    super ().
  end constructor.
        

  constructor public c_bindingsource (hQueryIP# as handle):
    super (hQueryIP#).
  end constructor.
        

  destructor public c_bindingsource ( ):
        
  end destructor.


end class. /* c-bindingsource */

/* EOF  */

