{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_eventbroadcaster
  implements
  i_help_runtime: 

  /****************************** Source Header ********************************\

      Description: Broadcasts events; 
                   loose-coupled event mechanism for session-wide events.
      
                   Can be used on windows as well as unix platforms.
      
                   Can be used by any class (just implement i_eventbroadcastclient 
                   if you want to subscribe to events; anyone can publish, even 
                   static methods and procedures).
                   
                   Preferred over ABL publish/subscribe, waiting
                   for real ABL event support (as of 10.2A02).
                   
                   For the data transmitted in the event, you can use one
                   of the following techniques:
                   1) Use FireEvent(text, text) and pass a simple string.
                   2) Use FireEvent(text, Object) and do a cast of oData on the recieving end.
                   3) Make your own i_eventbroadcastdata class, and extend it
                      to your liking. Use FireCustomEvent for firing the event.
                   
                   Suggested event name convention:
                   Prefix the eventname with "evt@" for easy grepping.
                   This convention is technically not required.
                   
                   Outside of Panaedra:
                   External platforms (like OE Eclipse boot procedures) can use 
                   sc_eventbroadcaster_loose.p.
                   Do a search for the .p or the .r, and run it if found.
                   This is a loose coupling to the whole broadcasted event mechanism,
                   and prevents syntax errors if the Panaedra platform is not present.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/
  
  define public property bHelpInstance as logical no-undo get. set. 
    
  define protected static temp-table ttEventClient no-undo rcode-information
    field oClient    as Progress.Lang.Object /* Always i_eventbroadcastclient        */
    field hProc      as handle               /* For old-style procedure handles only */
    field cEventName as character
    index cEventName_oClient is primary unique cEventName oClient
    index oClient                              oClient
    index hProc                                hProc.
 
 
  constructor static sc_eventbroadcaster():
    
  end constructor. /* Static constructor */
 
 
  method public static void SubscribeEvent(oClientIP# as i_eventbroadcastclient , cEventNameIP# as char):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    do for ttEventClient:
      create ttEventClient.
      assign 
        ttEventClient.oClient    = oClientIP#
        ttEventClient.cEventName = cEventNameIP#.
    end.
    
  end method. /* SubscribeEvent ; normal route */  
  
  
  method public static void SubscribeEvent(hProcIP# as handle , cEventNameIP# as char):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    do for ttEventClient:
      create ttEventClient.
      assign 
        ttEventClient.hProc      = hProcIP#
        ttEventClient.cEventName = cEventNameIP#.
    end.
    
  end method. /* SubscribeEvent ; by procedure handle */  
  
  
  method public static void UnSubscribeEvent(oClientIP# as i_eventbroadcastclient , cEventNameIP# as char):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    do for ttEventClient:
      
      find ttEventClient 
        where ttEventClient.oClient    = oClientIP#
        and   ttEventClient.cEventName = cEventNameIP#
        no-error.
        
      if avail ttEventClient then delete ttEventClient.
      
    end.
    
  end method. /* UnSubscribeEvent ; normal route */  


  method public static void UnSubscribeEvent(hProcIP# as handle, cEventNameIP# as char):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    do for ttEventClient:
      
      find ttEventClient 
        where ttEventClient.hProc      = hProcIP#
        and   ttEventClient.cEventName = cEventNameIP#
        no-error.
        
      if avail ttEventClient then delete ttEventClient.
      
    end.
    
  end method. /* UnSubscribeEvent ; by procedure handle */  
  
  
  method public static void UnSubscribeAllEvents(oClientIP# as i_eventbroadcastclient):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    do for ttEventClient:
      
      for each ttEventClient 
        where ttEventClient.oClient = oClientIP#
        and   ttEventClient.hProc   = ?
        on error undo, throw:
        
        delete ttEventClient.
        
      end.
      
    end.
    
  end method. /* UnSubscribeAllEvents ; normal route */  
  
  
  method public static void UnSubscribeAllEvents(hProcIP# as handle):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    if hProcIP# <> ? then
    do for ttEventClient:
      
      for each ttEventClient 
        where ttEventClient.hProc = hProcIP#
        on error undo, throw:
        
        delete ttEventClient.
        
      end.
      
    end.
    
  end method. /* UnSubscribeAllEvents ; by procedure handle */  
  
  
  method public static void FireEvent(cEventNameIP# as char):
    
    FireEventImplement(cEventNameIP#, new c_eventbroadcastdata(cEventNameIP#)).

  end method. /* FireEvent ; char */  
  
  
  method public static void FireEvent(cEventNameIP# as char, output oEventBroadcastDataOP# as i_eventbroadcastdata):
    
    oEventBroadcastDataOP# = new c_eventbroadcastdata(cEventNameIP#).
    FireEventImplement(cEventNameIP#, oEventBroadcastDataOP#).

  end method. /* FireEvent ; char + output dataobject */  
  
  
  method public static void FireEvent(cEventNameIP# as char, cEventDataIP# as char):
    
    FireEventImplement(cEventNameIP#, new c_eventbroadcastdata(cEventNameIP#, cEventDataIP#)).

  end method. /* FireEvent ; char + char */  
  
  
  method public static void FireEvent(cEventNameIP# as char, cEventDataIP# as char, output oEventBroadcastDataOP# as i_eventbroadcastdata):
    
    oEventBroadcastDataOP# = new c_eventbroadcastdata(cEventNameIP#, cEventDataIP#).
    FireEventImplement(cEventNameIP#, oEventBroadcastDataOP#).

  end method. /* FireEvent ; char + char + output dataobject */  
  
  
  method public static void FireEvent(cEventNameIP# as char, oEventDataIP# as Progress.Lang.Object):
    
    FireEventImplement(cEventNameIP#, new c_eventbroadcastdata(cEventNameIP#, oEventDataIP#)).

  end method. /* FireEvent ; char + Object */  
  

  method public static void FireEvent(cEventNameIP# as char, oEventDataIP# as Progress.Lang.Object, output oEventBroadcastDataOP# as i_eventbroadcastdata):
    
    oEventBroadcastDataOP# = new c_eventbroadcastdata(cEventNameIP#, oEventDataIP#).
    FireEventImplement(cEventNameIP#, oEventBroadcastDataOP#).

  end method. /* FireEvent ; char + Object + output dataobject */  
  

  method public static void FireEvent(cEventNameIP# as char, oEventDataIP# as Progress.Lang.Object, cEventDataIP# as char):
    
    FireEventImplement(cEventNameIP#, new c_eventbroadcastdata(cEventNameIP#, oEventDataIP#, cEventDataIP#)).

  end method. /* FireEvent ; char + Object + char */  
  

  method public static void FireEvent(cEventNameIP# as char, oEventDataIP# as Progress.Lang.Object, cEventDataIP# as char, output oEventBroadcastDataOP# as i_eventbroadcastdata):
    
    oEventBroadcastDataOP# = new c_eventbroadcastdata(cEventNameIP#, oEventDataIP#, cEventDataIP#).
    FireEventImplement(cEventNameIP#, oEventBroadcastDataOP#).

  end method. /* FireEvent ; char + Object + char + output dataobject */  
  

  method public static logical FireCustomEvent(oDataIP# as i_eventbroadcastdata):
    
    FireEventImplement(oDataIP#:cEventName, oDataIP#).

  end method. /* FireCustomEvent */  

  
  method protected static void FireEventImplement(cEventNameIP# as char, oDataIP# as i_eventbroadcastdata):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer ttEventClient for ttEventClient.
    
    do for ttEventClient:
      for each ttEventClient where ttEventClient.cEventName = cEventNameIP#
        on error undo, throw:
        if ttEventClient.hProc = ? then 
        do:
          if not valid-object(ttEventClient.oClient)then 
          do:
            delete ttEventClient.
          end.
          else 
          do:
            cast(ttEventClient.oClient, i_eventbroadcastclient):OnEventBroadcast(oDataIP#).
            if oDataIP#:iAbort > 0 then 
            do:
              return.
            end.
          end.
        end. /* hProc is not used */
        else do:
          if not valid-handle(ttEventClient.hProc) or ttEventClient.hProc:type <> "procedure" then 
          do:
            delete ttEventClient.
          end.
          else 
          do:
            run OnEventBroadcast in ttEventClient.hProc(oDataIP#).
            if oDataIP#:iAbort > 0 then 
            do:
              return.
            end.
          end.
        end. /* hProc is used */
      end.
    end.

  end method. /* FireEventImplement */  
  
  method public static void DebugShowData():

    if sc_html:TempTableToHTML(buffer ttEventClient:handle, sc_path:cTempDir + "ttBroadcastClient.html") then 
      sc_win32:ShellExecute(sc_path:cTempDir + "ttBroadcastClient.html"). /* Open file */
    
  end method. /* DebugShowData */    


  method public c_array_char GetRuntimeHelp():
    
    define variable cRuntimeHelp as c_array_char no-undo.

    cRuntimeHelp = new c_array_char().
    
    cRuntimeHelp:AddLast(
      "Item=FireEventImplement~n" +
      "Type=Method~n"             +
      "Audience=Developers~n"     +
      "Language=English~n"        +
      "Format=WpfFlowDocument~n"  +
      "[ContentStart]~n"          +
      '
<FlowDocument 
  LineHeight="5" PagePadding="5,0,5,0" AllowDrop="True" NumberSubstitution.CultureSource="User" 
  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
  xmlns:ebs="clr-namespace:EmbeddedBitmapSample;assembly=EmbeddedBitmapSample">

  <Paragraph> <Run FontWeight="Bold" FontSize="14">CD Collection Tips &amp; Tricks</Run> </Paragraph>
  
  <Paragraph><Run FontWeight="Bold" FontSize="12.5">Scrapbook editing</Run></Paragraph>
  
  <Paragraph><Run FontStyle="Italic">You can use the following keys to format selected text:</Run></Paragraph>
  
  <Paragraph>Ctrl+] : Increase font size</Paragraph>
  
  <Paragraph>Ctrl+[ : Decrease font size</Paragraph><Paragraph>Ctrl+E: Center text</Paragraph>

  <Paragraph>Ctrl+R: Right-justify</Paragraph>

  <Paragraph>Ctrl+L: Left-justify</Paragraph>

  <Paragraph>Ctrl+B: Bold</Paragraph>

  <Paragraph>Ctrl+I: Italic</Paragraph>

  <Paragraph>Ctrl+U: Underline</Paragraph>
  
  <Paragraph><Run FontStyle="Italic">You can use Ctrl+C, Ctrl+X and Ctrl+V for copy, cut and paste.</Run></Paragraph>
  
  <Paragraph><Run FontStyle="Italic">Ctrl+Z is undo of the last action.</Run></Paragraph>

  <Paragraph Margin="0,0,0,0" TextAlignment="Center" FontFamily="Tw Cen MT" FontSize="16">
    <Hyperlink NavigateUri="http://www._FCMPNY_.com/"><Span Foreground="#FF000000" xml:lang="en-us">
      <Span.TextDecorations>
      <TextDecoration Location="Underline" />
      </Span.TextDecorations>www._FCMPNY_.com</Span>
    </Hyperlink>
  </Paragraph>
  
</FlowDocument>      
      ' + "~n[ContentEnd]~n").
    
    return cRuntimeHelp.
    
  end method. /* GetRuntimeHelp */

end class.

/* EOF */
