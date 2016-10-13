*smalltalkci-gemstone-core
hash: aString length: aLength
	^ aString hash asHexString asLowercase first: aLength
