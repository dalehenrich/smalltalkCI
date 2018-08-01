accessing
at: aGlobalName put: anObject
  ^ (GsSession currentSession symbolList objectNamed: #'UserGlobals')
    at: aGlobalName
    put: anObject