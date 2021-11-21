Class {
	#name : 'SCITestRunnerTest',
	#superclass : 'TestCase',
	#category : 'SmalltalkCI-Tests'
}

{ #category : 'testing' }
SCITestRunnerTest >> testRunClasses [
	| runner |
	runner := SmalltalkCI testRunnerClass runClasses: {SmalltalkCITest}.
	self assert: runner isSuccessful.
	runner := SmalltalkCI testRunnerClass runClasses: {SCIExcludedTests}.
	self deny: runner isSuccessful.
	self
		should: [ SmalltalkCI testRunnerClass runClasses: {SmalltalkCI} ]
		raise: SCIError
]

{ #category : 'testing' }
SCITestRunnerTest >> testRunSpecNamed [
	| runner |
	runner := SmalltalkCI testRunnerClass
		runSpec: (SCIDummySpec forClass: SmalltalkCITest).
	self assert: runner isSuccessful.
	runner := SmalltalkCI testRunnerClass
		runSpec: (SCIDummySpec forClass: SCIExcludedTests).
	self deny: runner isSuccessful.
	runner := SmalltalkCI testRunnerClass
		runSpec: (SCIDummySpec forClass: SmalltalkCI).
	self assert: 0 equals: runner totalTests.
	self assert: runner isSuccessful.
]
