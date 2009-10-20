{panaedra/msi/logic/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_data_analysis   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_data_analysis.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-20 12:17:07+02:00 $ 
    Date Modified: $Modtime: 2009-10-20 12:16:25+02:00 $ 

      Description: Class voor b.v. het inlezen van een temp-table record en te kijken of deze
                   leeg is.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_data_analysis(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/


  method public static logical IsRecordEmpty (hRecordBufferIP# as handle, cSvExcludeFieldsIP# as character):
    
    /* Bekijkt een record van een meegegeven buffer en beoordeel of deze leeg is of niet */
    /* Je kan velden negeren als deze niet meegenomen hoeven te worden in de beoordeling */
    define variable hField#    as handle    no-undo.
    define variable iFieldNr#  as integer   no-undo.
    define variable bEmpty#    as logical   no-undo initial true.
    define variable cInitial#  as character no-undo.
    define variable cValue#    as character no-undo.
    define variable cDataType# as character no-undo.
    
    loopdoorvelden:
    do iFieldNr# = 1 to hRecordBufferIP#:num-fields:
      
      assign
        hField#    = hRecordBufferIP#:buffer-field(iFieldNr#)
        cInitial#  = hField#:initial
        cValue#    = hField#:buffer-value
        cDataType# = hField#:data-type.
      
      if lookup(cSvExcludeFieldsIP#, hField#:name) = 0 then
      do:
      
        case cDataType#:
        
          when "character" then
            do:
              if trim(cValue#) <> trim(cInitial#) then
                bEmpty# = false.
            end. /* character */  
      
          when "integer" then
            do:
              if int(cValue#) <> int(cInitial#) then
                bEmpty# = false.
            end. /* integer */  
      
          when "decimal" then
            do:
              if dec(cValue#) <> dec(cInitial#) then
                bEmpty# = false.
            end. /* decimal */  
      
          otherwise 
          do:
          
          end. /* Otherwise */  
      
        end case. /* cDataType# */
      
        /* Als we hebben bepaald dat het record niet leeg is heeft heeft het geen zin om verder te zoeken */
        if bEmpty# = false then 
          leave loopdoorvelden.
      
      end. /* iFieldNr# = 1 to hRecordBufferIP#:num-fields */ 
    
    end. /* lookup(cSvExcludeFieldsIP#, hRecordBufferIP#:name) */
    
    return bEmpty#.
    
  end method. /* IsRecordEmpty */

end class.

/* EOF */ 
