Class {
	#name : 'SCIDummySpec',
	#superclass : 'SmalltalkCISpec',
	#instVars : [
		'classesToTest'
	],
	#category : 'SmalltalkCI-Tests'
}

{ #category : 'instance creation' }
SCIDummySpec class >> forClass: aClass [
	^ self new
		classesToTest: {aClass};
		yourself
]

{ #category : 'instance creation' }
SCIDummySpec class >> named: aName forClass: aClass [
	^ self new
		name: aName;
		classesToTest: {aClass};
		yourself
]

{ #category : 'accessing' }
SCIDummySpec >> classesToTest [

	^ classesToTest ifNil: [ super classesToTest ]
]

{ #category : 'accessing' }
SCIDummySpec >> classesToTest: anObject [

	classesToTest := anObject
]

{ #category : 'accessing' }
SCIDummySpec >> failOnZeroTests [
	^ self testing at: #failOnZeroTests ifAbsent: [ false ]
]
