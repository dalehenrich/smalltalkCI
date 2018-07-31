system messages
removeFromShutDownList: anObject
	"different arrangements should be made for GemStone - it's not a good idea to put session information 
	 (typical use of startup/shutdown) in a shared variable. see SystemLoginNotification."