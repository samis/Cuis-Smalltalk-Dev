'From Cuis 4.2 of 25 July 2013 [latest update: #2957] on 13 October 2016 at 9:51:31 pm'!

!Context class methodsFor: 'private' stamp: 'SH 10/13/2016 21:24:49'!
theReturnMethod

	| meth |
	meth _ MethodContext lookupSelector: #return:.
	meth primitive = 0 ifFalse: [^ self error: 'expected #return: to not be a primitive'].
	^ meth! !


!Context class methodsFor: 'cached class state' stamp: 'SH 10/13/2016 21:33:54'!
releaseClassCachedState
	PrimitiveFailToken _ nil.
	QuickStep _ nil.
	ValueIndex _ nil. 
	ContextPart releaseClassCachedState.! !

!Context class methodsFor: 'cached class state' stamp: 'SH 10/13/2016 21:34:26'!
valueIndex
	ValueIndex ifNil: [
		ValueIndex _ 2.
		self assert: (Association instVarNameForIndex: ValueIndex) = 'value' ].
	^ ValueIndex! !

!Context class methodsFor: 'special context creation' stamp: 'SH 10/13/2016 21:11:32'!
contextEnsure: block
	"Create an #ensure: context that is ready to return from executing its receiver"
	
	| ctxt chain |
	ctxt _ thisContext.
	[chain _ thisContext sender cut: ctxt. ctxt jump] ensure: block.
	"jump above will resume here without unwinding chain"
	^ chain! !

!Context class methodsFor: 'special context creation' stamp: 'SH 10/13/2016 21:19:41'!
contextOn: exceptionClass do: block
	"Create an #on:do: context that is ready to return from executing its receiver"

	| ctxt chain |
	ctxt _ thisContext.
	[chain _ thisContext sender cut: ctxt. ctxt jump] on: exceptionClass do: block.
	"jump above will resume here without unwinding chain"
	^ chain! !

!Context class methodsFor: 'private' stamp: 'SH 10/13/2016 21:16:10'!
carefullyPrint: anObject on: aStream
	| printString |
	printString _ [anObject printString]
		on: UnhandledError
		do: [:ex | ex return: 'unprintable ' , anObject class printString].
	aStream nextPutAll: printString! !


!ContextPart methodsFor: 'private' stamp: 'SH 10/13/2016 21:26:49'!
activateReturn: aContext value: value
	"Activate 'aContext return: value' in place of self, so execution will return to aContext's sender"

	^Context 
		sender: self
		receiver: aContext
		method: Context theReturnMethod
		arguments: {value}! !

!ContextPart methodsFor: 'private' stamp: 'SH 10/13/2016 20:48:36'!
doPrimitive: primitiveIndex method: meth receiver: receiver args: arguments
	"Simulate a primitive method whose index is primitiveIndex.  The simulated receiver and
	 arguments are given as arguments to this message. If successful, push result and return
	 resuming context, else ^ {errCode, PrimitiveFailToken}. Any primitive which provokes
	 execution needs to be intercepted and simulated to avoid execution running away."

	| value |
	"Judicious use of primitive 19 (a null primitive that doesn't do anything) prevents
	 the debugger from entering various run-away activities such as spawning a new
	 process, etc.  Injudicious use results in the debugger not being able to debug
	 interesting code, such as the debugger itself.  hence use primitive 19 with care :-)"
	"SystemNavigation new browseAllSelect: [:m| m primitive = 19]"
	primitiveIndex = 19 ifTrue:
		[Debugger
			openContext: self
			label:'Code simulation error'
			contents: nil].

	((primitiveIndex between: 201 and: 222)
	 and: [(self objectClass: receiver) includesBehavior: BlockClosure]) ifTrue:
		[((primitiveIndex between: 201 and: 205)			 "BlockClosure>>value[:value:...]"
		  or: [primitiveIndex between: 221 and: 222]) ifTrue: "BlockClosure>>valueNoContextSwitch[:]"
			[^receiver simulateValueWithArguments: arguments caller: self].
		 primitiveIndex = 206 ifTrue:						"BlockClosure>>valueWithArguments:"
			[^receiver simulateValueWithArguments: arguments first caller: self]].

	primitiveIndex = 83 ifTrue: "afr 9/11/1998 19:50" "Object>>perform:[with:...]"
		[^self send: arguments first to: receiver with: arguments allButFirst super: false].
	primitiveIndex = 84 ifTrue: "afr 9/11/1998 19:50 & eem 8/18/2009 17:04" "Object>>perform:withArguments:"
		[^self send: arguments first to: receiver with: (arguments at: 2) lookupIn: (self objectClass: receiver)].
	primitiveIndex = 100 ifTrue: "eem 8/18/2009 16:57" "Object>>perform:withArguments:inSuperclass:"
		[^self send: arguments first to: receiver with: (arguments at: 2) lookupIn: (arguments at: 3)].

	"Mutex>>primitiveEnterCriticalSection
	 Mutex>>primitiveTestAndSetOwnershipOfCriticalSection"
	(primitiveIndex = 186 or: [primitiveIndex = 187]) ifTrue:
		[| effective |
		 effective := Processor activeProcess effectiveProcess.
		 "active == effective"
		 value := primitiveIndex = 186
					ifTrue: [receiver primitiveEnterCriticalSectionOnBehalfOf: effective]
					ifFalse: [receiver primitiveTestAndSetOwnershipOfCriticalSectionOnBehalfOf: effective].
		 ^(self isPrimFailToken: value)
			ifTrue: [value]
			ifFalse: [self push: value]].

	primitiveIndex = 188 ifTrue: "eem 5/27/2008 11:10 Object>>withArgs:executeMethod:"
		[((self objectClass: (arguments at: 1)) == Array
		  and: [(self objectClass: (arguments at: 2)) includesBehavior: CompiledMethod]) ifFalse:
			[^Context primitiveFailTokenFor: #'bad argument'].
		 (arguments at: 2) numArgs = (arguments at: 1) size ifFalse:
			[^Context primitiveFailTokenFor: #'bad number of arguments'].
		 (arguments at: 2) primitive > 0 ifTrue:
			[(arguments at: 2) isQuick ifTrue:
				[^self push: (receiver withArgs: (arguments at: 1) executeMethod: (arguments at: 2))].
			 ^self doPrimitive: (arguments at: 2) primitive method: (arguments at: 2) receiver: receiver args: (arguments at: 1)].
		 ^Context
			sender: self
			receiver: receiver
			method: (arguments at: 2)
			arguments: (arguments at: 1)].

	"Closure primitives"
	(primitiveIndex = 200 and: [self == receiver]) ifTrue:
		"ContextPart>>closureCopy:copiedValues:; simulated to get startpc right"
		[^self push: (BlockClosure
						outerContext: receiver
						startpc: pc + 2
						numArgs: arguments first
						copiedValues: arguments last)].

	primitiveIndex = 118 ifTrue: "[receiver:]tryPrimitive:withArgs:; avoid recursing in the VM"
		[(arguments size = 3
		  and: [(self objectClass: arguments second) == SmallInteger
		  and: [(self objectClass: arguments last) == Array]]) ifTrue:
			[^self doPrimitive: arguments second method: meth receiver: arguments first args: arguments last].
		 (arguments size = 2
		 and: [(self objectClass: arguments first) == SmallInteger
		 and: [(self objectClass: arguments last) == Array]]) ifFalse:
			[^Context primitiveFailTokenFor: nil].
		 ^self doPrimitive: arguments first method: meth receiver: receiver args: arguments last].

	value := primitiveIndex = 120 "FFI method"
				ifTrue: [(meth literalAt: 1) tryInvokeWithArguments: arguments]
				ifFalse:
					[primitiveIndex = 117 "named primitives"
						ifTrue: [self tryNamedPrimitiveIn: meth for: receiver withArgs: arguments]
						ifFalse:
							["should use self receiver: receiver tryPrimitive: primitiveIndex withArgs: arguments but this is only in later VMs"
							receiver tryPrimitive: primitiveIndex withArgs: arguments]].

	^(self isPrimFailToken: value)
		ifTrue: [value]
		ifFalse: [self push: value]! !


!ContextPart class methodsFor: 'cached class state' stamp: 'SH 10/13/2016 20:52:13'!
primitiveFailToken
	"A unique object to be returned when a primitive fails during simulation"
	^ Context primitiveFailToken! !

!ContextPart class methodsFor: 'cached class state' stamp: 'SH 10/13/2016 21:34:39'!
valueIndex
	^ Context valueIndex! !


!Context class reorganize!
('cached class state' primitiveFailToken releaseClassCachedState valueIndex)
('instance creation' basicNew: initializedInstance new new: newForMethod: sender:receiver:method:arguments:)
('special context creation' contextEnsure: contextOn:do:)
('private' carefullyPrint:on: isContextClass theReturnMethod)
('examples' tallyInstructions: tallyMethods: trace: trace:on: trace:onFileNamed:)
('enumerating' allInstances allInstancesDo:)
('simulation' primitiveFailTokenFor: runSimulated:)
!

