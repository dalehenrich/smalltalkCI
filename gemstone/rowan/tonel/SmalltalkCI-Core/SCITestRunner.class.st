Class {
	#name : 'SCITestRunner',
	#superclass : 'SCIObjectWithSpec',
	#instVars : [
		'suite',
		'suiteTime',
		'results'
	],
	#category : 'SmalltalkCI-Core'
}

{ #category : 'constants' }
SCITestRunner class >> errorExceptions [
	^ Halt, Error, TestFailure
]

{ #category : 'compatibility' }
SCITestRunner class >> isTestMethod: aMethod [
	"Compatibility function for older versions of Squeak that do not have CompiledMethod>>isTestMethod"
	^ (aMethod methodClass isKindOf: TestCase class)
		and: [ aMethod selector beginsWith: 'test' ]
]

{ #category : 'running' }
SCITestRunner class >> runClasses: aCollectionOfClasses [
	^ self runClasses: aCollectionOfClasses spec: SmalltalkCISpec new
]

{ #category : 'running-deprecated' }
SCITestRunner class >> runClasses: aCollectionOfClasses named: aSuiteName [
	SmalltalkCI deprecated: 'Use SCITestRunner>>runClasses:spec: instead'.
	^ self runClasses: aCollectionOfClasses
]

{ #category : 'running-deprecated' }
SCITestRunner class >> runClasses: aCollectionOfClasses named: aSuiteName failOnZeroTests: failOnZeroTests [
	| spec |
	SmalltalkCI deprecated: 'Use SCITestRunner>>runClasses:spec: instead'.
	spec := SmalltalkCISpec new.
	spec testing at: #failOnZeroTests put: failOnZeroTests.
	^ self runClasses: aCollectionOfClasses spec: spec
]

{ #category : 'running' }
SCITestRunner class >> runClasses: aCollectionOfClasses spec: aSCISpec [
  | suite classes |
  suite := TestSuite named: aSCISpec name.
  classes := (aCollectionOfClasses
    select: [ :each | (each includesBehavior: TestCase) and: [ each isAbstract not ] ])
      asSortedCollection: [ :a :b | a name <= b name ].
  classes
    do: [ :each | each addToSuiteFromSelectors: suite ].
  ^ self runSuite: suite spec: aSCISpec
]

{ #category : 'running' }
SCITestRunner class >> runSpec: aSCISpec [
	^ self runClasses: aSCISpec classesToTest spec: aSCISpec
]

{ #category : 'running' }
SCITestRunner class >> runSuite: aTestSuite [
	^ self runSuite: aTestSuite spec: SmalltalkCISpec new
]

{ #category : 'running-deprecated' }
SCITestRunner class >> runSuite: aTestSuite failOnZeroTests: failOnZeroTests [
	| spec |
	SmalltalkCI deprecated: 'Use SCITestRunner>>runSuite:spec: instead'.
	spec := SmalltalkCISpec new.
	spec testing at: #failOnZeroTests put: failOnZeroTests.
	^ self runSuite: aTestSuite spec: spec
]

{ #category : 'running' }
SCITestRunner class >> runSuite: aTestSuite spec: aSCISpec [
	^ self new
		initializeOn: aTestSuite;
		spec: aSCISpec;
		run
]

{ #category : 'constants' }
SCITestRunner class >> skipExceptions [
	^ ExceptionSet new
]

{ #category : 'running' }
SCITestRunner >> basicRunCase: aTestCase [
	aTestCase runCase	
]

{ #category : 'accessing' }
SCITestRunner >> erroredTests [
	| size |
	size := 0.
	results valuesDo: [ :clsResults |
		size := size + (clsResults select: [ :r | r errored ]) size ].
	^ size
]

{ #category : 'accessing' }
SCITestRunner >> failedTests [
	| size |
	size := 0.
	results valuesDo: [ :clsResults |
		size := size + (clsResults select: [ :r | r failed ]) size ].
	^ size
]

{ #category : 'initialize-release' }
SCITestRunner >> initialize [
	super initialize.
	suiteTime := 0 asDuration.
	results := Dictionary new
]

{ #category : 'initialize-release' }
SCITestRunner >> initializeOn: aTestSuite [
	suite := aTestSuite
]

{ #category : 'accessing' }
SCITestRunner >> isSuccessful [
	| deprecationWarningCheck |
	deprecationWarningCheck := spec failOnSCIDeprecationWarnings
		ifTrue: [ SmalltalkCI deprecationWarnings isEmpty ]
		ifFalse: [ true ].
	^ deprecationWarningCheck and: [
			(self erroredTests + self failedTests) = 0]
]

{ #category : 'accessing' }
SCITestRunner >> passingTests [
	^ self totalTests - self erroredTests - self failedTests
]

{ #category : 'running' }
SCITestRunner >> printProgress: aTestResult [
	SmalltalkCI stdout nextPut: (aTestResult passed
		ifTrue: [ $. ]
		ifFalse: [ (aTestResult failed)
			ifTrue: [ $F ]
			ifFalse: [ $E ] ])

]

{ #category : 'accessing' }
SCITestRunner >> results [

	^ results
]

{ #category : 'running' }
SCITestRunner >> run [
	[ self setUp. suiteTime := SmalltalkCI timeToRun: [ self runAll ] ] ensure: [ self tearDown ]
]

{ #category : 'running' }
SCITestRunner >> runAll [
	suite tests do: [ :each | each run: self ]
]

{ #category : 'running' }
SCITestRunner >> runCase: aTestCase [
	| result |
	SmalltalkCI printDebug: aTestCase asString.
	result := SCITestRunnerResult new testCase: aTestCase; yourself.
	result time: (SmalltalkCI timeToRun: [
		[ [ self basicRunCase: aTestCase ]
			on: self class errorExceptions
			do: [ :err |
				result testError: err.
				(aTestCase shouldPass & (self spec testing at: #serializeError ifAbsent:[ true ]))
					ifTrue: [ self serializeError: result testError of: aTestCase ].
				result stack: (self stackTraceString: err of: aTestCase) ] ]
					on: self class skipExceptions
					do: [ :skip | result skipped: true ] ]).
	self printProgress: result.
	(results at: aTestCase class ifAbsentPut: [ OrderedCollection new ])
		add: result
		
	
]

{ #category : 'private' }
SCITestRunner >> serializeError: error of: aTestCase [
	"Hook for supporting post-mortem stack dumps. Do nothing by default."
]

{ #category : 'running' }
SCITestRunner >> setUp [
	SmalltalkCI printToStdout: 'Running suite "', self suiteName ,'" with ', suite tests size asString, ' tests.'.

	"Initialize the test resources."
	suite resources do: [ :each |
		each isAvailable
			ifFalse: [ TestResult signalErrorWith: 'Resource ' , each name , ' could not be initialized' ] ]

]

{ #category : 'private' }
SCITestRunner >> stackTraceString: err of: aTestCase [
	self subclassResponsibility
]

{ #category : 'accessing' }
SCITestRunner >> suite [

	^ suite
]

{ #category : 'accessing' }
SCITestRunner >> suite: anObject [

	suite := anObject
]

{ #category : 'accessing' }
SCITestRunner >> suiteName [

	^ suite name
]

{ #category : 'accessing' }
SCITestRunner >> suiteTime [

	^ suiteTime
]

{ #category : 'accessing' }
SCITestRunner >> suiteTimeInSeconds [
	^ (self suiteTime / 1000.0)
]

{ #category : 'accessing' }
SCITestRunner >> suiteTimeString [
	^ (SmalltalkCI stringFor: self suiteTimeInSeconds maxDecimalPlaces: 2), 's'
]

{ #category : 'accessing' }
SCITestRunner >> summary [
	^ self totalTests asString, ' Tests with ', self failedTests asString, ' Failures and ', self erroredTests asString, ' Errors in ', self suiteTimeString
]

{ #category : 'running' }
SCITestRunner >> tearDown [
	suite resources
		do: [ :each | each reset ].

	SmalltalkCI printToStdout: 'Finished running suite: ', self suiteName.
	
	(self spec failOnZeroTests and: [ self totalTests == 0 ])
		ifTrue: [ SCIError signal: 'No tests were executed.

If this is intended, use `#failOnZeroTests : false` in your SmalltalkCISpec.' ].

]

{ #category : 'accessing' }
SCITestRunner >> totalTests [
	| size |
	size := 0.
	results valuesDo: [ :clsResults |
		size := size + clsResults size ].
	^ size

]
