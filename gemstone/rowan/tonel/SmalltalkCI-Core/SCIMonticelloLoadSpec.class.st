Class {
	#name : 'SCIMonticelloLoadSpec',
	#superclass : 'SCIAbstractLoadSpecWithCredentials',
	#instVars : [
		'url',
		'packages',
		'versions',
		'loadedClasses'
	],
	#category : 'SmalltalkCI-Core'
}

{ #category : 'compatibility' }
SCIMonticelloLoadSpec class >> isPlatformCompatible [
	self subclassResponsibility
]

{ #category : 'instance creation' }
SCIMonticelloLoadSpec class >> new [
	^ self platformClass basicNew 
		initialize
]

{ #category : 'accessing' }
SCIMonticelloLoadSpec class >> platformClass [
	"There will be just one subclass installed (for each platform)"
	^ self allSubclasses detect: [ :cl | cl isPlatformCompatible ]
]

{ #category : 'executing' }
SCIMonticelloLoadSpec >> addLoadedClassesFrom: aDefinitionsCollection [
	| mcOrganization classes |
	mcOrganization := aDefinitionsCollection detect: [ :def | def isOrganizationDefinition ].
	mcOrganization ifNil: [ self error: 'Could not find MCOrganizationDefinition' ].
	classes := SmalltalkCI classesWithCategoryNames: mcOrganization categories.
	self loadedClasses addAll: classes
]

{ #category : 'executing' }
SCIMonticelloLoadSpec >> basicLoadProjectOn: aSmalltalkCI [
	| repository |
	repository := self repository.
	self extractVersionsFromPackages: repository.
	self loadVersions: repository
]

{ #category : 'executing' }
SCIMonticelloLoadSpec >> extractVersionsFromPackages: aRepository [
	self subclassResponsibility
]

{ #category : 'testing' }
SCIMonticelloLoadSpec >> isComplete [
	self url ifNil: [ ^ false ].
	((self packages isNil or: [ self packages isEmpty ]) and: [
		self versions isNil or: [ self versions isEmpty ] ])
			ifTrue: [ ^ false ].
	^ true
]

{ #category : 'accessing' }
SCIMonticelloLoadSpec >> loadedClasses [

	^ loadedClasses ifNil: [ loadedClasses := Set new ]
]

{ #category : 'accessing' }
SCIMonticelloLoadSpec >> loadedClasses: anObject [

	loadedClasses := anObject
]

{ #category : 'executing' }
SCIMonticelloLoadSpec >> loadVersion: aVersionName repository: aRepository [
	self subclassResponsibility
]

{ #category : 'executing' }
SCIMonticelloLoadSpec >> loadVersions: aRepository [
	self versions do: [ :version |
		self loadVersion: version repository: aRepository ]
]

{ #category : 'accessing' }
SCIMonticelloLoadSpec >> packages [

	^ packages ifNil: [ packages := OrderedCollection new ]
]

{ #category : 'accessing' }
SCIMonticelloLoadSpec >> packages: anObject [

	packages := anObject
]

{ #category : 'accessing' }
SCIMonticelloLoadSpec >> password [

	^ super password ifNil: ['']
]

{ #category : 'private' }
SCIMonticelloLoadSpec >> repository [
	^ MCHttpRepository 
		location: self url
		user: self user
		password: self password
]

{ #category : 'accessing' }
SCIMonticelloLoadSpec >> url [

	^ url
]

{ #category : 'accessing' }
SCIMonticelloLoadSpec >> url: anObject [

	url := anObject
]

{ #category : 'accessing' }
SCIMonticelloLoadSpec >> user [

	^ super user ifNil: ['']
]

{ #category : 'executing' }
SCIMonticelloLoadSpec >> versionNumberOf: aVersionString [
	^ ((aVersionString copyAfterLast: $-) copyAfter: $.) asInteger
]

{ #category : 'accessing' }
SCIMonticelloLoadSpec >> versions [

	^ versions ifNil: [ versions := OrderedCollection new ]
]

{ #category : 'accessing' }
SCIMonticelloLoadSpec >> versions: anObject [

	versions := anObject
]
