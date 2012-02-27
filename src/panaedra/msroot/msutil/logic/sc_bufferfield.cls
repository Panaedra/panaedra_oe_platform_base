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
  
  
  method public static character getKeyfields(
  /*--------------------------------
    return then Keyfields of a table
    based on the primairy index.  
    -------------------------------- */
   input hBufferIP# as handle 
  ):

    define variable cReturn#  as char no-undo init "".
    define variable iVeld#    as int  no-undo.
    define variable iIndex#   as int  no-undo.
    define variable cIndex#   as char no-undo init "".
    define variable bPrimary# as log  no-undo.
    define variable bUnique#  as log  no-undo.
  
    /*-- find the primairy index --*/
    zoek_index:
    do while cIndex# <> ? :
      iIndex# = iIndex# + 1.
      cIndex# = hBufferIP#:index-information(iIndex#).
  
      bUnique# = (entry(2, cIndex#) = "1") no-error.
      bPrimary# = (entry(3, cIndex#) = "1") no-error.
  
      if bUnique# and bPrimary# then
        leave zoek_index.
    end. /* do */
  
    /*- do we have prim/unique index? -*/
    if bUnique# and bPrimary# then 
    do:
      if valid-handle(hBufferIP#)  
        then 
      do iVeld# = 5 to num-entries(cIndex#) by 2 :
        cReturn# = cReturn# 
          + min(cReturn#, ",")
          + entry(iVeld#, cIndex#)
          .
      end. /* if */
    end. /* if */
    else 
      cReturn# = "".

   return cReturn#.   /* Function return value. */
  
  end method. /* getKeyfields */

end class.

/* EOF */ 
