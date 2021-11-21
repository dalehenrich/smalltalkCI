Class {
	#name : 'SmalltalkCITest',
	#superclass : 'TestCase',
	#instVars : [
		'sci'
	],
	#category : 'SmalltalkCI-Tests'
}

{ #category : 'helpers' }
SmalltalkCITest class >> expectedTests: aClass [
	^ (SmalltalkCI methodDictOf: aClass) keys select: [ :ea | ea beginsWith: 'test' ]
]

{ #category : 'accessing' }
SmalltalkCITest >> sci [

	^ sci
]

{ #category : 'accessing' }
SmalltalkCITest >> sci: anObject [

	sci := anObject
]

{ #category : 'setup' }
SmalltalkCITest >> setUp [
	self sci: SmalltalkCI basicNew initialize
]

{ #category : 'testing' }
SmalltalkCITest >> testAppVeyorDetection [
	(SmalltalkCI getEnv: 'USER') = 'appveyor'
		ifTrue: [ self assert: SmalltalkCI isAppVeyorBuild ]
		ifFalse: [ self deny: SmalltalkCI isAppVeyorBuild ].

	SmalltalkCI isAppVeyorBuild ifTrue: [
		self
			assert: 'True'
			equals: (SmalltalkCI getEnv: 'CI').
		self
			assert: (SmalltalkCI getEnv: 'APPVEYOR_PROJECT_NAME') notEmpty
	]
]

{ #category : 'testing' }
SmalltalkCITest >> testAuthor [
	| currentAuthor |
	currentAuthor := SmalltalkCI getAuthor.
	
	[
	SmalltalkCI basicNew initialize.
	self deny: SmalltalkCI defaultAuthor isNil.
	] ensure: [
		SmalltalkCI setAuthor: currentAuthor.
		self assert: SmalltalkCI getAuthor equals: currentAuthor ]
]

{ #category : 'testing' }
SmalltalkCITest >> testClassesForCategories [
	| classes size |
	classes := SmalltalkCI classesForCategories: #('SmalltalkCI-Core').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self deny: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SmalltalkCISpecTest).
	self assert: classes size equals: (SmalltalkCI classesInCategory: 'SmalltalkCI-Core') size.
	
	classes := SmalltalkCI classesForCategories: #('SmalltalkCI-Cor.*' 'SmalltalkCI-T.*').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self assert: (classes includes: SmalltalkCITest).
	self assert: (classes includes: SmalltalkCISpecTest).
	self deny: (classes includes: Object).
	size := (SmalltalkCI classesInCategory: 'SmalltalkCI-Core') size.
	size := size + (SmalltalkCI classesInCategory: 'SmalltalkCI-Tests') size.
	self assert: classes size equals: size.
]

{ #category : 'testing' }
SmalltalkCITest >> testClassesForPackages [
	| classes size |
	classes := SmalltalkCI classesForPackages: #('SmalltalkCI-Core').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self deny: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SmalltalkCISpecTest).
	self assert: classes size equals: (SmalltalkCI classesInPackage: 'SmalltalkCI-Core') size.
	
	classes := SmalltalkCI classesForPackages: #('SmalltalkCI-Cor.*' 'SmalltalkCI-T.*').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self assert: (classes includes: SmalltalkCITest).
	self assert: (classes includes: SmalltalkCISpecTest).
	self deny: (classes includes: Object).
	size := (SmalltalkCI classesInPackage: 'SmalltalkCI-Core') size.
	size := size + (SmalltalkCI classesInPackage: 'SmalltalkCI-Tests') size.
	self assert: classes size equals: size.
]

{ #category : 'testing' }
SmalltalkCITest >> testClassesFrom [
	| classes testing |
	testing := (Dictionary new
        add: #'classes' -> #(Dictionary);
        add: #'categories' -> #('SmalltalkCI-Core');
        yourself).
	classes := SmalltalkCI classesFrom: testing.
	self assert: (classes includes: Dictionary).
	self assert: (classes includes: SmalltalkCI).
	self deny: (classes includes: SmalltalkCITest).
	
	testing := (Dictionary new
        add: #'packages' -> #('SmalltalkCI-Core');
        yourself).
	classes := SmalltalkCI classesFrom: testing.
	self deny: (classes includes: Dictionary).
	self assert: (classes includes: SmalltalkCI).
	self deny: (classes includes: SmalltalkCITest).

	testing := (Dictionary new
        add: #'packages' -> #('SmalltalkCI-*');
        yourself).
	classes := SmalltalkCI classesFrom: testing.
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCITest).
	self assert: (classes includes: SCIExcludedTests)
]

{ #category : 'testing' }
SmalltalkCITest >> testClassesInCategory [
	| classes |
	classes := SmalltalkCI classesInCategory: 'SmalltalkCI-Core'.
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self deny: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SmalltalkCISpecTest).
]

{ #category : 'testing' }
SmalltalkCITest >> testClassesInPackage [
	| classes |
	classes := SmalltalkCI classesInPackage: 'SmalltalkCI-Core'.
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self deny: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SmalltalkCISpecTest)
]

{ #category : 'testing' }
SmalltalkCITest >> testClassesOfProjects [
	| classes |
	classes := SmalltalkCI classesOfProjects: #('SomeNonExistingProject').
	self assert: classes size = 0.
	
	classes := SmalltalkCI classesOfProjects: #('SmalltalkCI').
	self assert: classes size > 0.
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec)
]

{ #category : 'testing' }
SmalltalkCITest >> testClassesWithCategoryNames [
	| classes size |
	classes := SmalltalkCI classesWithCategoryNames: #('SmalltalkCI-Core').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self deny: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SmalltalkCISpecTest).
	self assert: classes size equals: (SmalltalkCI classesInCategory: 'SmalltalkCI-Core') size.
	
	classes := SmalltalkCI classesWithCategoryNames: #('SmalltalkCI-Core' 'SmalltalkCI-Tests').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self assert: (classes includes: SmalltalkCITest).
	self assert: (classes includes: SmalltalkCISpecTest).
	self deny: (classes includes: Object).
	size := (SmalltalkCI classesInCategory: 'SmalltalkCI-Core') size.
	size := size + (SmalltalkCI classesInCategory: 'SmalltalkCI-Tests') size.
	self assert: classes size equals: size.
]

{ #category : 'testing' }
SmalltalkCITest >> testClassesWithPackageNames [
	| classes size |
	classes := SmalltalkCI classesWithPackageNames: #('SmalltalkCI-Core').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self deny: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SmalltalkCISpecTest).
	self assert: classes size equals: (SmalltalkCI classesInPackage: 'SmalltalkCI-Core') size.
	
	classes := SmalltalkCI classesWithPackageNames: #('SmalltalkCI-Core' 'SmalltalkCI-Tests').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self assert: (classes includes: SmalltalkCITest).
	self assert: (classes includes: SmalltalkCISpecTest).
	self deny: (classes includes: Object).
	size := (SmalltalkCI classesInPackage: 'SmalltalkCI-Core') size.
	size := size + (SmalltalkCI classesInPackage: 'SmalltalkCI-Tests') size.
	self assert: classes size equals: size.
]

{ #category : 'testing' }
SmalltalkCITest >> testGitLabCIDetection [
	(SmalltalkCI getEnv: 'GITLAB_CI') = 'true'
		ifTrue: [ self assert: SmalltalkCI isGitLabCIBuild ]
		ifFalse: [ self deny: SmalltalkCI isGitLabCIBuild ]
]

{ #category : 'testing' }
SmalltalkCITest >> testNew [
	self should: [ SmalltalkCI new ] raise: Error
]

{ #category : 'testing' }
SmalltalkCITest >> testNewTravisID [
	| travisID |
	travisID := SmalltalkCI platformClass newTravisID.
	self assert: travisID ~= SmalltalkCI platformClass newTravisID.
	self assert: 4 equals: travisID size

]

{ #category : 'testing' }
SmalltalkCITest >> testResolveAllWith [
	| list result |
	list := #('foo' 'bar' 'foo-bar' 'bar-foo' 'foo-car').
	self assert: #('foo') equals: (SmalltalkCI resolveAll: #('foo') with: list).
	self assert: #() equals: (SmalltalkCI resolveAll: #('zzz') with: list).

	result := SmalltalkCI resolveAll: #('foo' 'bar') with: list.
	self assert: (result size = 2).
	self assert: (result includes: 'foo').
	self assert: (result includes: 'bar').

	result := SmalltalkCI resolveAll: #('foo-*' 'bar.*') with: list.
	self assert: (result size = 4).
	self assert: (result includes: 'foo-bar').
	self assert: (result includes: 'foo-car').
	self assert: (result includes: 'bar').
	self assert: (result includes: 'bar-foo').

	result := SmalltalkCI resolveAll: #('*') with: list.
	self assert: (result size = list size).
	result := SmalltalkCI resolveAll: #('.*') with: list.
	self assert: (result size = list size).
]

{ #category : 'testing' }
SmalltalkCITest >> testResolveWith [
	| list result |
	list := #('foo' 'bar' 'foo-bar' 'bar-foo' 'foo-car').
	self assert: #('foo') equals: (SmalltalkCI resolve: 'foo' with: list).
	self assert: #() equals: (SmalltalkCI resolve: 'zzz' with: list).

	result := SmalltalkCI resolve: 'foo-*' with: list.
	self assert: (result size = 2).
	self assert: (result includes: 'foo-bar').
	self assert: (result includes: 'foo-car').
	
	result := SmalltalkCI resolve: 'foo-.*' with: list.
	self assert: (result size = 2).
	self assert: (result includes: 'foo-bar').
	self assert: (result includes: 'foo-car').

	result := SmalltalkCI resolve: 'foo.*' with: list.
	self assert: (result size = 3).
	self assert: (result includes: 'foo').
	self assert: (result includes: 'foo-bar').
	self assert: (result includes: 'foo-car').

	result := SmalltalkCI resolve: '*' with: list.
	self assert: (result size = list size).
	result := SmalltalkCI resolve: '.*' with: list.
	self assert: (result size = list size).
]

{ #category : 'testing' }
SmalltalkCITest >> testTravisDetection [
	| path hasJoshsApproval isTravisPath |
	path := SmalltalkCI platformClass imagePath.
	hasJoshsApproval := (SmalltalkCI getEnv: 'HAS_JOSH_K_SEAL_OF_APPROVAL') notNil.
	"Linux or macOS path"
	isTravisPath := ((path findString: '/home/travis/') = 1) or: [ (path findString: '/Users/travis/') = 1 ].
	(hasJoshsApproval and: isTravisPath)
		ifTrue: [ self assert: SmalltalkCI isTravisBuild ]
		ifFalse: [ self deny: SmalltalkCI isTravisBuild ].

	SmalltalkCI isTravisBuild ifTrue: [
		self
			assert: 'true'
			equals: (SmalltalkCI getEnv: 'CI').
		self
			assert: (SmalltalkCI getEnv: 'TRAVIS_SMALLTALK_VERSION') notEmpty
	]
]

{ #category : 'testing' }
SmalltalkCITest >> testTravisFold [
	| stream result index |
	stream := WriteStream on: (String new: 1000).
	SmalltalkCI platformClass travisFold: 'Some Stage Title' id: 'stage_id' on: stream block: [ stream nextPutAll: '@@@' ].
	result := stream contents.
	"Check content and respect order"
	index := result findString: 'travis_fold:start:stage_id'.
	self assert: index = 1.
	index := result findString: 'travis_time:start:stage_id_timer' startingAt: index.
	self assert: index > 0.
	index := result findString: 'Some Stage Title' startingAt: index.
	self assert: index > 0.
	index := result findString: (SmalltalkCI newLine) startingAt: index.
	self assert: index > 0.
	index := result findString: '@@@' startingAt: index.
	self assert: index > 0.
	index := result findString: 'travis_time:end:stage_id_timer' startingAt: index.
	self assert: index > 0.
	index := result findString: ',duration=' startingAt: index.
	self assert: index > 0.
	index := result findString: 'travis_fold:end:stage_id' startingAt: index.
	self assert: index > 0
	

]
