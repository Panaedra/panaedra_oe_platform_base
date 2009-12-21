/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msas/logic/tt/session_tt.i $ 
        Version: $Revision: 2 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-12-21 14:02:59+01:00 $ 
  Date Modified: $Modtime: 2009-12-21 13:21:35+01:00 $ 

    Description: add_your_comments_here

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msas_logic_tt_session_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msas_logic_tt_session_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msas_logic_tt_session_tt_i $Revision: 2 $
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} tt~{~&ttPrefix~}Session~{~&ttSuffix~}

&if defined(tt{&ttPrefix}Session{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}Session{&ttSuffix} true

define {&protected} {&static} temp-table tt{&ttPrefix}Session{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field cUserID      as character
  field cSessionGuid as character
  {&ttExtraFields}
  index cSessionGuid is primary unique cSessionGuid
  {&ttExtraIndices}.

&endif

&endif /* {&dvcs__panaedra_msroot_msas_logic_tt_session_tt_i} */

/* EOF : panaedra/msroot/msas/logic/tt/session_tt.i */
