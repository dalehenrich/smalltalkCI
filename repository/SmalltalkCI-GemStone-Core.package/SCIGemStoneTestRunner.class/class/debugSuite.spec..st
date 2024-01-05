debugging
debugSuite: aTestSuite spec: aSCISpec
  ^ self new
    initializeOn: aTestSuite;
    spec: aSCISpec;
    debug