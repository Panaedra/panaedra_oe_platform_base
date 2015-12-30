using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
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
      when "datetime-tz" then 
        return iso-date(hFieldIP#:buffer-value).

      when "decimal" then 
        do:
          if session:numeric-format = "european" then 
          do:
            cRepl# = substitute("&1",hFieldIP#:buffer-value).
            cRepl# = replace(cRepl#,".",chr(4)).
            cRepl# = replace(cRepl#,",",".").
            cRepl# = replace(cRepl#,chr(4),",").
            return cRepl#.
          end.
          else return substitute("&1",hFieldIP#:buffer-value).
        end.
      
      otherwise 
      return substitute("&1",hFieldIP#:buffer-value).
      
    end.

  end method. /* IsoString */
  
  
  method public static character getKeyfields(
    /*--------------------------------
      return the Keyfields of a table.
      -------------------------------- */
    input hBufferIP# as handle 
    ):

    define variable cReturn#  as char no-undo init "".
    define variable iVeld#    as int  no-undo.
    define variable iIndex#   as int  no-undo.
    define variable cIndex#   as char no-undo init "".
    define variable bPrimary# as log  no-undo.
    define variable bUnique#  as log  no-undo.
  
    /*-- find the unique index --*/
    zoek_index:
    do while cIndex# <> ? :
      iIndex# = iIndex# + 1.
      cIndex# = hBufferIP#:index-information(iIndex#).
  
      bUnique# = (entry(2, cIndex#) = "1") no-error.
      bPrimary# = (entry(3, cIndex#) = "1") no-error.
  
      if bUnique# then
        leave zoek_index.
    end. /* do */
  
    /*- do we have prim/unique index? -*/
    if bUnique# then 
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


  method public static character GetFieldnames(
  
    /* Return a list of field-names from a buffer */
    
    input hBufferIP# as handle):

    return GetFieldnames(hBufferIP#, ",").
  
  end method. /* GetFieldnames ; simple overload with ',' (comma) as delimiter */
  
  
  method public static character GetFieldnames(
  
    /* Return a list of field-names from a buffer */
    
    input hBufferIP#    as handle,
    input cDelimiterIP# as character):

    define variable iIndex#        as int       no-undo.
    define variable hField#        as handle    no-undo.
    define variable cSvFieldnames# as character no-undo.
    
    do iIndex# = 1 to hBufferIP#:num-fields:
      assign
        hField#        = hBufferIP#:buffer-field(iIndex#)
        cSvFieldnames# = cSvFieldnames# + cDelimiterIP# + trim(substitute("&1", hField#:name)).
    end.
    
    cSvFieldnames# = trim(cSvFieldnames#, cDelimiterIP#).

    return cSvFieldnames#.    
  
  end method. /* GetFieldnames */
  

  method public static character GetKeyFieldValues(
    input hBufferIP# as handle,
    input cSeparatorCharIP# as character
    ):
    
    return GetKeyFieldValues(hBufferIP#,"",cSeparatorCharIP#).
      
  end method. /* GetKeyFieldValues */
  
      
  method public static character GetKeyFieldValues(
    input hBufferIP# as handle,
    input cSvKeyValuesIP# as character,
    input cSeparatorCharIP# as character
    ):
      
    define variable cKeyfields#   as character no-undo.
    define variable cSvKeyValues# as character no-undo.  
    define variable iField#       as integer   no-undo.
    define variable hField#       as handle    no-undo.
    define variable cFieldname#   as character no-undo.
    
    if cSvKeyValuesIP# > "" then  
      cKeyfields# = cSvKeyValuesIP#.
    else
      cKeyfields# = getKeyfields(hBufferIP#).
     
    if hBufferIP#:available then   
    do iField# = 1 to num-entries(cKeyfields#) :
      assign 
        cFieldname#   = entry(iField#, cKeyfields#)
        hField#       = hBufferIP#:buffer-field(cFieldname#)
        cSvKeyValues# = cSvKeyValues#
        + min(cSvKeyValues#, cSeparatorCharIP#)
        + subst("&1=&2", cFieldname#, string(hField#:buffer-value))
        .   
    end.  
    else
      cSvKeyValues# = "not available".
      
    return cSvKeyValues#.     
  
  end method. /* GetKeyFieldValues */
  
  
  method public static handle GetQueryBufferField(
    input hQueryIP#     as handle,
    input cTableIP#     as character,
    input cFieldnameIP# as character
    ):
  
    define variable iBuffer# as integer no-undo.
    define variable hBuffer# as handle  no-undo.
    define variable hField#  as handle  no-undo.
    
    bZoekBuffer:
    do iBuffer# = 1 to hQueryIP#:num-buffers :
      hBuffer# = hQueryIP#:get-buffer-handle(iBuffer#).
      
      if hBuffer#:table = cTableIP# then
      do:
        hField# = hBuffer#:buffer-field(cFieldnameIP#).
        leave bZoekBuffer.
      end.
    end.
    
    return hField#.
  
  end method. /* GetQueryBufferField */
  
  
  method public static void SetBufferValue(
    input hBufferIP# as handle,
    input cFieldnameIP# as character,
    input cValueIP# as character
    ):
      
    define variable hField# as handle no-undo.  
      
    if hBufferIP#:available then
    do:
      hField# = hBufferIP#:buffer-field(cFieldnameIP#).
      
      case hField#:data-type:
        when "integer" then
          hField#:buffer-value = integer(cValueIP#).
        when "decimal" then
          hField#:buffer-value = decimal(cValueIP#).
        when "date" then
          hField#:buffer-value = date(cValueIP#).
        when "character" then
          hField#:buffer-value = string(cValueIP#).
        
        otherwise
        undo, throw new c_panaedraexception(
          99950104,
          sc_lang:oEnglish,
          substitute("Datatype '&1' not implemented (yet).", hField#:data-type)
          ).
      end case.
      
    end.  
  
  end method. /* SetBufferValue */

end class.

/* EOF */ 
