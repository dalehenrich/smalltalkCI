accessing
at: aSymbol
	^ (System myUserProfile objectNamed: aSymbol)
		ifNil: [ self error: 'No global named: ' , aSymbol printString , ' found.' ]