{panaedra/msi/logic/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_html: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_html.cls $ 
          Version: $Revision: 4 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-13 11:22:14+02:00 $ 
    Date Modified: $Modtime: 2009-10-13 11:16:39+02:00 $ 

      Description: Genereren van HTML code, bv voor reporting.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_html(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 4 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  method public static logical TempTableToHTML (input hBuffIP# as handle, input cFileTargetIP# as character):
    
    return TempTableToHTML(hBuffIP#, ?, cFileTargetIP#).
    
  end method.

  method public static logical TempTableToHTML (input hBuffIP# as handle, input hQueryIP# as handle, input cFileTargetIP# as character):
    
    define variable iField# as integer no-undo.
    
    /* main */
    do on error undo, throw:
      
      if not valid-handle(hQueryIP#) then 
      do:
        create query hQueryIP#.
        hQueryIP#:set-buffers(hBuffIP#).
        hQueryIP#:query-prepare(subst("for each &1 no-lock", hBuffIP#:name)).
        hQueryIP#:query-open().
        hQueryIP#:get-first().
      end.
      
      /* Open bestand */
      output to value(cFileTargetIP#).
      
      /* Open html file */
      put unformatted '<html><body><table border= "0">~n'.

      put unformatted '<tr>'.
      do iField# = 1 to hBuffIP#:num-fields:
        put unformatted '<td bgcolor="lightgrey">' hBuffIP#:buffer-field(iField#):name '</td>'.
      end.
      put unformatted "</tr>~n".
        
      /* Loop door de temp-table */  
      do while not hQueryIP#:query-off-end:
        
                
        /* Zet dit record om in data voor html */        
        RecordToHTMLLine(hBuffIP#).
        
        hQueryIP#:get-next().
      end.         
      
      /* Sluit html file */  
      put unformatted "</table></body></html>~n".
      
    end.
    
    /* Foutfhandeling */
    catch e as Progress.Lang.Error :
      panaedra.msex.logic.sc_showexception:ShowException(e).
      return false.  		
    end catch.
    
    finally:
      output close.
      return true.   		
    end finally.
    
  end method. /* TempTableToHTML */
  
  method protected static char FormatBufferValue(hFieldIP# as handle):
    /* Neem het goede format aan voor het inkomende veld */
    define variable cFormat# as character no-undo.
    
    cFormat# = hFieldIP#:format.
    
    if cFormat# > "" then 
      return string(hFieldIP#:buffer-value,cFormat#).
    else 
      return hFieldIP#:buffer-value.
      
  end method. /* FormatBufferValue */
  
  
  method protected static void RecordToHTMLLine (hBuffIP# as handle):
    
    define variable iField#       as integer   no-undo.
    define variable hField#       as handle    no-undo.
    define variable cLine#        as character no-undo.
    define variable cBgColor#     as character no-undo.
    
    define variable cBGColorParm# as character no-undo.
    define variable bHandled#     as logical   no-undo.

    put unformatted '<tr>'.
    
    do iField# = 1 to hBuffIP#:num-fields:
      
      assign
        bHandled# = false
        hField#   = hBuffIP#:buffer-field(iField#).
      
      /* Zet de waarde van het huidige veld om in html geschikte text en zet dit
         in het goede format */
      if not bHandled# and hField#:data-type = "character" then 
        assign
          bHandled# = true
          cLine#    = hField#:buffer-value.
          
      if not bHandled# and hField#:data-type = "Progress.Lang.Object" then
        assign
          bHandled# = true
          cLine#    = ( if not valid-object(cast(hField#:buffer-value,Progress.Lang.Object)) 
                        then "no-object" 
                        else string(hField#:buffer-value)).
         
      if not bHandled# and hField#:data-type begins "datetime"  then
        assign
          bHandled# = true
          cLine#    = string(hField#:buffer-value,"99-99-9999 hh:mm:ss.sss").
          
      if not bHandled# and hField#:data-type = "int64"  then
        assign
          bHandled# = true
          cLine#    = trim(string(hField#:buffer-value,"->>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>9")).
          
      if not bHandled# then
        assign
          bHandled# = true
          cLine#    = FormatBufferValue(hField#). 
      
      assign
        cLine# = replace(cLine#, "~n", "<br/>~n")
        /* Keep first */
        cLine# = replace(cLine#, "~& ", "~&amp; ")
        cLine# = replace(cLine#, " ~&", " ~&amp;")
        /* Then the rest */
        cLine# = replace(cLine#, "'", "~&#39;")
        cLine# = replace(cLine#, '"', "~&quot;")
        cLine# = replace(cLine#, "<", "~&lt;")
        cLine# = replace(cLine#, ">", "~&gt;")
        .
      
      cBGColorParm# = panaedra.msroot.msutil.logic.sc_string_csv:getparam(hBuffIP#:buffer-field(iField#):help, "HtmlBackColor"). 
       
      /* Handel de achtergrond kleuren per veld af */ 
      case cBGColorParm#:
         
        when "green" then 
          cBgColor# = "#00FF00".
        
        when "red" then
          cBgColor# = "#FF0000".
        
        when "yellow" then
          cBgColor# = "#FFFF00".
          
        otherwise 
        do:
          if cBGColorParm# begins "#" then cBgColor# = cBGColorParm#. 
          else cBgColor# = "#FFFFFF".
        end.
          
      end case.  
      
      /* Plaats de regel */
      put unformatted '<td bgcolor="' cBgColor# '">' cLine# '</td>'.
    end.  
    
    put unformatted "</tr>~n".
    
  end method. /* RecordToHTMLline */  
  


end class.


/* EOF */ 
