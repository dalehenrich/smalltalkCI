Class {
	#name : 'SCICustomScriptTest',
	#superclass : 'SCITestCaseWithFile',
	#category : 'SmalltalkCI-Tests'
}

{ #category : 'constants' }
SCICustomScriptTest class >> testFileContents [
	^ 'Smalltalk at: #SCICustomScriptTestFileResult put: true.'
]

{ #category : 'constants' }
SCICustomScriptTest class >> testFileName [
	^  '__fileInTest.st'
]

{ #category : 'testing' }
SCICustomScriptTest >> testFileInFrom [
	self withTestFileDo: [ :testFile | | filename dirname |
		filename := SmalltalkCI basename: testFile.
		dirname := SmalltalkCI dirname: testFile.
		(SCICustomScript newForPath: filename) fileInFrom: dirname.
		self assert: (Smalltalk at: #SCICustomScriptTestFileResult).
		Smalltalk at: #SCICustomScriptTestFileResult put: nil ]
]
