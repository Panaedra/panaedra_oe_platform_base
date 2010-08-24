using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_xml_sax   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_xml_sax.cls $ 
          Version: $Revision: 3 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-08-24 14:17:11+02:00 $ 
    Date Modified: $Modtime: 2010-08-24 12:11:00+02:00 $ 

      Description: XML SAX helper methods

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_xml_sax(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 3 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static variable iTtErrorOrder     as integer no-undo.
  define protected static variable hSaxReaderCurrent as handle  no-undo.
    
  define protected static temp-table ttError no-undo
    field iOrder as integer
    field iLine  as integer
    field iCol   as integer
    field cType  as character
    field cError as character
    index iOrder is primary unique iOrder
    .
  
  method public static void ValidateXmlByXsd(
    
    /* Validate an XML to an XSD. Sax-reader is used. */
  
    input  cXmlFileIP#   as character, 
    input  cNameSpaceIP# as character,
    input  cXsdFileIP#   as character, 
    output cErrorOP#     as character):
    
    define variable hSaxReaderProc# as handle no-undo.
    define variable hSaxReader#     as handle no-undo.
    
    define buffer b-ttError for ttError.
    
    
    iTtErrorOrder = 0.
    empty temp-table ttError.
  
    run panaedra/msroot/msutil/logic/sc_xml_sax_sub_saxreader.p persistent set hSaxReaderProc#.
    
    create sax-reader hSaxReader#.
  
    hSaxReaderCurrent = hSaxReader#.
    
    hSaxReader#:set-input-source("file", cXmlFileIP#).
    hSaxReader#:handler = hSaxReaderProc#.
    hSaxReader#:add-schema-location(cNameSpaceIP#, cXsdFileIP#).
    hSaxReader#:sax-parse().
    
    for each b-ttError:
      if length(cErrorOP#) < 10000 then
        cErrorOP# = cErrorOP# + chr(10) + subst("&1 &2@[Line]&3[Col]&4: &5", b-ttError.iOrder, b-ttError.cType, b-ttError.iLine, b-ttError.iCol, b-ttError.cError).
    end. 
    cErrorOP# = substring(cErrorOP#,2).
    
    finally:
      hSaxReaderCurrent = ?.
      if valid-handle(hSaxReaderProc#) then apply "close" to hSaxReaderProc#.
      if valid-handle(hSaxReaderProc#) then delete procedure hSaxReaderProc#.
      if valid-handle(hSaxReader#)     then delete object hSaxReader#.
    end finally.

  end method. /* ValidateXmlByXsd */


  method public static void _sys_SaxValidatingReturnedWarning(hProcIP# as handle, cErrorIP# as character):
    
    define variable bEclipseFix# as logical no-undo.
    define buffer b-ttError for ttError.
    
    create b-ttError.
    
    assign 
      iTtErrorOrder    = iTtErrorOrder + 1
      b-ttError.iOrder = iTtErrorOrder
      b-ttError.cType  = "Warning"
      b-ttError.cError = cErrorIP#
      b-ttError.iCol   = hSaxReaderCurrent:locator-column-number
      b-ttError.iLine  = hSaxReaderCurrent:locator-line-number
      .
    
    if iTtErrorOrder > 100 then hSaxReaderCurrent:stop-parsing().

  end method. /* _sys_SaxValidatingReturnedWarning */


  method public static void _sys_SaxValidatingReturnedError(hProcIP# as handle, cErrorIP# as character):

    define variable bEclipseFix# as logical no-undo.
    define buffer b-ttError for ttError.
    
    create b-ttError.
    
    assign 
      iTtErrorOrder    = iTtErrorOrder + 1
      b-ttError.iOrder = iTtErrorOrder
      b-ttError.cType  = "Error"
      b-ttError.cError = cErrorIP#
      b-ttError.iCol   = hSaxReaderCurrent:locator-column-number
      b-ttError.iLine  = hSaxReaderCurrent:locator-line-number
      .

    if iTtErrorOrder > 100 then hSaxReaderCurrent:stop-parsing().

  end method. /* _sys_SaxValidatingReturnedError */


  method public static void _sys_SaxValidatingReturnedFatalError(hProcIP# as handle, cErrorIP# as character):

    define variable bEclipseFix# as logical no-undo.
    define buffer b-ttError for ttError.
    
    create b-ttError.
    
    assign 
      iTtErrorOrder    = iTtErrorOrder + 1
      b-ttError.iOrder = iTtErrorOrder
      b-ttError.cType  = "FatalError"
      b-ttError.cError = cErrorIP#
      b-ttError.iCol   = hSaxReaderCurrent:locator-column-number
      b-ttError.iLine  = hSaxReaderCurrent:locator-line-number
      .

    if iTtErrorOrder > 100 then hSaxReaderCurrent:stop-parsing().
    
  end method. /* _sys_SaxValidatingReturnedFatalError */

end class.

/* EOF */ 
