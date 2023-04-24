class organization
classesInPackage: packageName
	| projectWithPackage loadedPackage |
	projectWithPackage := Rowan projects
		detect: [ :project | (project packageNamed: packageName ifAbsent: [  ]) notNil ]
		ifNone: [ #() ].
	loadedPackage := projectWithPackage _loadedProject loadedPackages at: packageName. "v2 api deficiency"
	^ loadedPackage loadedClasses keys
		collect: [ :className | Rowan globalNamed: className ]