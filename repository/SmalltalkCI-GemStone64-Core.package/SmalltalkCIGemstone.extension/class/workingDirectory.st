*smalltalkci-gemstone64-core
workingDirectory
	^ GsFile _expandEnvVariable: 'PWD' isClient: false
