Class {
	#name : 'SCIAbstractLoadSpecTest',
	#superclass : 'TestCase',
	#instVars : [
		'spec'
	],
	#category : 'SmalltalkCI-Tests'
}

{ #category : 'setup' }
SCIAbstractLoadSpecTest >> setUp [
	self spec: SCIAbstractLoadSpec new
]

{ #category : 'accessing' }
SCIAbstractLoadSpecTest >> spec [
	^ spec
]

{ #category : 'accessing' }
SCIAbstractLoadSpecTest >> spec: aSpec [
	spec := aSpec
]

{ #category : 'testing' }
SCIAbstractLoadSpecTest >> testIsComplete [
	self assert: false equals: (self spec isComplete)
]

{ #category : 'testing' }
SCIAbstractLoadSpecTest >> testIsPlatformCompatible [
	self spec platforms: {SmalltalkCI platformSymbol}.
	self assert: true equals: self spec isPlatformCompatible.
	
	self spec platforms: #(#bogus).
	self assert: false equals: self spec isPlatformCompatible
]

{ #category : 'testing' }
SCIAbstractLoadSpecTest >> testloadProjectOn [
	self should: [ self spec loadProjectOn: nil ] raise: Error
]

{ #category : 'testing' }
SCIAbstractLoadSpecTest >> testSimple [
	self assert: 0 equals: (self spec loadedClasses size)
]
