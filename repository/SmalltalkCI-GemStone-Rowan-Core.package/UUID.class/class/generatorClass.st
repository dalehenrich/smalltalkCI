accessing
generatorClass
  self _generatorClass ifNil: [ ^ FastUUIDGenerator ].
  ^ self _generatorClass