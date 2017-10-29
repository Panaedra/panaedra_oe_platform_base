{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.interfaces.sc_messageboxtype: 

  /****************************** Source Header ********************************\

      Description: Overload ID static class

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define public static property Simple       as i_messageboxtype_simple        no-undo get.
  define public static property Simple_OnTop as i_messageboxtype_simple_ontop  no-undo get.
  define public static property YesNo        as i_messageboxtype_yesno         no-undo get.
  define public static property YesNo_OnTop  as i_messageboxtype_yesno_ontop   no-undo get.
  define public static property oDebug       as i_messageboxtype_debug         no-undo get.
  define public static property AsAlertBox   as i_messageboxtype_asalertbox    no-undo get.
  define public static property YesNoCancel  as i_messageboxtype_yesnocancel   no-undo get.

end class.

/* EOF */ 
