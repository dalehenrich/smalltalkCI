Class {
	#name : 'SCITestReporterXMLTest',
	#superclass : 'TestCase',
	#category : 'SmalltalkCI-Tests'
}

{ #category : 'testing' }
SCITestReporterXMLTest >> testReportFailure [
	| runner reporter stream result expectedTests index |
	runner := SmalltalkCI testRunnerClass runSpec: (
		SCIDummySpec
			named: 'XML-testReportFailure'
			forClass: SCIExcludedTests).
	stream := WriteStream on: (String new: 1000).
	reporter := SCITestReporterXML report: runner on: stream.
	result := stream contents.
	expectedTests := SmalltalkCITest expectedTests: SCIExcludedTests.
	"Check content and respect order"
	index := result findString: '<?xml version="1.0" encoding="UTF-8"?>'.
	self assert: index = 1.
	index := result findString: '<testsuite name="XML-testReportFailure"' startingAt: index.
	self assert: index > 0.
	index := result findString: 'tests="', expectedTests size asString, '"' startingAt: index.
	self assert: index > 0.
	index := result findString: 'failures="', runner failedTests asString ,'"' startingAt: index.
	self assert: index > 0.
	index := result findString: 'errors="', runner erroredTests asString ,'"' startingAt: index.
	self assert: index > 0.
	index := result findString: '<testcase classname="SmalltalkCI.Excluded.Tests' startingAt: index.
	self assert: index > 0.
	index := result findString: '<failure type="TestFailure"' startingAt: index.
	self assert: index > 0.
	index := result findString: '</failure>' startingAt: index.
	self assert: index > 0.
	index := result findString: '<system-out><![CDATA[]]></system-out>' startingAt: index.
	self assert: index > 0.
	index := result findString: '<system-err><![CDATA[]]></system-err>' startingAt: index.
	self assert: index > 0.
	index := result findString: '</testsuite>' startingAt: index.
	self assert: index > 0

]

{ #category : 'testing' }
SCITestReporterXMLTest >> testReportSuccess [
	| runner reporter stream result expectedTests index |
	runner := SmalltalkCI testRunnerClass runSpec: (
		SCIDummySpec
			named: 'XML-testReportSuccess'
			forClass: SmalltalkCITest).
	stream := WriteStream on: (String new: 1000).
	reporter := SCITestReporterXML report: runner on: stream.
	result := stream contents.
	expectedTests := SmalltalkCITest expectedTests: SmalltalkCITest.
	"Check content and respect order"
	index := result findString: '<?xml version="1.0" encoding="UTF-8"?>'.
	self assert: index = 1.
	index := result findString: '<testsuite name="XML-testReportSuccess"' startingAt: index.
	self assert: index > 0.
	index := result findString: 'tests="', expectedTests size asString, '"' startingAt: index.
	self assert: index > 0.
	index := result findString: 'failures="0" errors="0"' startingAt: index.
	self assert: index > 0.
	index := result findString: '<testcase classname="SmalltalkCI.Tests' startingAt: index.
	self assert: index > 0.
	index := result findString: '<system-out><![CDATA[]]></system-out>' startingAt: index.
	self assert: index > 0.
	index := result findString: '<system-err><![CDATA[]]></system-err>' startingAt: index.
	self assert: index > 0.
	index := result findString: '</testsuite>' startingAt: index.
	self assert: index > 0

]
