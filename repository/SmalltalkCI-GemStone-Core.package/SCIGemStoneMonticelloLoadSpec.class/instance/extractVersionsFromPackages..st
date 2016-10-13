executing
extractVersionsFromPackages: aRepository
  self packages do: [ :pkg | | versionNames |
      versionNames := aRepository allFileNames
        select: [ :filename | (filename copyUpToLast: $-) = pkg ].
      versionNames isEmpty
        ifTrue: [ self error: 'No version for "' , pkg , '" found in ' , aRepository asString ].
      self versions
        add: (versionNames detectMax: [ :ea | self versionNumberOf: ea ]) ]