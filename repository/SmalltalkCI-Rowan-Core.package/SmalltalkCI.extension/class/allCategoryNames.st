*smalltalkci-rowan-core
allCategoryNames
	^ ClassOrganizer new categories keys collect: [ :c | c asString ]
