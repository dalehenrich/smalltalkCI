accessing
default
	^(SessionTemps current at: self _defaultKey ifAbsent: [])
		ifNil: [
			| default |
			default := self new initialize.
      SessionTemps current at: self _defaultKey put: default ]
