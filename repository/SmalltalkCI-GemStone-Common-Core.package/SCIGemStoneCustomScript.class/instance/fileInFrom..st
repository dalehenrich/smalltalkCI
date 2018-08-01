executing
fileInFrom: aDirectory
	((Smalltalk at: #BinaryOrTextFile) openRead: aDirectory, SmalltalkCI pathNameDelimiter, self path) fileIn
