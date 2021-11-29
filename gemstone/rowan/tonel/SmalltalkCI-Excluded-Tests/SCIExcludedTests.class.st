Class {
	#name : 'SCIExcludedTests',
	#superclass : 'TestCase',
	#category : 'SmalltalkCI-Excluded-Tests'
}

{ #category : 'testing' }
SCIExcludedTests >> expectedFailures [
	^ #( testShouldFail testShouldPassUnexpectedly )
]

{ #category : 'testing' }
SCIExcludedTests >> testAssertError [
	self assert: 3 equals: 4
]

{ #category : 'testing' }
SCIExcludedTests >> testDeprecation [
	SmalltalkCI deprecated: 'This is just a test'
]

{ #category : 'testing' }
SCIExcludedTests >> testError [
	self error: 'An error message.'
]

{ #category : 'testing' }
SCIExcludedTests >> testFailure [
	self fail: 'A failure message.'
]

{ #category : 'testing' }
SCIExcludedTests >> testShouldFail [
	self error: 'Foo'.
]

{ #category : 'testing' }
SCIExcludedTests >> testShouldPass [
]

{ #category : 'testing' }
SCIExcludedTests >> testShouldPassUnexpectedly [
]

{ #category : 'testing' }
SCIExcludedTests >> testThisIsAVeryLongMethodNameThatProbablyNeedsToBeContractedInOrderToBeDisplayedCorrectlyInATravisLog [
	self assert: false
]
