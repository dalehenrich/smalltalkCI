class organization
resolve: unresolvedName with: knownNames
	unresolvedName last = $* ifTrue: [ | start |
		start := unresolvedName copyFrom: 1 to: unresolvedName size - 1.
		"Treat .* similar to just *"
		(start isEmpty not and: [ start last = $. ])
			ifTrue: [ start := start copyFrom: 1 to: start size - 1 ].
		start isEmpty ifTrue: [ ^ knownNames ].
		^ knownNames select: [ :ea | ea beginsWith: start ] ].
	^ knownNames select: [ :ea | ea = unresolvedName ]
