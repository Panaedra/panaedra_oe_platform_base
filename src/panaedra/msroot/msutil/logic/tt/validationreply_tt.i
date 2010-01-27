/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/tt/validationreply_tt.i $ 
        Version: $Revision: 1 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-01-27 16:59:09+01:00 $ 
  Date Modified: $Modtime: 2010-01-27 16:59:09+01:00 $ 

    Description: Child of ttValidationQuestion. Replies (by the user) to the question, to be 
                 sent back to the db layer or client validation logic.

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_tt_validationreply_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_tt_validationreply_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_tt_validationreply_tt_i $Revision: 1 $
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} tt~{~&ttPrefix~}ValidationReply~{~&ttSuffix~}

&if defined(tt{&ttPrefix}ValidationReply{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}ValidationReply{&ttSuffix} true

define {&protected} {&static} temp-table tt{&ttPrefix}ValidationReply{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDValidationQuestion    as int64
  field iOrderValidationQuestion as int64
  field iIDValidationReply       as int64
  field dtmCreValidationReply    as datetime-tz
  field cMessage                 as character
  field cTable                   as character /* Can be used for focussing the UI */
  field cField                   as character /* Can be used for focussing the UI */
  field bFeedbackGiven           as logical   /* The user has already given feedback */
  {&ttExtraFields}
  index iIDValidationReply           is primary unique iIDValidationReply
  index iIDValidationQuestion_iOrder                   iIDValidationQuestion descending iOrderValidationQuestion
  {&ttExtraIndices}.

&endif

&endif /* {&dvcs__panaedra_msroot_msutil_logic_tt_validationreply_tt_i} */

/* EOF : panaedra/msroot/msutil/logic/tt/validationreply_tt.i */
