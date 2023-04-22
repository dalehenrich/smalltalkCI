compatibility
readOnlyFileNamed: aFilename do: aBlock
	| fullName |
	fullName := aFilename asFileReference pathString.
	(GsFile _exists: fullName onClient: false)
		ifFalse: [ ^ self error: 'File named: ' , fullName printString , ' does not exist.' ].
	^ GsFile openReadOnServer: fullName