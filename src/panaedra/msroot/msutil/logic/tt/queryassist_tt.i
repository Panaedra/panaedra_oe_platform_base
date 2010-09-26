/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: panaedra/msroot/msutil/logic/tt/queryassist_tt.i $
        Version: $Revision: 2 $
     Programmer: $Author: $
   Date Checkin: $Date: 2008-03-01 10:31:58+01:00 $
  Date Modified: $Modtime: 2008-03-01 10:31:49+01:00 $
  
    Description: Dummy ttAssistNN temp-tables.
                 Bedoeld voor queries met omgekeerde inner-join.
                 Vb. for each A, each B of A outer-join, first ttAssist01 where rowid(B) = ?.
                 Deze include wordt ook opgenomen in query analyze tools,
                 zoals rp/gui/query-tester.w. 
    
\**************************** End of Dvcs_ Header ****************************/
&if defined(dvcs__def_ttassist_i) = 0 &then
&glob dvcs__def_ttassist_i
procedure dvcs__def_ttassist_i: return "$Revision: 1 $". end.
/******************************* $NoKeywords:  $ *****************************/

def temp-table ttAssist01 no-undo field bAssist as log.
create ttAssist01.
def temp-table ttAssist02 no-undo field bAssist as log.
create ttAssist02.
def temp-table ttAssist03 no-undo field bAssist as log.
create ttAssist03.
def temp-table ttAssist04 no-undo field bAssist as log.
create ttAssist04.
def temp-table ttAssist05 no-undo field bAssist as log.
create ttAssist05.

&endif /* dvcs__def_ttassist_i */
/* EOF */
