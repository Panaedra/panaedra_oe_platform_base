{panaedra/msi/logic/ptop_procedure.i}

/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/c_file_stream_sub.p $ 
        Version: $Revision: 1 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-11-05 14:24:54+01:00 $ 
  Date Modified: $Modtime: 2009-11-05 14:22:37+01:00 $ 

    Description: Used a help procedure for c_file_stream.cls

\**************************** End of Dvcs_ Header ****************************/
&scop dvcs_proc procedure dvcs__panaedra_msroot_msutil_logic_c_file_stream_sub_p: return "$Revision: 1 $". end.
{&dvcs_proc}
/******************************* $NoKeywords:  $ *****************************/
def stream s-stream.

def output param hStreamOP# as handle no-undo.

hStreamOP# = stream s-stream:handle.


/* EOF */
