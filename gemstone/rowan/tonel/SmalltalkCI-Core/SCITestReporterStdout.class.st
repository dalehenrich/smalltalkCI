Class {
	#name : 'SCITestReporterStdout',
	#superclass : 'SCITestReporter',
	#category : 'SmalltalkCI-Core'
}

{ #category : 'executing' }
SCITestReporterStdout class >> report: aSCITestRunner spec: aSCISpec [
	self report: aSCITestRunner spec: aSCISpec on: SmalltalkCI stdout
]

{ #category : 'printing' }
SCITestReporterStdout >> printBanner: aTitle color: aColor [
	self printBanner: aTitle subtitle: '' color: aColor
]

{ #category : 'printing' }
SCITestReporterStdout >> printBanner: aTitle subtitle: aSubtitle color: aColor [
	| textLength separator |
	textLength := (aTitle size max: aSubtitle size).
	separator := String new: (textLength + 4) withAll: $#. "+ 4 for `#  #` (see below)"
	self newLine;
		setModeBold; print: aColor, separator; newLine;
		setModeBold; print: aColor, '# ', (self rightPad: aTitle to: textLength), ' #'; newLine.
	aSubtitle ifNotEmpty: [
		self setModeBold; print: aColor, '# ', (self rightPad: aSubtitle to: textLength), ' #'; newLine ].
	self
		setModeBold; print: aColor, separator; newLine;
		resetMode
]

{ #category : 'printing' }
SCITestReporterStdout >> printDeprecationWarnings [
	SmalltalkCI deprecationWarnings ifNotEmpty: [
    self
      newLine;
      printTravisFold: 'deprecation_warnings' action: 'start';
      setModeBoldRed;
      print: 'smalltalkCI Deprecation Warnings';
      resetMode;
      newLine.
    SmalltalkCI deprecationWarnings do: [ :each | self print: ' - ', each; newLine ].
    self printTravisFold: 'deprecation_warnings' action: 'end' ].
]

{ #category : 'printing' }
SCITestReporterStdout >> printEnd [
	self newLine; newLine; setModeBold.
	runner erroredTests > 0
		ifTrue: [ self setModeRed ]
		ifFalse: [
			runner failedTests > 0
				ifTrue: [ self setModeYellow ]
				ifFalse: [ self setModeGreen ] ].

	self
		print: '  Executed ', runner summary, '.';
		resetMode; newLine; newLine
]

{ #category : 'printing' }
SCITestReporterStdout >> printException: aResult [
	self
		printTravisFold: aResult foldName action: 'start';
		setModeBold;
		print: (aResult ansiTitleContractedTo: 70);
		newLine;
		setModeBold;
		print: aResult testError asString;
		resetMode.
	aResult stack ifNotNil: [
		self newLine;
			print: aResult stack;
			resetMode ].
	self printTravisFold: aResult foldName action: 'end'
]

{ #category : 'printing' }
SCITestReporterStdout >> printNotPassingResults [
	| title |
	title := (runner erroredTests + runner failedTests) asString, ' tests did not pass:'.
	self printBanner: title color: SmalltalkCI ansiRed.
	runner results keysAndValuesDo: [ :class :results | | notPassing |
		notPassing := results select: [ :result | result passed not ].
		notPassing ifNotEmpty: [
			self printTitle: class asString.
			notPassing do: [ :result | self printException: result ] ] ].
	SmalltalkCI isTravisBuild
		ifFalse: [ self printNotPassingSummary ]
]

{ #category : 'printing' }
SCITestReporterStdout >> printNotPassingSummary [
	self newLine; printBanner: 'Summary' color: SmalltalkCI ansiRed.
	runner results keysAndValuesDo: [ :class :results | | notPassing |
		notPassing := results select: [ :result | result passed not ].
		notPassing ifNotEmpty: [
			self printTitle: class asString.
			notPassing do: [ :result | self print: result ansiTitle; newLine ] ] ]
]

{ #category : 'printing' }
SCITestReporterStdout >> printPass: aResult [
	self print: aResult ansiTitle; newLine
]

{ #category : 'printing' }
SCITestReporterStdout >> printPassingResults [
	| title |
	self newLine; printTravisFold: 'passing_tests' action: 'start'.
	title := '(', runner passingTests asString, ' tests passed)'.
	self print: title; newLine.
	
	[ runner results keysAndValuesDo: [ :class :results | | passing |
		passing := results select: [ :result | result passed ].
		passing ifNotEmpty: [
			self printTitle: class asString.
			passing do: [ :result | self printPass: result ] ] ]
	] ensure: [ self printTravisFold: 'passing_tests' action: 'end' ]
]

{ #category : 'printing' }
SCITestReporterStdout >> printResults [
	(runner passingTests > 0 and: [ self spec hidePassingTests not ])
		ifTrue: [ self printPassingResults ].
	(runner isSuccessful not and: [ runner passingTests < runner totalTests])
		ifTrue: [ self printNotPassingResults ].
  self printDeprecationWarnings.

]

{ #category : 'printing' }
SCITestReporterStdout >> printStart [
	self printBanner: runner suiteName subtitle: runner summary color: SmalltalkCI ansiBlue
]

{ #category : 'printing' }
SCITestReporterStdout >> printTitle: aTitle [
	self
		setModeBold;
		newLine; print: aTitle; newLine;
		resetMode
]

{ #category : 'printing' }
SCITestReporterStdout >> printTravisFold: foldName action: action [
	SmalltalkCI isTravisBuild ifFalse: [ ^ self ].
	self print: (SmalltalkCI travisFold: foldName action: action)
]

{ #category : 'ansi' }
SCITestReporterStdout >> resetMode [
	self print: SmalltalkCI ansiReset
]

{ #category : 'helpers' }
SCITestReporterStdout >> rightPad: aString to: length [
	^ aString, (String new: (length - aString size) withAll: Character space)
]

{ #category : 'ansi' }
SCITestReporterStdout >> setModeBlue [
	self print: SmalltalkCI ansiBlue
]

{ #category : 'ansi' }
SCITestReporterStdout >> setModeBold [
	self print: SmalltalkCI ansiBold
]

{ #category : 'ansi' }
SCITestReporterStdout >> setModeBoldBlue [
	self setModeBold; setModeBlue
]

{ #category : 'ansi' }
SCITestReporterStdout >> setModeBoldRed [
	self setModeBold; setModeRed
]

{ #category : 'ansi' }
SCITestReporterStdout >> setModeGreen [
	self print: SmalltalkCI ansiGreen
]

{ #category : 'ansi' }
SCITestReporterStdout >> setModeRed [
	self print: SmalltalkCI ansiRed
]

{ #category : 'ansi' }
SCITestReporterStdout >> setModeYellow [
	self print: SmalltalkCI ansiYellow
]
