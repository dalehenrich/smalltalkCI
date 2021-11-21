Class {
	#name : 'SCIGoferLoadSpec',
	#superclass : 'SCIAbstractLoadSpecWithCredentials',
	#instVars : [
		'url',
		'packages',
		'versions',
		'loadedClasses'
	],
	#category : 'SmalltalkCI-Core'
}

{ #category : 'executing' }
SCIGoferLoadSpec >> addLoadedClassesFrom: goferReferences [
	self loadedClasses addAll: (
		SmalltalkCI classesWithPackageNames: (
			goferReferences collect: [ :ref | ref packageName ] ))
]

{ #category : 'executing' }
SCIGoferLoadSpec >> basicLoadProjectOn: aSmalltalkCI [
	| gofer |
	gofer := Gofer new.
	gofer url: self url username: self user password: self password.
	self packages do: [ :package | gofer package: package].
	self versions do: [ :version | gofer version: version ].
	gofer load.
	self addLoadedClassesFrom: gofer references
]

{ #category : 'testing' }
SCIGoferLoadSpec >> isComplete [
	self url ifNil: [ ^ false ].
	((self packages isNil or: [ self packages isEmpty ]) and: [
		self versions isNil or: [ self versions isEmpty ] ])
			ifTrue: [ ^ false ].
	^ true
]

{ #category : 'accessing' }
SCIGoferLoadSpec >> loadedClasses [

	^ loadedClasses ifNil: [ loadedClasses := Set new ]
]

{ #category : 'accessing' }
SCIGoferLoadSpec >> loadedClasses: anObject [

	loadedClasses := anObject
]

{ #category : 'accessing' }
SCIGoferLoadSpec >> packages [

	^ packages ifNil: [ packages := OrderedCollection new ]
]

{ #category : 'accessing' }
SCIGoferLoadSpec >> packages: anObject [

	packages := anObject
]

{ #category : 'accessing' }
SCIGoferLoadSpec >> password [

	^ super password ifNil: ['']
]

{ #category : 'accessing' }
SCIGoferLoadSpec >> url [

	^ url
]

{ #category : 'accessing' }
SCIGoferLoadSpec >> url: anObject [

	url := anObject
]

{ #category : 'accessing' }
SCIGoferLoadSpec >> user [

	^ super user ifNil: ['']
]

{ #category : 'accessing' }
SCIGoferLoadSpec >> versions [

	^ versions ifNil: [ versions := OrderedCollection new ]
]

{ #category : 'accessing' }
SCIGoferLoadSpec >> versions: anObject [

	versions := anObject
]
