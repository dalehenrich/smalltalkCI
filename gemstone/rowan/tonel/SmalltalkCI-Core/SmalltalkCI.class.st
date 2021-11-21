Class {
	#name : 'SmalltalkCI',
	#superclass : 'SCIObjectWithSpec',
	#instVars : [
		'projectDirectory'
	],
	#classVars : [
		'DeprecationWarnings',
		'IsColorful',
		'PlatformClass',
		'TravisID'
	],
	#category : 'SmalltalkCI-Core'
}

{ #category : 'class organization' }
SmalltalkCI class >> allCategoryNames [
	^ Smalltalk organization categories collect: [ :c | c asString ]
]

{ #category : 'class organization' }
SmalltalkCI class >> allPackageNames [
	^ self platformClass allPackageNames
]

{ #category : 'ansi' }
SmalltalkCI class >> ansiBlue [
	^ self isColorful
		ifTrue: [ self escape, '[34m' ]
		ifFalse: [ '' ]
]

{ #category : 'ansi' }
SmalltalkCI class >> ansiBold [
	^ self isColorful
		ifTrue: [ self escape, '[1m' ]
		ifFalse: [ '' ]
]

{ #category : 'ansi' }
SmalltalkCI class >> ansiClear [
	^ self isColorful
		ifTrue: [ self escape, '[0K' ]
		ifFalse: [ '' ]
]

{ #category : 'ansi' }
SmalltalkCI class >> ansiGray [
	^ self isColorful
		ifTrue: [ self escape, '[37m' ]
		ifFalse: [ '' ]
]

{ #category : 'ansi' }
SmalltalkCI class >> ansiGreen [
	^ self isColorful
		ifTrue: [ self escape, '[32m' ]
		ifFalse: [ '' ]
]

{ #category : 'ansi' }
SmalltalkCI class >> ansiRed [
	^ self isColorful
		ifTrue: [ self escape, '[31m' ]
		ifFalse: [ '' ]
]

{ #category : 'ansi' }
SmalltalkCI class >> ansiReset [
	^ self isColorful
		ifTrue: [ self escape, '[0m' ]
		ifFalse: [ '' ]
]

{ #category : 'ansi' }
SmalltalkCI class >> ansiYellow [
	^ self isColorful
		ifTrue: [ self escape, '[33m' ]
		ifFalse: [ '' ]
]

{ #category : 'compatibility' }
SmalltalkCI class >> assureDirectoryExistence: aDirectory [
	"Currently only implemented for Squeak & Pharo"
	^ self platformClass assureDirectoryExistence: aDirectory
]

{ #category : 'helpers' }
SmalltalkCI class >> basename: aPath [
	^ aPath copyAfterLast: self pathNameDelimiter first
]

{ #category : 'constants' }
SmalltalkCI class >> buildDirectory [
	^ (self getEnv: 'SCIII_BUILD') ifNil: [ '' ]
]

{ #category : 'constants' }
SmalltalkCI class >> buildStatusFile [
	"Return full path only when buildDirectory notEmpty"
	(self buildDirectory notEmpty)
		ifTrue: [	^ self buildDirectory, self pathNameDelimiter, 'build_status.txt' ].
	^ 'build_status.txt'
]

{ #category : 'class organization' }
SmalltalkCI class >> classesForCategories: unresolvedCategeryNames [
	| resolvedNames |
	resolvedNames := self resolveAll: unresolvedCategeryNames with: self allCategoryNames.
	^ self classesWithCategoryNames: resolvedNames
]

{ #category : 'class organization' }
SmalltalkCI class >> classesForPackages: unresolvedPackageNames [
	^ self classesWithPackageNames: (self resolvedPackageNames: unresolvedPackageNames)
]

{ #category : 'class organization' }
SmalltalkCI class >> classesFrom: aDictionary [
	| classes |
	classes := Set new.
	aDictionary at: #classes
		ifPresent: [ :classList |
			classList do: [ :eachClass |
				Smalltalk at: eachClass ifPresent: [ :class | classes add: class ] ] ].
	
	aDictionary at: #categories
		ifPresent: [ :categories |
			classes addAll: (self classesForCategories: categories) ].

	aDictionary at: #packages
		ifPresent: [ :packages |
			classes addAll: (self classesForPackages: packages) ].
		
	aDictionary at: #'projects'
		ifPresent: [ :projectsList |
			classes addAll: (self classesOfProjects: projectsList) ].

	^ classes
]

{ #category : 'class organization' }
SmalltalkCI class >> classesInCategory: aCategory [
	^ (Smalltalk organization listAtCategoryNamed: aCategory) collect: [ :className | Smalltalk at: className ]
]

{ #category : 'class organization' }
SmalltalkCI class >> classesInPackage: packageName [
	^ self platformClass classesInPackage: packageName
]

{ #category : 'class organization' }
SmalltalkCI class >> classesOfProjects: projectList [
  | classes |
  classes := Set new.
  projectList do: [ :projectName | 
      | registration |
      registration := MetacelloProjectRegistration
        registrationForClassNamed: projectName
        ifAbsent: [].
      registration
        ifNotNil: [ classes addAll: registration currentlyLoadedClassesInProject ]
        ifNil: [ self printToStdout: 'Project ' , projectName printString , ' not registered (loaded)' ]].
  ^ classes
]

{ #category : 'class organization' }
SmalltalkCI class >> classesWithCategoryNames: categoryNames [
	| classes |
	classes := Set new.
	categoryNames do: [ :eachName |
		classes addAll: (self classesInCategory: eachName) ].
	^ classes
]

{ #category : 'class organization' }
SmalltalkCI class >> classesWithPackageNames: packageNames [
	| classes |
	classes := Set new.
	packageNames do: [ :eachName |
		classes addAll: (self classesInPackage: eachName) ].
	^ classes
]

{ #category : 'compatibility' }
SmalltalkCI class >> codeCoverageClass [
	^ self platformClass codeCoverageClass
]

{ #category : 'constants' }
SmalltalkCI class >> defaultAuthor [
	^ 'smalltalkCI'
]

{ #category : 'compatibility' }
SmalltalkCI class >> deleteFile: aFilename [
	self platformClass deleteFile: aFilename
]

{ #category : 'helpers' }
SmalltalkCI class >> deprecated: aMessage [
	self deprecationWarnings add:
		self platformClass deprecationWarning, ' (', aMessage, ')'
]

{ #category : 'helpers' }
SmalltalkCI class >> deprecatedReset [
	DeprecationWarnings := OrderedCollection new
]

{ #category : 'helpers' }
SmalltalkCI class >> deprecationWarning [
	self subclassResponsibility
]

{ #category : 'helpers' }
SmalltalkCI class >> deprecationWarnings [
	^ DeprecationWarnings ifNil: [ DeprecationWarnings := OrderedCollection new ]
]

{ #category : 'private' }
SmalltalkCI class >> deprecationWarnings: warnings [
	"This is used for testing."
	DeprecationWarnings := warnings
]

{ #category : 'helpers' }
SmalltalkCI class >> dirname: aPath [
	^ aPath copyUpToLast: self pathNameDelimiter first
]

{ #category : 'helpers' }
SmalltalkCI class >> ensureAuthor [
	self getAuthor ifEmpty: [
		self setAuthor: self defaultAuthor ]
]

{ #category : 'build-status' }
SmalltalkCI class >> ensureNoExistingBuildStatusFile [
	(self fileExists: self buildStatusFile)
		ifTrue: [ SCIError signal: 'A build status file already exists.' ]
]

{ #category : 'ansi' }
SmalltalkCI class >> escape [
	^ Character escape asString
]

{ #category : 'compatibility' }
SmalltalkCI class >> explicitTestKeys [
  "keys that take precedence over tests from loaded project"

  ^ #(#'classes' #'categories' #'packages')
]

{ #category : 'helpers' }
SmalltalkCI class >> failAndQuit: aString [
	"Prints and persists an internal failure for debugging purposes"
	| message |
	<haltOrBreakpointForTesting> "Skip method in Pharo linter"
	
	message := aString, String cr, String cr, 'To inspect this error, open the image in the "', self platformClass imagePath, '" directory.'.
	self
		printErrorToStdout: message;
		saveAndQuitImage;
		halt
]

{ #category : 'compatibility' }
SmalltalkCI class >> fileExists: aFilename [
	^ self platformClass fileExists: aFilename
]

{ #category : 'folding' }
SmalltalkCI class >> fold: aTitle block: aBlock [
	self fold: aTitle on: self stdout block: aBlock
]

{ #category : 'folding' }
SmalltalkCI class >> fold: aTitle on: aStream block: aBlock [
	| timeToRun |
	aStream nextPutAll: (self foldTitle: aTitle); flush.
	timeToRun := SmalltalkCI timeToRun: [ aBlock value ].
	aStream nextPutAll: self newLine, ' > Done in ', (self stringFor: timeToRun maxDecimalPlaces: 3), 'ms.', self newLine; flush
]

{ #category : 'folding' }
SmalltalkCI class >> foldTitle: aTitle [
	^ self ansiBold, self ansiBlue, aTitle, self ansiReset, self newLine
]

{ #category : 'instance creation' }
SmalltalkCI class >> for: aSpec [
	^ self platformClass basicNew
		initialize;
		spec: aSpec;
		yourself
]

{ #category : 'compatibility' }
SmalltalkCI class >> forceNewFileNamed: aFile do: aBlock [
	^ self platformClass forceNewFileNamed: aFile do: aBlock
]

{ #category : 'helpers' }
SmalltalkCI class >> getAuthor [
	^ self platformClass getAuthor
]

{ #category : 'compatibility' }
SmalltalkCI class >> getEnv: aKey [
	^ self platformClass getEnv: aKey
]

{ #category : 'compatibility' }
SmalltalkCI class >> hash: aString maxLength: aLength [
	^ self platformClass hash: aString maxLength: aLength
]

{ #category : 'compatibility' }
SmalltalkCI class >> imagePath [
	^ self subclassResponsibility
]

{ #category : 'bootstrapping' }
SmalltalkCI class >> installMetacello [
	^ self subclassResponsibility
]

{ #category : 'helpers' }
SmalltalkCI class >> isAppVeyorBuild [
	^ (self getEnv: 'APPVEYOR') = 'True'
]

{ #category : 'helpers' }
SmalltalkCI class >> isColorful [
	"IsColorful := nil"
	^ IsColorful ifNil: [ IsColorful := (self getEnv: 'SCIII_COLORFUL') = 'true' ]
]

{ #category : 'helpers' }
SmalltalkCI class >> isDebug [
	^ (self getEnv: 'SCIII_DEBUG') = 'true'
]

{ #category : 'helpers' }
SmalltalkCI class >> isGitLabCIBuild [
	^ (self getEnv: 'GITLAB_CI') = 'true'
]

{ #category : 'helpers' }
SmalltalkCI class >> isHeadless [
	^ self platformClass isHeadless
]

{ #category : 'bootstrapping' }
SmalltalkCI class >> isMetacelloInstalled [ 
	^ Smalltalk includesKey: #Metacello
]

{ #category : 'compatibility' }
SmalltalkCI class >> isPlatformCompatible [
	self subclassResponsibility
]

{ #category : 'helpers' }
SmalltalkCI class >> isTravisBuild [
	^ (self getEnv: 'TRAVIS') = 'true'
]

{ #category : 'public-api' }
SmalltalkCI class >> load: fullPathToConfig [
	^ self
		load: fullPathToConfig
		projectDirectory: (self dirname: fullPathToConfig)
]

{ #category : 'public-api' }
SmalltalkCI class >> load: fullPathToConfig projectDirectory: aProjectDirectory [
	^ (self newInstanceFor: fullPathToConfig projectDirectory: aProjectDirectory)
		load
]

{ #category : 'compatibility' }
SmalltalkCI class >> methodDictOf: aClass [
	^ self platformClass methodDictOf: aClass
]

{ #category : 'instance creation' }
SmalltalkCI class >> new [
	self error: 'Use #load: or #test:'
]

{ #category : 'instance creation' }
SmalltalkCI class >> newInstance [
	^ self platformClass basicNew initialize
]

{ #category : 'instance creation' }
SmalltalkCI class >> newInstanceFor: aFilename projectDirectory: aProjectDirectory [
	^ self newInstance
		spec: (SmalltalkCISpec fromFile: aFilename);
		projectDirectory: aProjectDirectory;
		yourself
]

{ #category : 'compatibility' }
SmalltalkCI class >> newLine [
	^ String cr
]

{ #category : 'folding' }
SmalltalkCI class >> newTravisID [
	"Random and image-specific identifier for Travis folds"
	| r |
	r := Random new.
	^ (ByteArray with: (r nextInt: 255) with: (r nextInt: 255)) hex

]

{ #category : 'class organization' }
SmalltalkCI class >> packageNamed: aString ifAbsent: errorBlock [
	^ self platformClass packageNamed: aString ifAbsent: errorBlock
]

{ #category : 'compatibility' }
SmalltalkCI class >> pathNameDelimiter [
	^ self platformClass pathNameDelimiter
]

{ #category : 'accessing' }
SmalltalkCI class >> platformClass [
	"There will be just one subclass installed (for each platform)"
	^ PlatformClass ifNil: [
		SmalltalkCI allSubclasses detect: [ :cl | cl isPlatformCompatible ] ]
]

{ #category : 'private' }
SmalltalkCI class >> platformClass: aClass [
	"This is used for testing."
	PlatformClass := aClass
]

{ #category : 'compatibility' }
SmalltalkCI class >> platformSymbol [
	^ self platformClass platformSymbol
]

{ #category : 'helpers' }
SmalltalkCI class >> printDebug: aString [ 
	SmalltalkCI isDebug
		ifTrue: [SmalltalkCI printToStdout: aString]
]

{ #category : 'helpers' }
SmalltalkCI class >> printErrorToStdout: msg [
	self printToStdout: msg ansiColor: self ansiRed
]

{ #category : 'finalizing' }
SmalltalkCI class >> printStepsToReproduceLocally [
	| smalltalkSelection |
	smalltalkSelection := self smalltalkSelection
		ifNotNil: [ :s | ' -s ', s ] ifNil: [ '' ].
	SmalltalkCI printWarningToStdout: 'To reproduce the failed build locally, download smalltalkCI, and try to run something like:

	bin/smalltalkci', smalltalkSelection ,' --headfull /path/to/.smalltalk.ston
'
]

{ #category : 'helpers' }
SmalltalkCI class >> printToStdout: msg [
	self stdout nextPutAll: msg; cr; flush
]

{ #category : 'helpers' }
SmalltalkCI class >> printToStdout: msg ansiColor: ansiColor [
	self stdout cr; nextPutAll: ansiColor, msg, self ansiReset; cr; flush
]

{ #category : 'helpers' }
SmalltalkCI class >> printWarningToStdout: msg [
	self printToStdout: msg ansiColor: self ansiYellow
]

{ #category : 'helpers' }
SmalltalkCI class >> promptToProceed [

	"Delegate to method of different name to avoid infinite recursion if promptToProceed isn't implemented for this platform"
	^ self platformClass promptToProceedImpl
]

{ #category : 'helpers' }
SmalltalkCI class >> promptToProceedImpl [
	"Proceed by default"
	^ true
]

{ #category : 'image-operations' }
SmalltalkCI class >> quitImage [
	SmalltalkCI platformClass quitImage
]

{ #category : 'compatibility' }
SmalltalkCI class >> readOnlyFileNamed: aFilename do: aBlock [
	^ self platformClass readOnlyFileNamed: aFilename do: aBlock
]

{ #category : 'build-status' }
SmalltalkCI class >> reportBuildError: anError [
	self reportToBuildStatusFile: anError messageText
]

{ #category : 'build-status' }
SmalltalkCI class >> reportBuildSuccess [
	self reportToBuildStatusFile: '[success]'
]

{ #category : 'build-status' }
SmalltalkCI class >> reportToBuildStatusFile: aMessage [
	self forceNewFileNamed: self buildStatusFile do: [ :stream |
		"Manually convert cr to crlf"
		stream nextPutAll: (aMessage copyReplaceAll: String cr with: String crlf) ]
]

{ #category : 'bootstrapping' }
SmalltalkCI class >> requireMetacello [
	self isMetacelloInstalled ifTrue: [ ^ self ].
    	
	self installMetacello.
	self isMetacelloInstalled
		ifFalse: [ self error: 'Metacello could not be loaded.' ]
]

{ #category : 'class organization' }
SmalltalkCI class >> resolve: unresolvedName with: knownNames [
	unresolvedName last = $* ifTrue: [ | start |
		start := unresolvedName allButLast.
		"Treat .* similar to just *"
		(start isEmpty not and: [ start last = $. ])
			ifTrue: [ start := start allButLast ].
		start ifEmpty: [ ^ knownNames ].
		^ knownNames select: [ :ea | ea beginsWith: start ] ].
	^ knownNames select: [ :ea | ea = unresolvedName ]
]

{ #category : 'class organization' }
SmalltalkCI class >> resolveAll: names with: knownNames [
	| items |
	items := Set new.
	names do: [ :n |
		items addAll: (self resolve: n with: knownNames) ].
	^ items asArray
]

{ #category : 'class organization' }
SmalltalkCI class >> resolvedPackageNames: unresolvedPackageNames [
	^ self resolveAll: unresolvedPackageNames with: self allPackageNames
]

{ #category : 'helpers' }
SmalltalkCI class >> run: aBlock spec: aSmalltalkCISpec in: aProjectDirectory [
	"No coverage testing enabled"
	^ aBlock value
]

{ #category : 'image-operations' }
SmalltalkCI class >> saveAndQuitImage [
	self platformClass saveImage
		"Close image only if it is not resuming."
		ifFalse: [ self platformClass quitImage ]
]

{ #category : 'compatibility' }
SmalltalkCI class >> saveImage [
	self subclassResponsibility
]

{ #category : 'helpers' }
SmalltalkCI class >> setAuthor: anAuthor [
	(Smalltalk at: #MetacelloPlatform) current authorName: anAuthor
]

{ #category : 'finalizing' }
SmalltalkCI class >> shutdown: buildSuccessful [
	self isHeadless
		ifTrue: [ self shutdownHeadless: buildSuccessful ]
]

{ #category : 'finalizing' }
SmalltalkCI class >> shutdownHeadless: buildSuccessful [
	buildSuccessful
		ifTrue: [ self quitImage ]
		ifFalse: [
			self printStepsToReproduceLocally.
			self saveAndQuitImage ]
]

{ #category : 'helpers' }
SmalltalkCI class >> smalltalkSelection [
	^ SmalltalkCI getEnv: 'SCIII_SMALLTALK'
]

{ #category : 'folding' }
SmalltalkCI class >> stage: stageTitle id: anID block: aBlock [
	self isTravisBuild
		ifTrue: [ self travisFold: stageTitle id: anID block: aBlock ]
		ifFalse: [ self fold: stageTitle block: aBlock ]
]

{ #category : 'helpers' }
SmalltalkCI class >> stdout [
	^ self platformClass stdout
]

{ #category : 'compatibility' }
SmalltalkCI class >> stringFor: aNumber maxDecimalPlaces: placesDesired [
	^ self platformClass stringFor: aNumber maxDecimalPlaces: placesDesired
]

{ #category : 'public-api' }
SmalltalkCI class >> test: fullPathToConfig [
	^ self
		test: fullPathToConfig
		projectDirectory: (self dirname: fullPathToConfig)
]

{ #category : 'public-api' }
SmalltalkCI class >> test: fullPathToConfig named: aName [
	^ self test: fullPathToConfig named: aName projectDirectory: (self dirname: fullPathToConfig)
]

{ #category : 'public-api' }
SmalltalkCI class >> test: fullPathToConfig named: aName projectDirectory: aProjectDirectory [
	| instance |
	instance := self newInstanceFor: fullPathToConfig projectDirectory: aProjectDirectory.
	instance spec name: aName.
	^ instance test
]

{ #category : 'public-api' }
SmalltalkCI class >> test: fullPathToConfig projectDirectory: aProjectDirectory [
	 ^ (self newInstanceFor: fullPathToConfig projectDirectory: aProjectDirectory)
		test
]

{ #category : 'compatibility' }
SmalltalkCI class >> testRunnerClass [
	^ self platformClass testRunnerClass
]

{ #category : 'compatibility' }
SmalltalkCI class >> timeToRun: aBlock [
	"BlockClosure>>timeToRun returns Duration in Pharo"
	^ Time millisecondsToRun: aBlock
]

{ #category : 'folding' }
SmalltalkCI class >> travisFold: foldName action: action [
	^ 'travis_fold:', action, ':', foldName, '_', self travisID, self newLine, self ansiClear
]

{ #category : 'folding' }
SmalltalkCI class >> travisFold: aTitle id: anID block: aBlock [
	self travisFold: aTitle id: anID on: self stdout block: aBlock
]

{ #category : 'folding' }
SmalltalkCI class >> travisFold: aTitle id: anID on: aStream block: aBlock [
	aStream nextPutAll: (self travisFold: anID action: 'start'); flush.
	[ self travisTime: aTitle foldName: anID on: aStream block: aBlock]
		ensure: [aStream nextPutAll: (self travisFold: anID action: 'end'); flush ]
]

{ #category : 'accessing' }
SmalltalkCI class >> travisID [
	"TravisID := nil"
	^ TravisID ifNil: [ TravisID := self newTravisID ]
]

{ #category : 'folding' }
SmalltalkCI class >> travisTime: aTitle foldName: foldName on: aStream block: aBlock [
	| timerName start |
	timerName := foldName, '_timer_', self travisID.
	aStream
		nextPutAll: 'travis_time:start:', timerName, self newLine, self ansiClear;
		nextPutAll: (self foldTitle: aTitle); flush.
	start := Time millisecondClockValue * 1000000.
	aBlock ensure: [ | finish duration |
		finish := Time millisecondClockValue * 1000000.
		duration := finish - start.
		aStream nextPutAll: self newLine, 'travis_time:end:', timerName, ':start=', start asString,
			',finish=', finish asString, ',duration=', duration asString, self newLine, self ansiClear; flush ]
]

{ #category : 'build-status' }
SmalltalkCI class >> withBuildStatusReportingDo: aBlock [
	[ self ensureNoExistingBuildStatusFile.
	 aBlock value.
	 self reportBuildSuccess ] on: SCIError
			do: [ :e | self reportBuildError: e ]
]

{ #category : 'compatibility' }
SmalltalkCI class >> workingDirectory [
	^ self platformClass workingDirectory
]

{ #category : 'executing' }
SmalltalkCI >> basicLoad [
	self ensureSpecIsValid.
	self reportImageInfo.
	self class
		stage: 'Loading project...'
		id: 'load_project'
		block: [
			[
			self prepareForLoading.
			"Install all specs for the current platform"
			self spec compatibleLoadSpecs do: [ :each | each loadProjectOn: self ] ]
				ensure: [ self finishUpAfterLoading ] ]
]

{ #category : 'executing' }
SmalltalkCI >> basicTest [
	| runner |
	self ensureSpecIsValid.
	self class
		stage: 'Testing project...'
		id: 'test_project'
		block: [
			self prepareForTesting.
			self executionClass
				run: [ runner := self runTests ]
				spec: self spec
				in: self projectDirectory.
			self finishUpAfterTesting ].
	self reportResults: runner.
	runner isSuccessful
		ifFalse: [ SCIError signal: '[test failure]' ]
]

{ #category : 'external-deprecated' }
SmalltalkCI >> compatibleConfigurationsFor: aPlatform [
	SmalltalkCI deprecated: 'Use "spec compatibleConfigurationsFor:" instead'.
	^ self spec compatibleConfigurationsFor: aPlatform
]

{ #category : 'external-deprecated' }
SmalltalkCI >> compatibleSpecs [
	SmalltalkCI deprecated: 'Use "spec compatibleLoadSpecs" instead'.
	^ self spec compatibleLoadSpecs
]

{ #category : 'helpers' }
SmalltalkCI >> ensureSpecIsValid [
	self spec isValid ifFalse: [
		SCIError signal: 'SmalltalkCISpec is invalid: "', self spec originalError asString, '".

Please check for invalid characters and trailing commas.']
]

{ #category : 'helpers' }
SmalltalkCI >> executionClass [
	^ self isCoverageTestingEnabled
		ifTrue: [ self class codeCoverageClass ]
		ifFalse: [ self class ]
]

{ #category : 'reporting' }
SmalltalkCI >> fileInCompatibleCustomScripts: aPhase [
	(self spec compatibleCustomScripts: aPhase)
		do: [ :each | each fileInFrom: self projectDirectory ]
]

{ #category : 'executing' }
SmalltalkCI >> finishUpAfterLoading [
	self fileInCompatibleCustomScripts: 'postLoading'
]

{ #category : 'executing' }
SmalltalkCI >> finishUpAfterTesting [
	self fileInCompatibleCustomScripts: 'postTesting'
]

{ #category : 'reporting' }
SmalltalkCI >> imageInfo [
	self subclassResponsibility
]

{ #category : 'initialize-release' }
SmalltalkCI >> initialize [
	self class ensureAuthor
]

{ #category : 'helpers' }
SmalltalkCI >> isCoverageTestingEnabled [
	^ SmalltalkCI platformSymbol ~= #gemstone and: [ self spec coverageEnabled ]
]

{ #category : 'executing' }
SmalltalkCI >> load [
	self class withBuildStatusReportingDo: [ self basicLoad ]
]

{ #category : 'loading' }
SmalltalkCI >> performMetacelloLoad: aBlock [
	^ aBlock value
]

{ #category : 'executing' }
SmalltalkCI >> prepareForLoading [
	self fileInCompatibleCustomScripts: 'preLoading'
]

{ #category : 'executing' }
SmalltalkCI >> prepareForTesting [
	self fileInCompatibleCustomScripts: 'preTesting'
]

{ #category : 'accessing' }
SmalltalkCI >> projectDirectory [

	^ projectDirectory
]

{ #category : 'accessing' }
SmalltalkCI >> projectDirectory: anObject [

	projectDirectory := anObject
]

{ #category : 'external-deprecated' }
SmalltalkCI >> readSTONSpec: aFilename [
  SmalltalkCI deprecated: 'Use "SmalltalkCISpec>>fromFile:" instead'.
  self subclassResponsibility
]

{ #category : 'reporting' }
SmalltalkCI >> reportImageInfo [
	self class
		stage: 'Image Information'
		id: 'image_info'
		block: [ SmalltalkCI printToStdout: self imageInfo ]
]

{ #category : 'reporting' }
SmalltalkCI >> reportResults: aTestRunner [
	SCITestReporterStdout report: aTestRunner spec: self spec.
	SCITestReporterXML report: aTestRunner spec: self spec
]

{ #category : 'executing' }
SmalltalkCI >> runTests [
	^ self class testRunnerClass
		runSpec: self spec
]

{ #category : 'executing' }
SmalltalkCI >> test [
	| hasThrownError |
	"self class withBuildStatusReportingDo: [ self basicTest ]"

	"test should not shutdown image in the future (see #242), the below is a terrible workaround and only to keep the behavior for GsDevKit compatibility"
	hasThrownError := false.
	self class withBuildStatusReportingDo: [
		[ self basicTest ] on: SCIError do: [ :e | 
			hasThrownError := true.
			"Create new error, GemStone does not allow to signal an exception twice"
			SCIError signal: e messageText ]].
	SmalltalkCI shutdown: hasThrownError not
]

{ #category : 'external-deprecated' }
SmalltalkCI >> testCI [
	SmalltalkCI deprecated: 'Use SmalltalkCI>>test instead'.
	self test
]
