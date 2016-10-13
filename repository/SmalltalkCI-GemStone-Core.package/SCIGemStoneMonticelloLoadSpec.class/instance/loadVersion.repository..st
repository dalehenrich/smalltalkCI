executing
loadVersion: aVersionName repository: aRepository
  | versionName |
  versionName := aVersionName.
  (aVersionName endsWith: '.mcz')
    ifFalse: [ versionName := versionName , '.mcz' ].
  aRepository
    versionReaderForFileNamed: versionName
    do: [ :reader | | version |
      version := reader version.
      [ version load ]
        on: Warning
        do: [ :ex | Transcript
            cr;
            show: ex description.
          SmalltalkCI platformClass isHeadless
            ifTrue: [ ex resume ]
            ifFalse: [ ex pass ] ].
      self addLoadedClassesFrom: reader definitions.
      version workingCopy repositoryGroup addRepository: aRepository.
      ^ self ].
  self
    error:
      'Version "' , aVersionName asString , '" not found in ' , aRepository asString