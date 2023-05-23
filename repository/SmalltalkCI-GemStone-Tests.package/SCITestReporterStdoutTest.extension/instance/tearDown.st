*smalltalkci-gemstone-tests
tearDown
  SmalltalkCIGemstone
    isColorful:
      (SessionTemps current
        at: #'GS_TEST_REPORTER_IS_COLORFUL_CACHE'
        ifAbsent: [ nil ]).
  super tearDown