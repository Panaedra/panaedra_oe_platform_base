{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.sc_dataset_xml   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_dataset_xml.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-03-11 13:07:55+01:00 $ 
    Date Modified: $Modtime: 2010-03-11 13:07:26+01:00 $ 

      Description: add_your_comments_here

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_dataset_xml(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/


  method public static void WriteXmlAndSplit(
    hDatasetIP#    as handle,
    hQueryIP#      as handle,
    iBatchSizeIP#  as integer,
    cOutputFileIP# as character):

    define variable hSplitDataset#         as handle  no-undo.
    define variable iNumItterations#       as integer no-undo.
    define variable iBuffer#               as integer no-undo.
    define variable hTempTabelBuffer#      as handle  no-undo extent.
    define variable hSplitTempTableBuffer# as handle  no-undo extent.
    define variable iField#                as integer no-undo.
    
    create dataset hSplitDataset#.
    hSplitDataset#:create-like(hDatasetIP#).
    hSplitDataset#:namespace-uri = hDatasetIP#:namespace-uri.
    
    /* Get all relevant buffers */
    assign
      extent(hTempTabelBuffer#)      = hQueryIP#:num-buffers
      extent(hSplitTempTableBuffer#) = hQueryIP#:num-buffers.
    
    do iBuffer# = 1 to hQueryIP#:num-buffers:
      assign
        hTempTabelBuffer#[iBuffer#]      = hQueryIP#:get-buffer-handle(iBuffer#)
        hSplitTempTableBuffer#[iBuffer#] = hSplitDataset#:get-buffer-handle(hTempTabelBuffer#[iBuffer#]:name). 
    end.   
    
    /*    FOR EACH ttBeetje  WHERE ttBeetje.relatieveldje=ttAatje.relatieveldje*/

    hQueryIP#:get-first().
    
/*    hDatasetIP#:get-buffer-handle(1):find-first("").                     */
/*    message hDatasetIP#:get-buffer-handle(1):buffer-field(2):buffer-value*/
/*      view-as alert-box.                                                 */
    
    message hQueryIP#:get-buffer-handle:buffer-field(1):buffer-value
      view-as alert-box.
    
    
    do while not hQueryIP#:query-off-end:
      
      message 1
        view-as alert-box.
      
      
      do iBuffer# = 1 to hQueryIP#:num-buffers:

      message 1 skip iBuffer# skip "buffer"
        view-as alert-box.

        
        hSplitTempTableBuffer#[iBuffer#]:buffer-create.
        
        do iField# = 1 to hSplitTempTableBuffer#[iBuffer#]:num-fields:
          
        message 1 skip iField# skip "field"
          view-as alert-box.
          
          
          hSplitTempTableBuffer#[iBuffer#]:buffer-field(iField#) = hTempTabelBuffer#[iBuffer#]:buffer-field(iField#).
        end.  
                
        hSplitTempTableBuffer#[iBuffer#]:buffer-release.
              
      end.
      
      hQueryIP#:get-next().
      
    end.      
     
    hSplitDataset#:write-xml(
      "File", /* mode */
      cOutputFileIP#, /* file */
      yes,     /* formatted */
      "utf-8", /* encoding */
      "",      /* schema location */
      no,      /* write xml schema */
      no,      /* min-xmlschema */
      no,      /* write-before-image */
      no       /* omit initial values */
      ).
              
  end method. /* WriteXmlAndSplit */

end class.

/* EOF */ 
