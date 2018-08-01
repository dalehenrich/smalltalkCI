accessing
removeKey: aGlobalName ifAbsent: aBlock
  ^ (GsSession currentSession symbolList objectNamed: #'UserGlobals')
    removeKey: aGlobalName
    ifAbsent: aBlock