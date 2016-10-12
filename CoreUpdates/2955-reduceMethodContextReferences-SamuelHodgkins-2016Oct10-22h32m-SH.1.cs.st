'From Cuis 4.2 of 25 July 2013 [latest update: #2954] on 12 October 2016 at 2:08:05 am'!

!BlockClosure methodsFor: 'private' stamp: 'SH 10/12/2016 01:47:00'!
asContextWithSender: aContext
	"Inner private support method for evaluation.  Do not use unless you know what you're doing."
	^ (Context newForMethod: outerContext method)
		
			setSender: aContext
			receiver: outerContext receiver
			method: outerContext method
			closure: self
			startpc: startpc;
		privRefresh.! !

!BlockClosure methodsFor: 'system simulation' stamp: 'SH 10/12/2016 01:41:54'!
simulateValueWithArguments: anArray caller: aContext
	"Simulate the valueWithArguments: primitive. Fail if anArray is not an array of the right arity."
	| newContext sz |
	newContext _ (Context newForMethod: outerContext method)
		setSender: aContext
		receiver: outerContext receiver
		method: outerContext method
		closure: self
		startpc: startpc.
	((newContext objectClass: anArray) ~~ Array or: [ numArgs ~= anArray size ]) ifTrue: [ ^ Context primitiveFailTokenFor: nil ].
	sz _ self basicSize.
	newContext stackp: sz + numArgs.
	1
		to: numArgs
		do: [ :i |
			newContext
				at: i
				put: (anArray at: i) ].
	1
		to: sz
		do: [ :i |
			newContext
				at: i + numArgs
				put: (self at: i) ].
	^ newContext.! !


!ClosureExtractor methodsFor: 'accessing' stamp: 'SH 10/12/2016 01:45:30'!
scanner: anInstructionStream
	scanner _ anInstructionStream.
	currentContext _ Context
		sender: nil
		receiver: self
		method: scanner method
		arguments: (Array new: scanner method numArgs).! !


!Process methodsFor: 'signaling' stamp: 'SH 10/12/2016 01:56:03'!
signal: anException
	"Signal an exception in the receiver process...if the receiver is currently
	suspended, the exception will get signaled when the receiver is resumed.  If 
	the receiver is blocked on a Semaphore, it will be immediately re-awakened
	and the exception will be signaled; if the exception is resumed, then the receiver
	will return to a blocked state unless the blocking Semaphore has excess signals"
	"If we are the active process, go ahead and signal the exception"
	self isRunning ifTrue: [ ^ anException signal ].
	"Add a new method context to the stack that will signal the exception"
	suspendedContext _ Context
		sender: suspendedContext
		receiver: self
		method: (self class methodDict at: #pvtSignal:list:)
		arguments:
			(Array
				with: anException
				with: myList).
	"If we are on a list to run, then suspend and restart the receiver 
	(this lets the receiver run if it is currently blocked on a semaphore).  If
	we are not on a list to be run (i.e. this process is suspended), then when the
	process is resumed, it will signal the exception"
	myList ifNotNil: [
		self
			suspend;
			resume ].! !

!Process methodsFor: 'signaling' stamp: 'SH 10/12/2016 01:57:32'!
signalException: anException
	"Signal an exception in the receiver process...if the receiver is currently
	suspended, the exception will get signaled when the receiver is resumed.  If 
	the receiver is blocked on a Semaphore, it will be immediately re-awakened
	and the exception will be signaled; if the exception is resumed, then the receiver
	will return to a blocked state unless the blocking Semaphore has excess signals"
	"If we are the active process, go ahead and signal the exception"
	| oldList |
	self isRunning ifTrue: [ ^ anException signal ].
	"Suspend myself first to ensure that I won't run away in the
	midst of the following modifications."
	myList ifNotNil: [ oldList _ self suspend ].
	"Add a new method context to the stack that will signal the exception"
	suspendedContext _ Context
		sender: suspendedContext
		receiver: self
		method: (self class lookupSelector: #pvtSignal:list:)
		arguments:
			(Array
				with: anException
				with: oldList).
	"If we are on a list to run, then suspend and restart the receiver 
	(this lets the receiver run if it is currently blocked on a semaphore).  If
	we are not on a list to be run (i.e. this process is suspended), then when the
	process is resumed, it will signal the exception"
	oldList ifNotNil: [ self resume ].! !

!Context class methodsFor: 'instance creation' stamp: 'SH 10/12/2016 02:06:37'!
sender: s receiver: r method: m arguments: args
	"Answer an instance of me with attributes set to the arguments."
	^ (self newForMethod: m)
		setSender: s
		receiver: r
		method: m
		arguments: args.! !
