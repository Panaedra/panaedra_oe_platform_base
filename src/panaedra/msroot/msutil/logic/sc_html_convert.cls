using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_html_convert   : 

  /****************************** Source Header ********************************\

      Description: Convert characters to their html equivalent.
                   Uses sc_html_convert_[codepage].config, where [codepage] is the
                   session codepage.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define protected static temp-table ttHtmlConvert no-undo
    field iAscii    as int                 xml-node-type "attribute"
    field cHtmlCode as char case-sensitive xml-node-type "attribute"
    field cHtmlSafe as char case-sensitive xml-node-type "attribute"
    field cInfo     as char                xml-node-type "attribute"
    index iAscii is primary unique iAscii
    index cHtmlCode                cHtmlCode
    index cHtmlSafe                cHtmlSafe
    .
  
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


  method public static character ConvertFromHtml(cInputIP# as character):
    
    define variable cReturn# as character no-undo.
    define variable iTell#   as integer   no-undo.
    define variable cLett#   as character no-undo.
    define variable iSem#    as integer   no-undo.
    define variable cHtml#   as character no-undo.
    
    do iTell# = 1 to length(cInputIP#):
      
      cLett# = substring(cInputIP#,iTell#,1).
      
      if cLett# = "&" then 
      do:
        
        iSem# = index(cInputIP#,";", iTell# + 1).
        if iSem# > 0 and iSem# - iTell# < 20 then 
        do:
          
          /* An encoded character was found */
          cHtml# = substring(cInputIP#,iTell#,iSem# - iTell# + 1).
          
          /* Jump iTell# forward */
          iTell# = iSem#. 

          find first b-ttHtmlConvert where b-ttHtmlConvert.cHtmlCode = cHtml# no-lock no-error.

          if not avail b-ttHtmlConvert then
            find first b-ttHtmlConvert where b-ttHtmlConvert.cHtmlSafe = cHtml# no-lock no-error.

          if avail b-ttHtmlConvert then
          do:
            cLett# = chr(b-ttHtmlConvert.iAscii).
            release b-ttHtmlConvert.
          end.
          else 
            cLett# = " ".

        end. /* html coded character found */
        
      end. /* ampersand found */
      
      cReturn# = cReturn# + cLett#.
      
    end. /* walk the string */
    
    return cReturn#.
    
  end method. /* ConvertFromHtml */
  
  
  method public static character ConvertFromUrl(
    
    /* Convert URL's and URI's to a normal string */
    
    cToDecodeIP# as character):

    define variable cReturn# as character no-undo.
    
    assign
      cReturn# = cToDecodeIP#
      cReturn# = replace(cReturn#,"%20"," ")
      cReturn# = replace(cReturn#,"%22",'"')
      cReturn# = replace(cReturn#,"%23","#")
      cReturn# = replace(cReturn#,"%24","$")
      cReturn# = replace(cReturn#,"%26","&")
      cReturn# = replace(cReturn#,"%27","'")
      cReturn# = replace(cReturn#,"%25","%") /* Keep last! */
      .
      
    return cReturn#.   
  
  end method. /* ConvertFromUrl */
  
  
  method public static character ConvertToUrl(

    /* Convert a string to be used in URL's and URI's */
  
    cToEncodeIP# as character):
      
    define variable cReturn# as character no-undo.
    
    assign
      cReturn# = cToEncodeIP#
      cReturn# = replace(cReturn#,"%","%25") /* Keep first! */
      cReturn# = replace(cReturn#," ","%20")
      cReturn# = replace(cReturn#,'"',"%22")
      cReturn# = replace(cReturn#,"#","%23")
      cReturn# = replace(cReturn#,"$","%24")
      cReturn# = replace(cReturn#,"&","%26")
      cReturn# = replace(cReturn#,"'","%27")
      .
      
    return cReturn#.   

  end method. /* ConvertToUrl */


  method public static void ReloadConfigFile():
    
    define variable cFile# as character no-undo.
    
    cFile# = sc_path:cIniDir + subst("sc_html_convert_&1.config", lc(session:cpinternal)).
    
    if search(cFile#) = ? then 
    do:
      undo, throw new AppError(subst("The html conversion file '&1' could not be found.", cFile#), 99950140).  
    end.

    sc_config:ReadXml(temp-table ttHtmlConvert:handle, cFile#).
    
  end method. /* ReloadConfigFile */

end class.

/* EOF */ 
