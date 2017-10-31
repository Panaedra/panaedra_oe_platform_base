using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
class panaedra.msroot.msutil.logic.sc_abl   : 

  /****************************** Source Header ********************************\

      Description: Very generic functions for ABL behaviour

  \*****************************  Include Files ********************************/
  
  {paninui/logic/includes/preproc_dotnetclasses.i &class=class}

  /******************************* $NoKeywords:  $ *****************************/

  define public static variable bNoProcessEvents as logical no-undo.


  method public static void MicroSleep(input iMillisecondsIP# as integer):
    
    &if opsys = "unix" &then
    
    /*
       CPU friendly sleep in milliseconds for inside a do while true loopwith a process events.
     
       In AIX 5.2, reduced CPU load from 47.8% to around 2.7% with a sleep 
       of 10 ms, to around 0.8% with a sleep of 100 ms.
       So the perl script gives a bit of overhead (say 2% CPU), but we don't 
       have an external (shared object or HLC) at the moment.
       For now - as good as it gets.
     
       os-command silent 
         value("/progress/scripts/usleep.pl "
         +
         trim(string(trunc(iMillisecondsIP# / 1000.0, 0),">>9"))
         + "." + string(iMillisecondsIP# mod 1000,"999")
         + " 1> /dev/null 2> /dev/null").
    
       TW 20070807
      
    */
    
    /* TW 20110224, we have a shared object implementation now, that's much more efficient. */
    /* See http://bertnet/_DOC_/doku.php?id=dev:aix_shared_objects                           */
    sc_unix:MicroSleep(iMillisecondsIP#).
  
    &else

    /*
    
     CPU friendly sleep in milliseconds for inside a do while true loop with a process events.
     
     In WinXPSP2 Intel E6600/4GB, reduced CPU load from 50.0% (dual core!) to 0.00% with a sleep 
     of 10 ms, and also 0.00% with a sleep of 1 ms.
     
     TW 20070807
      
    */
    
    sc_win32:MicroSleep(iMillisecondsIP#). /* Also valid in win32 tty, no dotnet is used */
    
    &endif
    
  end method. /* MicroSleep */  
  
  
  method public static void ProcessEvents():

    if not bNoProcessEvents then
      process events.

  end method. /* ProcessEvents */


  method public static void ProcessEvents(oObjectIP# as Progress.Lang.Object):
    
    /* This void (!) method is for safely doing a "process events.".
    
       Can be "stalled" when the environment is in a state where process events 
       is prohibited, or ignored alltogether.

       The "process events" statement shouldn't be used directly.
       
     */
  
    ProcessEvents().
    
  end method. /* ProcessEvents */
  

end class.

/* EOF */ 
