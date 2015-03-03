/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/ds/sc_dataset_xml_unittests.i $ 
        Version: $Revision: 1 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-01-27 16:59:09+01:00 $ 
  Date Modified: $Modtime: 2010-01-27 16:59:09+01:00 $ 

    Description: dataset for testing

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msutil_logic_ds_sc_dataset_xml_unittests_i}" = "" &then
&glob dvcs__panaedra_msroot_msutil_logic_ds_sc_dataset_xml_unittests_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msutil_logic_ds_sc_dataset_xml_unittests_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msutil_logic_ds_sc_dataset_xml_unittests_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/
{panaedra/msroot/msutil/logic/tt/sc_dataset_xml_unittests_tt.i  {&*}}

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

define {&protected} {&static} dataset dsTestDatasetXml {&reference-only} for tt{&ttPrefix}TestDatasetXml{&ttSuffix}.

&endif /* {&dvcs__panaedra_msroot_msutil_logic_ds_sc_dataset_xml_unittests_i} */

/* EOF : panaedra/msroot/msutil/logic/ds/sc_dataset_xml_unittests.i */
