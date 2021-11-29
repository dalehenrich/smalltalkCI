Class {
	#name : 'SCIPassingTests',
	#superclass : 'TestCase',
	#category : 'SmalltalkCI-Excluded-Tests'
}

{ #category : 'testing' }
SCIPassingTests >> testAssert [
	self assert: true
]

{ #category : 'testing' }
SCIPassingTests >> testAssertEquals [
	self assert: 2 equals: (1+1)
]

{ #category : 'testing' }
SCIPassingTests >> testDeny [
	self deny: false
]

{ #category : 'testing' }
SCIPassingTests >> testEmpty [
]

{ #category : 'testing' }
SCIPassingTests >> testRaise [
	self should: [ self error: 'Error' ] raise: Error
]
