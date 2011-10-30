/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Dataset definition for dsMsRuntime

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_mspack_logic_ds_mspack_ds_i}" = "" &then
&glob dvcs__panaedra_msroot_mspack_logic_ds_mspack_ds_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_mspack_logic_ds_mspack_ds_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_mspack_logic_ds_mspack_ds_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

{panaedra/msroot/mspack/logic/tt/mspack_tt.i                    {&*}}
{panaedra/msroot/mspack/logic/tt/mschildpack_tt.i               {&*}}
{panaedra/msroot/mspack/logic/tt/mschildpacks_tt.i              {&*}}
{panaedra/msroot/mspack/logic/tt/msconstructoritems_tt.i        {&*}}
{panaedra/msroot/mspack/logic/tt/mscontrollers_tt.i             {&*}}
{panaedra/msroot/mspack/logic/tt/msdatasetconstructoritem_tt.i  {&*}}
{panaedra/msroot/mspack/logic/tt/msdatasetcontroller_tt.i       {&*}}
{panaedra/msroot/mspack/logic/tt/msframelogic_tt.i              {&*}}
{panaedra/msroot/mspack/logic/tt/mslogicobjects_tt.i            {&*}}
{panaedra/msroot/mspack/logic/tt/msmainframe_tt.i               {&*}}
{panaedra/msroot/mspack/logic/tt/msmdimaster_tt.i               {&*}}
{panaedra/msroot/mspack/logic/tt/mspreloadpack_tt.i             {&*}}
{panaedra/msroot/mspack/logic/tt/mspreloads_tt.i                {&*}}
{panaedra/msroot/mspack/logic/tt/msscopetable_tt.i              {&*}}
{panaedra/msroot/mspack/logic/tt/mssubframes_tt.i               {&*} &ttSuffix="Ovly" &xml-node-name-tt="SubFrames.GroupframeOverlay"}
{panaedra/msroot/mspack/logic/tt/mssubframe_tt.i                {&*} &ttSuffix="Ovly" &xml-node-name-tt="SubFrame"}
{panaedra/msroot/mspack/logic/tt/mssubframepacks_tt.i           {&*} &ttSuffix="Ovly" &xml-node-name-tt="SubFramepacks.GroupframeOverlay"}
{panaedra/msroot/mspack/logic/tt/mssubframepack_tt.i            {&*} &ttSuffix="Ovly" &xml-node-name-tt="SubFramepack"}

define {&protected} {&static} dataset dsPackConfig
  xml-node-name "DsPackConfiguration"
  for 
  ttMsPack,
  ttMsMdiMaster,
  ttMsMainFrame,
  ttMsPreloads,
  ttMsPreloadPack,
  ttMsScopetable,
  ttMsConstructorItems,
  ttMsDatasetConstructorItem,
  ttMsControllers,
  ttMsDatasetController,
  ttMsLogicObjects,
  ttMsFrameLogic,
  ttMsSubframesOvly,
  ttMsSubframeOvly,
  ttMsSubframePacksOvly,
  ttMsSubframePackOvly,
  ttMsChildPacks,
  ttMsChildPack
  
  data-relation for ttMsPreloads,          ttMsPreloadPack relation-fields (iIDMsPreloads,iIDMsPreloads) nested
  data-relation for ttMsConstructorItems,  ttMsDatasetConstructorItem relation-fields (iIDMsConstructorItems,iIDMsConstructorItems) nested
  data-relation for ttMsControllers,       ttMsDatasetController relation-fields (iIDMsControllers,iIDMsControllers) nested
  data-relation for ttMsLogicObjects,      ttMsFrameLogic relation-fields (iIDMsLogicObjects,iIDMsLogicObjects) nested
  data-relation for ttMsSubframesOvly,     ttMsSubframeOvly relation-fields (iIDMsSubframes,iIDMsSubframes) nested
  data-relation for ttMsSubframepacksOvly, ttMsSubframePackOvly relation-fields (iIDMsSubframepacks,iIDMsSubframepacks) nested
  data-relation for ttMsChildPacks,        ttMsChildPack relation-fields (iIDMsChildPacks,iIDMsChildPacks) nested
  .


&endif /* {&dvcs__panaedra_msroot_mspack_logic_ds_mspack_ds_i} */

/* EOF : panaedra/msroot/mspack/logic/ds/mspack_ds.i */
