helpers
xmlFileNamed: aName in: aPath
  | fileName |
  fileName := aName, '.xml'.
  aPath ifNotNil: [
	^ aPath, SmalltalkCI pathNameDelimiter, fileName ].
  ^ ((Smalltalk at: #System) gemEnvironmentVariable: 'SMALLTALK_CI_BUILD')
    ifNotNil: [ :smalltalk_ci_build | smalltalk_ci_build , SmalltalkCI pathNameDelimiter, fileName ]
    ifNil: [ fileName ]
