testing
testTravisFold
	| stream result index |
	stream := WriteStream on: (String new: 1000).
	SmalltalkCI platformClass travisFold: 'Some Stage Title' id: 'stage_id' on: stream block: [ stream nextPutAll: '@@@' ].
	result := stream contents.
	"Check content and respect order"
	index := result indexOfSubCollection: 'travis_fold:start:stage_id'.
	self assert: index = 1.
	index := result indexOfSubCollection: 'travis_time:start:stage_id_timer' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: 'Some Stage Title' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: (SmalltalkCI platformClass newLine) startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: '@@@' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: 'travis_time:end:stage_id_timer' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: ',duration=' startingAt: index.
	self assert: index > 0.
	index := result indexOfSubCollection: 'travis_fold:end:stage_id' startingAt: index.
	self assert: index > 0
	
