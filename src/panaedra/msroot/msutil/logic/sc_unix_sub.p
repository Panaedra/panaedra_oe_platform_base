{panaedra/msroot/msutil/logic/top_i/ptop_procedure.i}

  /****************************** Source Header ********************************\

    Description: Unix shared objects externals. Don't use this sub procedure directly.

\*****************************  Include Files ********************************/

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

procedure abl_signal_threadmask_apply external "panaedra/msroot/msutil/bin_aix/ms_abl_signal_threadmask.so" persistent:
  define return parameter iReturnOP#  as long.
end procedure.

procedure abl_signal_threadmask_reset external "panaedra/msroot/msutil/bin_aix/ms_abl_signal_threadmask.so" persistent:
  define return parameter iReturnOP#  as long.
end procedure.

/* EOF */
