{panaedra/msi/logic/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_string_csv: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_string_csv.cls $ 
          Version: $Revision: 7 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-09 14:44:30+02:00 $ 
    Date Modified: $Modtime: 2009-10-09 11:28:18+02:00 $ 

      Description: Class implementatie van de csvlib.
                   Bevat (C)omma (S)eparated (V)alue gerelateerde functionaliteit
                   (comma moet je breed zien).

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_string_csv(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 7 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  method public static char GetParam
    (cParamIP# as char, cTokenIP# as char):
  
    /* Haalt waardes uit een goed te lezen string als " [Hallo] hoi [Bla] boe ".
       Trim vindt automatisch plaats.
       Dit formaat wordt ook bij session:parameter (de -param bij opstarten) gebruikt.
    */
  
    define variable iTell as integer   no-undo.
    define variable cPara as character no-undo.
    define variable cEntr as character no-undo.

    cPara = cParamIP#.

    do iTell = 1 to num-entries(cPara,"["):
      cEntr = entry(iTell,cPara,"[").
      if cEntr = "" then next.
      if cTokenIP# = trim(entry(1,cEntr,"]")) then
        return trim(entry(2,cEntr,"]")).
    end.
  
    return "".

  end method. /* getParam */


  method public static character SetSubParam (
    cParamIP#  as character, 
    cTokenIP#  as character, 
    cSearchIP# as character, 
    cValueIP#  as character):
      
    /* Als setParam, maar een searchstring waarnaar 
   gezocht wordt in de parameter value
   kan worden overschreven met een nieuwe waarde.
   Indien de searchstring niet wordt gevonden,
   wordt de nieuwe waarde geappend.
   De volgende wildcard mag worden gebruikt: sterretje plus delimiter aan het eind.
   Sterretje mag only op voorlaatste positie, anders
   wordt het niet als wildcard beschouwd.
    
   Vb. " [Param1] sub1 = yes | sub2 = no | sub3 = waarde [Param2] waarde2 " 
      met
      "Param1", "sub1 =*|", "sub1 = no"
      wordt 
      " [Param1] sub1 = no | sub2 = no | sub3 = waarde [Param2] waarde2 "
   De gehele (nieuwe) parameter string wordt teruggegeven.
*/
  
    define variable iTell   as integer   no-undo.
    define variable iTell2  as integer   no-undo.
    define variable cPara   as character no-undo.
    define variable cEntr   as character no-undo.
  
    define variable cToken  as character no-undo.
    define variable cValue  as character no-undo.
  
    define variable cReturn as character no-undo.
    define variable bReuse  as log       no-undo.
    define variable bReuse2 as log       no-undo.
    define variable cDelim  as character no-undo.
  
    cPara = cParamIP#.

    do iTell = 1 to num-entries(cPara,"["):
      cEntr = entry(iTell,cPara,"[").
      if cEntr = "" then next.
      cToken = trim(entry(1,cEntr,"]")).
    
      if cTokenIP# = cToken then 
      do:
        bReuse = yes.
        if cSearchIP# > "" then 
        do:
          cValue = trim(entry(2,cEntr,"]")).
          if cSearchIP# matches "*~~*." then 
          do:
            /* wildcard + delimiter ; sterretje is voorlaatste karakter */
            cDelim = substring(cSearchIP#,length(cSearchIP#)).
            cSearchIP# = substring(cSearchIP#,1,length(cSearchIP#) - 2).
            do iTell2 = 1 to num-entries(cValue, cDelim):
              if trim(entry(iTell2, cValue, cDelim)) begins cSearchIP#
                then 
                assign bReuse2                       = yes
                  entry(iTell2, cValue, cDelim) = " " + trim(cValueIP#) + " ".
            end.
            if not bReuse2 then
              cValue = " " + trim(cValue + " " + cDelim + " " + cValueIP#, cDelim + " ") + " ".
          end.
          else cValue = cValueIP#.
        end. /* search string opgegeven */
        else cValue = cValueIP#.
      end.
      else
        cValue = trim(entry(2,cEntr,"]")).
    
      cReturn = cReturn + " [" + cToken + "] " + cValue. 
    
    end.
  
    if not bReuse then
      cReturn = cReturn + " [" + cTokenIP# + "] " + cValueIP#. 
  
    cReturn = substring(cReturn, 2).
  
    return cReturn.

  end method. /* SetSubParam */


  method public static character SetParam (
    cParamIP# as char, 
    cTokenIP# as char,
    cValueIP# as char):
    
    /* Stel een parameter in, op de ingegeven tekst. 
     Een bestaande waarde wordt overschreven.
     Vb. " [Param1] waarde1 [Param2] waarde2 " wordt " [Param1] waardenieuw [Param2] waarde2 "
     De gehele (nieuwe) parameter string wordt teruggegeven.
    */
    
    return panaedra.msroot.msutil.logic.sc_string_csv:SetSubParam(cParamIP#, cTokenIP#, "", cValueIP#).
    
  end method. /* SetParam */
 
 
  method public static character CsvGetJoinList (
    csvOneIP#   as char, 
    csvTwoIP#   as char, 
    cDelimIP#   as char, 
    cOptionsIP# as char):

    /* Vergelijkt twee csv lijsten met elkaar, en geeft de Join terug. */
    
    def var csvJoin# as char no-undo.
    def var iTell#   as int   no-undo.
    def var iTell2#  as int   no-undo.
  
    if csvOneIP# = csvTwoIP# then 
    do:
      csvJoin# = csvOneIP#.
      return csvJoin#.
    end.
  
    if 
      index(cDelimIP# + csvTwoIP# + cDelimIP#, cDelimIP# + csvOneIP# + cDelimIP#) > 0 then 
    do:
      csvJoin# = csvOneIP#.
      return csvJoin#.
    end.
  
    if 
      index(cDelimIP# + csvOneIP# + cDelimIP#, cDelimIP# + csvTwoIP# + cDelimIP#) > 0 then 
    do:
      csvJoin# = csvTwoIP#.
      return csvJoin#.
    end.
  
    do iTell# = 1 to num-entries(csvOneIP#,cDelimIP#):
      do iTell2# = 1 to num-entries(csvTwoIP#,cDelimIP#):
        if entry(iTell#,csvOneIP#,cDelimIP#) = entry(iTell2#,csvTwoIP#,cDelimIP#) then 
        do:
          if lookup(entry(iTell#,csvOneIP#,cDelimIP#),csvJoin#,cDelimIP#) = 0
            then csvJoin# = csvJoin# + subst("&1&2",cDelimIP#,entry(iTell#,csvOneIP#,cDelimIP#)).
        end.
      end.
    end.  

    csvJoin# = substring(csvJoin#,2).

    return csvJoin#.

  end method. /* CsvGetJoinList */ 
 

  method public static logical CsvIsSubset (
    cSmallListIP# as char, 
    cBigListIP# as char, 
    cDelim# as char):
  
    /*------------------------------------------------------------------------------
      Purpose:  Test if all entries of cSmallListIP# are in cBigListIP#
        Notes:  I.E.: "1,3" "1,2,3" "," returns true
    ------------------------------------------------------------------------------*/
   
    def var iTell#  as int   no-undo.
    def var cEntry# as char no-undo.
  
    if cSmallListIP# = ? or cBigListIP# = ? or cDelim# = ? then return no.
  
    do iTell# = 1 to num-entries(cSmallListIP#, cDelim#):
   
      cEntry# = entry(iTell#, cSmallListIP#, cDelim#).
      if lookup (cEntry#, cBigListIP#, cDelim#) = 0 then return no.
   
    end.
  
    return yes.
  
  end method. /* CsvIsSubset */


  method public static logical CsvIndexHit  (
    cListIP#       as char, 
    cTestStringIP# as char, 
    cDelimIP#      as char):

    /*------------------------------------------------------------------------------
      Purpose:  Kijkt of minstens 1 onderdeel van cListIP# in cTestStringIP# voorkomt
        Notes:  Vb.: "tic,tac,toe" "ik wou dat ik een aap was" "," geeft yes
    ------------------------------------------------------------------------------*/
   
    def var iTell#     as int   no-undo.
    def var cEntry#    as char no-undo.
    def var bRetValOP# as log       no-undo init no.
  
    if cListIP# = ? or cTestStringIP# = ? or cDelimIP# = ? then return no.
  
    do iTell# = 1 to num-entries(cListIP#, cDelimIP#) while bRetValOP# = no:
      cEntry# = entry(iTell#,cListIP#,cDelimIP#).
      if 
        index(cTestStringIP#, cEntry#) > 0 then 
        bRetValOP# = yes.
    end.
  
    return bRetValOP#.

  end method. /* CsvIndexHit  */
  

  def protected static temp-table ttCsvSortList no-undo
    field cValue as char
    index cValue is primary cValue.

  method public static character CsvSortList (
    cListIP# as char, 
    cDelimIP# as char):
  
    /* _TERM_UNDISCLOSED_ een lijst, gescheiden door delimiters.
       Maak van bv A,D,C,B een lijst A,B,C,D.
       Lege entries worden gerespecteerd.
       Dubbele entries worden niet opgeschoond.
    */
  
    def var iTell#   as int   no-undo.
    def var cReturn# as char no-undo.
  
    empty temp-table ttCsvSortList.
  
    do iTell# = 1 to num-entries(cListIP#,cDelimIP#) transaction:
      create ttCsvSortList.
      assign 
        ttCsvSortList.cValue = entry(iTell#,cListIP#,cDelimIP#).
    end.
  
    for each ttCsvSortList:
      cReturn# = cReturn# + cDelimIP# + ttCsvSortList.cValue.
    end.
  
    cReturn# = substring(cReturn#, length(cDelimIP#) + 1).
  
    return cReturn#.
  
  end method. /* CsvSortList */


  method public static character CsvAddLast (cCsvIP# as character, cNewValueIP# as character):
    
    /* Voegt een waarde toe aan een seperated value, zonder dat er seperators teveel in komen.
       Als deze aangeroepen wordt, is de seperator een komma (",") */
    
    return CsvAddLast(cCsvIP#, cNewValueIP#, ",").
    
  end method. /* CsvAddLast */


  method public static character CsvAddLast (cCsvIP# as character, cNewValueIP# as character, cSeperatorIP# as character):
    
    /* Voegt een waarde toe aan een seperated value, zonder dat er seperators teveel in komen.
       Als deze aangeroepen wordt, is de seperator variable */
    
    define variable cRetunCsv# as character no-undo.
    
    if cNewValueIP# = ? then cNewValueIP# = "?".
    
    cRetunCsv# = cCsvIP# + cSeperatorIP# + cNewValueIP#.
    cRetunCsv# = trim(cRetunCsv#, cSeperatorIP#).
    
    return cRetunCsv#.
    
  end method. /* CsvAddLast */

  
  method public static character CsvAddFirst (cCsvIP# as character, cNewValueIP# as character):
    
    /* Voegt een waarde toe aan een seperated value vooraan de lijst, zonder dat er seperators teveel in komen.
       Als deze aangeroepen wordt, is de seperator een komma (",") */
    
    return CsvAddFirst(cCsvIP#, cNewValueIP#, ",").
    
  end method. /* CsvAddFirst */


  method public static character CsvAddFirst (cCsvIP# as character, cNewValueIP# as character, cSeperatorIP# as character):
    
    /* Voegt een waarde toe aan een seperated value vooraan de lijst, zonder dat er seperators teveel in komen.
       Als deze aangeroepen wordt, is de seperator variable */
    
    define variable cRetunCsv# as character no-undo.
    
    if cNewValueIP# = ? then cNewValueIP# = "?".
    
    cRetunCsv# = cNewValueIP# + cSeperatorIP# + cCsvIP#.
    cRetunCsv# = trim(cRetunCsv#, cSeperatorIP#).
    
    return cRetunCsv#.
    
  end method. /* CsvAddFirst */
  
  
end class. 

/* EOF */

