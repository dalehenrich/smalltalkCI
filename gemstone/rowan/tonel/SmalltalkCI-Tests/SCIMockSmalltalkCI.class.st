"
I am a mock class for SmalltalkCI.
"
Class {
	#name : 'SCIMockSmalltalkCI',
	#superclass : 'SCIObjectWithSpec',
	#classInstVars : [
		'envVars'
	],
	#category : 'SmalltalkCI-Tests'
}

{ #category : 'private' }
SCIMockSmalltalkCI class >> envVars [

	^ envVars ifNil: [envVars := Dictionary new]
]

{ #category : 'compatibility' }
SCIMockSmalltalkCI class >> getEnv: key [

	^ self envVars at: key
]

{ #category : 'support' }
SCIMockSmalltalkCI class >> installDuring: aBlock [

	| previousClass |
	previousClass := SmalltalkCI platformClass.
	SmalltalkCI platformClass: self.
	^ aBlock ensure: [
		SmalltalkCI platformClass: previousClass]
]

{ #category : 'compatibility' }
SCIMockSmalltalkCI class >> setEnv: key to: value [

	^ self envVars at: key put: value
]
