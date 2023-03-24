ansi
ansiBlue
  ^ self isColorful
    ifTrue: [ 
      System waitForDebug.
      self escape , '[34m' ]
    ifFalse: [ '' ]