{panaedra/msi/logic/ctop_class.i}
class paninui.view.use.display.sc_displaydata   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/paninui/view/use/display/sc_displaydata.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-08-29 23:08:22+02:00 $ 
    Date Modified: $Modtime: 2009-08-29 23:08:22+02:00 $ 

      Description: Display data on a paninUi frame.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_displaydata(o-sourcecontrol as tool.c-sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    tool.c-sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  method public static void DisplayData (
    oFrmLogicIP# as paninui.view.interfaces.i_frmlogic
    /* en: pack id (kan in property van base frmlogic)
       en: widgettype
       en: data    (bv query)
       en: subdata (bv grid column buffer fields)
    */ 
    ):

  end method. /* DisplayData */  


end class.

/* EOF */
