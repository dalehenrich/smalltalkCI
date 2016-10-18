testing
testReportFailure
	| runner reporter stream result expectedTests index |
	runner := SmalltalkCI testRunnerClass runClasses: {SCIExcludedTests} named: 'SmalltalkCI-Excluded'.
	stream := WriteStream on: (String new: 1000).
	reporter := SmalltalkCI testReporterStdoutClass report: runner on: stream.
	result := stream contents.
	expectedTests := SmalltalkCITest expectedTests: SCIExcludedTests.
	"Check content and respect order"
	index := result indexOfSubCollection: '##############'.
	self assert: index > 0.
	index := result indexOfSubCollection: SmalltalkCI platformClass ansiBold, SmalltalkCI  platformClass ansiBlue startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: 'SmalltalkCI-Excluded' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: expectedTests size asString, ' Tests' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: runner failedTests asString, ' Failures and' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: runner erroredTests asString, ' Errors' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: '(', runner passingTests asString ,' tests passed)' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: (runner failedTests + runner erroredTests) asString ,' tests did not pass' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: SmalltalkCI  platformClass ansiBold, SmalltalkCI  platformClass ansiRed startingAt: index.
	self assert: index > 0.
