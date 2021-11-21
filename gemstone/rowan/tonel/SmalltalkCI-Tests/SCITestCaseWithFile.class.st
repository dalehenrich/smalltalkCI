Class {
	#name : 'SCITestCaseWithFile',
	#superclass : 'TestCase',
	#category : 'SmalltalkCI-Tests'
}

{ #category : 'constants' }
SCITestCaseWithFile class >> testFileContents [
	self subclassResponsibility
]

{ #category : 'constants' }
SCITestCaseWithFile class >> testFileName [
	self subclassResponsibility
]

{ #category : 'file-handling' }
SCITestCaseWithFile >> createTestFile [
	self assert: false equals: (SmalltalkCI fileExists: self fullTestFilePath).
	SmalltalkCI
		forceNewFileNamed: self fullTestFilePath
		do: [ :stream | stream nextPutAll: self class testFileContents ]
]

{ #category : 'file-handling' }
SCITestCaseWithFile >> deleteTestFile [
	(SmalltalkCI fileExists: self fullTestFilePath)
		ifTrue: [ SmalltalkCI deleteFile: self fullTestFilePath ]
]

{ #category : 'file-handling' }
SCITestCaseWithFile >> fullTestFilePath [
	^ SmalltalkCI workingDirectory, SmalltalkCI pathNameDelimiter, self class testFileName
]

{ #category : 'file-handling' }
SCITestCaseWithFile >> withTestFileDo: aBlock [
	[ self createTestFile.
	aBlock value: self fullTestFilePath ]
		ensure: [ self deleteTestFile ]
]
