{panaedra/msi/logic/ctop_class.i}

class panaedra.msroot.msutil.logic.sc_prop: 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_prop.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-09-04 08:02:43+02:00 $ 
    Date Modified: $Modtime: 2009-09-04 07:06:37+02:00 $ 

      Description: add_your_comments_here

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_prop(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  method public static character getProp(
    hWidgetIP# as handle,
    cPropIP#   as character) :

    /* Purpose:  Get a property from a private-data chr(1) chr(2) list */
     
    define variable iEntry#  as integer   no-undo.
    define variable cReturn# as character no-undo.

    if hWidgetIP#:private-data = "" or hWidgetIP#:private-data = ? then
      return ?.

    if num-entries(hWidgetIP#:private-data,chr(1)) = 1 then
      run propReformat (hWidgetIP#).

    iEntry# = lookup(cPropIP#, entry(1,hWidgetIP#:private-data,chr(1)), chr(2)).

    if iEntry# = 0 then return ?.
  
    cReturn# = entry(iEntry#, entry(2,hWidgetIP#:private-data,chr(1)), chr(2)).

    return if cReturn# = "?" then ? else cReturn#.
    
  end method. /* getProp */  
  

  method public static void setProp (
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
        run propReformat (hWidgetIP#).

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
    
  end method. /* setProp */


  method public static void PropsFromString (hWidgetIP# as handle, csvPropsIP# as character):

    /* Convert a string like " propA = yes | propB = somethingelse " 
     to properties on the private-data.
     
     Can also be called with it's own private-data after
     an AppBuilder built procedure widget is filled with
     a typed-in property string. Set the private-data to ? beforehand 
     in that case.
  
     */
  
    def var iTell#  as int  no-undo.
    def var cEntry# as char no-undo.
    def var iIndex# as int  no-undo.
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
        run setProp(hWidgetIP#,cProp#,cValue#).
      end.
    end.
    

  end method. /* PropsToString */


  method public static char PropsToString (hWidgetIP# as handle):
     
    /* Convert the private-data to a string like " propA = yes | propB = somethingelse ".
     Can be used if the private-data needs to be stored as a property itself.
    */
  
    def var iTell#     as int  no-undo.
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


end class.


/* EOF */



