*smalltalkci-gemstone64-core
addToSuite: suite fromMethods: testMethods
  testMethods do: [ :selector | suite addTest: (self selector: selector) ].
  ^ suite
