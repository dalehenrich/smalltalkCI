compatibility
hash: aString maxLength: aLength
"
	^ aString hash asHexString asLowercase truncateTo: aLength
"
self error: 'not yet implemented'
