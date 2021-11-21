Class {
	#name : 'SmalltalkCIGemstone',
	#superclass : 'SmalltalkCI',
	#instVars : [
		'produceXMLLog',
		'xmlLogDirPath'
	],
	#category : 'SmalltalkCI-GemStone-Core'
}

{ #category : 'class organization' }
SmalltalkCIGemstone class >> allPackageNames [
	^ MCWorkingCopy allManagers collect: [ :wc | wc packageName ]
]

{ #category : 'class organization' }
SmalltalkCIGemstone class >> classesInPackage: packageName [
	| package |
	package := MCWorkingCopy allManagers
		detect: [ :wc | wc packageName = packageName ]
		ifNone: [ ^ #() ].
	^ package packageInfo classes
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> codeCoverageClass [
	^ nil "not implemented"
]

{ #category : 'transactions' }
SmalltalkCIGemstone class >> commitTransaction: operationLabel [
  [ 
  (Smalltalk at: #'System') commitTransaction
    ifFalse: [ 
      SmalltalkCI
        printToStdout:
          self ansiRed , 'Commit failed ' , operationLabel , self ansiReset ] ]
    on: Error
    do: [ :ex | 
      SmalltalkCI
        printToStdout:
          self ansiRed , 'Error ' , operationLabel , ': ' , ex description
            , self ansiReset ]
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> deleteFile: aFilename [
	GsFile removeServerFile: aFilename
]

{ #category : 'as yet unclassified' }
SmalltalkCIGemstone class >> deprecationWarning [
	| senderMethod |
	senderMethod := (GsProcess _frameContentsAt: 3) first. "First sender is SmalltalkCI>>deprecated"
	^ senderMethod inClass asString, '>>', senderMethod selector asString
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> explicitTestKeys [
  "keys that take precedence over tests from loaded project"

  ^ super explicitTestKeys , #(#'projects')
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> fileExists: aFilename [
	^ GsFile exists: aFilename
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> forceNewFileNamed: aFile do: aBlock [
	| stream |
	stream := BinaryOrTextFile openWrite: aFile.
	[ aBlock value: stream ] ensure: [ stream close ]
]

{ #category : 'helpers' }
SmalltalkCIGemstone class >> getAuthor [
  ^ (Smalltalk at: #'MCPlatformSupport') authorInitials
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> getEnv: aKey [
	^  (Smalltalk at: #System) gemEnvironmentVariable: aKey
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> hash: aString maxLength: aLength [
	^ aString hash asHexString asLowercase truncateTo: aLength
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> imagePath [
	^ (Smalltalk at: #ServerFileDirectory) default fullName
]

{ #category : 'bootstrapping' }
SmalltalkCIGemstone class >> installMetacello [
	(Smalltalk at: #Gofer) new
		package: 'GsUpgrader-Core';
		url: 'http://ss3.gemtalksystems.com/ss/gsUpgrader';
		load.
	(Smalltalk at: #GsUpgrader) upgradeMetacello
]

{ #category : 'helpers' }
SmalltalkCIGemstone class >> isHeadless [
	^ true
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> isPlatformCompatible [
	Smalltalk at: #'SystemVersion'
		ifPresent: [ :cl | ^ false ].
	^ true
]

{ #category : 'public-api' }
SmalltalkCIGemstone class >> loadAndTest: aFilenameString [
  ^ self
	basicNew initialize;
	spec: (SmalltalkCISpec fromFile: aFilenameString);
	load;
	test
]

{ #category : 'public-api' }
SmalltalkCIGemstone class >> loadAndTest: aFilenameString produceXMLLog: produceXMLLog [
  ^ self basicNew
    initialize;
    spec: (SmalltalkCISpec fromFile: aFilenameString);
    produceXMLLog: produceXMLLog
    load;
    test
]

{ #category : 'public-api' }
SmalltalkCIGemstone class >> loadAndTest: aFilenameString xmlLogDirPath: aString [
  ^ self basicNew
    initialize;
    xmlLogDirPath: aString;
    spec: (SmalltalkCISpec fromFile: aFilenameString);
    load;
    test
]

{ #category : 'executing-deprecated' }
SmalltalkCIGemstone class >> loadCIFor: aFilenameString [
	^ self load: aFilenameString
]

{ #category : 'executing-deprecated' }
SmalltalkCIGemstone class >> loadCIFor: aFilenameString projectDirectory: aDirectoryPathString [
	^ self load: aFilenameString projectDirectory: aDirectoryPathString
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> methodDictOf: aClass [
	^ aClass methodDictForEnv: 0
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> newLine [
	^ String crlf
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> pathNameDelimiter [
	"There is no Windows support yet"
	^ '/'
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> platformSymbol [
	^ #gemstone
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> quitImage [
	"Nothing to do"
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> readOnlyFileNamed: aFilename do: aBlock [
  | dir fileName |
  dir := ServerFileDirectory forFileName: aFilename.
  fileName := ServerFileDirectory localNameFor: aFilename.
  ^ dir readOnlyFileNamed: fileName do: aBlock
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> saveImage [
  self commitTransaction: 'attempting to saveImage'.
  ^ false	"For GemStone always assume that you want to resume/continue execution - the topaz job explicitly exits."
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> stdout [
	^ (Smalltalk at: #GsFile) stdoutServer
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> stringFor: aNumber maxDecimalPlaces: placesDesired [
	^ aNumber asFloat asStringUsingFormat: {0. placesDesired. false}
]

{ #category : 'public-api' }
SmalltalkCIGemstone class >> test: aFilenameString xmlLogDirPath: aString [
  ^ self basicNew
    initialize;
    xmlLogDirPath: aString;
    spec: (SmalltalkCISpec fromFile: aFilenameString);
    test
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> testRunnerClass [
	^ SCIGemStoneTestRunner
]

{ #category : 'compatibility' }
SmalltalkCIGemstone class >> workingDirectory [
	^ FileDirectory default pathName
]

{ #category : 'reporting' }
SmalltalkCIGemstone >> imageInfo [
	^ System gemVersionReport asReportString
]

{ #category : 'initialize-release' }
SmalltalkCIGemstone >> initialize [
	super initialize.
	self produceXMLLog: true
]

{ #category : 'loading' }
SmalltalkCIGemstone >> performMetacelloLoad: aBlock [
  ^ GsDeployer bulkMigrate: aBlock
]

{ #category : 'accessing' }
SmalltalkCIGemstone >> produceXMLLog: anObject [

	produceXMLLog := anObject
]

{ #category : 'external-deprecated' }
SmalltalkCIGemstone >> readSTONSpec: aFilePath [
  | dir fileName |
  SmalltalkCI deprecated: 'Use "SmalltalkCISpec>>fromFile:" instead'.
  dir := ServerFileDirectory forFileName: aFilePath.

  "Remove once GsDevKit_home does not depend on this side effect anymore"
  projectDirectory := dir fullName.

  fileName := ServerFileDirectory localNameFor: aFilePath.
  dir
    readOnlyFileNamed: fileName
    do: [ :fileStream | self spec: (SmalltalkCISpec fromStream: fileStream) ]
]

{ #category : 'executing' }
SmalltalkCIGemstone >> reportResults: aTestRunner [
	SCIGemStoneTestReporterStdout report: aTestRunner spec: self spec.
	produceXMLLog ifTrue: [
		SCIGemStoneTestReporterXML report: aTestRunner spec: self spec xmlLogDirPath: xmlLogDirPath ]
]

{ #category : 'accessing' }
SmalltalkCIGemstone >> xmlLogDirPath: anObject [

	xmlLogDirPath := anObject
]
