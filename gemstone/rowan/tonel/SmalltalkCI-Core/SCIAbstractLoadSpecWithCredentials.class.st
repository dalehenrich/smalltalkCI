Class {
	#name : 'SCIAbstractLoadSpecWithCredentials',
	#superclass : 'SCIAbstractLoadSpec',
	#instVars : [
		'user',
		'password',
		'usernameEnvVar',
		'passwordEnvVar'
	],
	#category : 'SmalltalkCI-Core'
}

{ #category : 'accessing' }
SCIAbstractLoadSpecWithCredentials >> password [

	password ifNotNil: [ ^ password ].
	self passwordEnvVar ifNotNil: [ :env | ^ SmalltalkCI getEnv: env ].
	^ nil
]

{ #category : 'accessing' }
SCIAbstractLoadSpecWithCredentials >> password: anObject [

	password := anObject
]

{ #category : 'accessing' }
SCIAbstractLoadSpecWithCredentials >> passwordEnvVar [

	^ passwordEnvVar
]

{ #category : 'accessing' }
SCIAbstractLoadSpecWithCredentials >> passwordEnvVar: aString [

	passwordEnvVar := aString
]

{ #category : 'accessing' }
SCIAbstractLoadSpecWithCredentials >> user [

	user ifNotNil: [ ^ user ].
	self usernameEnvVar ifNotNil: [ :env | ^ SmalltalkCI getEnv: env ].
	^ nil
]

{ #category : 'accessing' }
SCIAbstractLoadSpecWithCredentials >> user: anObject [

	user := anObject
]

{ #category : 'accessing' }
SCIAbstractLoadSpecWithCredentials >> usernameEnvVar [

	^ usernameEnvVar
]

{ #category : 'accessing' }
SCIAbstractLoadSpecWithCredentials >> usernameEnvVar: aString [

	usernameEnvVar := aString
]
