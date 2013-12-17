{panaedra/msroot/msutil/logic/top_i/ptop_procedure.i}

/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: $ 
        Version: $Revision: $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: $ 
  Date Modified: $Modtime: $ 

    Description: Unix shared objects externals. Don't use this sub procedure directly.

\**************************** End of Dvcs_ Header ****************************/
&scop dvcs_proc procedure dvcs__panaedra_msroot_msutil_logic_sc_unix_sub_p: return "$Revision: $". end.
{&dvcs_proc}
/******************************* $NoKeywords:  $ *****************************/

procedure usleep external "panaedra/msroot/msutil/bin_aix/microsleep_64.so" persistent:
  define input  parameter iMsIP#     as long.
  define return parameter iReturnOP# as long.
end procedure.

procedure setenvironmentvalue external "panaedra/msroot/msutil/bin_aix/ms_setenv_64.so" persistent:
  define input parameter  cTokenIP#   as character.
  define input parameter  cValueIP#   as character.
  define return parameter iReturnOP#  as long.
end procedure.

/* EOF */
