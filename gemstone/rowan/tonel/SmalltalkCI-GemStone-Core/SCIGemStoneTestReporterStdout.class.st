Class {
	#name : 'SCIGemStoneTestReporterStdout',
	#superclass : 'SCITestReporterStdout',
	#category : 'SmalltalkCI-GemStone-Core'
}

{ #category : 'helpers' }
SCIGemStoneTestReporterStdout >> newLine [
	stream crlf
]

{ #category : 'helpers' }
SCIGemStoneTestReporterStdout >> print: aString [
	stream nextPutAll: ((Smalltalk at: #UTF8Encoding) encode: aString)
]
