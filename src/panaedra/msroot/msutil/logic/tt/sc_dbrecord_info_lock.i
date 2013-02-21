&if defined(static) > 0 and defined(reference-only) > 0 &then &undefine reference-only
&endif

&if "{&do-undo}"         <> "true" &then &scop no-undo no-undo
&endif

&if "{&no-rcode-info}"   <> "true" &then &scop rcode-information rcode-information
&endif

&if "{&no-before-table}" <> "true" &then &scop before-table before-table btTt~{~&ttPrefix~}Lock~{~&ttSuffix~}
&endif

&if "{&TtAllDefined}"     > "" &then &glob TtAllDefined {&TtAllDefined},
&endif

&glob TtAllDefined {&TtAllDefined} ~{~&TtBufferPrefix~}tt~{~&ttPrefix~}Lock~{~&ttSuffix~}

&if defined(tt{&ttPrefix}Lock{&ttSuffix}) = 0 &then
&glob tt{&ttPrefix}Lock{&ttSuffix} true
define {&protected} {&static} temp-table tt{&ttPrefix}Lock{&ttSuffix} {&no-undo} {&reference-only} {&rcode-information} {&before-table}
  field iIDLock         as int64       format "->>>,>>>,>>>,>>9"    initial ? xml-node-type "attribute" help " [private-data] CasedTableName=Lock "  
  field cDb             as character   format "x(4)"
  field iLockId         as int64
  field rLockRecid      as recid
  field iLockUsr        as integer
  field iTransactionNum as int64       label "Transaction-Id" format ">>>>>>>>>>>>>>>>9"  /*  codeQok#7103 */
  field cLockName       as character
  field iLockTable      as integer
  field cTableName      as character   label "Table"
  field cDevice         as character   label "Device" format "x(15)"
  field iPid            as integer
  field cWhoInfo        as character   label "Who info"     format "x(30)"
  field cCommandLineRaw as character   label "Command line" format "x(74)"
  field cCommandLine01  as character   label "Command line 1" format "x(74)"
  field cCommandLine02  as character   label "Command line 2" format "x(74)"
  field cCommandLine03  as character   label "Command line 3" format "x(74)"
  field cCommandLine04  as character   label "Command line 4" format "x(74)"
  field cCommandLine05  as character   label "Command line 5" format "x(74)"
  field cCommandLine06  as character   label "Command line 6" format "x(74)"
  field cCommandLine07  as character   label "Command line 7" format "x(74)"
  field cCommandLine08  as character   label "Command line 8" format "x(74)"
  field cCommandLine09  as character   label "Command line 9" format "x(74)"
  field cCommandLine10  as character   label "Command line 10" format "x(74)"
  field dtmSince        as datetime-tz label "Since"
  field cSince          as character   label "Since" format "x(8)"
  
  {&ttExtraFields}
  
  index iIDLock is unique primary iIDLock
  {&ttExtraIndices}
  .

&endif



