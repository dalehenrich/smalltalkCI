Class {
	#name : 'SCIMetacelloLoadSpec',
	#superclass : 'SCIAbstractLoadSpecWithCredentials',
	#instVars : [
		'baseline',
		'configuration',
		'directory',
		'failOn',
		'load',
		'onWarningLog',
		'onConflict',
		'onUpgrade',
		'repository',
		'version',
		'useLatestMetacello',
		'ignoreImage'
	],
	#category : 'SmalltalkCI-Core'
}

{ #category : 'compatibility' }
SCIMetacelloLoadSpec class >> isPlatformCompatible [
	self subclassResponsibility
]

{ #category : 'instance creation' }
SCIMetacelloLoadSpec class >> new [
	^ self platformClass basicNew 
		initialize
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec class >> platformClass [
	"There will be just one subclass installed (for each platform)"
	^ self allSubclasses detect: [ :cl | cl isPlatformCompatible ]
]

{ #category : 'helpers' }
SCIMetacelloLoadSpec class >> updateMetacello [
	(Smalltalk at: #Metacello) new
		baseline: 'Metacello';
		repository: 'github://Metacello/metacello:master/repository';
		get.
	(Smalltalk at: #Metacello) new
		baseline: 'Metacello';
		repository: 'github://Metacello/metacello:master/repository';
		load: #( 'batch' )
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> baseline [
	^ baseline
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> baseline: aBaseline [
	baseline := aBaseline
]

{ #category : 'executing' }
SCIMetacelloLoadSpec >> basicLoadProjectOn: aSmalltalkCI [
	| metacello metacelloPassword metacelloUser |
	
	aSmalltalkCI class requireMetacello.
	self updateMetacelloIfRequested.
	
	metacello := (Smalltalk at: #Metacello) new.
	metacello
		repository: (self repository ifNil: [ 
			self repositoryUrlIn: aSmalltalkCI projectDirectory ]);
		baseline: self baseline;
		configuration: self configuration;
		version: self version.
	((metacelloUser := self user) isEmptyOrNil and: [(metacelloPassword := self password) isEmptyOrNil]) ifFalse: [
		metacello
			username: metacelloUser;
			password: metacelloPassword].
	
	self ignoreImage ifTrue: [
		metacello ignoreImage ].
	self onConflict ifNotNil: [ :selector |
		metacello onConflict: [ :ex :loaded :incoming | ex perform: selector ]].
	self onUpgrade ifNotNil: [ :selector |
		metacello onUpgrade: [ :ex :loaded :incoming | ex perform: selector ]].
	
	metacello copy get.	"compensate for older versions of Metacello"
	self withExceptionHandlerDo: [ 
		aSmalltalkCI performMetacelloLoad: [ 
			[ metacello load: self load ]
			on: MetacelloIgnorePackageLoaded
			do: [ :e | e resume: self ignoreImage ] ] ]
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> configuration [
	^ configuration
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> configuration: aConfiguration [
	configuration := aConfiguration
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> directory [
	^ directory ifNil: [ directory := '' ]
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> directory: aDirectory [
	directory := aDirectory
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> failOn [
	failOn ifNil: [ failOn := #() ].
	^ failOn
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> failOn: anObject [

	failOn := anObject
]

{ #category : 'private' }
SCIMetacelloLoadSpec >> getClassesForMetacelloProjectRegistration: aClassName [
	Smalltalk at: #'MetacelloProjectRegistration' ifPresent: [ :mpr |
		^ (mpr registrationForClassNamed: aClassName
				ifAbsent: [ self error: aClassName printString , ' not registered (loaded)' ])
			currentlyLoadedClassesInProject ].
	^ #()
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> ignoreImage [

	^ ignoreImage ifNil: [ false ]
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> ignoreImage: aBoolean [

	ignoreImage := aBoolean
]

{ #category : 'testing' }
SCIMetacelloLoadSpec >> isComplete [
	(self baseline isNil and: [ self configuration isNil ])
		ifTrue: [ ^ false ].
	^ true
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> load [
	^ load ifNil: [ load := #() ]
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> load: required [
	load := required
]

{ #category : 'testing' }
SCIMetacelloLoadSpec >> loadedClasses [
  self baseline
    ifNotNil: [ :b | ^ self getClassesForMetacelloProjectRegistration: 'BaselineOf' , b ].
  self configuration
    ifNotNil: [ :c | ^ self getClassesForMetacelloProjectRegistration: 'ConfigurationOf' , c ].
  ^ #()
]

{ #category : 'executing-deprecated' }
SCIMetacelloLoadSpec >> loadRepositoryFor: aSmalltalkCI [
	SmalltalkCI deprecated: 'Use repository and repositoryUrlIn: instead'.
	^ self repository
		ifNil: [ 'filetree://', aSmalltalkCI projectDirectory, SmalltalkCI pathNameDelimiter, self directory ]

]

{ #category : 'private' }
SCIMetacelloLoadSpec >> loadWarnings [
	Smalltalk at: #OCSemanticWarning ifPresent: [ :semanticWarning |
		^ Warning, semanticWarning ].
	^ Warning
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> onConflict [
	^ onConflict
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> onConflict: aSymbol [
	"What happens on conflict of sources. 
	 Values can be #useLoaded|#useIncoming"

	onConflict := aSymbol

]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> onUpgrade [
	^ onUpgrade
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> onUpgrade: aSymbol [
	"What happens on upgrade of sources. 
	 Values can be #useLoaded|#useIncoming"

	onUpgrade := aSymbol
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> onWarningLog [
  onWarningLog ifNil: [ onWarningLog := false ].
  ^ onWarningLog
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> onWarningLog: aBool [
  onWarningLog := aBool
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> repository [
	^ repository
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> repository: aRepository [
	repository := aRepository
]

{ #category : 'executing' }
SCIMetacelloLoadSpec >> repositorySchemeIn: aProjectDirectory [
	self subclassResponsibility
]

{ #category : 'executing' }
SCIMetacelloLoadSpec >> repositoryUrlIn: aProjectDirectory [
	| projectLocation |
	projectLocation := aProjectDirectory, SmalltalkCI pathNameDelimiter, self directory.
	^ (self repositorySchemeIn: projectLocation), '://', projectLocation
]

{ #category : 'private' }
SCIMetacelloLoadSpec >> requiresLatestMetacello [
	"Check for missing features."

	"Credentials parameters (https://github.com/Metacello/metacello/pull/536)"
	(self user isEmptyOrNil not and: [ (Metacello canUnderstand: #username:) not ])
		ifTrue: [ ^ true ].
	(self password isEmptyOrNil not and: [ (Metacello canUnderstand: #password:) not ])
		ifTrue: [ ^ true ].
	
	^ false
]

{ #category : 'private' }
SCIMetacelloLoadSpec >> updateMetacelloIfRequested [
	(self useLatestMetacello or: [ self requiresLatestMetacello ])
		ifTrue: [ self class updateMetacello ]
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> useLatestMetacello [
  useLatestMetacello ifNil: [ useLatestMetacello := false ].
  ^ useLatestMetacello
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> useLatestMetacello: anObject [

	useLatestMetacello := anObject
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> version [
	^ version
]

{ #category : 'accessing' }
SCIMetacelloLoadSpec >> version: aVersionString [
	version := aVersionString
]

{ #category : 'private' }
SCIMetacelloLoadSpec >> withExceptionHandlerDo: aBlock [
	self withLoadWarningsHandlerDo: aBlock
]

{ #category : 'private' }
SCIMetacelloLoadSpec >> withLoadWarningsHandlerDo: aBlock [
	"compensate for older versions of Metacello"
	aBlock
		on: self loadWarnings
		do: [ :ex |
			(self failOn includes: ex class name)
				ifTrue: [ SCIError signal: ex description ].
			self onWarningLog
				ifTrue: [ SmalltalkCI printWarningToStdout: ex description ].
			ex pass ]
]
