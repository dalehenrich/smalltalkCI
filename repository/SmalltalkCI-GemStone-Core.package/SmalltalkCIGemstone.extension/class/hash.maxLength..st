*smalltalkci-gemstone-core
hash: aString maxLength: aLength
	^ aString hash asHexString asLowercase truncateTo: aLength
