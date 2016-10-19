/****************************** Source Header ********************************\

    Description: Default catch blocks. 
                 Replacement for {&JoinUiExceptionCatches}, when Ctrl+I messes up.

\******************************* $NoKeywords:  $ *****************************/
    catch oException# as System.Exception:
      sc_showexception:ShowException(oException#).
    end catch.
   
    catch oError# as Progress.Lang.Error: 
      sc_showexception:ShowException(oError#).
    end catch.
/* EOF : paninui/logic/includes/paninui_catchblocks.i */
