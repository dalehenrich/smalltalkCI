Class {
	#name : 'SCICustomScript',
	#superclass : 'SCIAbstractLoadSpec',
	#instVars : [
		'path'
	],
	#category : 'SmalltalkCI-Core'
}

{ #category : 'compatibility' }
SCICustomScript class >> isPlatformCompatible [
	self subclassResponsibility
]

{ #category : 'instance creation' }
SCICustomScript class >> new [
	^ self platformClass basicNew 
		initialize
]

{ #category : 'instance creation' }
SCICustomScript class >> newForPath: aPath [
	^ self new path: aPath; yourself 
]

{ #category : 'accessing' }
SCICustomScript class >> platformClass [
	"There will be just one subclass installed (for each platform)"
	^ self allSubclasses detect: [ :cl | cl isPlatformCompatible ]
]

{ #category : 'executing' }
SCICustomScript >> basicLoadProjectOn: aSmalltalkCI [
	self fileInFrom: aSmalltalkCI projectDirectory
]

{ #category : 'executing' }
SCICustomScript >> fileInFrom: aDirectory [
	self subclassResponsibility
]

{ #category : 'testing' }
SCICustomScript >> isComplete [
	^ path notNil
]

{ #category : 'accessing' }
SCICustomScript >> path [

	^ path
]

{ #category : 'accessing' }
SCICustomScript >> path: anObject [

	path := anObject
]
