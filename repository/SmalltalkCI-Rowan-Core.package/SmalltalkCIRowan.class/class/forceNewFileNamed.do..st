compatibility
forceNewFileNamed: aFile do: aBlock
	^ aFile asFileReference writeStreamDo: aBlock