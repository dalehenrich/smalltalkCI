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
                  "expect to be doing remote debugging with topaz debuggem command"
                  System waitForDebug ] ] ]
            on: self class skipExceptions
            do: [ :skip | result skipped: true ] ]).
  self printProgress: result.
  (results at: aTestCase class ifAbsentPut: [ OrderedCollection new ])
    add: result