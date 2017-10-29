using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_html: 

  /****************************** Source Header ********************************\

      Description: Generate HTML code

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/


  method public static logical TempTableToHTML (input hBuffIP# as handle, input cFileTargetIP# as character):
    
    return TempTableToHTML(hBuffIP#, ?, cFileTargetIP#).
    
  end method. /* TempTableToHTML : simple overload */
  

  method public static logical TempTableToHTML (input hBuffIP# as handle, input hQueryIP# as handle, input cFileTargetIP# as character):
    
    define variable iField#    as integer no-undo.
    define variable bOwnQuery# as logical no-undo.
    
    /* main */
    do on error undo, throw:
      
      if not valid-handle(hQueryIP#) then 
      do:
        bOwnQuery# = true.
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
        
      do while not hQueryIP#:query-off-end:
        RecordToHTMLLine(hBuffIP#).
        hQueryIP#:get-next().
      end.         
      
      /* Close html file */  
      put unformatted "</table></body></html>~n".
      
    end.
    
    return true.
    
    catch e as Progress.Lang.Error :
      panaedra.msroot.msutil.logic.sc_showexception:ShowException(e).
    end catch.
    
    finally:
      output close.
      if bOwnQuery# and valid-handle(hQueryIP#) then delete object hQueryIP#.     
    end finally.
    
  end method. /* TempTableToHTML : optional query as input for filtering */
  
  
  method protected static char FormatBufferValue(hFieldIP# as handle):
    /* Handle string format for field widgets */
    define variable cFormat# as character no-undo.
    
    cFormat# = hFieldIP#:format.
    
    if cFormat# > "" then 
      return string(hFieldIP#:buffer-value,cFormat#).
    else 
      return hFieldIP#:buffer-value.
    
    catch ex as Progress.Lang.Error :
      
      do on error undo, throw:
      
        if valid-handle(hFieldIP#) and hFieldIP#:buffer-handle:available then
          /* Return the value with no formatting applied */
          return hFieldIP#:buffer-value.
        
        else sc_showexception:ShowException(ex).
        
        catch ex2 as Progress.Lang.Error :
          sc_showexception:ShowException(ex2).
        end catch.  
      
      end.
        
    end catch.  
      
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
        /* Keep first */
        cLine# = replace(cLine#, "~& ", "~&amp; ")
        cLine# = replace(cLine#, " ~&", " ~&amp;")
        cLine# = replace(cLine#, "< ", "~&lt; ")
        cLine# = replace(cLine#, " <", " ~&lt;")
        cLine# = replace(cLine#, "> ", "~&gt; ")
        cLine# = replace(cLine#, " >", " ~&gt;")
        /* Then the rest */
        cLine# = replace(cLine#, "'", "~&#39;")
        cLine# = replace(cLine#, '"', "~&quot;")
        
        cLine# = replace(cLine#, "~n", "<br/>~n")
        .
      
      cBGColorParm# = panaedra.msroot.msutil.logic.sc_string_csv:getparam(hBuffIP#:buffer-field(iField#):help, "HtmlBackColor"). 
       
      /* Handle background colors for field widgets */ 
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
      
      put unformatted '<td bgcolor="' cBgColor# '">' cLine# '</td>'.
      
    end.  
    
    put unformatted "</tr>~n".
    
  end method. /* RecordToHTMLline */  

end class.

/* EOF */ 
