class organization
classesInPackage: packageName
	| projectWithPackage package |
	projectWithPackage := Rowan projects
		detect: [ :project | (project packageNamed: packageName ifAbsent: [  ]) notNil ]
		ifNone: [ #() ].
	package := projectWithPackage packageNameNamed: packageName.
	^ package classDefinitions keys
		collect: [ :className | Rowan globalNamed: className ]