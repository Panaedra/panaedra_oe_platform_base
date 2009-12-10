{panaedra/msi/logic/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_data_analysis   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_data_analysis.cls $ 
          Version: $Revision: 8 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-12-10 19:36:05+01:00 $ 
    Date Modified: $Modtime: 2009-12-10 19:35:00+01:00 $ 

      Description: Class met static methods voor het analyseren van de 
                   inhoud van een (temp-)table of (temp-)table buffer.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_data_analysis(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 8 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/


  method public static logical IsRecordEmpty(
    
    /* Kijk of een record leeg is; d.w.z. gelijk aan zijn initial values.
    */

    hBufferIP# as handle):
      
    return IsRecordEmpty(hBufferIP#, "", false).
    
  end method. /* IsRecordEmpty ; only een buffer handle */
  
  
  method public static logical IsRecordEmpty(
  
    /* Kijk of een record leeg is; d.w.z. gelijk aan zijn initial values.
       Parameter cSvExcludeFieldsIP# : velden om te negeren bij de compare. 
    */

    hBufferIP#          as handle, 
    cSvExcludeFieldsIP# as character):
  
    return IsRecordEmpty(hBufferIP#, cSvExcludeFieldsIP#, false).
  
  end method. /* IsRecordEmpty ; buffer handle + cSvExcludeFieldsIP# */
  

  method public static logical IsRecordEmpty(
  
    /* Kijk of een record leeg is; d.w.z. gelijk aan zijn initial values.
       Parameter cSvExcludeFieldsIP# : velden om te negeren bij de compare. 
       Parameter bTrimIP#            : optioneel trimmen char en longchar 'before compare'. 
    */
  
    hBufferIP#          as handle, 
    cSvExcludeFieldsIP# as character, 
    bTrimIP#            as logical):

    /* TODO:
       Nog inbouwen: 
       - Progress.Lang.Object 
       - com-handle 
       - date 
       - datetime 
       - datetime-tz
       - handle 
       - int64 
       - logical
       - longchar + trim
       - memptr
       - blob
       - clob
       - raw 
       - recid 
       - rowid 
    */
    
    define variable hField#     as handle    no-undo.
    define variable iFieldNr#   as integer   no-undo.
    define variable bEmpty#     as logical   no-undo initial true.
    define variable cDataType#  as character no-undo.
    define variable iExtent#    as integer   no-undo.
    define variable cDataValue# as character no-undo.
    
    if hBufferIP# <> ? then 
    do:
      
      if not hBufferIP#:available then bEmpty# = ?.
      else
      /* Behandel elk veld */
      b_LoopDoorVelden:
      do iFieldNr# = 1 to hBufferIP#:num-fields:
        
        hField# = hBufferIP#:buffer-field(iFieldNr#).
        
        /* Als dit veld niet bij de excludes hoort */
        if lookup(hField#:name, cSvExcludeFieldsIP#) = 0 then
        do:
          
          /* Loop elke extent (vaak 0 to 0) door */
          do iExtent# = 
            (if hField#:extent = 0 then 0 else 1) to 
            (if hField#:extent = 0 then 0 else hField#:extent):
          
            /* Onthoud datatype */
            cDataType# = hField#:data-type.
                   
            /* Behandel elk data-type op zijn eigen manier */
            case cDataType#:
        
              when "character" then
                do:
                  cDataValue# = if bTrimIP# then trim(hField#:buffer-value[iExtent#]) else hField#:buffer-value[iExtent#].
                  
                  if 
                    (cDataValue# = ? and hField#:initial = ?) 
                    or 
                    (cDataValue# = hField#:initial) then
                    . /* Is ok, doe niets. */
                  else  
                    bEmpty# = false.
                    
                end. /* character */  
      
              when "integer" then
                do:
                  if 
                    (hField#:buffer-value[iExtent#] = ? and int(hField#:initial) = ?) 
                    or
                    hField#:buffer-value[iExtent#] = int(hField#:initial) then
                    . /* Is ok, doe niets. */
                  else
                    bEmpty# = false.
                    
                end. /* integer */  
      
              when "decimal" then
                do:
                  if 
                    (hField#:buffer-value[iExtent#] = ? and dec(hField#:initial) = ?) 
                    or
                    hField#:buffer-value[iExtent#] = dec(hField#:initial) then
                    . /* Is ok, doe niets. */
                  else
                    bEmpty# = false.
                    
                end. /* decimal */  
      
              otherwise 
              do:
                undo, throw new AppError(subst("Het datatype '&1' wordt (nog) niet ondersteund.", hField#:data-type), 99950080).
              end. /* otherwise ; onbekend datatype */  
      
            end case. /* cDataType# */
      
            /* Als we hebben bepaald dat het record niet leeg is heeft heeft het geen zin om verder te zoeken */
            if bEmpty# = false then 
              leave b_LoopDoorVelden.
      
          end. /* do iExtent# = */   
      
        end. /* lookup(hField#:name, cSvExcludeFieldsIP#) = 0 */ 
    
      end. /* buffer is available; iFieldNr# = 1 to hBufferIP#:num-fields */
    
      return bEmpty#.
    
    end. /* if hBufferIP# <> ? */
    else
      return ?.
    
  end method. /* IsRecordEmpty ; buffer handle + cSvExcludeFieldsIP# + bTrimIP# */


  method public static logical IsDataSetEmpty(input hDataSetIP# as handle):
    
    /* Determine if every (temp-)table in this dataset is empty */
    define variable iBuff#    as integer no-undo.
    define variable hBuff#    as handle  no-undo.
    define variable bIsEmpty# as logical no-undo initial true.
    
    /* Check for every (temp-)table is there is data available */
    b_each_buff:
    do iBuff# = 1 to hDataSetIP#:num-buffers:
      
      /* Get (temp-)table buffer handle */
      hBuff# = hDataSetIP#:get-buffer-handle(iBuff#).
      
      hBuff#:find-first("", no-lock) no-error.
      
      /* If there is a record available then dataset is not empty */
      if hBuff#:available then
      do:
        bIsEmpty# = false.  
        leave b_each_buff.        
      end.    
      
    end. /* b_each_buff */
    
    return bIsEmpty#.
    
  end method. /* IsDataSetEmpty */

end class.

/* EOF */ 
