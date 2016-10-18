*smalltalkci-gemstone64-core
hash: aString maxLength: aLength
  | str |
  str := aString hash asHexString asLowercase.
  ^ str size <= aLength
      ifTrue: [ str ]
      ifFalse: [ str copyFrom: 1 to: aLength ]
