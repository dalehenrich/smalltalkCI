external-deprecated
readSTONSpec: aFilePath
"
  | dir fileName |
  SmalltalkCI deprecated: 'Use "SmalltalkCISpec>>fromFile:" instead'.
  dir := ServerFileDirectory forFileName: aFilePath.

  projectDirectory := dir fullName.

  fileName := ServerFileDirectory localNameFor: aFilePath.
  dir
    readOnlyFileNamed: fileName
    do: [ :fileStream | self spec: (SmalltalkCISpec fromStream: fileStream) ]
"
self error: 'not yet implemented'
