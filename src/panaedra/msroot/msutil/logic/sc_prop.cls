{panaedra/msroot/msutil/logic/top_i/ctop_class.i}
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.

class panaedra.msroot.msutil.logic.sc_prop:

  /****************************** Source Header ********************************\

      Description: Class implementation of generic loose coupled properties.
                   
                   Strong typed OO is preferred instead of using this class, but 
                   may still be used when appropriate.

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  define protected static temp-table ttSharedVars no-undo
    field varDestId as char format "x(10)"  /* id */
    field varLabel  as char format "x(15)"
    field varValue  as char format "x(15)" 
    field procname  as char format "x(35)" /* for debugging, which procedure initialized it */
    index idxId is primary unique varDestId varLabel. 


  method public static character GetProp(
    hWidgetIP# as handle,
    cPropIP#   as character) :

    /* Purpose:  Get a property from a private-data chr(1) chr(2) list */
     
    define variable iEntry#  as integer   no-undo.
    define variable cReturn# as character no-undo.

    if hWidgetIP#:private-data = "" or hWidgetIP#:private-data = ? then
      return ?.

    if num-entries(hWidgetIP#:private-data,chr(1)) = 1 then
      PropReformat (hWidgetIP#).

    iEntry# = lookup(cPropIP#, entry(1,hWidgetIP#:private-data,chr(1)), chr(2)).

    if iEntry# = 0 then return ?.
  
    cReturn# = entry(iEntry#, entry(2,hWidgetIP#:private-data,chr(1)), chr(2)).

    return if cReturn# = "?" then ? else cReturn#.
    
  end method. /* GetProp */  
  

  method public static void SetProp (
    hWidgetIP# as handle,
    cPropIP#   as character,
    cValueIP#  as character):
    
    /*------------------------------------------------------------------------------
      Purpose:     Set a property on the private data csv string
      Parameters:  <none>
      Notes:       If pd is filled with a pipe-delimited string, it's converted
                   to proper properties. If it's filled with a random string,
                   a property "oldData" is set.
    ------------------------------------------------------------------------------*/

    define variable iTell#    as integer   no-undo.
    define variable cEntry#   as character no-undo.
    define variable csvProp#  as character no-undo.
    define variable csvValue# as character no-undo.
    define variable iEntry#   as integer   no-undo.

    if hWidgetIP#:private-data = "" or
      hWidgetIP#:private-data = ? then
      hWidgetIP#:private-data = substitute("&1&2&3", cPropIP#, chr(1), cValueIP#).

    else 
    do:

      if num-entries(hWidgetIP#:private-data,chr(1)) = 1 then
        PropReformat (hWidgetIP#).

      /* normal property list is there */

      csvProp#  = entry(1,hWidgetIP#:private-data,chr(1)).
      csvValue# = entry(2,hWidgetIP#:private-data,chr(1)).

      iEntry# = lookup(cPropIP#,csvProp#,chr(2)).

      if iEntry# = 0 then assign
          csvProp#  = csvProp#  + substitute("&1&2",chr(2),cPropIP#)
          csvValue# = csvValue# + substitute("&1&2",chr(2),cValueIP#).
      else 
        entry(iEntry#,csvValue#,chr(2)) = substitute("&1", cValueIP#).

      hWidgetIP#:private-data = csvProp# + chr(1) + csvValue#.

    end.
    
  end method. /* SetProp */


  method public static void PropsFromString(hWidgetIP# as handle, csvPropsIP# as character):

    /* Convert a string like " propA = yes | propB = somethingelse " 
     to properties on the private-data.
     
     Can also be called with it's own private-data after
     an AppBuilder built procedure widget is filled with
     a typed-in property string. Set the private-data to ? beforehand 
     in that case.
  
     */
  
    def var iTell#  as int   no-undo.
    def var cEntry# as char no-undo.
    def var iIndex# as int   no-undo.
    def var cValue# as char no-undo.
    def var cProp#  as char no-undo.
  
    do iTell# = 1 to num-entries(csvPropsIP#,"|"):
      cEntry# = trim(entry(iTell#,csvPropsIP#,"|")).
      if cEntry# > "" then 
      do:
        iIndex# = 
          index(cEntry#,"=").
        if iIndex# = 0 then assign 
            cProp#  = cEntry#
            cValue# = "yes".
        else assign 
            cProp#  = trim(substring(cEntry#, 1, iIndex# - 1))
            cValue# = trim(substring(cEntry#, iIndex# + 1, -1)).
        SetProp(hWidgetIP#,cProp#,cValue#).
      end.
    end.
    
  end method. /* PropsFromString */


  method public static char PropsToString(hWidgetIP# as handle):
     
    /* Convert the private-data to a string like " propA = yes | propB = somethingelse ".
     Can be used if the private-data needs to be stored as a property itself.
    */
  
    def var iTell#     as int   no-undo.
    def var cEntry#    as char no-undo.
    def var cPrivData# as char no-undo.
    def var csvProp#   as char no-undo.
    def var csvValue#  as char no-undo.
    def var csvProps#  as char no-undo.
      
    cPrivData# = hWidgetIP#:private-data.
  
    if cPrivData# = ? or trim(cPrivData#) = "" then return "".
  
    if num-entries(cPrivData#,chr(1)) < 2 then 
    do:
      /* We assume the widget has already a string in it's private data 
         of the format " propA = yes | propB = somethingelse" */
      csvProps# = cPrivData#.
      return "".
    end.
  
    csvProp#  = entry(1,cPrivData#,chr(1)).
    csvValue# = entry(2,cPrivData#,chr(1)).
  
    do iTell# = 1 to num-entries(csvProp#,chr(2)):
      cEntry# = entry(iTell#,csvProp#,chr(2)).
      csvProps# = csvProps# + substitute("| &1 = &2 ", cEntry#, entry(iTell#,csvValue#,chr(2))).
    end.
  
    csvProps# = trim(substring(csvProps#,2)).
    
    return csvProps#.
    
  end method. /* PropsToString */


  method public static void PropReformat(hWidgetIP# as handle):
    /*------------------------------------------------------------------------------
      Purpose:     convert a "p1=v1|p2=v2" string to proper format
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

    define variable iTell#    as integer   no-undo.
    define variable cEntry#   as character no-undo.
    define variable csvProp#  as character no-undo.
    define variable csvValue# as character no-undo.

    if num-entries(hWidgetIP#:private-data,chr(1)) = 1 then 
    do:

      do iTell# = 1 to num-entries(hWidgetIP#:private-data,"|"):
        cEntry#   = entry(iTell#, hWidgetIP#:private-data,"|").
        csvProp#  = csvProp#  + chr(2) + trim(entry(1,cEntry#,"=")).
        csvValue# = csvValue# + chr(2) + (if num-entries(cEntry#,"=") < 2 then "yes" else trim(entry(2,cEntry#,"="))).
      end.

      csvProp#  = substring(csvProp#,2).
      csvValue# = substring(csvValue#,2).

      hWidgetIP#:private-data = csvProp# + chr(1) + csvValue#.

    end.

  end method. /* PropReformat */


  method public static logical DelAllSharedVar(cVarDestidIP# as character):

    for each ttSharedVars where ttSharedVars.VarDestId = cVarDestidIP#
      on error undo, throw:
      delete ttSharedVars.
    end.
      
    return true.  
   
  end method. /* DelAllSharedVar */
    
    
  method public static character GetSharedVar
    (cVarDestIdIP# as character, 
    cVarLabelIP#  as character):
      
    find ttSharedVars where ttSharedVars.VarDestId = cVarDestIdIP#
      and ttSharedVars.varLabel = cVarLabelIP#
      no-lock no-error.
    if not avail ttSharedVars
      then
      return ?.
    else
      return ttSharedVars.VarValue.
      
  end method. /* GetSharedVar */


  method public static logical PutSharedVar
    (cVarDestIdIP#    as char  ,
    cVarLabelIP#     as char  ,
    cVarValueIP#     as char  ):

    find ttSharedVars where ttSharedVars.VarDestId = cVarDestIdIP#
      and ttSharedVars.VarLabel     = cVarLabelIP#
      no-error.
    if not avail ttSharedVars
      then 
    do:
      create ttSharedVars.
      assign 
        ttSharedVars.varDestId = cVarDestIdIP#
        ttSharedVars.varLabel  = cVarLabelIP#
        ttSharedVars.ProcName  = program-name(2).
    end.
    assign 
      ttSharedVars.varValue = cVarValueIP#.

    return true.
     
  end method. /* PutSharedVar */


  method public static void DispSharedVar(
    
    /* Show all shared var entries of the temp-table */
    
    cVarDestIdIP# as char):
  
    def frame f-dispSharedVar.
  
    do with frame f-dispSharedVar:
      for each ttSharedVars where ttSharedVars.VarDestId = cVarDestIdIP# or cVarDestIdIP# = ?
        on error undo, throw:
        disp ttSharedVars with frame f-dispSharedVar 10 down overlay centered row 4.
        down 1 with frame f-dispSharedVar.
      end. /* each ttSharedVars where ttSharedVars.VarDestId = i-VarDestId or i-VarDestid = ? : */
      readkey.
      hide frame f-dispSharedVar.
    end.
  
    return.
  
  end method. /* DispSharedVar */


  method public static void SetBufferPropsFromHelpString (input hBuffIP# as handle):
    
    /* This method converts a help string that's in the following format : 
       " [private-data] Prop01=Value01 | Prop02=Value02 " into a  
       property string which you can use with GetProp (and SetProp).
       
       N.B.   Settings like " [label] SomeLabel " are ignored in this method.
              Only the [private-data] setting is used.
              
       N.B. 2 You must use the rcode-information setting on the temp-table.
       
    */
    
    define variable iTell#  as integer   no-undo.
    define variable hField# as handle    no-undo.
    define variable cHelp#  as character no-undo.
    
    do iTell# = 1 to hBuffIP#:num-fields:
      hField# = hBuffIP#:buffer-field(iTell#).
      cHelp# = hField#:help.
      if cHelp# matches "*[private-data]*" then
        PropsFromString(hField#, sc_string_csv:GetParam(cHelp#,"private-data")).
    end.

  end method. /* SetBufferPropsFromHelpString */

  method public static void SetDataObjectPropsFromHelpString(hDataObjectIP# as handle):
    
    /* See comment in SetBufferPropsFromHelpString */
    
    define variable iTell# as integer no-undo.
    
    case hDataObjectIP#:type:
      
      when "buffer" then 
        do:
          SetBufferPropsFromHelpString(hDataObjectIP#).
        end.
      when "query" then 
        do:
          do iTell# = 1 to hDataObjectIP#:num-buffers:
            SetBufferPropsFromHelpString(hDataObjectIP#:get-buffer-handle(iTell#)).
          end.
        end.
      when "dataset" then 
        do:
          /* ShouldHave:  Check if num-buffers also works on a dataset, instead we have to use top-buffers and data-relations */
          do iTell# = 1 to hDataObjectIP#:num-buffers:
            SetBufferPropsFromHelpString(hDataObjectIP#:get-buffer-handle(iTell#)).
          end.
        end.
        
    end case. 

  end method. /* SetDataObjectPropsFromHelpString */

end class.


/* EOF */



