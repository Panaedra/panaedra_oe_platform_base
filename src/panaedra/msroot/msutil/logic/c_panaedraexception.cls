using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.c_panaedraexception
  inherits
  Progress.Lang.AppError: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Lightweight exception, normal AppError but support for language indicator.
      
                   Example:
                     
                   undo, throw new c_panaedraexception(12345678, sc_lang:oEnglish, "Something went wrong").   

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_panaedraexception(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  /* The temp-table b-ttExceptionLine is built in to work around a progress bug in (at least) oe11.0 and earlier.
     super:GetMessage(1) gives a weird incompatible datatype error, when called from an inherited exception like c_apiproxyexception 
  */
  
  define protected temp-table ttExceptionLine no-undo
    field iIndex as integer
    field cError as character
    field iError as integer
    index iIndex is primary unique iIndex
    .
    
  define protected variable iLastIndex as integer no-undo.

  define property oRecordStatus as c_recordstatus no-undo
    public get.
    protected set.
  
  define property cLang as character no-undo 
    public    get.
    protected set.

  define property oLog as i_log no-undo 
    public    get.
    protected set.

  define property oInnerException as Progress.Lang.Error no-undo 
    public    get.
    public    set.

  define property cCategoryEvent as character no-undo 
    public    get.
    public    set.


  define property cCategoryEventID as character no-undo 
    public    get.
    public    set.

  constructor public c_panaedraexception(
    iErrorIP# as integer, 
    oDutchIP# as i_language_dutch,
    cErrorIP# as character):
    
    /* Note: 11.0A progress bug: 
       in inheriting classes like c_apiproxyexception, the super with parameters does not work.
       Splitting in two statements works around this issue. 
       */    
    super().
    this-object:AddMessage(cErrorIP#, iErrorIP#).
    _sys_AddMessage(iErrorIP#,cErrorIP#).
    
    cLang = "Dutch":u.
    
  end constructor.


  constructor public c_panaedraexception(
    iErrorIP# as integer, 
    oEnglishIP# as i_language_english,
    cErrorIP# as character):
    
    /* Note: 11.0A progress bug: 
       in inheriting classes like c_apiproxyexception, the super with parameters does not work.
       Splitting in two statements works around this issue. 
       */    
    super().
    this-object:AddMessage(cErrorIP#, iErrorIP#).
    _sys_AddMessage(iErrorIP#,cErrorIP#).
    
    &if false &then    
    message cErrorIP# "added to c_panaedraexception" "with number" iErrorIP# skip
      this-object:NumMessages
      view-as alert-box.
    &endif
    
    cLang = "English":u.
    
    catch ex as Progress.Lang.Error :
      sc_showexception:ShowException(ex).	
    end catch.
    
  end constructor.


  constructor public c_panaedraexception(
    iErrorIP#          as integer, 
    oInnerExceptionIP# as Progress.Lang.Error,
    cCategoryEventIP#  as character,
    oDutchIP#          as i_language_dutch,
    cErrorMsgIP#       as character):
    
    /* Note: 11.0A progress bug: 
       in inheriting classes like c_apiproxyexception, the super with parameters does not work.
       Splitting in two statements works around this issue. 
       */    
    super().
    this-object:AddMessage(cErrorMsgIP#, iErrorIP#).
    _sys_AddMessage(iErrorIP#,cErrorMsgIP#).
    
    assign
      oInnerException = oInnerExceptionIP#
      cCategoryEvent  = cCategoryEventIP#
      cLang           = "Dutch":u.
    
  end constructor. /* Language with innerexception */


  constructor public c_panaedraexception(
    iErrorIP#          as integer,
    oInnerExceptionIP# as Progress.Lang.Error,
    cCategoryEventIP#  as character,
    oEnglishIP#        as i_language_english,
    cErrorMsgIP#       as character
    ):
    
    /* Note: 11.0A progress bug: 
       in inheriting classes like c_apiproxyexception, the super with parameters does not work.
       Splitting in two statements works around this issue. 
       */    
    super().
    this-object:AddMessage(cErrorMsgIP#, iErrorIP#).
    _sys_AddMessage(iErrorIP#,cErrorMsgIP#).
    
    assign
      oInnerException = oInnerExceptionIP#
      cCategoryEvent  = cCategoryEventIP#
      cLang           = "English":u.
    
    catch oError# as Progress.Lang.Error :
      sc_showexception:ShowException(oError#).	
    end catch.
    
  end constructor. /* Language with innerexception */


  constructor public c_panaedraexception(
    iErrorIP# as integer, 
    oDutchIP# as i_language_dutch,
    cErrorIP# as character,
    oLogIP# as i_log
    ):
    
    super().

    this-object:AddMessage(cErrorIP#, iErrorIP#).
    _sys_AddMessage(iErrorIP#,cErrorIP#).
    
    assign
      this-object:oLog = oLogIP#
      cLang            = "Dutch":u.
    
  end constructor.


  constructor public c_panaedraexception(
    iErrorIP# as integer, 
    oEnglishIP# as i_language_english,
    cErrorIP# as character,
    oLogIP# as i_log
    ):
    
    super().
    
    this-object:AddMessage(cErrorIP#, iErrorIP#).
    _sys_AddMessage(iErrorIP#,cErrorIP#).

    assign
      this-object:oLog = oLogIP#
      cLang            = "English":u.
    
  end constructor.


  constructor public c_panaedraexception(
    iErrorIP# as integer, 
    oLangIP# as i_language_any,
    oRecordStatusIP# as c_recordstatus
    ):
      
    define variable cError# as character no-undo.  
    
    super().
    
    oRecordStatus = oRecordStatusIP#.
    
    /* The error message (english) is only for situation where we don't have ShowException. 
       ShowException translates the c_recordstatus information to a message in the language 
       of the end user. 
    */
    
    cError# = subst("Record Status Error &1: ~"&2~" record &3: &4",
      iErrorIP#, 
      oRecordStatusIP#:cTablename,
      (if oRecordStatusIP#:bLocked then "locked" else if oRecordStatusIP#:bAmbiguous then "ambiguous" else if oRecordStatusIP#:bAvailable then "available" else "not available"), 
      oRecordStatusIP#:cSvKeyValues
      ). 
      
    this-object:AddMessage(cError#,iErrorIP#).
    _sys_AddMessage(iErrorIP#,cError#).
    
    assign
      cLang = "Any":u.
    
  end constructor.
  
  
  method public void AddMessageSuper(cErrorMessageIP#  as character,iMessageNumberIP# as integer):
    
    /* workaround for inheritance bug c_apiproxyexception */
    super:AddMessage(cErrorMessageIP#, iMessageNumberIP#).
    _sys_AddMessage(iMessageNumberIP#,cErrorMessageIP#).
    
    catch ex as Progress.Lang.Error :
      sc_showexception:ShowException(ex).	
    end catch.
    
  end method.
  
  method public override character GetMessage(iIndexIP# as integer):
    
    define variable cReturn# as character no-undo.
    
    define buffer b-ttExceptionLine for ttExceptionLine.
    
    find first b-ttExceptionLine where b-ttExceptionLine.iIndex = iIndexIP# no-error.

    if avail b-ttExceptionLine 
      then cReturn# = b-ttExceptionLine.cError.
    else 
      cReturn# = super:GetMessage(iIndexIP#).
      
    return cReturn#.
    
    catch ex as Progress.Lang.Error:
      if ex:GetMessageNum(1) = 5729
        then return "Use AddMessageSuper instead of AddMessage, to work around a progress bug.".
      else
        sc_showexception:ShowException(ex).	
    end catch.
      
  end method. /* GetMessage */
  
  
  method protected void _sys_AddMessage(iErrorIP# as integer, cErrorIP# as character):
  
    define buffer b-ttExceptionLine for ttExceptionLine.
    
    create b-ttExceptionLine.
    
    assign
      iLastIndex               = iLastIndex + 1 
      b-ttExceptionLine.iIndex = iLastIndex
      b-ttExceptionLine.iError = iErrorIP#
      b-ttExceptionLine.cError = cErrorIP#
      .      
    
    release b-ttExceptionLine.  
  
  end method. /* _sys_AddMessage */
  
    
  destructor public c_panaedraexception ():
    
    if valid-object(oRecordStatus) then
      delete object oRecordStatus.
       
  end destructor.

end class.

/* EOF */ 
