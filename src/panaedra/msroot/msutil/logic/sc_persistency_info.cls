{panaedra/msi/logic/ctop_class.i} 
using panaedra.msroot.msutil.logic.*.
using panaedra.msroot.msutil.interfaces.*.
using panaedra.msf.logic.*.

class panaedra.msroot.msutil.logic.sc_persistency_info   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/sc_persistency_info.cls $ 
          Version: $Revision: 1 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2009-10-15 10:16:07+02:00 $ 
    Date Modified: $Modtime: 2009-10-15 10:14:37+02:00 $ 

      Description: Uses the session handle to find persistent buffers, procedures, or objects.
                   Very useful for checking if you didn't forget to clean something up.

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public sc_persistency_info(o-sourcecontrol as panaedra.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 1 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/
  
  define protected static temp-table ttPersistentThings no-undo rcode-info
    field cType              as char
    field cName              as char
    field cInstantiatingProc as char
    field hHandle            as handle
    /*    field oObject            as Progress.Lang.Object*/
    index cType_cName cType cName.
  

  method public static void ShowAllPersistentThings():

    empty temp-table ttPersistentThings.
    
    do on error undo, throw:
    
      FillPersistentObjects().
    /*    catch ex as Progress.Lang.Error :                                                                                                */
    /*      do on error undo, throw:                                                                                                       */
    /*        System.Windows.Forms.MessageBox:SHow(subst("nog maar een catch &1 &2", program-name(1) , ex:getMessage(1))).                 */
    /*        process events.                                                                                                              */
    /*        catch exIn as Progress.Lang.Error :                                                                                          */
    /*          System.Windows.Forms.MessageBox:SHow(subst("nog maar een catch in een catch &1 &2", program-name(1) , exIn:getMessage(1))).*/
    /*        end catch.                                                                                                                   */
    /*      end.                                                                                                                           */
    /*    end catch.                                                                                                                       */
    
    end.
    FillPersistentProcedures().
    FillBuffers().
    FillDatasets().
    FillQueries().

    ShowTempTable().

  end method. /* ShowAllPersistentThings */


  method public static void ShowPersistentObjects():
    
    empty temp-table ttPersistentThings.

    FillPersistentObjects().

    ShowTempTable().

  end method. /* ShowPersistentObjects */


  method protected static void ShowTempTable():
    
    if sc_html:TempTableToHTML(buffer ttPersistentThings:handle, sc_path:cTempDir + "PersistentThings.html") then 
      &if opsys <> "unix" &then
      sc_win32:ShellExecute(sc_path:cTempDir + "PersistentThings.html")
      &else
    message "Open the following file yourself: " sc_path:cTempDir + "PersistentThings.html"
      view-as alert-box.
      &endif
    . /* Show HTML file */

  end method. /* ShowPersistentObjects */


  method protected static void FillPersistentObjects():
    
    define variable oObj#     as Progress.Lang.Object no-undo.
    define variable oObjNext# as Progress.Lang.Object no-undo.
    define buffer ttPersistentThings for ttPersistentThings.
    
    do for ttPersistentThings on error undo, throw:
      
      oObj# = session:first-object.
      
      do while valid-object(oObj#):
        oObjNext# = oObj#:next-sibling. /* Because it could in theory be deleted in the meantime */
        create ttPersistentThings.
        assign 
          ttPersistentThings.cType = "Object"
          ttPersistentThings.cName = oObj#:ToString()
          /*          ttPersistentThings.oObject = oObj#*/
          .
        if type-of(oObj#,paninui.view.init.display.c_bindingsource) then 
        do on error undo, throw:
/*          if retry then do:                                                                        */
/*            System.Windows.Forms.MessageBox:SHow(subst("eerste subretry &1 &2", program-name(1) )).*/
/*            end.                                                                                   */
/*            System.Windows.Forms.MessageBox:SHow(subst("voor delete &1 &2", program-name(1) )).    */
          DeleteBindingSource(cast(oObj#,paninui.view.init.display.c_bindingsource)).
/*          process events.                                                                    */
/*          pause 0 before-hide no-message.                                                    */
/*            System.Windows.Forms.MessageBox:SHow(subst("na delete &1 &2", program-name(1) )).*/
          /*          delete object oObj#.                                                       */
          /*                    cast(oObj#,paninui.view.init.display.c_bindingsource):Handle = ?.*/
          /*                    cast(oObj#,paninui.view.init.display.c_bindingsource):Dispose(). */
/*          catch ex as Progress.Lang.Error :                                                                          */
/*            System.Windows.Forms.MessageBox:SHow(subst("eerste subcatch &1 &2", program-name(1) , ex:getMessage(1))).*/
/*          end catch.                                                                                                 */
/*          finally:                                                                                                   */
/*            System.Windows.Forms.MessageBox:SHow(subst("eerste subfinally &1 &2", program-name(1) )).                */
/*                                                                                                                     */
/*          end.                                                                                                       */
        end.
        oObj# = oObjNext#.
      end.
       
/*          catch ex2 as Progress.Lang.Error :                                                                                          */
/*            System.Windows.Forms.MessageBox:SHow(subst("nog een catch &1 &2 &3", program-name(1) , ex2:getMessage(1), ex2:CallStack)).*/
/*          end catch.                                                                                                                  */
    end.
    
  end method. /* FillPersistentObjects */
  
  
  method public static void DeleteBindingSource (oBindingSourceIP# as paninui.view.init.display.c_bindingsource):
    do on error undo, throw:
      if valid-object(oBindingSourceIP#) then
        delete object oBindingSourceIP#.
/*      catch e as Progress.Lang.Error :*/
/*                                      */
/*      end catch.                      */
    
    end.
  end method. /* DeleteBindingSource */  

  method protected static void FillPersistentProcedures():
    
    define variable hProc# as handle no-undo.
    define buffer ttPersistentThings for ttPersistentThings.
    
    do for ttPersistentThings:
      
      hProc# = session:first-procedure.
      
      do while valid-handle(hProc#):
        create ttPersistentThings.
        assign 
          ttPersistentThings.cType   = "Procedure"
          ttPersistentThings.cName   = hProc#:file-name
          ttPersistentThings.hHandle = hProc#.
        hProc# = hProc#:next-sibling.
      end.
       
    end.
    
  end method. /* FillPersistentProcedures */


  method protected static void FillBuffers():
    
    define variable hBuff# as handle no-undo.
    define buffer ttPersistentThings for ttPersistentThings.
    
    do for ttPersistentThings:
      
      hBuff# = session:first-buffer.
      
      do while valid-handle(hBuff#):
        create ttPersistentThings.
        assign 
          ttPersistentThings.cType   = "Buffer"
          ttPersistentThings.cName   = hBuff#:name
          ttPersistentThings.hHandle = hBuff#.
        assign
          ttPersistentThings.cInstantiatingProc = hBuff#:instantiating-procedure:file-name no-error.
        hBuff# = hBuff#:next-sibling.
      end.
       
    end.
    
  end method. /* FillBuffers */


  method protected static void FillDatasets():
    
    define variable hDs# as handle no-undo.
    define buffer ttPersistentThings for ttPersistentThings.
    
    do for ttPersistentThings:
      
      hDs# = session:first-dataset.
      
      do while valid-handle(hDs#):
        create ttPersistentThings.
        assign 
          ttPersistentThings.cType   = "Dataset"
          ttPersistentThings.cName   = hDs#:name
          ttPersistentThings.hHandle = hDs#.
        assign
          ttPersistentThings.cInstantiatingProc = hDs#:instantiating-procedure:file-name no-error.
        hDs# = hDs#:next-sibling.
      end.
       
    end.
    
  end method. /* FillDatasets */


  method protected static void FillQueries():
    
    define variable hQuery# as handle no-undo.
    define buffer ttPersistentThings for ttPersistentThings.
    
    do for ttPersistentThings:
      
      hQuery# = session:first-query.
      
      do while valid-handle(hQuery#):
        create ttPersistentThings.
        assign 
          ttPersistentThings.cType   = "Query"
          ttPersistentThings.cName   = hQuery#:name
          ttPersistentThings.hHandle = hQuery#.
        assign
          ttPersistentThings.cInstantiatingProc = hQuery#:instantiating-procedure:file-name no-error.
        if ttPersistentThings.cName = ? or ttPersistentThings.cName = "" then
          ttPersistentThings.cName = hQuery#:prepare-string no-error.
        if ttPersistentThings.cName = ? or ttPersistentThings.cName = "" then
          ttPersistentThings.cName = hQuery#:get-buffer-handle(1):name no-error.
        if ttPersistentThings.cName = ? or ttPersistentThings.cName = "" then
          ttPersistentThings.cName = hQuery#:get-buffer-handle(1):table no-error.
        if ttPersistentThings.cName = ? or ttPersistentThings.cName = "" then
          ttPersistentThings.cName = hQuery#:get-buffer-handle(1):table-handle:name no-error.
        if ttPersistentThings.cName = ? or ttPersistentThings.cName = "" then
          ttPersistentThings.cName = subst("Unknown query &1",(if hQuery#:is-open then ", is open" else ", is not open")).
        hQuery# = hQuery#:next-sibling.
      end.
       
    end.
    
  end method. /* FillQueries */


end class.

/* EOF */ 
