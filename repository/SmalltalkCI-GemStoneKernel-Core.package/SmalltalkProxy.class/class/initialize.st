initialization
initialize
  "SmalltalkProxy initialize"

  | userGlobals |
  userGlobals := GsSession currentSession symbolList objectNamed: #'UserGlobals'.
  userGlobals at: #'Smalltalk' put: self new.
