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

  define property bUpdated as logical no-undo
    public get.
    public set.

  define property bCreated as logical no-undo
    public get.
    public set.

  define property bChangedByAnotherUser as logical no-undo
    public get.
    public set.

  define property cSvFieldsChanged as character no-undo
    public get.
    public set.

  define property cSvFieldsDirtyReadValue as character no-undo
    public get.
    public set.

  define property cSvFieldsEditValue as character no-undo
    public get.
    public set.

  define property cSvFieldsUpdatedValue as character no-undo
    public get.
    public set.

  define property cSeperatorCsv as character no-undo
    public get.
    protected set.

  constructor public c_recordstatus(
    input hBufferIP# as handle,
    input cSvKeyvaluesIP# as character
    ):
    
    assign   
      cTableName    = hBufferIP#:table
      bAvailable    = hBufferIP#:available
      bLocked       = hBufferIP#:locked
      bAmbiguous    = hBufferIP#:ambiguous
      cSvKeyvalues  = cSvKeyvaluesIP#
      cSeperatorCsv = "|"
      .  
      
  end constructor.


  constructor public c_recordstatus(
    input hBufferIP# as handle
    ):
      
    /* build a list of fieldsnames/values of the prim.index
       and save in property cSvKeyValues */
    
    assign   
      cSvKeyValues  = sc_bufferfield:getKeyfieldValues(hBufferIP#, ";")
      cTableName    = hBufferIP#:table
      bAvailable    = hBufferIP#:available
      bLocked       = hBufferIP#:locked
      bAmbiguous    = hBufferIP#:ambiguous
      cSeperatorCsv = "|"
      .  
      
  end constructor.


end class.

/* EOF */ 
