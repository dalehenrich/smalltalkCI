*smalltalkci-rowan-tests
_loadSpecInstance2
	^ (SCIRowanLoadSpec new
			baseline: 'Foo';
			platforms: { SmalltalkCI platformSymbol })
