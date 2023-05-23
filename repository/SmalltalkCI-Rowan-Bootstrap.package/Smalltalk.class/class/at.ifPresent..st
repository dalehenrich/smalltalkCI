accessing
at: aSymbol ifPresent: aBlock
	^ (System myUserProfile objectNamed: aSymbol)
		ifNotNil: [ :global | aBlock cull: global ]