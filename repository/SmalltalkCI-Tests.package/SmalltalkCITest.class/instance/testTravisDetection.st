testing
testTravisDetection
	| path hasJoshsApproval isTravisPath |
	path := SmalltalkCI platformClass imagePath.
	hasJoshsApproval := (SmalltalkCI getEnv: 'HAS_JOSH_K_SEAL_OF_APPROVAL') notNil.
	"Linux or macOS path"
	isTravisPath := ((path indexOfSubCollection: '/home/travis/') = 1) or: [ (path indexOfSubCollection: '/Users/travis/') = 1 ].
	(hasJoshsApproval and: isTravisPath)
		ifTrue: [ self assert: SmalltalkCI isTravisBuild ]
		ifFalse: [ self deny: SmalltalkCI isTravisBuild ].

	SmalltalkCI isTravisBuild ifTrue: [
		self
			assert: 'true'
			equals: (SmalltalkCI getEnv: 'CI').
		self
			assert: (SmalltalkCI getEnv: 'TRAVIS_SMALLTALK_VERSION') notEmpty
	]