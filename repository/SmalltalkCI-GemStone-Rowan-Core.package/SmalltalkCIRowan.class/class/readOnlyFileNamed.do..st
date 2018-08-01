compatibility
readOnlyFileNamed: aFilename do: aBlock
"
  | dir fileName |
  dir := ServerFileDirectory forFileName: aFilename.
  fileName := ServerFileDirectory localNameFor: aFilename.
  ^ dir readOnlyFileNamed: fileName do: aBlock
"
self error: 'not yet implemented'
