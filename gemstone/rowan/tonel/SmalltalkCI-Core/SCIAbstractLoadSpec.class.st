Class {
	#name : 'SCIAbstractLoadSpec',
	#superclass : 'SCIPlatformDependent',
	#category : 'SmalltalkCI-Core'
}

{ #category : 'executing' }
SCIAbstractLoadSpec >> basicLoadProjectOn: aSmalltalkCI [
	self subclassResponsibility
]

{ #category : 'testing' }
SCIAbstractLoadSpec >> isComplete [
	^ false
]

{ #category : 'testing' }
SCIAbstractLoadSpec >> loadedClasses [
	^ #()
]

{ #category : 'executing' }
SCIAbstractLoadSpec >> loadProjectOn: aSmalltalkCI [
	self isComplete
		ifFalse: [ self error: 'This spec cannot be loaded or is incomplete.' ].
	self isPlatformCompatible
		ifFalse: [ self error: 'This spec cannot be loaded on this platform' ].
	self basicLoadProjectOn: aSmalltalkCI
]
