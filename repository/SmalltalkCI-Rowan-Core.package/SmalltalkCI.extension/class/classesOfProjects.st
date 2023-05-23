*smalltalkci-rowan-core
classesOfProjects: projectList
	| classes |
	classes := Set new.
	projectList
		do: [ :projectName | 
			(Rowan projectNamed: projectName) packages
				do: [ :package | 
					package _loadedPackage classDefinitions keys
						do: [ :className | classes add: (Rowan globalNamed: className) ] ] ].
	^ classes
