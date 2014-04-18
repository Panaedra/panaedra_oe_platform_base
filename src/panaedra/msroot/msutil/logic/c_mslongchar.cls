class panaedra.msroot.msutil.logic.c_mslongchar: 

  /******************************  Dvcs_ Header ********************************\

      Description: Helper object, to pass longchars by-reference

  ******************************** $NoKeywords:  $ *****************************/
  
  define public property clobValue as longchar no-undo get. set.
  
  constructor c_mslongchar(clobValueIP# as longchar):
    clobValue = clobValueIP#.
  end constructor.

end class.

/* EOF */ 
