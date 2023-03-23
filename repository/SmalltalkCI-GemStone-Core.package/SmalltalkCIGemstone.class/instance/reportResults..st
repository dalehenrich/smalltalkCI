executing
reportResults: aTestRunner
  SCIGemStoneTestReporterStdout report: aTestRunner spec: self spec.
  produceXMLLog
    ifTrue: [ 
      SCIGemStoneTestReporterXML
        report: aTestRunner
        spec: self spec
        xmlLogDirPath: xmlLogDirPath ].
  self reportFilePath
    ifNotNil: [ :filePath | 
      SCIGemStoneTestReporterStdout
        report: aTestRunner
        spec: self spec
        on: GsFile
        openWriteOnServer: filePath ]