Class {
	#name : 'SCIPlatformDependent',
	#superclass : 'Object',
	#instVars : [
		'platforms'
	],
	#category : 'SmalltalkCI-Core'
}

{ #category : 'compatibility' }
SCIPlatformDependent >> isPlatformCompatible [
	"Returns true if compatible with current platform."
	^ self isPlatformCompatible: (Smalltalk at: #SmalltalkCI) platformSymbol
]

{ #category : 'compatibility' }
SCIPlatformDependent >> isPlatformCompatible: aPlatformSymbol [
	"If no platform is specified, we assume is valid for current execution platform"
	^ self platforms isEmptyOrNil or: [ self platforms includes: aPlatformSymbol ]
]

{ #category : 'accessing' }
SCIPlatformDependent >> platforms [
	^ platforms ifNil: [ platforms := OrderedCollection new ]
]

{ #category : 'accessing' }
SCIPlatformDependent >> platforms: platformCollection [
	platforms := platformCollection
]
