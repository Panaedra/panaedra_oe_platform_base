&if not (opsys = "unix" or "{&window-system}" = "tty") &then
&if no &then
/******************************  Dvcs_ Header ********************************\
       Filename: $Archive: /ont/src/paninui/logic/includes/c_frmlg_eventhandling.i $ 
        Version: $Revision: 7 $ 
     Programmer: $Author: $ 
   Date Checkin: $Date: 2010-08-22 15:30:38+02:00 $ 
  Date Modified: $Modtime: 2010-08-22 04:25:04+02:00 $ 

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
                 
          Notes: "Ctrl-I-Fix" fixes formatting errors in the Eclipse OpenEdge editor, when pressing Ctrl-I 
                 which auto-indents the source code. The fix is very sensitive; " Ctrl-I-Fix " does not work 
                 as comment, and "Ctrl-I-Fix" (without spaces) *does* work. OE11.3win32 2015Q4. 
                 The fix was especially needed for the JoinUiExceptionCatches preprocessor in frame logic classes.

\**************************** End of Dvcs_ Header ****************************/
&endif &glob ~
    sourcecontrolversions {&sourcecontrolversions} | paninui_logic_includes_c_frmlg_eventhandling_i $Revision: 7 $
&if no &then 
/*$NoKeywords:  $*/ 
&endif &glob JoinUiNull ~
    System.Object
&glob JoinUiCallParm oNullIP# as {&JoinUiNull} 
&glob JoinUiEventClass ~
    /*Ctrl-I-Fix*/ ~~n~
    inherits tool.c-frm-join_base implements tool.i-frm-join
&glob JoinUiEventCodeHeader ~
    /*Ctrl-I-Fix*/ ~~n~
    def var o-joinhelp as c_delegate_helper no-undo. ~~n~
    def var iDelegateID# as int64 no-undo.
&glob JoinUiExceptionCatches ~
    /*Ctrl-I-Fix*/ ~~n~
    catch oException# as System.Exception: ~~n~
      sc_showexception:ShowException(oException#). ~~n~
    end catch. ~~n~
    catch oError# as Progress.Lang.Error: ~~n~
      sc_showexception:ShowException(oError#). ~~n~
    end catch. ~~n
&glob JoinUiEventCode ~~n~
    /*Ctrl-I-Fix*/ ~~n~
    o-joinhelp = sc_coll_delegatedata:JoinInit(this-object,c_eventtype:~{&JoinUiWidget}_~{&JoinUiEvent}). ~~n~
    o-joinhelp:JoinEvent:subscribe(On_~{&JoinUiWidget}_~{&JoinUiWidgetName}_~{&JoinUiEvent}). ~~n~
    iDelegateID# = sc_coll_delegatedata:JoinFinish(this-object,o-joinhelp). ~~n~
    delete object o-joinhelp. ~~n~
    paninui.view.use.sc_coll_eventdata:ItemAdd( ~~n~
        paninui.view.interfaces.sc_widgettype:i_~{~&JoinUiWidget}, ~~n~
        this-object:iPackID, this-object:iFrmLogicID, ~~n~
        iDelegateID#, ~{~&JoinUiLogicObject}, "~{~&JoinUiWidgetName}", "~{~&JoinUiEvent}"  ~{&JoinUiEventOptions}). ~~n~
&glob JoinUiEventCodeFooter ~~n~
    /*Ctrl-I-Fix*/ ~~n
using Progress.Lang.*.
using paninui.view.init.delegates.* from assembly. 
using paninui.view.enums.* from assembly. 
using paninui.view.eventargs.* from assembly. 
using paninui.view.use.delegates.* from assembly. 
using paninui.view.use.*.
using paninui.view.use.display.*.
using paninui.view.use.events.*. 
using paninui.view.interfaces.*.
&else
/*Ctrl-I-Fix*/ ~~n~
using paninui.view.use.*.
using paninui.view.use.display.*.
using paninui.view.use.events.*. 
using paninui.view.interfaces.*.
using paninui.view.interfaces_tty.*.
&endif
/* EOF : paninui/logic/includes/c_frmlg_eventhandling.i */
