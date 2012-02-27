using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 


class panaedra.msroot.msutil.logic.c_recordstatus: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: record status: available, locked, ambigious

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_recordstatus(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define property cTablename as character no-undo
    public get.
    protected set.
    
  define property cSvKeyValues as character no-undo
    public get.
    protected set.  

  define property bLocked as logical no-undo
    public get.
    protected set.  
    
  define property bAvailable as logical no-undo
    public get.
    protected set.  

  define property bAmbiguous as logical no-undo
    public get.
    protected set.


  constructor public c_recordstatus(
    input hBufferIP# as handle
    ):
      
    define variable cKeyvalues# as character no-undo.
    define variable iVeld#      as integer   no-undo.
    define variable cKeyfields# as character no-undo.
    define variable hField#     as handle    no-undo.
    define variable cFieldname# as character no-undo.
    
    /* build a list of fieldsnames/values of the prim.index
       and save in property cSvKeyValues */
    assign
      cKeyfields# = sc_bufferfield:getKeyfields(hBufferIP#)
      cSvKeyValues = ""
      .
     
    if hBufferIP#:available then   
    do iVeld# = 1 to num-entries(cKeyfields#) :
      assign 
      cFieldname# = entry(iVeld#, cKeyfields#)
      hField# = hBufferIP#:buffer-field(cFieldname#)
      cSvKeyValues = cSvKeyValues
        + min(cSvKeyValues, ";")
        + subst("&1=&2", cFieldname#, string(hField#:buffer-value))
        .   
    end.  
    else
      cSvKeyValues = "not available".
    
    assign   
      cTableName   = hBufferIP#:table
      bAvailable   = hBufferIP#:available
      bLocked      = hBufferIP#:locked
      bAmbiguous   = hBufferIP#:ambiguous
      .  
      
  end constructor.


end class.

/* EOF */ 
