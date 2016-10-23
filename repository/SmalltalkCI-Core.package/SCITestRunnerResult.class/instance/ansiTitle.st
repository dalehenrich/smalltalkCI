accessing
ansiTitle
	| prefix |
	prefix := self passed
		ifTrue: [ self class checkMark, SmalltalkCI platformClass ansiReset ]
		ifFalse: [ self class ballot ].
	^ self color, ' ', prefix, ' ', self title, SmalltalkCI platformClass ansiReset
