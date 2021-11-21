Class {
	#name : 'SCIGemStoneTestReporterXML',
	#superclass : 'SCITestReporterXML',
	#category : 'SmalltalkCI-GemStone-Core'
}

{ #category : 'executing' }
SCIGemStoneTestReporterXML class >> report: aSCITestRunner spec: aSCISpec xmlLogDirPath: xmlLogDirPath [
	| cacheStream |
	cacheStream := AnsiWriteStream on: String new.
	[ self report: aSCITestRunner spec: aSCISpec on: cacheStream.
	SmalltalkCI
		forceNewFileNamed: (self xmlFileNamed: aSCITestRunner suiteName in: xmlLogDirPath)
		do: [ :stream | stream nextPutAll: cacheStream ]]
			ensure: [ cacheStream close ]
]

{ #category : 'executing-deprecated' }
SCIGemStoneTestReporterXML class >> report: aSCITestRunner xmlLogDirPath: xmlLogDirPath [
	SmalltalkCI deprecated: 'Use report:spec:xmlLogDirPath: instead'.
	self report: aSCITestRunner spec: SmalltalkCISpec new xmlLogDirPath: xmlLogDirPath
]

{ #category : 'helpers' }
SCIGemStoneTestReporterXML class >> xmlFileNamed: aName in: aPath [
  | fileName |
  fileName := aName, '.xml'.
  aPath ifNotNil: [
	^ aPath, SmalltalkCIGemstone pathNameDelimiter, fileName ].
  ^ ((Smalltalk at: #System) gemEnvironmentVariable: 'SMALLTALK_CI_BUILD')
    ifNotNil: [ :smalltalk_ci_build | smalltalk_ci_build , SmalltalkCIGemstone pathNameDelimiter, fileName ]
    ifNil: [ fileName ]
]
