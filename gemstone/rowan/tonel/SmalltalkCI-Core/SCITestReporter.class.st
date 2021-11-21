Class {
	#name : 'SCITestReporter',
	#superclass : 'SCIObjectWithSpec',
	#instVars : [
		'runner',
		'stream'
	],
	#category : 'SmalltalkCI-Core'
}

{ #category : 'executing-deprecated' }
SCITestReporter class >> report: aSCITestRunner [
	SmalltalkCI deprecated: 'Use report:spec: instead'.
	self	 report: aSCITestRunner spec: SmalltalkCISpec new
]

{ #category : 'executing' }
SCITestReporter class >> report: aSCITestRunner on: aStream [
	self	 report: aSCITestRunner spec: SmalltalkCISpec new on: aStream
]

{ #category : 'executing' }
SCITestReporter class >> report: aSCITestRunner spec: aSCISpec [
	self subclassResponsibility
]

{ #category : 'executing' }
SCITestReporter class >> report: aSCITestRunner spec: aSCISpec on: aStream [
	self	 new
		runner: aSCITestRunner;
		spec: aSCISpec;
		stream: aStream;
		report
]

{ #category : 'helpers' }
SCITestReporter >> newLine [
	stream cr
]

{ #category : 'helpers' }
SCITestReporter >> print: aString [
	stream nextPutAll: aString
]

{ #category : 'printing' }
SCITestReporter >> printEnd [
	self subclassResponsibility
]

{ #category : 'printing' }
SCITestReporter >> printException: aResult [
	self subclassResponsibility
]

{ #category : 'printing' }
SCITestReporter >> printPass: aResult [
	self subclassResponsibility
]

{ #category : 'printing' }
SCITestReporter >> printResult: aResult [
	aResult passed
		ifTrue: [ self printPass: aResult ]
		ifFalse: [ self printException: aResult ]
]

{ #category : 'printing' }
SCITestReporter >> printResults [
	runner results keysAndValuesDo: [ :class :results |
		results do: [ :result |
			self printResult: result ] ]
]

{ #category : 'printing' }
SCITestReporter >> printStart [
	self subclassResponsibility
]

{ #category : 'printing' }
SCITestReporter >> report [
	self printStart.
	self printResults.
	self printEnd
]

{ #category : 'accessing' }
SCITestReporter >> runner [

	^ runner
]

{ #category : 'accessing' }
SCITestReporter >> runner: anObject [

	runner := anObject
]

{ #category : 'accessing' }
SCITestReporter >> stream [

	^ stream
]

{ #category : 'accessing' }
SCITestReporter >> stream: anObject [

	stream := anObject
]

{ #category : 'helpers' }
SCITestReporter >> tab [
	stream nextPut: Character tab
]
