*smalltalkci-gemstone64-core
writeToFile
	[ | file |
	  file := GsFile openWriteOnServer: self xmlFilePath.
 	  file nextPutAll: stream contents ]
		ensure: [ file ifNotNil: [ file close ] ].
