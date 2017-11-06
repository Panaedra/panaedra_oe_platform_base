using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msroot.mspy.logic.*.

/* Simple pythonbridge example, with it's own bootstrapping for safe session exit */

define variable bSessionQuitPS#     as logical no-undo.
define variable bSessionQuittingPS# as logical no-undo.

b_bootstrap:
do on quit undo, retry
  on stop undo, retry:
  if retry then 
  do:
    bSessionQuitPS# = true.
    if not bSessionQuittingPS# then 
    do:
      bSessionQuittingPS# = true.
      sc_eventbroadcaster:FireEvent("evt@SessionClose").
    end.
    leave b_bootstrap.
  end.
  run bootSession in this-procedure.
end.
quit.

procedure bootSession:

  do on error undo, throw
    on stop undo, retry:
      
    if retry then undo, throw new c_panaedraexception(10101010, sc_lang:oEnglish, "STOP Condition").
    
    message "Hello python world" skip
      "os-getenv PYTHONPATH:" skip
      replace(os-getenv("PYTHONPATH"),";","~n")
      view-as alert-box.

    message "Via bridge:" skip
      sc_mspython:PyEval("import os,json;cDataOP=json.dumps(~{x:y for x,y in os.environ.items() if 'PYTHON' in x~},indent=2)", "")
      view-as alert-box.

    do while true:
      /* For your own test, try a divide by 0 below to throw a python exception */
      message
        sc_mspython:PyEval("cDataOP=str(11.0/3)", "")  skip
        "Press Ctrl+Pause(Break) or Ctrl+C (unix) to exit the loop"
        view-as alert-box.
      message
        sc_mspython:PyEval("cDataOP=str(2**int(cDataIP))", string(random(1,10))) skip
        "Press Ctrl+Pause(Break) or Ctrl+C (unix) to exit the loop"
        view-as alert-box.
    end.
    
    catch oError# as Progress.Lang.Error:
      sc_showexception:ShowException("Caught but we continue...", oError#).
    end catch.
    
  end.

  quit. /* This will trigger the on quit from the panaedra boilerplate */
  
end procedure. /* bootSession */

/* EOF */
