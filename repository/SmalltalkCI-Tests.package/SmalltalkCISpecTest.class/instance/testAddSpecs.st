testing
testAddSpecs
	self assert: 0 equals: (self spec loading size).
	self spec addLoadSpec: SCIAbstractLoadSpec new.
	self assert: 0 equals: (self spec loading size).
	self spec addLoadSpec: self _loadSpecInstance1.
	self assert: 0 equals: (self spec loading size).
	self spec addLoadSpec: self _loadSpecInstance2.
	self assert: 1 equals: (self spec loading size).