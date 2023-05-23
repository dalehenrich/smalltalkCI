*smalltalkci-gemstone-tests
setUp
  super setUp.
  SessionTemps current
    at: #'GS_TEST_REPORTER_IS_COLORFUL_CACHE'
    put: SmalltalkCIGemstone isColorful.
  SmalltalkCIGemstone isColorful: true