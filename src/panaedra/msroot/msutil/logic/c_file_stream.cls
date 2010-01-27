{panaedra/msroot/msutil/logic/top_i/ctop_class.i} 

class panaedra.msroot.msutil.logic.c_file_stream   : 

  /******************************  Dvcs_ Header ********************************\
         Filename: $Archive: /ont/src/panaedra/msroot/msutil/logic/c_file_stream.cls $ 
          Version: $Revision: 2 $ 
       Programmer: $Author: $ 
     Date Checkin: $Date: 2010-01-27 21:10:16+01:00 $ 
    Date Modified: $Modtime: 2010-01-27 19:30:14+01:00 $ 

      Description: Use this for passing stream within classes, create a new instance
                   of this object to access the stream-handle hStream

  \*****************************  Include Files ********************************/

  /************************  Source control constructor ************************/
  constructor public c_file_stream(o-sourcecontrol as panaedra.msroot.msv.logic.c_sourcecontrol, o-inheritant as Progress.Lang.Object):
    /* Uncomment when inheriting: super(o-sourcecontrol, this-object).*/
    panaedra.msroot.msv.logic.c_sourcecontrol:Construct_SRVR_ll(o-sourcecontrol, this-object, o-inheritant, '$Revision: 2 $', '{&sourcecontrolversions}').
  end constructor.
  /******************************* $NoKeywords:  $ *****************************/

  define public    property hStream         as handle get. set.
  define protected property hPersistentProc as handle get. set.

  constructor public c_file_stream():
    
    define variable hProc#   as handle no-undo.
    define variable hStream# as handle no-undo.
    
    /* Contains stream */
    run panaedra/msroot/msutil/logic/c_file_stream_sub.p persistent set hProc# (output hStream#).
    
    assign 
      hPersistentProc = hProc#
      hStream         = hStream#.
    
  end constructor.


  destructor public c_file_stream():
    
    if valid-handle(hPersistentProc) then 
      panaedra.msroot.msutil.logic.sc_procedurehandles:DeleteProcedure(hPersistentProc).

  end destructor.

end class.

/* EOF */ 
