initialize-release
ensureAuthor
	SmalltalkCI getAuthor isEmpty ifTrue: [
		self class setAuthor: self class defaultAuthor ]
