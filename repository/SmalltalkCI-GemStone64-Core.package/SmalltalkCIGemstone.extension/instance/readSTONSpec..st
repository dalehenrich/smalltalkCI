*smalltalkci-gemstone64-core
readSTONSpec: aFilePath
  | stream file endOfPath |
  endOfPath := aFilePath
    findLastSubString: '/'
    startingAt: aFilePath size.
  projectDirectory := aFilePath copyFrom: 1 to: endOfPath.
  [ file := GsFile openReadOnServer: aFilePath.
    stream := ReadStreamPortable on: (file contents _decodeFromUtf8: false) ]
    ensure: [ file ifNotNil: [ file close ] ].
  self spec: (SmalltalkCISpec fromStream: stream)
