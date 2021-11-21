Class {
	#name : 'SmalltalkCISpecTest',
	#superclass : 'SCITestCaseWithFile',
	#instVars : [
		'spec'
	],
	#category : 'SmalltalkCI-Tests'
}

{ #category : 'constants' }
SmalltalkCISpecTest class >> testFileContents [
	^ '
SmalltalkCISpec {
  #loading : [
    SCIMetacelloLoadSpec {
      #baseline : ''SmalltalkCI'',
      #directory : ''repository'',
      #load : [ ''tests'' ],
      #onWarningLog : true,
      #platforms : [ #squeak, #pharo, #gemstone ]
    }
  ],
  #testing : {
    #coverage : {
      #categories : [ ''SmalltalkCI-*'' ]
    },
    #exclude : {
      #classes : [ #SCIExcludedTests ]
    }
  }
}'
]

{ #category : 'constants' }
SmalltalkCISpecTest class >> testFileName [
	^ '__smalltalkCITestSpec.ston'
]

{ #category : 'setup' }
SmalltalkCISpecTest >> setUp [
	self spec: SmalltalkCISpec new
]

{ #category : 'accessing' }
SmalltalkCISpecTest >> spec [
	^ spec
]

{ #category : 'accessing' }
SmalltalkCISpecTest >> spec: aSpec [
	spec := aSpec
]

{ #category : 'testing' }
SmalltalkCISpecTest >> testAddSpecs [
	self assert: 0 equals: (self spec loading size).
	self spec addLoadSpec: SCIAbstractLoadSpec new.
	self assert: 0 equals: (self spec loading size).
	self spec addLoadSpec: SCIMetacelloLoadSpec new.
	self assert: 0 equals: (self spec loading size).
	self spec addLoadSpec:
		(SCIMetacelloLoadSpec new
			baseline: 'Foo';
			platforms: { SmalltalkCI platformSymbol }).
	self assert: 1 equals: (self spec loading size).
]

{ #category : 'testing' }
SmalltalkCISpecTest >> testClassesToTest [
	| classes |
	self spec: (SmalltalkCISpec new testing: (Dictionary new
        add: #'classes' -> #(Dictionary);
        add: #'categories' -> #('SmalltalkCI-Tests');
        yourself)).

	classes := self spec classesToTest.
	self assert: (classes includes: Dictionary).
	self deny: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCITest).
	
	self spec loading: { SCIMetacelloLoadSpec new baseline: 'SmalltalkCI'; yourself }.
	self spec testing: (Dictionary new
	  add: #'allTestCases' -> false;
        add: #'exclude' -> (Dictionary new
		add: #'classes' -> #(SCIExcludedTests);
		yourself);
        add: #'include' -> (Dictionary new
		add: #'classes' -> #(Object ObjectTest BreakpointTest);
		yourself);
        yourself).
	classes := self spec classesToTest.
	self deny: (classes includes: Object).
	Smalltalk at: #'ObjectTest' ifPresent: [ :ot | self assert: (classes includes: ot) ].
	Smalltalk at: #'BreakpointTest' ifPresent: [ :bt | self assert: (classes includes: bt) ].
	self deny: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SCIExcludedTests).

	self spec testing: (Dictionary new
	  add: #'allTestCases' -> true;
        add: #'exclude' -> (Dictionary new
		add: #'classes' -> #(SCIExcludedTests);
		yourself);
        add: #'include' -> (Dictionary new
		add: #'classes' -> #(Object);
		yourself);
        yourself).
	classes := self spec classesToTest.
	self deny: (classes includes: Object).
	Smalltalk at: #'ObjectTest' ifPresent: [ :ot | self assert: (classes includes: ot) ].
	Smalltalk at: #'BreakpointTest' ifPresent: [ :bt | self assert: (classes includes: bt) ].
	self deny: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SCIExcludedTests).
	
	self spec testing: Dictionary new.
	classes := SmalltalkCI classesFrom: (Dictionary new
        add: #'projects' -> #('SmalltalkCI');
        yourself).
	self spec classesToTest allSatisfy: [ :cl | classes includes: cl]
	
]

{ #category : 'testing' }
SmalltalkCISpecTest >> testCompatibleCustomScripts [
	| preLoading postLoading preTesting postTesting |
	self spec: (SmalltalkCISpec new
		preLoading: 'some.st';
		postLoading: #('some.st' 'other.st');
		preTesting: {
			'some.st'.
			SCICustomScript newForPath: 'other.st'.
			SCICustomScript new
				path: 'another.st';
				platforms: {SmalltalkCI platformSymbol};
				yourself.
			SCICustomScript new
				path: 'incompatible.st';
				platforms: #(#incompatible);
				yourself. };
		postTesting: (SCICustomScript new path: 'some.st'; platforms: #(#unknown); yourself) ;
		yourself).

	preLoading := self spec compatibleCustomScripts: 'preLoading'.
	postLoading := self spec compatibleCustomScripts: 'postLoading'.
	preTesting := self spec compatibleCustomScripts: 'preTesting'.
	postTesting := self spec compatibleCustomScripts: 'postTesting'.
	
	self assert: 1 equals: preLoading size.
	self assert: (preLoading first isKindOf: SCICustomScript).
	self assert: 'some.st' equals: preLoading first path.

	self assert: 2 equals: postLoading size.
	self assert: (postLoading allSatisfy: [ :each | each isKindOf: SCICustomScript ]).
	self assert: 'some.st' equals: postLoading first path.
	self assert: 'other.st' equals: postLoading second path.

	self assert: 3 equals: preTesting size.
	self assert: (preTesting allSatisfy: [ :each | each isKindOf: SCICustomScript ]).
	self assert: 'some.st' equals: preTesting first path.
	self assert: 'other.st' equals: preTesting second path.
	self assert: 'another.st' equals: preTesting third path.

	self assert: postTesting isEmpty
	
]

{ #category : 'testing' }
SmalltalkCISpecTest >> testFromFile [
	self withTestFileDo: [ :testFile | | spec |
		spec := SmalltalkCISpec fromFile: testFile.
		self assert: 1 equals: spec loading size.
		self assert: #('SmalltalkCI-*') equals: ((spec testing at: #coverage) at: #categories)]
]

{ #category : 'testing' }
SmalltalkCISpecTest >> testFromStream [
	#('SmalltalkCISpec {}' 'SmalltalkCISpec { #loading : [] }') do: [ :each |
		self assert: (SmalltalkCISpec fromStream: each readStream) isValid].

	#('SmalltalkCISpec {,}' '[]' '{}' '1' '&^#%,,') do: [ :each |
		self deny: (SmalltalkCISpec fromStream: each readStream) isValid].
	
	self assert: ((SmalltalkCISpec fromStream: ',' readStream) originalError isKindOf: Error)
]

{ #category : 'testing' }
SmalltalkCISpecTest >> testSimple [
	self spec
		configuring: OrderedCollection new;
		loading: (OrderedCollection with: SCIMetacelloLoadSpec new).

	self
		assert: 0 equals: self spec configuring size;
		assert: 1 equals: self spec loading size
]
