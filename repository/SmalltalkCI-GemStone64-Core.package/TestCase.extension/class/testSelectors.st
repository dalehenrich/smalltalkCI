*smalltalkci-gemstone64-core
testSelectors
  ^ self sunitSelectors
    select: [ :each | ('test*' sunitMatch: each) and: [ each numArgs == 0 ] ]
