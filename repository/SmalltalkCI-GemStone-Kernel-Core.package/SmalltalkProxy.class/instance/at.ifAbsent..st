accessing
at: aGlobalName ifAbsent: aBlock
  | glob |
  aGlobalName isNil
    ifTrue: [ ^ aBlock value ].
  glob := GsSession currentSession symbolList objectNamed: aGlobalName.
  ^ glob == nil
    ifTrue: [ aBlock value ]
    ifFalse: [ glob ]