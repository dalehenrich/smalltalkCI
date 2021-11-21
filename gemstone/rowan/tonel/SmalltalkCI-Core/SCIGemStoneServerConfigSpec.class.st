Class {
	#name : 'SCIGemStoneServerConfigSpec',
	#superclass : 'SCIAbstractConfig',
	#instVars : [
		'defaultSessionName',
		'stoneConfPath',
		'gemConfPath',
		'timeZone'
	],
	#classVars : [
		'DefaultSessionName'
	],
	#category : 'SmalltalkCI-Core'
}

{ #category : 'public-api' }
SCIGemStoneServerConfigSpec class >> defaultSessionName [
  ^ DefaultSessionName ifNil: [ DefaultSessionName := 'travis' ]
]

{ #category : 'public-api' }
SCIGemStoneServerConfigSpec class >> defaultSessionName: anObject [

   DefaultSessionName := anObject

]

{ #category : 'public-api' }
SCIGemStoneServerConfigSpec >> defaultSessionName [

	^ defaultSessionName
]

{ #category : 'accessing' }
SCIGemStoneServerConfigSpec >> defaultSessionName: anObject [

	defaultSessionName := anObject
]

{ #category : 'public-api' }
SCIGemStoneServerConfigSpec >> gemConfPath [
  "path to gem.conf file. The gem.conf is used to customize the GemStone options for 
   GemStone clients (i.e. GEM_TEMPOBJ_CACHE_SIZE)"

  ^ gemConfPath
]

{ #category : 'accessing' }
SCIGemStoneServerConfigSpec >> gemConfPath: anObject [

   gemConfPath := anObject

]

{ #category : 'public-api' }
SCIGemStoneServerConfigSpec >> stoneConfPath [
  "path to stone.conf file. The stone.conf file is used to customize the GemStone options for 
   the stone itself (i.e. SHR_PAGE_CACHE_SIZE_KB"

  ^ stoneConfPath
]

{ #category : 'accessing' }
SCIGemStoneServerConfigSpec >> stoneConfPath: anObject [

   stoneConfPath := anObject

]

{ #category : 'public-api' }
SCIGemStoneServerConfigSpec >> timeZone [

   ^ timeZone

]

{ #category : 'accessing' }
SCIGemStoneServerConfigSpec >> timeZone: anObject [

   timeZone := anObject

]
