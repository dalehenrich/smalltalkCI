*smalltalkci-gemstone-core
allPackageNames
	^ MCWorkingCopy allManagers collect: [ :wc | wc packageName ]