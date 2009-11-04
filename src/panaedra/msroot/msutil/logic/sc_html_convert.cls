{panaedra/msi/logic/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_html_convert   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_html_convert.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-11-04 10:00:44+01:00 $ 
    Date Modified: $Modtime: 2009-11-04 09:54:17+01:00 $ 

      Description: Convert characters to their html equivalent.
                   Uses sc_html_convert_[codepage].config, where [codepage] is the
                   session codepage.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_html_convert(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define protected static temp-table ttHtmlConvert no-undo
    field iAscii    as int  xml-node-type "attribute"
    field cHtmlCode as char xml-node-type "attribute"
    field cHtmlSafe as char xml-node-type "attribute"
    field cInfo     as char xml-node-type "attribute"
    index iAscii is primary unique iAscii.
  
  define protected static buffer b-ttHtmlConvert for ttHtmlConvert.
  
  
  constructor static sc_html_convert():
    
    ReloadConfigFile().
    
  end constructor.
  

  method public static character ConvertToHtml(cInputIP# as character, cModeIP# as character):
    
    define variable cReturn# as character no-undo.
    define variable iTell#   as integer   no-undo.
    define variable iAscii#  as integer   no-undo.
    define variable cLett#   as character no-undo.
    
    ReloadConfigFile().
    
    do iTell# = 1 to length(cInputIP#):
      cLett# = substring(cInputIP#,iTell#,1).
      iAscii# = asc(cLett#).
      
      find first b-ttHtmlConvert where b-ttHtmlConvert.iAscii = iAscii# no-lock no-error.
      
      if avail b-ttHtmlConvert then 
      do:
        
        case cModeIP#:
          
          when "" then 
              cLett# = if b-ttHtmlConvert.cHtmlCode > "" then b-ttHtmlConvert.cHtmlCode else b-ttHtmlConvert.cHtmlSafe.
          when "Safe" then 
              cLett# = if b-ttHtmlConvert.cHtmlSafe > "" then b-ttHtmlConvert.cHtmlSafe else b-ttHtmlConvert.cHtmlCode.
          when "OnlySafe" then 
              cLett# = b-ttHtmlConvert.cHtmlSafe.
              
        end case.
        
        release b-ttHtmlConvert.
         
      end.
      
      cReturn# = cReturn# + cLett#.
      
    end.
    
    return cReturn#.
    
  end method. /* ConvertToHtml */


  method public static void ReloadConfigFile():
    
    define variable cFile# as character no-undo.
    
    cFile# = panaedra.msf.logic.sc_path:cIniDir + subst("sc_html_convert_&1.config",session:cpinternal).
    
    if search(cFile#) = ? then 
    do:
      undo, throw new AppError(subst("The html conversion file '&1' could not be found.", cFile#), 99950140).  
    end.

    temp-table ttHtmlConvert:read-xml("file",cFile#,"empty",?,?).
    
  end method. /* ReloadConfigFile */


end class.

/* EOF */ 
