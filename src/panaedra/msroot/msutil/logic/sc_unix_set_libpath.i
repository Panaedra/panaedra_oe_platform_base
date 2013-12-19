/******************************  Dvcs_ Header ********************************\

    Description: Set the LIBPATH environment variable. 
                 It's reset on AIX because of the setuid flag 
                 on "_progres" (and appserver/other binaries)
                 
                 Needed for "external" procedures that reference shared objects with dependencies.

******************************** $NoKeywords:  $ *****************************/

&if opsys = "unix" &then
if length(os-getenv("LIBPATH")) > 0 then.
else sc_unix:SetEnvironmentValue("LIBPATH","/opt/freeware/openssl_64/lib:/opt/freeware/lib64:/opt/freeware/lib:/usr/lib"). /* codeQok#7303 */
&endif

/* EOF : panaedra/msroot/msutil/logic/sc_unix_set_libpath.i */
