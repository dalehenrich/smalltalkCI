running
setUp
  super setUp.
  currentUuidGeneratorClass := UUID _generatorClass.
  UUID generatorClass: self generatorClass