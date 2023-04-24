*smalltalkci-monticello-core
classesInCategory: aCategory
	^ (Smalltalk organization listAtCategoryNamed: aCategory) collect: [ :className | Smalltalk at: className ]
