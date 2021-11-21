Class {
	#name : 'SCIAbstractConfigTest',
	#superclass : 'TestCase',
	#instVars : [
		'config'
	],
	#category : 'SmalltalkCI-Tests'
}

{ #category : 'accessing' }
SCIAbstractConfigTest >> config [

	^ config
]

{ #category : 'accessing' }
SCIAbstractConfigTest >> config: anObject [

	config := anObject
]

{ #category : 'setup' }
SCIAbstractConfigTest >> setUp [
	self config: SCIAbstractConfig new
]

{ #category : 'testing' }
SCIAbstractConfigTest >> testSimple [
	self config
		configName: 'foo';
		platforms: #(#myplatform #anotherplatform).
	
	self
		assert: 'foo' equals: self config configName;
		assert: 2 equals: self config platforms size;
		assert: true equals: (self config isPlatformCompatible: #myplatform)
]
