{panaedra/msroot/msutil/logic/top_i/ctop_interface.i} 

interface panaedra.msroot.msutil.interfaces.i_unittest_client:  

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive:  $ 
          Version: $Revision:  $ 
       Programmer: $Author: $ 
     Date Checkin: $Date:  $ 
    Date Modified: $Modtime:  $ 

      Description: Unittest client interface

  \*****************************  Include Files ********************************/

  /******************************* $NoKeywords:  $ *****************************/

  method public void GetUnittests(output cSvUnittestsOP# as character).
  method public void ExecuteUnittest(input cUnittestIP# as character).
  
end interface.

/* EOF */ 
