*smalltalkci-gemstone64-core
forceNewFileNamed: aFile
  (GsFile openWriteOnServer: aFile) ifNotNil: [:file | file close].
