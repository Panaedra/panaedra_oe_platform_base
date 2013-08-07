/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Temp-table definition

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_mspack_logic_tt_msframelogic_tt_i}" = "" &then
&glob dvcs__panaedra_msroot_mspack_logic_tt_msframelogic_tt_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_mspack_logic_tt_msframelogic_tt_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_mspack_logic_tt_msframelogic_tt_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsFrameLogic~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsFrameLogic~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsFrameLogic{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsFrameLogic{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsFrameLogic{&ttSuffix} {&no-undo}
  xml-node-name "FrameLogic"
  {&reference-only} {&rcode-information} {&before-table}
  field iIDMsFrameLogic     as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsFrameLogic "  
  field iIDMsLogicObjects   as int64       xml-node-type "hidden"
  field iFrmlgExtent        as integer     xml-node-type "attribute" initial ?
  field cObject             as character   xml-node-type "attribute"
  field bPackBootLoad       as logical     xml-node-type "attribute" initial true
  field bActive             as logical     xml-node-type "attribute"
  field cLinkName           as character   xml-node-type "attribute"
  field cLooseframeLinkName as character   xml-node-type "attribute"
  {&ttExtraFields}
  index iIDMsFrameLogic   is unique primary iIDMsFrameLogic
  index iIDMsLogicObjects is unique iIDMsLogicObjects cObject
  index iFrmlgExtent iFrmlgExtent
  {&ttExtraIndices}
  .

&endif


&endif /* {&dvcs__panaedra_msroot_mspack_logic_tt_msframelogic_tt_i} */

/* EOF : panaedra/msroot/mspack/logic/tt/msframelogic_tt.i */
