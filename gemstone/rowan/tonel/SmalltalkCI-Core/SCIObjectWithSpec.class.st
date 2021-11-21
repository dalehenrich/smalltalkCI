Class {
	#name : 'SCIObjectWithSpec',
	#superclass : 'Object',
	#instVars : [
		'spec'
	],
	#category : 'SmalltalkCI-Core'
}

{ #category : 'accessing' }
SCIObjectWithSpec >> spec [

	^ spec
]

{ #category : 'accessing' }
SCIObjectWithSpec >> spec: anObject [

	spec := anObject
]
