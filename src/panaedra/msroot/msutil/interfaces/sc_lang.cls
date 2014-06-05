using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.f_root.fb.logic.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.interfaces.sc_lang: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Ovid class (Overload Identifier).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_lang(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define public static property oDutch                      as i_language_dutch   no-undo get.
  define public static property oEnglish                    as i_language_english no-undo get.
  define public static property oAny                        as i_language_any     no-undo get.
 
  
  define public static property iLanguageCodeNL     as integer no-undo
    public get () :
      return 1.
    end get.
      
  define public static property iLanguageCodeDU     as integer no-undo
    public get () :
      return 2.
    end get. 
  define public static property iLanguageCodeEN    as integer no-undo
    public get () :
      return 3.
    end get. 
  define public static property iLanguageCodeFR    as integer no-undo
    public get () :
      return 4.
    end get.
  define public static property iLanguageCodeIT    as integer no-undo
    public get () :
      return 5.
    end get.
  define public static property iLanguageCodeCZ    as integer no-undo
    public get () :
      return 6.
    end get.
  define public static property iLanguageCodeHU    as integer no-undo
    public get () :
      return 7.
    end get.
  
  
  method public static character GetLabelLanguageCode( 
    input iLanguageCodeIP# as integer, 
    input cLabelIP#        as character
    ):
      
   define variable cWaarde# as character no-undo.   
       
    case cLabelIP# :
      
      when "AFZENDERLABEL"
      then 
        do:
          case iLanguageCodeIP#:  
            when iLanguageCodeNL then
              cWaarde# =  "AFZENDER".
            when iLanguageCodeDU then
              cWaarde# = "ABSENDER".  
            when iLanguageCodeEN then
              cWaarde# = "SHIPPER". 
            when iLanguageCodeFR then
              cWaarde# = "EXPEDITEUR".
            otherwise
            cWaarde# = "SHIPPER". /* Default is altijd Engels */
          end case.
          
        end.
        
      otherwise
      undo, throw new c_panaedraexception(
        50467457,
        oDutch,
        substitute("Onbekend _TERM_UNDISCLOSED_label: '&1'", cLabelIP#)
        ).
        
    end case.
    
    return cWaarde#.
   
  end method. /* GetCorrectLabelLngCode */   
  
  
  method public static character GetLabel_TERM_UNDISCLOSED_( 
    input c_TERM_UNDISCLOSED_IP# as character,
    input cLabelIP#       as character
    ):
    
    define variable cWaarde# as character no-undo. 
       
    case cLabelIP# :
      
      when "AFZENDERLABEL"
      then 
        do:
          case c_TERM_UNDISCLOSED_IP#:
            when sc_fb_TERM_UNDISCLOSED__logic:c_TERM_UNDISCLOSED_Ita then
              cWaarde# = "MITTENTE".
            when sc_fb_TERM_UNDISCLOSED__logic:c_TERM_UNDISCLOSED_Fra then
              cWaarde# = "EXPEDITEUR".      
            when sc_fb_TERM_UNDISCLOSED__logic:c_TERM_UNDISCLOSED_Hun then
              cWaarde# = "FELADO".      
            when sc_fb_TERM_UNDISCLOSED__logic:c_TERM_UNDISCLOSED_Cze then
              cWaarde# = "ODESILATEL".
            otherwise
            cWaarde# = "SHIPPER". /* Default is altijd Engels */
          end case.
        end.
      
        
      otherwise
      undo, throw new c_panaedraexception(
        50467457,
        oDutch,
        substitute("Onbekend _TERM_UNDISCLOSED_ label: '&1'", cLabelIP#)
        ).
        
    end case.
   
   return cWaarde#.
   
  end method. /* GetCorrectLabel_TERM_UNDISCLOSED_ */ 
  
 

end class.

/* EOF */ 
