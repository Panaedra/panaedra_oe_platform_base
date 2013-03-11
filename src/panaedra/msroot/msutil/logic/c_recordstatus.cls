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

  define property cParamRecordFindValues as character no-undo
    public get.
    protected set.  

  define property bLocked as logical no-undo
    public get.
    public set.  
    
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

  define property cVstInfo as character no-undo
    public get.
    protected set.

  constructor public c_recordstatus(
    input hBufferIP#                as handle,
    input cParamRecordFindValuesIP# as character
    ):
      
    define variable cConnectName# as character no-undo format "x(15)".
    define variable iPid#         as integer   no-undo format ">>>>>>>>>9".
    define variable cDevice#      as character no-undo format "x(20)".  
    
    assign   
      cTableName             = hBufferIP#:table
      bAvailable             = hBufferIP#:available
      bLocked                = hBufferIP#:locked
      bAmbiguous             = hBufferIP#:ambiguous
      cParamRecordFindValues = cParamRecordFindValuesIP#
      .
    
    if hBufferIP#:locked or hBufferIP#:available /* It is possible to supply a no-lock buffer to the locked record */ then 
    do:
      if (not hBufferIP#:available) and cParamRecordFindValues > "" then 
        hBufferIP#:find-first(ParamToPrep(hBufferIP#,cParamRecordFindValues),no-lock) no-error.
      if hBufferIP#:available then 
        sc_dbrecord_info:GetLockingInfo(hBufferIP#, output cConnectName#, output iPid#, output cDevice#).
      cVstInfo = subst("ConnectName=&1~nPID=&2~nDevice=&3~nWorkstation=&5", cConnectName#, iPid#, cDevice#, sc_environment:GetWorkstationDescription(cDevice#)).
    end.        
      
  end constructor.


  method protected static character ParamToPrep(

    /* Gets values from a readable string like " [Hallo] hoi [Bla] boe ".
       Trim is automatically applied.
       Generates a dynamic find where-string.
    */

    hBufferIP# as handle,
    cParamIP#  as character):
  
    define variable cReturn#     as character no-undo init "where true".
    define variable iTell#       as integer   no-undo.
    define variable cPara#       as character no-undo.
    define variable cEntr#       as character no-undo.
    define variable cToken#      as character no-undo.
    define variable cValue#      as character no-undo.
    define variable hField#      as handle    no-undo.
    define variable iFieldEntry# as integer   no-undo.

    cPara# = cParamIP#.

    do iTell# = 1 to num-entries(cPara#,"["):
      cEntr# = entry(iTell#,cPara#,"[").
      if cEntr# = "" or num-entries(cEntr#,"]") < 2 then next.
      cToken# = trim(entry(1,cEntr#,"]")).
      cValue# = trim(entry(2,cEntr#,"]")).
      if cToken# = "@rowid" then 
      do:
        iFieldEntry# = iFieldEntry# + 1.
        if iFieldEntry# = 1 then cReturn# = "where ". 
        else cReturn# = cReturn# + " and ".
        cReturn# = cReturn# + subst("rowid(&1) = to-rowid(&2)", hBufferIP#:name, quoter(cValue#)).
      end.
      else 
      do:
        hField# = hBufferIP#:buffer-field(cToken#) no-error.
        if hField# <> ? then 
        do:
          iFieldEntry# = iFieldEntry# + 1.
          if iFieldEntry# = 1 then cReturn# = "where ". 
          else cReturn# = cReturn# + " and ".
          cReturn# = cReturn# + subst("&1 = &2", hField#:name, if lookup(hField#:data-type,"character,clob,longchar") > 0 then quoter(cValue#) else cValue#).
        end.
      end.
    end.
    
    return cReturn#.

  end method. /* ParamToPrep */


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
