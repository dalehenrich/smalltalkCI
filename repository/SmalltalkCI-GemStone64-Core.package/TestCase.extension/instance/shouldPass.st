*smalltalkci-gemstone64-core
shouldPass
  "Unless the selector is in the list we get from #expectedFailures, we expect it to pass"

  ^ (self expectedFailures includes: testSelector) not
