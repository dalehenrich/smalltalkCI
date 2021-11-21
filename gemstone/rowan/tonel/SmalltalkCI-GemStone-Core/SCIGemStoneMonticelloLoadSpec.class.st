Class {
	#name : 'SCIGemStoneMonticelloLoadSpec',
	#superclass : 'SCIMonticelloLoadSpec',
	#category : 'SmalltalkCI-GemStone-Core'
}

{ #category : 'compatibility' }
SCIGemStoneMonticelloLoadSpec class >> isPlatformCompatible [
	^ SmalltalkCI platformSymbol = #gemstone
]

{ #category : 'executing' }
SCIGemStoneMonticelloLoadSpec >> extractVersionsFromPackages: aRepository [
	self error: 'Not implemented'
]

{ #category : 'executing' }
SCIGemStoneMonticelloLoadSpec >> loadVersion: aVersionName repository: aRepository [
	self error: 'Not implemented'
]
