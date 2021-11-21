Class {
	#name : 'SCIGemStoneMetacelloLoadSpec',
	#superclass : 'SCIMetacelloLoadSpec',
	#category : 'SmalltalkCI-GemStone-Core'
}

{ #category : 'compatibility' }
SCIGemStoneMetacelloLoadSpec class >> isPlatformCompatible [
	^ SmalltalkCI platformSymbol = #gemstone
]

{ #category : 'executing' }
SCIGemStoneMetacelloLoadSpec >> repositorySchemeIn: aProjectDirectory [
	^ 'filetree'
]
