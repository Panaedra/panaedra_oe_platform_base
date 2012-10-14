{panaedra/msroot/msutil/logic/top_i/ctop_interface.i}

interface panaedra.msroot.msmonitor.interfaces.i_msmon_idispatch:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $
          Version: $Revision:  $
       Programmer: $Author: $
     Date Checkin: $Date:  $
    Date Modified: $Modtime:  $

      Description: interface for tempfiles for use in msmon_feedback

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/


  method public logical DispatchFeedbackMessage(
    hBuffTtMsMonFeedbackDefIP# as handle,
    cOverrideValueIP#          as character,
    cTempFileIP#               as character,
    cErrorFileIP#              as character,
    cMonitorIdIP#              as character,
    cMessageIP#                as character,
    cEventIP#                  as character,
    cLocationIP#               as character
    ).
   

end interface.

/* EOF */ 
