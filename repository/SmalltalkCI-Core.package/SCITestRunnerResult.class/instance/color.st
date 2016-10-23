accessing
color
	self errored ifTrue: [ ^ SmalltalkCI platformClass ansiRed ].
	self failed ifTrue: [ ^ SmalltalkCI platformClass ansiYellow ].
	self passedUnexpectedly ifTrue: [ ^ SmalltalkCI platformClass ansiYellow ].
	^ SmalltalkCI platformClass ansiGreen
