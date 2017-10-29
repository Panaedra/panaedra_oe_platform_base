{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_string_prefixsuffix   : 

  /****************************** Source Header ********************************\

      Description: String logic for prefixes and suffixed (identified by casing 
                   or underscores).
                   
                   I.e. 
                   thisisAnExample ; "thisis" is the prefix.
                   See method comments for more examples.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method public static character GetPrefix(cCamelcaseNameIP# as character):
    
    /* tbSomeThing  -> "tb"
       _SomeThing   -> ""
       SomeThing    -> "" 
       my_SomeThing -> "my"
    */
    
    define variable iTell#   as integer   no-undo.
    define variable cLett#   as character no-undo.
    define variable cReturn# as character no-undo.
    
    do iTell# = 1 to length(cCamelcaseNameIP#):
      cLett# = substring(cCamelcaseNameIP#, iTell#, 1).
      if asc(cLett#) < asc("a") or asc(cLett#) > asc("z") then return cReturn#. 
      cReturn# = cReturn# + cLett#.
    end.
    
    return cReturn#.
    
  end method. /* GetPrefix ; simplest overload */


  method public static character GetPrefix(cCamelcaseNameIP# as character, output cRemainderOP# as character):
    
    /* tbSomeThing  -> "tb" + "SomeThing"
       _SomeThing   -> ""   + "_SomeThing"
       SomeThing    -> ""   + "SomeThing"
       my_SomeThing -> "my" + "_SomeThing"
    */

    define variable cPrefix# as character no-undo.
    define variable iLength# as integer   no-undo.
    
    assign
      cPrefix# = GetPrefix(cCamelcaseNameIP#)
      iLength# = length(cPrefix#).
    
    if iLength# > 0 then 
      assign
        cRemainderOP# = substring(cCamelcaseNameIP#, iLength# + 1).
    else 
      assign 
        cPrefix#      = ""
        cRemainderOP# = cCamelcaseNameIP#.
    
    return cPrefix#.
    
  end method. /* GetPrefix ; plus cRemainderOP# */

end class.

/* EOF */ 
