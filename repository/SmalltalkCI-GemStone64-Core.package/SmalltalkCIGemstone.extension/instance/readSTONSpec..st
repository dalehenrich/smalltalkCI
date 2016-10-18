*smalltalkci-gemstone64-core
readSTONSpec: aFilePath
  | stream file endOfPath |
  endOfPath := aFilePath
    findLastSubString: '/'
    startingAt: aFilePath size.
  projectDirectory := aFilePath copyFrom: 1 to: endOfPath.
  [ file := GsFile openReadOnServer: aFilePath.
    stream := WriteStreamPortable on: (file contents _decodeFromUtf8: false) ]
    ensure: [ file ifNotNil: [ file close ] ].
  SmalltalkCISpec fromStream: stream
