using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

{panaedra/msroot/msutil/logic/top_i/ptop_procedure.i}

/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_xml_sax_sub_saxreader.p $ 
        Version: $Revision: 1 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-08-24 12:05:44+02:00 $ 
  Date Modified: $Modtime: 2010-08-24 12:04:51+02:00 $ 

    Description: Sax reader, sub process of sc_xml_sax class

\**************************** End of Dvcs_ Header ****************************/
&scop dvcs_proc procedure dvcs__panaedra_msroot_msutil_logic_sc_xml_sax_sub_saxreader_p: return "$Revision: 1 $". end.
{&dvcs_proc}
/******************************* $NoKeywords:  $ *****************************/

define variable cLastStartElementPS#    as character no-undo.
define variable bLastCharactersEmptyPS# as logical   no-undo.

on close of this-procedure 
  do:
    delete procedure this-procedure.
  end.

procedure StartDocument:
/* Invoked when the XML parser starts. */

end procedure. /* StartDocument */

procedure StartElement:
  /* Invoked when the XML parser detects the beginning of an element. */
  define input parameter cNamespaceUriIP# as character no-undo.
  define input parameter cLocalNameIP#    as character no-undo.
  define input parameter cNodeNameIP#     as character no-undo.
  define input parameter cAttributesIP#   as handle    no-undo.
  
  assign
    cLastStartElementPS#    = cNodeNameIP#
    bLastCharactersEmptyPS# = true.

end procedure. /* StartElement */


procedure EndElement:
  /* Invoked when the XML parser detects the end of an element. */
  define input parameter cNamespaceUriIP# as character no-undo.
  define input parameter cLocalNameIP#    as character no-undo.
  define input parameter cNodeNameIP#     as character no-undo.

end procedure.

procedure Characters:
  /* Invoked when the XML parser detects character data. */
  define input parameter mDataIP#     as memptr  no-undo.
  define input parameter iNumCharsIP# as integer no-undo.
  
  /* Note: the parser doesn't call Characters, if the xsd blocks it. */
  
  if iNumCharsIP# = 0 then bLastCharactersEmptyPS# = false.
  else bLastCharactersEmptyPS# = trim(get-string(mDataIP#,1,iNumCharsIP#)) = "".
  
end procedure.

procedure EndDocument:
/* Invoked when the XML parser detects the end of an XML document. */

end procedure.

procedure Warning:
  /* Invoked to report a warning. */
  define input parameter cErrMessageIP# as character no-undo.
  
  sc_xml_sax:_sys_SaxValidatingReturnedWarning(
    this-procedure, 
    subst("The following WARNING was generated: &1 for: '&2'", cErrMessageIP#, cLastStartElementPS#)).
  
end procedure.
    
procedure Error:
  /* Invoked to report an error encountered by the parser while parsing the XML document. */
  define input parameter cErrMessageIP# as character no-undo.
  
  if not (bLastCharactersEmptyPS# and cErrMessageIP# = "No character data is allowed by content model") then 
  do:
    sc_xml_sax:_sys_SaxValidatingReturnedError(
      this-procedure, 
      subst("The following NONFATAL ERROR was generated: &1 for: '&2'", cErrMessageIP#, cLastStartElementPS#)).
  end.
  
end procedure.

procedure FatalError:
  /* Invoked to report a fatal error. */
  define input parameter cErrMessageIP# as character no-undo.

  sc_xml_sax:_sys_SaxValidatingReturnedError(
    this-procedure, 
    subst("The following FATAL ERROR was generated: &1 for: '&2'", cErrMessageIP#, cLastStartElementPS#)).

end procedure.

/* EOF */
