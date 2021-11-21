Class {
	#name : 'SCIGemStoneTestRunner',
	#superclass : 'SCITestRunner',
	#category : 'SmalltalkCI-GemStone-Core'
}

{ #category : 'private' }
SCIGemStoneTestRunner >> serializeError: error of: aTestCase [
  SmalltalkCI platformClass isTravisBuild
    ifFalse: [ 
      "only snap off continuation if doing a local build where developer can access continuations"
      (Smalltalk at: #'DebuggerLogEntry')
        createContinuationLabeled: self suiteName , ': ' , aTestCase printString.
      SmalltalkCI platformClass
        commitTransaction: 'attempting to log test case defect continuation' ]
]

{ #category : 'private' }
SCIGemStoneTestRunner >> stackTraceString: err of: aTestCase [
	^ (Smalltalk at: #GsProcess) stackReportToLevel: 100
]
