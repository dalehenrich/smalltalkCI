Class {
	#name : 'SCIAbstractConfig',
	#superclass : 'SCIPlatformDependent',
	#instVars : [
		'configName'
	],
	#category : 'SmalltalkCI-Core'
}

{ #category : 'accessing' }
SCIAbstractConfig >> configName [

   ^ configName

]

{ #category : 'accessing' }
SCIAbstractConfig >> configName: anObject [

   configName := anObject

]
