/******************************  Dvcs_ Header ********************************\
       Filename: $Archive:  $ 
        Version: $Revision:  $ 
     Programmer: $Author: $ 
   Date Checkin: $Date:  $ 
  Date Modified: $Modtime:  $ 

    Description: Definition for ttMsMonICheckAssertFile (assert that a file exists after the process has completed)

\**************************** End of Dvcs_ Header ****************************/
&if "{&dvcs__panaedra_msroot_msmonitor_logic_tt_msmon_icheckassertfile_i}" = "" &then
&glob dvcs__panaedra_msroot_msmonitor_logic_tt_msmon_icheckassertfile_i yes
&glob sourcecontrolversions {&sourcecontrolversions} | panaedra_msroot_msmonitor_logic_tt_msmon_icheckassertfile_i $Revision: 1 $
&if '{&class}' = '' &then
procedure dvcs__panaedra_msroot_msmonitor_logic_tt_msmon_icheckassertfile_i: return "$Revision: 1 $". end.
&endif
/******************************* $NoKeywords:  $ *****************************/

&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}MsMonICheckAssertFile~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}MsMonICheckAssertFile~{~&ttSuffix~}

&if defined(tt{&ttPrefix}MsMonICheckAssertFile{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}MsMonICheckAssertFile{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}MsMonICheckAssertFile{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDMsMonICheckAssertFile as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=MsMonICheckAssertFile  | PersistencyMode=xml-store "
  field cAssertType              as character   /* MustExist,MustNotExist,... */
  field cFullPath                as character   /* Full path to os file. Use tokens like [:cIniDir:] for sc_path parts.  */
  field bUseWildcards            as logical     /* Specify if wildcards are used in cFullPath */  
  field dtmModMinimum            as datetime-tz /* Minimum file mod timestamp */
  field dtmModMaximum            as datetime-tz /* Maximum file mod timestamp */
  field iByteSizeMinimum         as int64       /* Minimum file bytesize */
  field iByteSizeMaximum         as int64       /* Maximum file bytesize */
  {&ttExtraFields}
  index iIDMsMonICheckAssertFile is unique primary iIDMsMonICheckAssertFile
  {&ttExtraIndices}
  .

&endif

&endif /* {&dvcs__panaedra_msroot_msmonitor_logic_tt_msmon_icheckassertfile_i} */

/* EOF : panaedra/msroot/msmonitor/logic/tt/msmon_icheckassertfile.i */
