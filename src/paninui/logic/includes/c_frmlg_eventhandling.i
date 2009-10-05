&if no &then
/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/paninui/logic/includes/c_frmlg_eventhandling.i $ 
        Version: $Revision: 3 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2009-10-05 14:48:49+02:00 $ 
  Date Modified: $Modtime: 2009-10-05 13:48:45+02:00 $ 

    Description: JoinUi uilogic class preprocessors.

                 For unix compatibility in the future.
              
                 Annotation: 
                 @_FCMPNY_ file(joinui_method="yes"). 
                 could be used, so we can generate a joinui layer on 
                 unix (which can't use delegates or events in 10.2A).
                 On the other hand: we can probably do without, this
                 makes the code less bloated.
                 
                 We can make classes for unix in a different namespace
                 and make an ABL class for the JoinUI and EvtInfo classes
                 (amongst others).
              
                 In .Net, a c_delegate_helper is used to get a delegate (pointer/prototype to a method).  
                
                 This include's formatting (no linebreaks between commands, no EOF tag, and the ~~n's) is
                 optimized for neat preprocessed code.

\**************************** End of Dvcs_ Header ****************************/
&endif &glob ~
    sourcecontrolversions {&sourcecontrolversions} | paninui_logic_includes_c_frmlg_eventhandling_i $Revision: 3 $
&if no &then 
/*$NoKeywords:  $*/ 
&endif &glob JoinUiSystemObject ~
    System.Object
&glob JoinUiCallParm oNullIP# as {&JoinUiSystemObject} 
&glob JoinUiEventClass ~
    inherits tool.c-frm-join_base implements tool.i-frm-join
&glob JoinUiEventCodeHeader ~
    def var o-joinhelp as c_delegate_helper no-undo. ~~n~
    def var iDelegateID# as int64 no-undo.
&glob JoinUiEventCode ~~n~
    o-joinhelp = sc_coll_delegatedata:JoinInit(this-object,c_eventtype:~{&JoinUiWidget}_~{&JoinUiEvent}). ~~n~
    o-joinhelp:JoinEvent:subscribe(On_~{&JoinUiWidget}_~{&JoinUiWidgetName}_~{&JoinUiEvent}). ~~n~
    iDelegateID# = sc_coll_delegatedata:JoinFinish(this-object,o-joinhelp). ~~n~
    delete object o-joinhelp. ~~n~
    paninui.view.use.sc_coll_eventdata:ItemAdd( ~~n~
        paninui.view.interfaces.sc_widgettype:i_~{~&JoinUiWidget}, ~~n~
        this-object:iPackID, this-object:iFrmLogicID, ~~n~
        iDelegateID#, ~{~&JoinUiLogicObject}, "~{~&JoinUiWidgetName}", "~{~&JoinUiEvent}"). ~~n~
&glob JoinUiEventCodeFooter 
using Progress.Lang.*.
&if opsys <> "unix" &then using paninui.view.init.delegates.* from assembly. 
using paninui.view.eventargs.* from assembly. 
using paninui.view.enums.* from assembly. 
using paninui.view.use.delegates.* from assembly. &endif
/* EOF : paninui/logic/includes/c_frmlg_eventhandling.i */
