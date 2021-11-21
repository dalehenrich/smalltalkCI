Class {
	#name : 'SCIGemStoneCustomScript',
	#superclass : 'SCICustomScript',
	#category : 'SmalltalkCI-GemStone-Core'
}

{ #category : 'compatibility' }
SCIGemStoneCustomScript class >> isPlatformCompatible [
	^ SmalltalkCI platformSymbol = #gemstone
]

{ #category : 'executing' }
SCIGemStoneCustomScript >> fileInFrom: aDirectory [
	(BinaryOrTextFile openRead: aDirectory, SmalltalkCI pathNameDelimiter, self path) fileIn
]
