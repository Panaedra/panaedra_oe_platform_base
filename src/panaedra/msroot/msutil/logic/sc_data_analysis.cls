{panaedra/msi/logic/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_data_analysis   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_data_analysis.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-20 13:58:31+02:00 $ 
    Date Modified: $Modtime: 2009-10-20 13:47:41+02:00 $ 

      Description: Class voor b.v. het inlezen van een temp-table record en te kijken of deze
                   leeg is.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_data_analysis(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/


  method public static logical IsRecordEmpty (hBufferIP# as handle, cSvExcludeFieldsIP# as character):

    /* bouw support voor extents in                                                                                                  */
    /*  bTrimIP# als optie meegeven                                                                                            */
    /* maak drie overloads; eentje zonder cSv, eentje zonder bTrimIP#, en eentje zonder cSv en bTrimIP#                              */
    /* Nog inbouwen: 
       - Progress.Lang.Object 
       - com-handle 
       - date 
       - datetime 
       - datetime-tz
       - handle 
       - int64 
       - logical
       - longchar
       - memptr
       - blob
       - clob
       - raw 
       - recid 
       - rowid */
    
    /* Bekijkt een record van een meegegeven buffer en beoordeel of deze leeg is of niet */
    /* Je kan velden negeren als deze niet meegenomen hoeven te worden in de beoordeling */
    define variable hField#    as handle    no-undo.
    define variable iFieldNr#  as integer   no-undo.
    define variable bEmpty#    as logical   no-undo initial true.
    define variable cDataType# as character no-undo.
    
    if hBufferIP# <> ? then 
    do:
    
      b_LoopDoorVelden:
      do iFieldNr# = 1 to hBufferIP#:num-fields:
      
        assign
          hField#    = hBufferIP#:buffer-field(iFieldNr#)
          cDataType# = hField#:data-type.
        
        if lookup(hField#:name, cSvExcludeFieldsIP#) = 0 then
        do:
      
          case cDataType#:
        
            when "character" then
              do:
                if hField#:buffer-value <> hField#:initial then
                  bEmpty# = false.
              end. /* character */  
      
            when "integer" then
              do:
                if hField#:buffer-value <> int(hField#:initial) then
                  bEmpty# = false.
              end. /* integer */  
      
            when "decimal" then
              do:
                if hField#:buffer-value <> dec(hField#:initial) then
                  bEmpty# = false.
              end. /* decimal */  
      
            otherwise 
            do:
              undo, throw new AppError(subst("sc_data_analysis is een onbekend data-type tegengekomen: &1", hField#:data-type), 99950080).
            end. /* Otherwise */  
      
          end case. /* cDataType# */
      
          /* Als we hebben bepaald dat het record niet leeg is heeft heeft het geen zin om verder te zoeken */
          if bEmpty# = false then 
            leave b_LoopDoorVelden.
      
        end. /* lookup(cSvExcludeFieldsIP#, hBufferIP#:name) */ 
    
      end. /* iFieldNr# = 1 to hBufferIP#:num-fields */
    
      return bEmpty#.
    
    end. /* if hBufferIP# <> ? */
    else
      return ?.
    
  end method. /* IsRecordEmpty */

end class.

/* EOF */ 
