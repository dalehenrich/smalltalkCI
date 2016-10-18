*smalltalkci-gemstone64-core
addToSuiteFromSelectors: suite
  ^ self addToSuite: suite fromMethods: (self shouldInheritSelectors
        ifTrue: [ self allTestSelectors ]
        ifFalse: [ self testSelectors ])
