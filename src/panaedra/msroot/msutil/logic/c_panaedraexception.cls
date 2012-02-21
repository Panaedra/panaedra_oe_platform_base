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
  
  define property cLang as character no-undo 
    public    get.
    protected set.

  define property oLog as i_log no-undo 
    public    get.
    protected set.

  constructor public c_panaedraexception(
    iErrorIP# as integer, 
    oDutchIP# as i_language_dutch,
    cErrorIP# as character):
    
    super(cErrorIP#, iErrorIP#).
    
    cLang = "Dutch":u.
    
  end constructor.


  constructor public c_panaedraexception(
    iErrorIP# as integer, 
    oEnglishIP# as i_language_english,
    cErrorIP# as character):
    
    super(cErrorIP#, iErrorIP#).

    cLang = "English":u.
    
  end constructor.


  constructor public c_panaedraexception(
    iErrorIP# as integer, 
    oDutchIP# as i_language_dutch,
    cErrorIP# as character,
    oLogIP# as i_log
    ):
    
    super(cErrorIP#, iErrorIP#).
    
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
    
    super(cErrorIP#, iErrorIP#).

    assign
      this-object:oLog = oLogIP#
      cLang            = "English":u.
    
  end constructor.
  
  
  constructor public c_panaedraexception(
    iErrorIP# as integer, 
    oLangIP# as i_language_any,
    oRecordStatus as c_recordstatus
    ):
    
    super(
      /* The error message (english) is only for situation where we don't have ShowException. 
         ShowException translates the c_recordstatus information to a message in the language 
         of the end user. */
      subst("see@c_recordstatus|Error: &1 record &2: &3", 
      oRecordStatus:cTableName,
      (if oRecordStatus:bLocked then "locked" else if oRecordStatus:bAmbiguous then "ambiguous" else "not available"), 
      oRecordStatus:cIdFields
      ), 
      iErrorIP#).
    
    assign
      cLang = "Any":u.
    
  end constructor.

  

end class.

/* EOF */ 
