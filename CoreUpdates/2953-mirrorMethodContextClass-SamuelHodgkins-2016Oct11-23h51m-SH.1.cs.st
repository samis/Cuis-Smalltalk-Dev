'From Cuis 4.2 of 25 July 2013 [latest update: #2950] on 12 October 2016 at 12:09:01 am'!

!Context class methodsFor: 'instance creation' stamp: 'SH 10/12/2016 00:07:46'!
sender: s receiver: r method: m arguments: args
	"Answer an instance of me with attributes set to the arguments."
	^ (MethodContext newForMethod: m)
		setSender: s
		receiver: r
		method: m
		arguments: args.! !

!Context class methodsFor: 'enumerating' stamp: 'SH 10/12/2016 00:00:05'!
allInstances
	"Answer all instances of the receiver."
	"The primitive can fail because memory is low.  If so, fall back on the old
	 enumeration code, which gives the system a chance to GC and/or grow.
	 Because aBlock might change the class of inst (for example, using become:),
	 it is essential to compute next before aBlock value: inst.
	 Only count until thisContext since this context has been created only to
	 compute the existing instances."
	^ MethodContext allInstances! !

!Context class methodsFor: 'enumerating' stamp: 'SH 10/12/2016 00:01:59'!
allInstancesDo: aBlock
	"Evaluate aBlock with each of the current instances of the receiver."
	^ MethodContext allInstancesDo: aBlock.! !


!Context class reorganize!
('cached class state' primitiveFailToken primitiveFailTokenFor: releaseClassCachedState valueIndex)
('instance creation' basicNew: initializedInstance new new: newForMethod: sender:receiver:method:arguments:)
('special context creation' contextEnsure: contextOn:do:)
('private' carefullyPrint:on: isContextClass)
('examples' tallyInstructions: tallyMethods: trace: trace:on: trace:onFileNamed:)
('enumerating' allInstances allInstancesDo:)
('simulation' runSimulated:)
!

