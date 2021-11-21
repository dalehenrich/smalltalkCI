Class {
	#name : 'SCIMonticelloLoadSpecTest',
	#superclass : 'SCIAbstractLoadSpecTest',
	#category : 'SmalltalkCI-Tests'
}

{ #category : 'setup' }
SCIMonticelloLoadSpecTest >> setUp [
	self spec: SCIMonticelloLoadSpec new
]

{ #category : 'testing' }
SCIMonticelloLoadSpecTest >> testAddLoadedClassesFrom [
	| mcOrganization |
	self assert: true equals: (self spec loadedClasses isEmpty).
	
	mcOrganization := MCOrganizationDefinition categories: #('SmalltalkCI-Core' 'SmalltalkCI-Tests').
	self spec addLoadedClassesFrom: {mcOrganization}.
	self deny: (self spec loadedClasses isEmpty).
	self assert: (self spec loadedClasses includes: SmalltalkCI).
	self assert: (self spec loadedClasses includes: SmalltalkCITest).
]

{ #category : 'testing' }
SCIMonticelloLoadSpecTest >> testIsComplete [
	self assert: false equals: (self spec isComplete).
	
	self spec
		url: 'http://example.com/';
		versions: #('MyProject-fn.14');
		packages: #().
	self assert: true equals: (self spec isComplete).

	self spec versions: #().
	self assert: false equals: (self spec isComplete).

	self spec packages: #('MyPackage').
	self assert: true equals: (self spec isComplete)
]

{ #category : 'testing' }
SCIMonticelloLoadSpecTest >> testRepository [
	| repository |
	self assert: nil equals: (self spec url).
	
	self spec url: 'http://example.com/'.
	repository := self spec repository.
	self assert: true equals: (repository isKindOf: MCHttpRepository).
	self assert: '' equals: repository user.
	self assert: '' equals: repository password.
	
	self spec user: 'foo'; password: 'bar'.
	repository := self spec repository.
	self assert: true equals: (repository isKindOf: MCHttpRepository).
	self assert: 'foo' equals: repository user.
	self assert: 'bar' equals: repository password
]

{ #category : 'testing' }
SCIMonticelloLoadSpecTest >> testSimple [
	self assert: true equals: self spec packages isEmpty.
	self assert: true equals: self spec versions isEmpty.
	self assert: nil equals: self spec url.
	self assert: '' equals: self spec user.
	self assert: '' equals: self spec password.
	self assert: nil equals: self spec usernameEnvVar.
	self assert: nil equals: self spec passwordEnvVar.
	
	self spec packages: #('foo' 'bar').
	self assert: 2 equals: self spec packages size.

	self spec versions: #('foo-aa.4' 'bar-bb.42').
	self assert: 2 equals: self spec versions size.
	
	self spec
		url: 'http://example.com';
		usernameEnvVar: 'FOO_USER';
		passwordEnvVar: 'FOO_PASS'.
	self assert: 'http://example.com' equals: self spec url.
	self assert: 'FOO_USER' equals: self spec usernameEnvVar.
	self assert: 'FOO_PASS' equals: self spec passwordEnvVar.
	
	SCIMockSmalltalkCI installDuring: [
		SCIMockSmalltalkCI
			setEnv: 'FOO_USER' to: 'user_foo';
			setEnv: 'FOO_PASS' to: 'pass_bar'.
		self assert: 'user_foo' equals: self spec user.
		self assert: 'pass_bar' equals: self spec password].
	
	self spec
		user: 'foo';
		password: 'bar'.
	self assert: 'foo' equals: self spec user.
	self assert: 'bar' equals: self spec password.
]
