constants
buildStatusFile
	"Return full path only when buildDirectory notEmpty"

	(self buildDirectory asFileReference children notEmpty)
		ifTrue: [	^ self buildDirectory, self pathNameDelimiter, 'build_status.txt' ].
	^ 'build_status.txt'