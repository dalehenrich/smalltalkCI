testing
testReportSuccess
	| runner reporter stream result expectedTests index |
	runner := SmalltalkCI testRunnerClass runClasses: {SmalltalkCITest} named: 'MyRunnerName'.
	stream := WriteStream on: (String new: 1000).
	reporter := SmalltalkCI testReporterXMLClass report: runner on: stream.
	result := stream contents.
	expectedTests := SmalltalkCITest expectedTests: SmalltalkCITest.
	"Check content and respect order"
	index := result indexOfSubCollection: '<?xml version="1.0" encoding="UTF-8"?>'.
	self assert: index = 1.
	index := result indexOfSubCollection: '<testsuite name="MyRunnerName"' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: 'tests="', expectedTests size asString, '"' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: 'failures="0" errors="0"' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: '<testcase classname="SmalltalkCI.Tests' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: '<system-out><![CDATA[]]></system-out>' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: '<system-err><![CDATA[]]></system-err>' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: '</testsuite>' startingAt: index.
	self assert: index > 0
