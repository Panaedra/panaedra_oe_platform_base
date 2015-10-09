using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_string_csv: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_string_csv.cls $ 
          Version: $Revision: 12 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:12+01:00 $

      Description: Class implementation of csvlib.
                   Delivers (C)omma (S)eparated (V)alue functionality
                   (comma not to be taken literally).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_string_csv(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 12 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  constructor public sc_string_csv(
    input oParamIP# as panaedra.msroot.msutil.interfaces.i_unittest_param):
  end constructor.  
  

  define protected static temp-table ttCsvSortList no-undo
    field cValue as character
    index cValue is primary cValue.

  define protected static temp-table ttCsvSortListNumeric no-undo
    field iValue as integer
    index iValue is primary iValue.

  
  method public static character GetParam(
  
    cParamIP#   as character, 
    cTokenIP#   as character, 
    cDefaultIP# as character 
    ):
      
    define variable cReturn# as character no-undo.
  
    cReturn# = GetParam(cParamIP#, cTokenIP#). 

    if length(cReturn#) = 0 then
      cReturn# = cDefaultIP#. 

    return cReturn#.
  
  end method. /* GetParam */
  
  
  method public static character GetParam(
    cParamIP# as character, 
    cTokenIP# as character):
  
    /* Gets values from a readable string like " [Hallo] hoi [Bla] boe ".
       Trim is automatically applied.
       Default format for session:parameter (-param) string.
    */
  
    define variable iTell# as integer   no-undo.
    define variable cPara# as character no-undo.
    define variable cEntr# as character no-undo.

    cPara# = cParamIP#.

    do iTell# = 1 to num-entries(cPara#,"["):
      cEntr# = entry(iTell#,cPara#,"[").
      if cEntr# = "" then next.
      if cTokenIP# = trim(entry(1,cEntr#,"]")) then
        return trim(entry(2,cEntr#,"]")).
    end.
  
    return "".

  end method. /* GetParam */


  method public static character SetSubParam(
    cParamIP#  as character, 
    cTokenIP#  as character, 
    cSearchIP# as character, 
    cValueIP#  as character):
      
    /* Like SetParam, but read-write to a subset in the token value.
       You may use the following wildcard: asterisk plus end-delimiter.
      
       I.e. " [Param1] sub1 = yes | sub2 = no | sub3 = value [Param2] value2 " 
          with
          "Param1", "sub1 =*|", "sub1 = no"
          will be 
          " [Param1] sub1 = no | sub2 = no | sub3 = value [Param2] value2 "
       
       The new parameter string is returned.
    */
  
    define variable iTell#   as integer   no-undo.
    define variable iTell2#  as integer   no-undo.
    define variable cPara#   as character no-undo.
    define variable cEntr#   as character no-undo.
  
    define variable cToken#  as character no-undo.
    define variable cValue#  as character no-undo.
  
    define variable cReturn# as character no-undo.
    define variable bReuse#  as logical   no-undo.
    define variable bReuse2# as logical   no-undo.
    define variable cDelim#  as character no-undo.
  
    cPara# = cParamIP#.

    do iTell# = 1 to num-entries(cPara#,"["):
      cEntr#= entry(iTell#,cPara#,"[").
      if cEntr#= "" then next.
      cToken# = trim(entry(1,cEntr#,"]")).
    
      if cTokenIP# = cToken# then 
      do:
        bReuse# = true.
        if cSearchIP# > "" then 
        do:
          cValue# = trim(entry(2,cEntr#,"]")).
          if cSearchIP# matches "*~~*." then 
          do:
            /* wildcard + delimiter ; asterisk is position before last */
            cDelim# = substring(cSearchIP#,length(cSearchIP#)).
            cSearchIP# = substring(cSearchIP#,1,length(cSearchIP#) - 2).
            do iTell2# = 1 to num-entries(cValue#, cDelim#):
              if trim(entry(iTell2#, cValue#, cDelim#)) begins cSearchIP#
                then 
                assign 
                  bReuse2#                         = true
                  entry(iTell2#, cValue#, cDelim#) = " " + trim(cValueIP#) + " ".
            end.
            if not bReuse2# then
              cValue# = " " + trim(cValue# + " " + cDelim# + " " + cValueIP#, cDelim# + " ") + " ".
          end.
          else cValue# = cValueIP#.
        end. /* search string supplied */
        else cValue# = cValueIP#.
      end.
      else
        cValue# = trim(entry(2,cEntr#,"]")).
    
      cReturn# = cReturn# + " [" + cToken# + "] " + cValue#. 
    
    end.
  
    if not bReuse# then
      cReturn# = cReturn# + " [" + cTokenIP# + "] " + cValueIP#. 
  
    cReturn# = substring(cReturn#, 2).
  
    return cReturn#.

  end method. /* SetSubParam */


  method public static character SetParam(
    cParamIP# as character, 
    cTokenIP# as character,
    cValueIP# as character):
    
    /* Set a parameter to the supplied value. 
       Existing values are overwritten.
       Example: " [Param1] value1 [Param2] value2 " will be " [Param1] valuenieuw [Param2] value2 "
       The new parameter string is returned.
    */
    
    return sc_string_csv:SetSubParam(cParamIP#, cTokenIP#, "", cValueIP#).
    
  end method. /* SetParam */
 
 
  method public static character CsvGetJoinList(
    csvOneIP#   as character, 
    csvTwoIP#   as character  ):
      
    return CsvGetJoinList(csvOneIP#, csvTwoIP#, ',', '').  
      
  end method. /* CsvGetJoinList overload zonder delimiter,options */   
 
 
  @panaedraannotation file(unittest="yes").
  method public static character CsvGetJoinList(
    csvOneIP#   as character, 
    csvTwoIP#   as character, 
    cDelimIP#   as character, 
    cOptionsIP# as character):

    /* Compares 2 csv lists, returns the Join */
    
    define variable csvJoin# as character no-undo.
    define variable iTell#   as integer   no-undo.
    define variable iTell2#  as integer   no-undo.
  
    /* if the 2 lists are both the same, then return list 1. */
    if csvOneIP# = csvTwoIP# then 
    do:
      csvJoin# = csvOneIP#.
      return csvJoin#.
    end.
  
    /* if list 2 is present inside list 1, then return list 1 */
    if 
      index(cDelimIP# + csvTwoIP# + cDelimIP#, cDelimIP# + csvOneIP# + cDelimIP#) > 0 then 
    do:
      csvJoin# = csvOneIP#.
      return csvJoin#.
    end.
  
    /* if list 1 is present inside list 2, then return list 2 */
    if 
      index(cDelimIP# + csvOneIP# + cDelimIP#, cDelimIP# + csvTwoIP# + cDelimIP#) > 0 then 
    do:
      csvJoin# = csvTwoIP#.
      return csvJoin#.
    end.
  
    /* none of the above; join the 2 lists */
    csvJoin# = CsvAddLastUnique(csvJoin#, csvOneIP#,cDelimIP#).
    csvJoin# = CsvAddLastUnique(csvJoin#, csvTwoIP#,cDelimIP#).

    return csvJoin#.

  end method. /* CsvGetJoinList */ 
 

  method public static logical CsvIsSubset(
    cSmallListIP# as character, 
    cBigListIP#   as character, 
    cDelim#       as character):
  
    /*------------------------------------------------------------------------------
      Purpose:  Test if all entries of cSmallListIP# are in cBigListIP#
        Notes:  I.E.: "1,3" "1,2,3" "," returns true
    ------------------------------------------------------------------------------*/
   
    define variable iTell#  as integer   no-undo.
    define variable cEntry# as character no-undo.
  
    if cSmallListIP# = ? or cBigListIP# = ? or cDelim# = ? then return false.
  
    do iTell# = 1 to num-entries(cSmallListIP#, cDelim#):
   
      cEntry# = entry(iTell#, cSmallListIP#, cDelim#).
      if lookup (cEntry#, cBigListIP#, cDelim#) = 0 then return false.
   
    end.
  
    return true.
  
  end method. /* CsvIsSubset */


  method public static logical CsvIndexHit(
    cListIP#       as character, 
    cTestStringIP# as character, 
    cDelimIP#      as character):

    /*------------------------------------------------------------------------------
      Purpose:  Verifies if at least 1 entry of cListIP# appears in cTestStringIP#.
                Uses index function.
        Notes:  Vb1.: "tic,tac,toe" "I hurt my toe"    "," returns yes
                Vb2.: "tic,tac,toe" "This idea sticks" "," returns yes
    ------------------------------------------------------------------------------*/
   
    define variable iTell#     as integer   no-undo.
    define variable cEntry#    as character no-undo.
    define variable bRetValOP# as logical   no-undo init false.
  
    if cListIP# = ? or cTestStringIP# = ? or cDelimIP# = ? then return false.
  
    do iTell# = 1 to num-entries(cListIP#, cDelimIP#) while bRetValOP# = false:
      cEntry# = entry(iTell#,cListIP#,cDelimIP#).
      if 
        index(cTestStringIP#, cEntry#) > 0 then 
        bRetValOP# = true.
    end.
  
    return bRetValOP#.

  end method. /* CsvIndexHit  */


  method public static character CsvSortList(
    cListIP#  as character, 
    cDelimIP# as character):
  
    /* Sort a list alphabetically.
       Empty entries are kept.
       Double entries are kept.
    */
    
    return CsvSortListImplement(cListIP#, cDelimIP#, false).
    
  end method. /* CsvSortList */
  
  
  method public static character CsvSortListUnique(
    cListIP#  as character, 
    cDelimIP# as character):
  
    /* Sort a list alphabetically.
       Empty entries are kept.
       Double entries are deleted.
    */
    
    return CsvSortListImplement(cListIP#, cDelimIP#, true).
    
  end method. /* CsvSortListUnique */
  
  
  method protected static character CsvSortListImplement(
    cListIP#       as character, 
    cDelimIP#      as character,
    bMakeUniqueIP# as logical):
  
    /* Sort a list alphabetically.
       Empty entries are kept.
       Double entries are kept or deleted.
    */
  
    define variable iTell#   as integer   no-undo.
    define variable cReturn# as character no-undo.
    
    define buffer b-ttCsvSortList for ttCsvSortList.
    
    empty temp-table ttCsvSortList.
  
    do iTell# = 1 to num-entries(cListIP#,cDelimIP#) transaction: /* codeQok#7103 */
      create ttCsvSortList.
      assign 
        ttCsvSortList.cValue = entry(iTell#,cListIP#,cDelimIP#).
    end.
    
    if bMakeUniqueIP# then
      for each ttCsvSortList on error undo, throw:
        for each b-ttCsvSortList 
          where b-ttCsvSortList.cValue = ttCsvSortList.cValue
          and rowid(b-ttCsvSortList) <> rowid(ttCsvSortList)
          on error undo, throw:
          delete b-ttCsvSortList.
        end.
      end.
  
    for each ttCsvSortList on error undo, throw:
      cReturn# = cReturn# + cDelimIP# + ttCsvSortList.cValue.
    end.
  
    cReturn# = substring(cReturn#, length(cDelimIP#) + 1).
  
    return cReturn#.
  
  end method. /* CsvSortListImplement */

  
  @panaedraannotation file(unittest="yes").
  method public static character CsvSortListNumeric(
    cListIP#       as character, 
    cDelimIP#      as character):
  
    /* Sort a list numericly */
  
    define variable iTell#     as integer   no-undo.
    define variable cSvReturn# as character no-undo.
    
    define buffer b-ttCsvSortListNumeric for ttCsvSortListNumeric.
    
    empty temp-table ttCsvSortListNumeric.
    
    do iTell# = 1 to num-entries(cListIP#,cDelimIP#) transaction: /* codeQok#7103 */

      if not sc_numericformat:IsInteger(entry(iTell#,cListIP#,cDelimIP#)) then
        undo, throw new c_panaedraexception(
          99936548,
          sc_lang:oDutch,
          "CsvSortListNumeric gebruikt met waardes die niet numeric zijn"
          ).
    
      create b-ttCsvSortListNumeric.
      assign 
        b-ttCsvSortListNumeric.iValue = int(entry(iTell#,cListIP#,cDelimIP#)).
        
    end.
  
    for each b-ttCsvSortListNumeric on error undo, throw:
      cSvReturn# = cSvReturn# + cDelimIP# + string(b-ttCsvSortListNumeric.iValue).
    end.
  
    cSvReturn# = substring(cSvReturn#, length(cDelimIP#) + 1).
  
    return cSvReturn#.
  
  end method. /* CsvSortListNumeric */


  method public static character CsvAddLast(cCsvIP# as character, cNewValueIP# as character):
    
    /* WouldHave: decide on comment and annotation standard */
    @panaedra.comment.method file
      (nl_desc="
       Voegt een waarde toe aan een seperated value list, zonder dat er dubbele entries in komen. ~n &if false &then codeQok#7104 &endif
       "
      ,nl_note="
       In deze overload is de delimiter een komma (~",~") ~n &if false &then codeQok#7104 &endif
       "
      ,en_desc="
       Adds a value to a seperated value list, unknown-value safe and with trim. ~n
       "
      ,en_note="
     In this overload, the delimiter is a comma (~",~") ~n
     "
      ).
    
    return CsvAddLast(cCsvIP#, cNewValueIP#, ",").
    
  end method. /* CsvAddLast ; delimiter = "," */


  method public static character CsvAddLast(cCsvIP# as character, cNewValueIP# as character, cDelimiterIP# as character):
    
    /* Adds a value to a seperated value, without adding too much delimiters.
       Use this overload to supply your own delimiter. 
    */
    
    define variable cReturn# as character no-undo.
    
    if cCsvIP#      = ? then cCsvIP# = "".
    if cNewValueIP# = ? then cNewValueIP# = "?".
    
    cReturn# = cCsvIP# + cDelimiterIP# + cNewValueIP#.
    cReturn# = trim(cReturn#, cDelimiterIP#).
    
    return cReturn#.
    
  end method. /* CsvAddLast ; any delimiter */


  @panaedraannotation file(unittest="yes").
  method public static character CsvRemoveValue(
    cSvIP# as character, cSvRemoveValueIP# as character):

    return CsvRemoveValue(cSvIP#, cSvRemoveValueIP#, ",").
    
  end method. /* CsvRemoveValue ; delimiter = "," */

   
  @panaedraannotation file(unittest="yes").
  method public static character CsvRemoveValue(
    cSvIP# as character, cSvRemoveValueIP# as character, cDelimiterIP# as character):
    /* removes one or more values from a csv */
    
    define variable cSvReturn# as character no-undo.
    define variable iTell#     as integer   no-undo.
    define variable cEntry#    as character no-undo.

    if cSvIP# = ? or cSvIP# = "" then
      cSvReturn# = "".
      
    else if cSvRemoveValueIP# = ? then
        cSvReturn# = cSvIP#.

      else
      do iTell# = 1 to num-entries(cSvIP#, cDelimiterIP#):
      
        /* Don't add the item to the new list if it's in the list of items to remove */
        if lookup(entry(iTell#, cSvIP#, cDelimiterIP#), cSvRemoveValueIP#, cDelimiterIP#) = 0 then 
          cSvReturn# = cSvReturn# + (if length(cSvReturn#) > 0 then cDelimiterIP# else "") + entry(iTell#, cSvIP#, cDelimiterIP#).

      end.

    return cSvReturn#.
    
  end method. /* CsvRemoveValue ; any delimiter */
  
  
  @panaedraannotation file(unittest="yes").
  method public static character CsvRemoveLastValue(
    cSvIP# as character, 
    cDelimiterIP# as character):
    /* removes the last value from a csv */
    
    define variable cSvReturn# as character no-undo.
    define variable iTell#     as integer   no-undo.
    define variable cEntry#    as character no-undo.

    if cSvIP# = ? or cSvIP# = "" then
      cSvReturn# = "".
      
    else
    do iTell# = 1 to num-entries(cSvIP#, cDelimiterIP#) - 1 /* skip last */:
      cSvReturn# = cSvReturn# + (if length(cSvReturn#) > 0 then cDelimiterIP# else "") + entry(iTell#, cSvIP#, cDelimiterIP#).
    end.

    return cSvReturn#.
    
  end method. /* CsvRemoveLastValue */
  
  
  method public static character CsvAddFirst(cCsvIP# as character, cNewValueIP# as character):
    
    /* Adds a value to a seperated value, without adding too much delimiters.
       Use this overload to get a comma as delimiter. 
    */
    
    return CsvAddFirst(cCsvIP#, cNewValueIP#, ",").
    
  end method. /* CsvAddFirst ; delimiter = "," */


  method public static character CsvAddFirst(cCsvIP# as character, cNewValueIP# as character, cDelimiterIP# as character):
    
    /* Adds a value to the front of a seperated value list, without adding too much delimiters.
       Use this overload to supply your own delimiter. 
    */
    
    define variable cReturn# as character no-undo.
    
    if cCsvIP#      = ? then cCsvIP# = "".
    if cNewValueIP# = ? then cNewValueIP# = "?".
    
    cReturn# = cNewValueIP# + cDelimiterIP# + cCsvIP#.
    cReturn# = trim(cReturn#, cDelimiterIP#).
    
    return cReturn#.
    
  end method. /* CsvAddFirst ; any delimiter */


  method public static character CsvAddFirstUnique(cCsvIP# as character, cSvNewValueIP# as character):
    
    /* Adds a value to the front of a seperated value list, without adding too much delimiters.
       Use this overload to use a comma as delimiter. 
    */
    
    return CsvAddFirstUNique(cCsvIP#, cSvNewValueIP#, ",").
    
  end method. /* CsvAddFirstUnique ; delimiter = "," */


  method public static character CsvAddFirstUnique(cCsvIP# as character, cSvNewValueIP# as character, cDelimiterIP# as character):
    
    /* Adds a value to the front of a seperated value list, without adding too much delimiters.
       Use this overload to supply your own delimiter. 
    */

    define variable cInputEntry# as character no-undo.
    define variable iTell#       as integer   no-undo.
    
    define variable cCsv#        as character no-undo.
    
    cCsv# = cCsvIP#.
    
    do iTell# = 1 to num-entries(cSvNewValueIP#, cDelimiterIP#):
      
      cInputEntry# = entry(iTell#,cSvNewValueIP#, cDelimiterIP#).

      if lookup(cInputEntry#, cCsv#, cDelimiterIP#) = 0 then 
        cCsv# = CsvAddFirst(cCsv#, cInputEntry#, cDelimiterIP#).
      
    end. /* walk input entries */
    
    return cCsv#.
    
  end method. /* CsvAddFirstUnique ; any delimiter */

  
  method public static character CsvAddLastUnique(cCsvIP# as character, cSvNewValueIP# as character):
    
    /* Adds a value to the end of a seperated value list, without adding too much delimiters.
       Use this overload to use comma as delimiter. 
    */
    
    return CsvAddLastUnique(cCsvIP#, cSvNewValueIP#, ",").
    
  end method. /* CsvAddLastUnique ; delimiter = "," */


  method public static character CsvAddLastUnique(cCsvIP# as character, cSvNewValueIP# as character, cDelimiterIP# as character):
    
    /* Adds a value (or a list of values) to the end of a seperated value list, without adding too much delimiters.
       Use this overload to supply your own delimiter. 
    */
    
    define variable cInputEntry# as character no-undo.
    define variable iTell#       as integer   no-undo.
    
    define variable cCsv#        as character no-undo.
    
    cCsv# = cCsvIP#.
    
    do iTell# = 1 to num-entries(cSvNewValueIP#, cDelimiterIP#):
      
      cInputEntry# = entry(iTell#,cSvNewValueIP#, cDelimiterIP#).

      if lookup(cInputEntry#, cCsv#, cDelimiterIP#) = 0 then 
        cCsv# = CsvAddLast(cCsv#, cInputEntry#, cDelimiterIP#).
      
    end. /* walk input entries */
    
    return cCsv#.
    
  end method. /* CsvAddLastUnique ; any delimiter */

  
  method public static character ConvertBufferToHeaderCsvString(
    
    /* A very simple way to export buffer field names to  csv header 
       form a csv header. Note: extents are supported. */
      
    input hBufferIP#    as handle, 
    input cDelimiterIP# as character
    ): 
      
    define variable cSvHeader#  as character no-undo.
    define variable cFieldname# as character no-undo.
    define variable hField#     as handle    no-undo.
    define variable iField#     as integer   no-undo.
    
    cSvHeader# = fill(cDelimiterIP#, hBufferIP#:num-fields).  
    
    do iField# = 1 to hBufferIP#:num-fields 
      on error undo, throw: 

      hField# = hBufferIP#:buffer-field(iField#). 
      
      if hField#:extent = 0 then  
      do:
        
        if length(hField#:label) > 0 then
          cFieldname# = hField#:label. 
        else
          cFieldname# = hField#:name. 
        
        entry(iField#, cSvHeader#, cDelimiterIP#) = string(cFieldname#). 

      end. /* hField#:extent == 0 */
   
    end. /* do iField# = 1 to hBuffIP#:num-fields */
    
    return trim(cSvHeader#, cDelimiterIP#). 
  
  end method. /* ConvertBufferToHeaderCsvString */
  
  
  method public static character ConvertBufferToCsvString(
   
    /* A very simple way to convert buffer field names
       to a csv string header. Note: extents are not supported.
       */ 
      
    input hBufferIP#    as handle, 
    input cDelimiterIP# as character
    ): 
      
    define variable cSvLine# as character no-undo.
    define variable cValue#  as character no-undo.
    define variable cFormat# as character no-undo.
    define variable hField#  as handle    no-undo.
    define variable iField#  as integer   no-undo.
    
    cSvLine# = fill(cDelimiterIP#, hBufferIP#:num-fields).  
    
    do iField# = 1 to hBufferIP#:num-fields 
      on error undo, throw: 

      hField# = hBufferIP#:buffer-field(iField#). 
      
      if hField#:extent = 0 then  
      do:
        
        if length(hField#:help) > 0 then 
        do: 
          cFormat# = trim(sc_string_csv:getParam(hField#:help,"format")).
          if length(cFormat#) > 0 then 
            cValue# = trim(string(hfield#:buffer-value, cFormat#)).
        end.
        else 
          cValue# = hfield#:buffer-value.
          
        if hfield#:buffer-value = ? then 
          cValue# = "". 
        
        entry(iField#, cSvLine#, cDelimiterIP#) = string(cValue#). 
        
      end. /* hField#:extent == 0 */
   
    end. /* do iField# = 1 to hBuffIP#:num-fields */
    
    return trim(cSvLine#, cDelimiterIP#). 
  
  end method. /* ConvertBufferToCsvString */
  
end class. 

/* EOF */

