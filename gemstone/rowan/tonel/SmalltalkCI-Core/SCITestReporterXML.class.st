Class {
	#name : 'SCITestReporterXML',
	#superclass : 'SCITestReporter',
	#category : 'SmalltalkCI-Core'
}

{ #category : 'executing' }
SCITestReporterXML class >> report: aSCITestRunner spec: aSCISpec [
	SmalltalkCI forceNewFileNamed: (aSCITestRunner suiteName , '.xml') do: [ :stream |
		self report: aSCITestRunner spec: aSCISpec on: stream ]
]

{ #category : 'printing' }
SCITestReporterXML >> encode: aString [
	^ ((aString asString
		copyReplaceAll: '&' with: '&amp;')
		copyReplaceAll: '"' with: '&quot;')
		copyReplaceAll: '<' with: '&lt;'
]

{ #category : 'printing' }
SCITestReporterXML >> printEnd [
	self
		tab;
		print: '<system-out><![CDATA[]]></system-out>'; newLine;
		tab; print: '<system-err><![CDATA[]]></system-err>'; newLine;
		print: '</testsuite>'.
]

{ #category : 'printing' }
SCITestReporterXML >> printException: aResult [
	| error type |
	error := aResult testError.
	type := aResult errored
		ifTrue: [ 'error' ]
		ifFalse: [ 'failure' ].
	
	self
		tab; tab; print: '<', type, ' type="', (self encode: error class name);
		print: '" message="', (self encode: (error messageText ifNil: [ error description ])), '">'.
	aResult stack ifNotNil: [
		self
			newLine; print: (self encode: aResult stack);
			tab; tab ].
	self print: '</', type, '>'; newLine
]

{ #category : 'printing' }
SCITestReporterXML >> printResult: aResult [
	self
		tab; print: '<testcase classname="';
		print: (self encode: (aResult testCase class category asString copyReplaceAll: '-' with: '.'));
		print: '.', (self encode: aResult testCase class name), '" ';
		print: 'name="', (self encode: aResult testCase selector), '" ';
		print: 'time="', (aResult time / 1000.0) asString, '">'.
	aResult passed ifFalse: [
		self newLine.
		super printResult: aResult.
		self tab ].
	self print: '</testcase>'; newLine
]

{ #category : 'printing' }
SCITestReporterXML >> printStart [
	self
		print: '<?xml version="1.0" encoding="UTF-8"?>'; newLine;
		print: '<testsuite name="', (self encode: runner suiteName);
    		print: '" tests="', runner totalTests asString;
    		print: '" failures="', runner failedTests asString;
    		print: '" errors="', runner erroredTests asString;
    		print: '" time="', (runner suiteTime / 1000.0) asString , '">';
		newLine

]
