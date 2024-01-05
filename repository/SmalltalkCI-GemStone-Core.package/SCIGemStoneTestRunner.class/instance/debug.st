debugging
debug
  [ 
  self setUp.
  suiteTime := SmalltalkCI timeToRun: [ self debugAll ] ]
    ensure: [ self tearDown ]