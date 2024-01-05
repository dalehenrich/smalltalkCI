debugging
debugCase: aTestCase
  | result |
  SmalltalkCI printDebug: aTestCase asString.
  result := SCITestRunnerResult new
    testCase: aTestCase;
    yourself.
  result
    time:
      (SmalltalkCI
        timeToRun: [ 
          [ 
          [ self basicDebugCase: aTestCase ]
            on: self class errorExceptions
            do: [ :err | 
              result testError: err.
              aTestCase shouldPass
                ifTrue: [ 
                  (System respondsTo: #'waitForDebug')
                    ifTrue: [ 
                      "expect to be doing remote debugging with topaz debuggem command (3.7.0 and beyond)"
                      System perform: #'waitForDebug' ]
                    ifFalse: [ 
                      (self spec testing at: #'serializeError' ifAbsent: [ true ])
                        ifTrue: [ self serializeError: result testError of: aTestCase ].
                      result stack: (self stackTraceString: err of: aTestCase) ] ] ] ]
            on: self class skipExceptions
            do: [ :skip | result skipped: true ] ]).
  self printProgress: result.
  (results at: aTestCase class ifAbsentPut: [ OrderedCollection new ])
    add: result