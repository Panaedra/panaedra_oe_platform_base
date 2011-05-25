{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_bufferfield: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Generic functionality for buffer-fields

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_bufferfield(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/


  method public static character IsoString(
    
    /* Get the contents of a buffer-field, in iso format (i.e. for inside xml) */
    
    hFieldIP# as handle):
    
    define variable cRepl# as character no-undo.
    
    case hFieldIP#:data-type:
      
      when "date" or
      when "datetime" or
      when "datetime-tz" then return iso-date(hFieldIP#:buffer-value).

      when "decimal" then do:
        if session:numeric-format = "european" then do:
          cRepl# = substitute("&1",hFieldIP#:buffer-value).
          cRepl# = replace(cRepl#,".",chr(4)).
          cRepl# = replace(cRepl#,",",".").
          cRepl# = replace(cRepl#,chr(4),",").
          return cRepl#.
        end.
        else return substitute("&1",hFieldIP#:buffer-value).
      end.
      
      otherwise return substitute("&1",hFieldIP#:buffer-value).
      
    end.

  end method. /* IsoString */

end class.

/* EOF */ 
