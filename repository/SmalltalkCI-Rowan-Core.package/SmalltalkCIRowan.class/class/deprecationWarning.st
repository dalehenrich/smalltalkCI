helpers
deprecationWarning
	| senderMethod |
	senderMethod := (GsProcess methodAt: 3) selector.	"First sender is SmalltalkCI>>deprecated"
	^ senderMethod inClass asString , '>>' , senderMethod selector asString