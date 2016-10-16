'From Cuis 4.2 of 25 July 2013 [latest update: #2958] on 16 October 2016 at 3:24:17 am'!

!Context methodsFor: 'accessing' stamp: 'eem 6/15/2008 11:28'!
activeHome
	"If executing closure, search senders for the activation of the original
	 (outermost) method that (indirectly) created my closure (the closureHome).
	 If the closureHome is not found on the sender chain answer nil."

	| methodReturnContext |
	self isExecutingBlock ifFalse: [^self].
	self sender ifNil: [^nil].
	methodReturnContext := self methodReturnContext.
	^self sender findContextSuchThat: [:ctxt | ctxt = methodReturnContext]! !

!Context methodsFor: 'accessing' stamp: 'eem 5/28/2008 10:45'!
activeOuterContext
	"If executing closure, search senders for the activation in which the receiver's
	 closure was created (the receiver's outerContext).  If the outerContext is not
	 found on the sender chain answer nil."

	| outerContext |
	self isExecutingBlock ifFalse: [^self].
	self sender ifNil: [^nil].
	outerContext := self outerContext.
	^self sender findContextSuchThat: [:ctxt | ctxt = outerContext]! !

!Context methodsFor: 'accessing' stamp: 'eem 6/27/2008 15:55'!
at: index
	"Primitive. Assumes receiver is indexable. Answer the value of an
	 indexable element in the receiver. Fail if the argument index is not an
	 Integer or is out of bounds. Essential. See Object documentation
	 whatIsAPrimitive.  Override the default primitive to give latitude to
	 the VM in context management."

	<primitive: 210>
	index isInteger ifTrue:
		[self errorSubscriptBounds: index].
	index isNumber
		ifTrue: [^self at: index asInteger]
		ifFalse: [self errorNonIntegerIndex]! !

!Context methodsFor: 'accessing' stamp: 'eem 6/27/2008 15:57'!
at: index put: value
	"Primitive. Assumes receiver is indexable. Answer the value of an
	 indexable element in the receiver. Fail if the argument index is not
	 an Integer or is out of bounds. Essential. See Object documentation
	 whatIsAPrimitive.  Override the default primitive to give latitude to
	 the VM in context management."

	<primitive: 211>
	index isInteger ifTrue:
		[self errorSubscriptBounds: index].
	index isNumber
		ifTrue: [^self at: index asInteger put: value]
		ifFalse: [self errorNonIntegerIndex]! !

!Context methodsFor: 'accessing' stamp: 'eem 6/27/2008 15:56'!
basicAt: index
	"Primitive. Assumes receiver is indexable. Answer the value of an
	 indexable element in the receiver. Fail if the argument index is not an
	 Integer or is out of bounds. Essential. See Object documentation
	 whatIsAPrimitive.  Override the default primitive to give latitude to
	 the VM in context management."

	<primitive: 210>
	index isInteger ifTrue:
		[self errorSubscriptBounds: index].
	index isNumber
		ifTrue: [^self at: index asInteger]
		ifFalse: [self errorNonIntegerIndex]! !

!Context methodsFor: 'accessing' stamp: 'eem 6/27/2008 15:57'!
basicAt: index put: value
	"Primitive. Assumes receiver is indexable. Answer the value of an
	 indexable element in the receiver. Fail if the argument index is not
	 an Integer or is out of bounds. Essential. See Object documentation
	 whatIsAPrimitive.  Override the default primitive to give latitude to
	 the VM in context management."

	<primitive: 211>
	index isInteger ifTrue:
		[self errorSubscriptBounds: index].
	index isNumber
		ifTrue: [^self at: index asInteger put: value]
		ifFalse: [self errorNonIntegerIndex]! !

!Context methodsFor: 'accessing' stamp: 'eem 9/17/2014 17:13'!
basicSize
	"Primitive. Answer the number of indexable variables in the receiver. 
	This value is the same as the largest legal subscript. Essential. Do not 
	override in any subclass. See Object documentation whatIsAPrimitive.  Override the default primitive to give latitude to
	 the VM in context management."

	<primitive: 212>
	"The number of indexable fields of fixed-length objects is 0"
	^self primitiveFailed! !

!Context methodsFor: 'accessing'!
client
	"Answer the client, that is, the object that sent the message that created this context."

	^sender receiver! !

!Context methodsFor: 'accessing' stamp: 'eem 7/22/2008 11:57'!
closure
	^closureOrNil! !

!Context methodsFor: 'accessing' stamp: 'eem 6/15/2008 11:31'!
contextForLocalVariables
	"Answer the context in which local variables (temporaries) are stored."

	^self! !

!Context methodsFor: 'accessing' stamp: 'eem 4/25/2009 09:50'!
hasMethodReturn
	^closureOrNil hasMethodReturn! !

!Context methodsFor: 'accessing' stamp: 'jmv 3/1/2010 11:40'!
home 
	"Answer the context in which the receiver was defined."

	closureOrNil
		ifNil: [^ self].
	^closureOrNil outerContext home! !

!Context methodsFor: 'accessing' stamp: 'eem 7/22/2008 11:57'!
isExecutingBlock
	"Is this executing a block versus a method?  In the new closure
	 implemetation this is true if closureOrNil is not nil, in which case
	 it should be holding a BlockClosure."

	^closureOrNil isClosure! !

!Context methodsFor: 'accessing'!
method

	^method! !

!Context methodsFor: 'accessing' stamp: 'ar 4/11/2006 01:49'!
methodNode
	^ self method methodNode.! !

!Context methodsFor: 'accessing' stamp: 'jmv 3/1/2010 11:40'!
methodReturnContext
	"Answer the context from which an ^-return should return from."

	closureOrNil
		ifNil: [^ self].
	^closureOrNil outerContext methodReturnContext! !

!Context methodsFor: 'accessing' stamp: 'jmv 3/1/2010 11:40'!
outerContext
	"Answer the context within which the receiver is nested."

	^ closureOrNil
		ifNotNil: [closureOrNil outerContext]! !

!Context methodsFor: 'accessing'!
receiver 
	"Refer to the comment in ContextPart|receiver."

	^receiver! !

!Context methodsFor: 'accessing'!
removeSelf
	"Nil the receiver pointer and answer its former value."

	| tempSelf |
	tempSelf _ receiver.
	receiver _ nil.
	^tempSelf! !

!Context methodsFor: 'accessing' stamp: 'eem 9/17/2014 17:13'!
size
	"Primitive. Answer the number of indexable variables in the receiver. 
	This value is the same as the largest legal subscript. Essential. See Object 
	documentation whatIsAPrimitive.  Override the default primitive to give latitude to
	 the VM in context management."

	<primitive: 212>
	"The number of indexable fields of fixed-length objects is 0"
	^self primitiveFailed! !

!Context methodsFor: 'accessing' stamp: 'eem 8/20/2008 09:28'!
tempAt: index 
	"Answer the value of the temporary variable whose index is the 
	 argument, index.  Primitive. Assumes receiver is indexable. Answer the
	 value of an indexable element in the receiver. Fail if the argument index
	 is not an Integer or is out of bounds. Essential. See Object documentation
	 whatIsAPrimitive.  Override the default at: primitive to give latitude to the
	 VM in context management."

	<primitive: 210>
	^self at: index! !

!Context methodsFor: 'accessing' stamp: 'eem 8/20/2008 09:29'!
tempAt: index put: value 
	"Store the argument, value, as the temporary variable whose index is the 
	 argument, index.  Primitive. Assumes receiver is indexable. Answer the
	 value of an indexable element in the receiver. Fail if the argument index
	 is not an Integer or is out of bounds. Essential. See Object documentation
	 whatIsAPrimitive.  Override the default at:put: primitive to give latitude to
	 the VM in context management."

	<primitive: 211>
	^self at: index put: value! !

!Context methodsFor: 'closure support' stamp: 'md 1/20/2006 17:17'!
asContext

	^ self! !

!Context methodsFor: 'closure support' stamp: 'ar 6/28/2003 00:15'!
contextTag
	"Context tags may be used for referring to contexts instead of contexts themselves as they can be copied and will continue to work in other processes (continuations). By default, we use the context itself to as its tag."
	^self! !

!Context methodsFor: 'controlling' stamp: 'eem 8/29/2008 06:27'!
closureCopy: numArgs copiedValues: anArray
	"Distinguish a block of code from its enclosing method by 
	creating a BlockClosure for that block. The compiler inserts into all 
	methods that contain blocks the bytecodes to send the message 
	closureCopy:copiedValues:. Do not use closureCopy:copiedValues: in code that you write!! Only the 
	compiler can decide to send the message closureCopy:copiedValues:. Fail if numArgs is 
	not a SmallInteger. Optional. No Lookup. See Object documentation 
	whatIsAPrimitive."

	<primitive: 200>
	^BlockClosure outerContext: self startpc: pc + 2 numArgs: numArgs copiedValues: anArray! !

!Context methodsFor: 'controlling'!
hasSender: context 
	"Answer whether the receiver is strictly above context on the stack."

	| s |
	self == context ifTrue: [^false].
	s _ sender.
	[s == nil]
		whileFalse: 
			[s == context ifTrue: [^true].
			s _ s sender].
	^false! !

!Context methodsFor: 'controlling' stamp: 'ajh 3/25/2004 00:07'!
jump
	"Abandon thisContext and resume self instead (using the same current process).  You may want to save thisContext's sender before calling this so you can jump back to it.
	Self MUST BE a top context (ie. a suspended context or a abandoned context that was jumped out of).  A top context already has its return value on its stack (see Interpreter>>primitiveSuspend and other suspending primitives).
	thisContext's sender is converted to a top context (by pushing a nil return value on its stack) so it can be jump back to."

	| top |
	"Make abandoned context a top context (has return value (nil)) so it can be jumped back to"
	thisContext sender push: nil.

	"Pop self return value then return it to self (since we jump to self by returning to it)"
	stackp = 0 ifTrue: [self stepToSendOrReturn].
	stackp = 0 ifTrue: [self push: nil].  "must be quick return self/constant"
	top _ self pop.
	thisContext privSender: self.
	^ top! !

!Context methodsFor: 'controlling' stamp: 'di 1/11/1999 22:40'!
pop
	"Answer the top of the receiver's stack and remove the top of the stack."
	| val |
	val _ self at: stackp.
	self stackp: stackp - 1.
	^ val! !

!Context methodsFor: 'controlling' stamp: 'di 1/11/1999 22:39'!
push: val 
	"Push val on the receiver's stack."

	self stackp: stackp + 1.
	self at: stackp put: val! !

!Context methodsFor: 'controlling' stamp: 'eem 9/2/2014 14:14'!
quickSend: selector to: rcvr with: arguments super: superFlag
	"Send the given selector with arguments in an environment which closely resembles
	 the non-simulating environment, with an interjected unwind-protected block to catch
	 nonlocal returns.  Attention: don't get lost!!  This beautiful method is due to
	 Hans-Martin Mosner.  Eliot Miranda merely added the mirror primitive code."
	| oldSender contextToReturnTo result lookupClass |
	contextToReturnTo := self.
	lookupClass := superFlag
					ifTrue: [self method methodClassAssociation value superclass]
					ifFalse: [self objectClass: rcvr].
	[oldSender := thisContext sender swapSender: self.
	 result := self object: rcvr perform: selector withArguments: arguments inClass: lookupClass.
	 thisContext sender swapSender: oldSender] ifCurtailed:
		[contextToReturnTo := thisContext sender receiver.	"The block context returning nonlocally"
		contextToReturnTo pc: contextToReturnTo previousPc.	"skip to front of return bytecode causing this unwind"
		contextToReturnTo willReturnTopFromMethod ifTrue:
			"If it was a returnTop, push the value to be returned.
			Otherwise the value is implicit in the bytecode"
			[contextToReturnTo push: (thisContext sender tempAt: 1)].
		thisContext swapSender: thisContext home sender.	"Make this block return to the method's sender"
		contextToReturnTo].
	contextToReturnTo push: result.
	^contextToReturnTo! !

!Context methodsFor: 'controlling' stamp: 'ar 3/4/2009 14:57'!
restart
	"Unwind thisContext to self and resume from beginning.  Execute unwind blocks when unwinding.  ASSUMES self is a sender of thisContext"

	| ctxt unwindBlock |
	self isDead ifTrue: [self cannotReturn: nil to: self].
	self privRefresh.
	ctxt := thisContext.
	[	ctxt := ctxt findNextUnwindContextUpTo: self.
		ctxt isNil
	] whileFalse: [
		(ctxt tempAt: 2) ifNil:[
			ctxt tempAt: 2 put: true.
			unwindBlock := ctxt tempAt: 1.
			thisContext terminateTo: ctxt.
			unwindBlock value].
	].
	thisContext terminateTo: self.
	self jump.
! !

!Context methodsFor: 'controlling' stamp: 'ajh 6/27/2003 22:17'!
resume
	"Roll back thisContext to self and resume.  Execute unwind blocks when rolling back.  ASSUMES self is a sender of thisContext"

	self resume: nil! !

!Context methodsFor: 'controlling' stamp: 'SqR 10/10/2015 15:25'!
resume: value

	self resumeEvaluating: [value]! !

!Context methodsFor: 'controlling' stamp: 'eem 4/25/2012 10:48'!
resume: value through: firstUnwindCtxt
	"Unwind thisContext to self and resume with value as result of last send.
	 Execute any unwind blocks while unwinding.
	 ASSUMES self is a sender of thisContext."

	| ctxt unwindBlock |
	self isDead ifTrue: [self cannotReturn: value to: self].
	ctxt := firstUnwindCtxt.
	[ctxt isNil] whileFalse:
		[(ctxt tempAt: 2) ifNil:
			[ctxt tempAt: 2 put: true.
			 unwindBlock := ctxt tempAt: 1.
			 thisContext terminateTo: ctxt.
			 unwindBlock value].
		 ctxt := ctxt findNextUnwindContextUpTo: self].
	thisContext terminateTo: self.
	^value
! !

!Context methodsFor: 'controlling' stamp: 'SqR 11/15/2015 11:43'!
resumeEvaluating: aBlock
	"Unwind thisContext to self and resume with aBlock value as result of last send.  Execute unwind blocks when unwinding.  ASSUMES self is a sender of thisContext"

	| ctxt unwindBlock |
	self isDead ifTrue: [self cannotReturn: aBlock value to: self].
	ctxt := thisContext.
	[
		ctxt := ctxt findNextUnwindContextUpTo: self.
		ctxt isNil
	] whileFalse: [
		(ctxt tempAt: 2) isNil ifTrue:
			[
				ctxt tempAt: 2 put: true.
				unwindBlock := ctxt tempAt: 1.
				thisContext terminateTo: ctxt.
				unwindBlock value
			]
	].
	thisContext terminateTo: self.
	^aBlock value! !

!Context methodsFor: 'controlling' stamp: 'ajh 1/21/2003 19:27'!
return
	"Unwind until my sender is on top"

	self return: self receiver! !

!Context methodsFor: 'controlling' stamp: 'ajh 5/20/2004 17:27'!
return: value
	"Unwind thisContext to self and return value to self's sender.  Execute any unwind blocks while unwinding.  ASSUMES self is a sender of thisContext"

	sender ifNil: [self cannotReturn: value to: sender].
	sender resume: value! !

!Context methodsFor: 'controlling' stamp: 'eem 4/25/2012 10:47'!
return: value through: firstUnwindContext
	"Unwind thisContext to self and return value to self's sender.
	 Execute any unwind blocks while unwinding.
	 ASSUMES self is a sender of thisContext."

	sender ifNil: [self cannotReturn: value to: sender].
	sender resume: value through: firstUnwindContext! !

!Context methodsFor: 'controlling' stamp: 'ajh 1/24/2003 15:30'!
return: value to: sendr 
	"Simulate the return of value to sendr."

	self releaseTo: sendr.
	sendr ifNil: [^ nil].
	^ sendr push: value! !

!Context methodsFor: 'controlling' stamp: 'SH 10/13/2016 20:40:32'!
runUntilErrorOrReturnFrom: aSender 
	"ASSUMES aSender is a sender of self.  Execute self's stack until aSender returns or an unhandled exception is raised.  Return a pair containing the new top context and a possibly nil exception.  The exception is not nil if it was raised before aSender returned and it was not handled.  The exception is returned rather than openning the debugger, giving the caller the choice of how to handle it."
	"Self is run by jumping directly to it (the active process abandons thisContext and executes self).  However, before jumping to self we insert an ensure block under aSender that jumps back to thisContext when evaluated.  We also insert an exception handler under aSender that jumps back to thisContext when an unhandled exception is raised.  In either case, the inserted ensure and exception handler are removed once control jumps back to thisContext."

	| error ctxt here topContext |
	here _ thisContext.

	"Insert ensure and exception handler contexts under aSender"
	error _ nil.
	ctxt _ aSender insertSender: (Context
		contextOn: UnhandledError do: [:ex |
			error ifNil: [
				error _ ex exception.
				topContext _ thisContext.
				ex resumeUnchecked: here jump]
			ifNotNil: [ex pass]
		]).
	ctxt _ ctxt insertSender: (Context
		contextEnsure: [error ifNil: [
				topContext _ thisContext.
				here jump]
		]).
	self jump.  "Control jumps to self"

	"Control resumes here once above ensure block or exception handler is executed"
	^ error ifNil: [
		"No error was raised, remove ensure context by stepping until popped"
		[ctxt isDead] whileFalse: [topContext _ topContext stepToCallee].
		{topContext. nil}

	] ifNotNil: [
		"Error was raised, remove inserted above contexts then return signaler context"
		aSender terminateTo: ctxt sender.  "remove above ensure and handler contexts"
		{topContext. error}
	].
! !

!Context methodsFor: 'controlling' stamp: 'SH 10/13/2016 20:31:41'!
send: selector to: rcvr with: arguments lookupIn: lookupClass
	"Simulate the action of sending a message with selector and arguments
	 to rcvr. The argument, lookupClass, is the class in which to lookup the
	 message.  This is the receiver's class for normal messages, but for super
	 messages it will be some specific class related to the source method."

	| meth primIndex val ctxt |
	(meth := lookupClass lookupSelector: selector) ifNil:
		[^self send: #doesNotUnderstand:
				to: rcvr
				with: {Message selector: selector arguments: arguments}
				lookupIn: lookupClass].
	(primIndex := meth primitive) > 0 ifTrue:
		[val := self doPrimitive: primIndex method: meth receiver: rcvr args: arguments.
		 (self isPrimFailToken: val) ifFalse:
			[^val]].
	(selector == #doesNotUnderstand: and: [lookupClass == ProtoObject]) ifTrue:
		[^self error: 'Simulated message ', arguments first selector, ' not understood'].
	ctxt := Context sender: self receiver: rcvr method: meth arguments: arguments.
	primIndex > 0 ifTrue:
		[ctxt failPrimitiveWith: val].
	^ctxt! !

!Context methodsFor: 'controlling' stamp: 'eem 8/11/2014 13:44'!
send: selector to: rcvr with: arguments super: superFlag 
	"Simulate the action of sending a message with selector arguments
	 to rcvr. The argument, superFlag, tells whether the receiver of the
	 message was specified with 'super' in the source method."

	^self send: selector
		to: rcvr
		with: arguments
		lookupIn: (superFlag
					ifTrue: [self method methodClassAssociation value superclass]
					ifFalse: [self objectClass: rcvr])! !

!Context methodsFor: 'controlling' stamp: 'ajh 1/24/2003 00:56'!
terminate
	"Make myself unresumable."

	sender _ nil.
	pc _ nil.
! !

!Context methodsFor: 'controlling' stamp: 'ar 3/6/2001 14:26'!
terminateTo: previousContext
	"Terminate all the Contexts between me and previousContext, if previousContext is on my Context stack. Make previousContext my sender."

	| currentContext sendingContext |
	<primitive: 196>
	(self hasSender: previousContext) ifTrue: [
		currentContext := sender.
		[currentContext == previousContext] whileFalse: [
			sendingContext := currentContext sender.
			currentContext terminate.
			currentContext := sendingContext]].
	sender := previousContext! !

!Context methodsFor: 'controlling'!
top
	"Answer the top of the receiver's stack."

	^self at: stackp! !

!Context methodsFor: 'debugger access' stamp: 'ajh 9/25/2001 00:12'!
contextStack 
	"Answer an Array of the contexts on the receiver's sender chain."

	^self stackOfSize: 100000! !

!Context methodsFor: 'debugger access'!
depthBelow: aContext
	"Answer how many calls there are between this and aContext."

	| this depth |
	this _ self.
	depth _ 0.
	[this == aContext or: [this == nil]]
		whileFalse:
			[this _ this sender.
			depth _ depth + 1].
	^depth! !

!Context methodsFor: 'debugger access' stamp: 'jmv 3/13/2012 12:36'!
errorReportOn: strm
	"Write a detailed error report on the stack (above me) on a stream.  For both the error file, and emailing a bug report.  Suppress any errors while getting printStrings.  Limit the length."

	| cnt aContext startPos |
 	strm print: Date today; space; print: Time now; newLine.
	strm newLine.
	strm nextPutAll: 'VM: ';
		nextPutAll: Smalltalk platformName asString;
		nextPutAll: ' - ';
		nextPutAll: Smalltalk vmVersion asString;
		newLine.
	strm nextPutAll: 'Image: ';
		nextPutAll: Smalltalk version asString;
		nextPutAll: ' [';
		nextPutAll: Smalltalk lastUpdateString asString;
		nextPutAll: ']';
		newLine.
	strm newLine.
	
	"Note: The following is an open-coded version of Context>>stackOfSize: since this method may be called during a low space condition and we might run out of space for allocating the full stack."
	cnt _ 0.  startPos _ strm position.
	aContext _ self.
	[aContext notNil and: [(cnt _ cnt + 1) < 20]] whileTrue: [
		aContext printDetails: strm.	"variable values"
		strm newLine.
		aContext _ aContext sender].

	strm newLine; nextPutAll: '--- The full stack ---'; newLine.
	aContext _ self.
	cnt _ 0.
	[aContext == nil] whileFalse: [
		cnt _ cnt + 1.
		cnt = 20 ifTrue: [strm nextPutAll: ' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'; newLine ].
		strm print: aContext; newLine.  "just class>>selector"	

		strm position > (startPos+40000) ifTrue: [strm nextPutAll: '...etc...'.
			^ self]. 	"exit early"
		cnt > 60 ifTrue: [strm nextPutAll: '-- and more not shown --'.  ^ self].
		aContext _ aContext sender].
! !

!Context methodsFor: 'debugger access' stamp: 'jmv 3/13/2012 12:29'!
longStack
	"Answer a String showing the top 100 contexts on my sender chain."

	^ String streamContents: [ :strm |
		(self stackOfSize: 100)
			do: [:item | strm print: item; newLine]]! !

!Context methodsFor: 'debugger access' stamp: 'eem 11/27/2014 13:11'!
methodClass 
	"Answer the class in which the receiver's method was found."
	
	^self method methodClass ifNil: [self objectClass: self receiver].! !

!Context methodsFor: 'debugger access' stamp: 'eem 7/17/2008 14:49'!
namedTempAt: index
	"Answer the value of the temp at index in the receiver's sequence of tempNames."
	^self debuggerMap namedTempAt: index in: self! !

!Context methodsFor: 'debugger access' stamp: 'eem 6/24/2008 12:24'!
namedTempAt: index put: aValue
	"Set the value of the temp at index in the receiver's sequence of tempNames.
	 (Note that if the value is a copied value it is also set out along the lexical chain,
	  but alas not in along the lexical chain.)."
	^self debuggerMap namedTempAt: index put: aValue in: self! !

!Context methodsFor: 'debugger access' stamp: 'eem 11/27/2014 13:07'!
print: anObject on: aStream
	"Safely print anObject in the face of direct ProtoObject subclasses."
	| objClass title |
	objClass := self objectClass: anObject.
	(objClass canUnderstand: #printOn:) ifTrue:
		[^anObject printOn: aStream].
	title := objClass name.
	aStream
		nextPutAll: (title first isVowel ifTrue: ['an '] ifFalse: ['a ']);
		nextPutAll: title! !

!Context methodsFor: 'debugger access'!
releaseTo: caller 
	"Remove information from the receiver and the contexts on its sender 
	chain up to caller in order to break circularities."

	| c s |
	c _ self.
	[c == nil or: [c == caller]]
		whileFalse: 
			[s _ c sender.
			c singleRelease.
			c _ s]! !

!Context methodsFor: 'debugger access' stamp: 'md 2/17/2006 18:47'!
selector
	"Answer the selector of the method that created the receiver."

	^self method selector ifNil: [self method defaultSelector].! !

!Context methodsFor: 'debugger access'!
sender
	"Answer the context that sent the message that created the receiver."

	^sender! !

!Context methodsFor: 'debugger access' stamp: 'jmv 3/13/2012 12:30'!
shortStack
	"Answer a String showing the top ten contexts on my sender chain."

	^ String streamContents: [ :strm |
		(self stackOfSize: 10)
			do: [:item | strm print: item; newLine]]! !

!Context methodsFor: 'debugger access' stamp: 'jmv 3/1/2010 09:50'!
singleRelease
	"Remove information from the receiver in order to break circularities."

	stackp ifNotNil: [1 to: stackp do: [:i | self at: i put: nil]].
	sender _ nil.
	pc _ nil! !

!Context methodsFor: 'debugger access' stamp: 'md 2/22/2006 16:58'!
sourceCode
	^self method getSource.
	
	"Note: The above is a bit safer than
		^ methodClass sourceCodeAt: selector
	which may fail if the receiver's method has been changed in
	the debugger (e.g., the method is no longer in the methodDict
	and thus the above selector is something like #Doit:with:with:with:)
	but the source code is still available."! !

!Context methodsFor: 'debugger access'!
stack 
	"Answer an Array of the contexts on the receiver's sender chain."

	^self stackOfSize: 9999! !

!Context methodsFor: 'debugger access' stamp: 'jmv 3/1/2010 14:04'!
stackOfSize: limit 
	"Answer an OrderedCollection of the top 'limit' contexts
	 on the receiver's sender chain."

	| stack ctxt |
	stack := OrderedCollection new.
	stack addLast: (ctxt := self).
	[(ctxt := ctxt sender) notNil
	 and: [stack size < limit]] whileTrue:
		[stack addLast: ctxt].
	^stack! !

!Context methodsFor: 'debugger access'!
swapSender: coroutine 
	"Replace the receiver's sender with coroutine and answer the receiver's 
	previous sender. For use in coroutining."

	| oldSender |
	oldSender := sender.
	sender := coroutine.
	^oldSender! !

!Context methodsFor: 'debugger access' stamp: 'eem 6/10/2008 09:42'!
tempNames
	"Answer a SequenceableCollection of the names of the receiver's temporary 
	 variables, which are strings."

	^ self debuggerMap tempNamesForContext: self! !

!Context methodsFor: 'debugger access' stamp: 'eem 6/10/2008 09:47'!
tempsAndValues
	"Return a string of the temporary variabls and their current values"
	^self debuggerMap tempsAndValuesForContext: self! !

!Context methodsFor: 'debugger access' stamp: 'jmv 4/2/2016 23:05'!
tempsAndValuesLimitedTo: sizeLimit indent: indent
	"Return a string of the temporary variabls and their current values"

	| aStream |
	aStream _ WriteStream on: (String new: 100).
	self tempNames
		withIndexDo: [:title :index |
			indent timesRepeat: [aStream tab].
			aStream nextPutAll: title; nextPut: $:; space; tab.
			aStream nextPutAll: 
				((self tempAt: index) printStringLimitedTo: (sizeLimit -3 -title size max: 1)).
			aStream newLine].
	^aStream contents! !

!Context methodsFor: 'initialization' stamp: 'eem 9/10/2009 15:49'!
privRefresh
	"Reinitialize the receiver so that it is in the state it was at its creation."

	closureOrNil
		ifNotNil:
			[pc := closureOrNil startpc.
			self stackp: closureOrNil numArgs + closureOrNil numCopiedValues.
			1 to: closureOrNil numCopiedValues do:
				[:i | self tempAt: closureOrNil numArgs + i put: (closureOrNil at: i)]]
		ifNil:
			[pc := method initialPC.
			self stackp: method numTemps.
			method numArgs+1 to: method numTemps do:
				[:i | self tempAt: i put: nil]]! !

!Context methodsFor: 'initialization' stamp: 'jmv 1/12/2010 11:48'!
privRefreshWith: aCompiledMethod 
	"Reinitialize the receiver as though it had been for a different method. 
	 Used by a Debugger when one of the methods to which it refers is 
	 recompiled."

	(aCompiledMethod is: #CompiledMethod) ifFalse: [
		self error: 'method can only be set to aCompiledMethod'].
	method := aCompiledMethod.
	self assert: closureOrNil == nil.
	"was: receiverMap := nil."
	self privRefresh! !

!Context methodsFor: 'inspecting' stamp: 'jmv 11/1/2011 23:06'!
inspectorClass
	"Answer the class of the inspector to be used on the receiver.  Called by inspect; 
	use basicInspect to get a normal (less useful) type of inspector."

	^ ContextInspector! !

!Context methodsFor: 'instruction decoding'!
doDup
	"Simulate the action of a 'duplicate top of stack' bytecode."

	self push: self top! !

!Context methodsFor: 'instruction decoding'!
doPop
	"Simulate the action of a 'remove top of stack' bytecode."

	self pop! !

!Context methodsFor: 'instruction decoding'!
jump: distance 
	"Simulate the action of a 'unconditional jump' bytecode whose offset is 
	the argument, distance."

	pc _ pc + distance! !

!Context methodsFor: 'instruction decoding' stamp: 'ajh 7/6/2003 20:38'!
jump: distance if: condition 
	"Simulate the action of a 'conditional jump' bytecode whose offset is the 
	argument, distance, and whose condition is the argument, condition."

	| bool |
	bool _ self pop.
	(bool == true or: [bool == false]) ifFalse: [
		^self
			send: #mustBeBooleanIn:
			to: bool
			with: {self}
			super: false].
	(bool eqv: condition) ifTrue: [self jump: distance]! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 6/15/2008 11:27'!
methodReturnConstant: value
	"Simulate the action of a 'return constant' bytecode whose value is the
	 argument, value. This corresponds to a source expression like '^0'."

	^self return: value from: self methodReturnContext! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 6/15/2008 11:27'!
methodReturnReceiver
	"Simulate the action of a 'return receiver' bytecode. This corresponds to
	 the source expression '^self'."

	^self return: self receiver from: self methodReturnContext! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 6/15/2008 11:27'!
methodReturnTop
	"Simulate the action of a 'return top of stack' bytecode. This corresponds
	 to source expressions like '^something'."

	^self return: self pop from: self methodReturnContext! !

!Context methodsFor: 'instruction decoding' stamp: 'jmv 8/16/2016 20:30:40'!
popIntoLiteralVariable: value 
	"Simulate the action of bytecode that removes the top of the stack and 
	stores it into a literal variable of my method."

	self object: value instVarAt: self class valueIndex put: self pop! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 5/12/2009 12:00'!
popIntoReceiverVariable: offset 
	"Simulate the action of bytecode that removes the top of the stack and 
	stores it into an instance variable of my receiver."

	self object: self receiver instVarAt: offset + 1 put: self pop! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 5/12/2009 13:07'!
popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
	"Simulate the action of bytecode that removes the top of the stack and  stores
	 it into an offset in one of my local variables being used as a remote temp vector."

	self object: (self at: tempVectorIndex + 1) basicAt: remoteTempIndex + 1 put: self pop! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 6/15/2008 11:34'!
popIntoTemporaryVariable: offset 
	"Simulate the action of bytecode that removes the top of the stack and 
	stores it into one of my temporary variables."

	self contextForLocalVariables at: offset + 1 put: self pop! !

!Context methodsFor: 'instruction decoding'!
pushActiveContext
	"Simulate the action of bytecode that pushes the the active context on the 
	top of its own stack."

	self push: self! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 8/29/2008 06:28'!
pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize
	"Simulate the action of a 'closure copy' bytecode whose result is the
	 new BlockClosure for the following code"
	| copiedValues |
	numCopied > 0
		ifTrue:
			[copiedValues := Array new: numCopied.
			 numCopied to: 1 by: -1 do:
				[:i|
				copiedValues at: i put: self pop]]
		ifFalse:
			[copiedValues := nil].
	self push: (BlockClosure
				outerContext: self
				startpc: pc
				numArgs: numArgs
				copiedValues: copiedValues).
	self jump: blockSize! !

!Context methodsFor: 'instruction decoding'!
pushConstant: value 
	"Simulate the action of bytecode that pushes the constant, value, on the 
	top of the stack."

	self push: value! !

!Context methodsFor: 'instruction decoding' stamp: 'jmv 8/16/2016 20:30:43'!
pushLiteralVariable: value 
	"Simulate the action of bytecode that pushes the contents of the literal 
	variable whose index is the argument, index, on the top of the stack."

	self push: (self object: value instVarAt: self class valueIndex)! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 5/27/2008 11:32'!
pushNewArrayOfSize: arraySize 
	self push: (Array new: arraySize)! !

!Context methodsFor: 'instruction decoding'!
pushReceiver
	"Simulate the action of bytecode that pushes the active context's receiver 
	on the top of the stack."

	self push: self receiver! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 5/12/2009 12:00'!
pushReceiverVariable: offset 
	"Simulate the action of bytecode that pushes the contents of the receiver's 
	instance variable whose index is the argument, index, on the top of the 
	stack."

	self push: (self object: self receiver instVarAt: offset + 1)! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 5/12/2009 13:07'!
pushRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
	"Simulate the action of bytecode that pushes the value at remoteTempIndex
	 in one of my local variables being used as a remote temp vector."
	self push: (self object: (self at: tempVectorIndex + 1) basicAt: remoteTempIndex + 1)! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 6/15/2008 11:34'!
pushTemporaryVariable: offset 
	"Simulate the action of bytecode that pushes the contents of the 
	temporary variable whose index is the argument, index, on the top of 
	the stack."

	self push: (self contextForLocalVariables at: offset + 1)! !

!Context methodsFor: 'instruction decoding' stamp: 'ajh 3/5/2004 03:44'!
return: value from: aSender 
	"For simulation.  Roll back self to aSender and return value from it.  Execute any unwind blocks on the way.  ASSUMES aSender is a sender of self"

	| newTop ctxt |
	aSender isDead ifTrue: [
		^ self send: #cannotReturn: to: self with: {value} super: false].
	newTop _ aSender sender.
	ctxt _ self findNextUnwindContextUpTo: newTop.
	ctxt ifNotNil: [
		^ self send: #aboutToReturn:through: to: self with: {value. ctxt} super: false].
	self releaseTo: newTop.
	newTop ifNotNil: [newTop push: value].
	^ newTop
! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 3/22/2013 14:43'!
send: selector super: superFlag numArgs: numArgs
	"Simulate the action of bytecodes that send a message with selector, 
	selector. The argument, superFlag, tells whether the receiver of the 
	message was specified with 'super' in the source method. The arguments 
	of the message are found in the top numArgs locations on the stack and 
	the receiver just below them."

	| receiver arguments |
	arguments := Array new: numArgs.
	numArgs to: 1 by: -1 do: [ :i | arguments at: i put: self pop].
	receiver := self pop.
	QuickStep == self ifTrue:
		[QuickStep := nil.
		^self quickSend: selector to: receiver with: arguments super: superFlag].
	^self send: selector to: receiver with: arguments super: superFlag! !

!Context methodsFor: 'instruction decoding' stamp: 'jmv 8/16/2016 20:30:46'!
storeIntoLiteralVariable: value 
	"Simulate the action of bytecode that stores the top of the stack into a 
	literal variable of my method."

	self object: value instVarAt: self class valueIndex put: self top! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 5/12/2009 12:00'!
storeIntoReceiverVariable: offset 
	"Simulate the action of bytecode that stores the top of the stack into an 
	instance variable of my receiver."

	self object: self receiver instVarAt: offset + 1 put: self top! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 5/12/2009 13:05'!
storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
	"Simulate the action of bytecode that stores the top of the stack at
	 an offset in one of my local variables being used as a remote temp vector."

	self object: (self at: tempVectorIndex + 1) basicAt: remoteTempIndex + 1 put: self top! !

!Context methodsFor: 'instruction decoding' stamp: 'eem 6/15/2008 11:34'!
storeIntoTemporaryVariable: offset 
	"Simulate the action of bytecode that stores the top of the stack into one 
	of my temporary variables."

	self contextForLocalVariables at: offset + 1 put: self top! !

!Context methodsFor: 'instruction decoding (closures)' stamp: 'eem 7/22/2008 11:56'!
blockReturnTop
	"Simulate the interpreter's action when a ReturnTopOfStackToCaller bytecode is 
	 encountered in the receiver.  This should only happen in a closure activation."
	self assert: closureOrNil isClosure.
	^self return: self pop from: self! !

!Context methodsFor: 'instruction decoding (closures)' stamp: 'eem 5/30/2008 18:40'!
pushConsArrayWithElements: numElements 
	| array |
	array := Array new: numElements.
	numElements to: 1 by: -1 do:
		[:i|
		array at: i put: self pop].
	self push: array! !

!Context methodsFor: 'mirror primitives' stamp: 'eem 5/13/2009 14:21'!
object: anObject basicAt: index 
	"Answer the value of an indexable element in the argument anObject without sending
	 it a message. Fail if the argument index is not an Integer or is out of bounds, or if
	 anObject is not indexable. This mimics the action of the VM when it indexes an object.
	 Used to simulate the execution machinery by, for example, the debugger.
	 Primitive.  See Object documentation whatIsAPrimitive."

	<primitive: 60>
	index isInteger ifTrue: [self errorSubscriptBounds: index].
	index isNumber
		ifTrue: [^self object: anObject basicAt: index asInteger]
		ifFalse: [self errorNonIntegerIndex]! !

!Context methodsFor: 'mirror primitives' stamp: 'eem 5/13/2009 14:21'!
object: anObject basicAt: index put: value 
	"Store the last argument 
	 value in the indexable element of the argument anObject indicated by index without sending
	 anObject a message. Fail if the argument index is not an Integer or is out of bounds, or if
	 anObject is not indexable, or if value is an inappropriate value for anObject's indexable slots.
	 This mimics the action of the VM when it indexes an object.
	 Used to simulate the execution machinery by, for example, the debugger.
	 Primitive.  See Object documentation whatIsAPrimitive."

	<primitive: 61>
	index isInteger
		ifTrue: [(index >= 1 and: [index <= (self objectSize: anObject)])
					ifTrue: [self errorImproperStore]
					ifFalse: [self errorSubscriptBounds: index]].
	index isNumber
		ifTrue: [^self object: anObject basicAt: index asInteger put: value]
		ifFalse: [self errorNonIntegerIndex]! !

!Context methodsFor: 'mirror primitives' stamp: 'eem 5/13/2009 14:23'!
object: anObject eqeq: anOtherObject 
	"Answer whether the first and second arguments are the same object (have the
	 same object pointer) without sending a message to the first argument.  This
	 mimics the action of the VM when it compares two object pointers.  Used to
	 simulate the execution machinery by, for example, the debugger.
	 Primitive.  See Object documentation whatIsAPrimitive."

	<primitive: 110>
	self primitiveFailed! !

!Context methodsFor: 'mirror primitives' stamp: 'eem 4/8/2009 19:27'!
object: anObject instVarAt: anIndex
	"Primitive. Answer a fixed variable in an object. The numbering of the 
	 variables corresponds to the named instance variables. Fail if the index 
	 is not an Integer or is not the index of a fixed variable. Essential for the
	 debugger. See  Object documentation whatIsAPrimitive."

	<primitive: 73>
	"Access beyond fixed variables."
	^self object: anObject basicAt: anIndex - (self objectClass: anObject) instSize! !

!Context methodsFor: 'mirror primitives' stamp: 'eem 4/8/2009 19:30'!
object: anObject instVarAt: anIndex put: aValue 
	"Primitive. Store a value into a fixed variable in the argument anObject.
	 The numbering of the variables corresponds to the named instance
	 variables.  Fail if the index is not an Integer or is not the index of a
	 fixed variable.  Answer the value stored as the result. Using this
	 message violates the  principle that each object has sovereign control
	 over the storing of values into its instance variables. Essential for the
	 debugger. See Object documentation whatIsAPrimitive."

	<primitive: 74>
	"Access beyond fixed fields"
	^self object: anObject basicAt: anIndex - (self objectClass: anObject) instSize put: aValue! !

!Context methodsFor: 'mirror primitives' stamp: 'dtl 12/11/2011 19:39'!
object: anObject perform: selector withArguments: argArray inClass: lookupClass
	"Send the selector, aSymbol, to anObject with arguments in argArray.
	 Fail if the number of arguments expected by the selector 
	 does not match the size of argArray, or if lookupClass
	 cannot be found among the anObject's superclasses.
	 Primitive. Essential for the debugger."

	<primitive: 100 error: error>
	(selector isSymbol) ifFalse:
		[^self error: 'selector argument must be a Symbol'].
	(argArray isMemberOf: Array) ifFalse:
		[^self error: 'argArray must be an Array'].
	(selector numArgs = argArray size)
		ifFalse: [^self error: 'incorrect number of arguments'].
	((self objectClass: anObject) == lookupClass
	 or: [(self objectClass: anObject) inheritsFrom: lookupClass]) ifFalse:
		[^self error: 'lookupClass is not in anObject''s inheritance chain'].
	self primitiveFailed! !

!Context methodsFor: 'mirror primitives' stamp: 'ul 12/15/2009 19:04'!
objectClass: anObject

	<primitive: 111>
	self primitiveFailed! !

!Context methodsFor: 'mirror primitives' stamp: 'eem 5/13/2009 14:21'!
objectSize: anObject
	"Answer the number of indexable variables in the argument anObject without sending
	 it a message. This mimics the action of the VM when it fetches an object's variable size.
	 Used to simulate the execution machinery by, for example, the debugger.
	 Primitive.  See Object documentation whatIsAPrimitive."

	<primitive: 62>
	"The number of indexable fields of fixed-length objects is 0"
	^0! !

!Context methodsFor: 'objects from disk' stamp: 'jmv 2/17/2010 23:16'!
storeDataOn: aDataStream
	"Contexts are not allowed go to out in DataStreams.  They must be included inside an ImageSegment."

	self error: 'Contexts are not allowed go to out in DataStreams'.
	^ nil! !

!Context methodsFor: 'printing' stamp: 'SH 10/16/2016 03:17:08'!
printDetails: strm
	"Put my class>>selector and instance variables and arguments and temporaries on the stream.  Protect against errors during printing."
		| pe str pos |
	self printOn: strm.
	strm newLine.
	strm tab; nextPutAll: 'Receiver: '.
	pe _ '<<error during printing>>'.
	strm nextPutAll: ([receiver printStringLimitedTo: 90] ifError: [:err :rcvr | pe]).

	strm newLine; tab; nextPutAll: 'Arguments and temporary variables: '; newLine.
	str _ [(self tempsAndValuesLimitedTo: 80 indent: 2) 
				padded: #right to: 1 with: $x] ifError: [:err :rcvr | pe].
	strm nextPutAll: (str allButLast).

	strm newLine; tab; nextPutAll: 'Receiver''s instance variables: '; newLine.
	pos _ strm position.
	[receiver longPrintOn: strm limitedTo: 80 indent: 2] ifError: [:err :rcvr | 
				strm nextPutAll: pe].
	pos = strm position ifTrue: ["normal printString for an Array (it has no inst vars)"
		strm nextPutAll: ([receiver printStringLimitedTo: 90] ifError: [:err :rcvr | pe])].
	strm peekLast isLineSeparator ifFalse: [strm newLine].! !

!Context methodsFor: 'printing' stamp: 'SH 10/16/2016 03:12:49'!
printOn: aStream
	| selector class mclass |
	self outerContext ifNil: [
	self method ifNil: [ ^ super printOn: aStream ].
	class _ self receiver class.
	mclass _ self methodClass.
	selector _ self selector ifNil: [ self method defaultSelector ].
	aStream nextPutAll: class name.
	mclass == class ifFalse: [
		aStream nextPut: $(.
		aStream nextPutAll: mclass name.
		aStream nextPut: $) ].
	aStream nextPutAll: '>>'.
	aStream nextPutAll: selector.
	selector == #doesNotUnderstand: ifTrue: [
		aStream space.
		(self tempAt: 1) selector printOn: aStream ].
	] ifNotNil: [:outerContext |
	aStream nextPutAll: '[] in '.
	outerContext printOn: aStream]
	! !

!Context methodsFor: 'printing' stamp: 'jmv 2/23/2011 16:04'!
printStack: depth
	self print.
	depth > 0 ifTrue: [
		self sender ifNotNil: [ :s | s printStack: depth-1 ]]! !

!Context methodsFor: 'printing' stamp: 'jmv 5/7/2012 20:25'!
printString
	"Answer an emphasized string in case of a breakpoint method"
	(self method notNil and: [ self method hasBreakpoint ])
		ifFalse: [ ^ super printString ].
	^ super printString , ' [break]' asText allBold! !

!Context methodsFor: 'query' stamp: 'ajh 7/21/2003 09:59'!
bottomContext
	"Return the last context (the first context invoked) in my sender chain"

	^ self findContextSuchThat: [:c | c sender isNil]! !

!Context methodsFor: 'query' stamp: 'ajh 1/27/2003 18:35'!
copyStack

	^ self copyTo: nil! !

!Context methodsFor: 'query' stamp: 'ul 4/27/2011 22:57'!
copyTo: aContext
	"Copy self and my sender chain down to, but not including, aContext.  End of copied chain will have nil sender."

	| copy |
	self == aContext ifTrue: [ ^nil ].
	copy := self copy.
	sender ifNotNil: [ copy privSender: (sender copyTo: aContext) ].
	^copy! !

!Context methodsFor: 'query' stamp: 'ajh 1/24/2003 00:12'!
findContextSuchThat: testBlock
	"Search self and my sender chain for first one that satisfies testBlock.  Return nil if none satisfy"

	| ctxt |
	ctxt _ self.
	[ctxt isNil] whileFalse: [
		(testBlock value: ctxt) ifTrue: [^ ctxt].
		ctxt _ ctxt sender.
	].
	^ nil! !

!Context methodsFor: 'query' stamp: 'md 1/20/2006 16:15'!
findSecondToOldestSimilarSender
	"Search the stack for the second-to-oldest occurance of self's method.  Very useful for an infinite recursion.  Gets back to the second call so you can see one complete recursion cycle, and how it was called at the beginning."

	| sec ctxt bot |
	sec := self.
	ctxt := self.
	[	bot := ctxt findSimilarSender.
		bot isNil
	] whileFalse: [
		sec := ctxt.
		ctxt := bot.
	].
	^ sec
! !

!Context methodsFor: 'query' stamp: 'md 1/20/2006 16:14'!
findSimilarSender
	"Return the closest sender with the same method, return nil if none found"

	| meth |
	meth := self method.
	^ self sender findContextSuchThat: [:c | c method == meth]! !

!Context methodsFor: 'query' stamp: 'ajh 1/24/2003 19:42'!
hasContext: aContext 
	"Answer whether aContext is me or one of my senders"

	^ (self findContextSuchThat: [:c | c == aContext]) notNil! !

!Context methodsFor: 'query' stamp: 'eem 12/31/2008 11:28'!
isBottomContext
	"Answer if this is the last context (the first context invoked) in my sender chain"

	^sender isNil! !

!Context methodsFor: 'query' stamp: 'eem 11/26/2008 20:21'!
isContext
	^true! !

!Context methodsFor: 'query' stamp: 'ajh 1/24/2003 00:04'!
isDead
	"Has self finished"

	^ pc isNil! !

!Context methodsFor: 'query' stamp: 'ajh 1/24/2003 22:28'!
secondFromBottom
	"Return the second from bottom of my sender chain"

	self sender ifNil: [^ nil].
	^ self findContextSuchThat: [:c | c sender sender isNil]! !

!Context methodsFor: 'system simulation' stamp: 'hmm 7/30/2001 20:43'!
completeCallee: aContext
	"Simulate the execution of bytecodes until a return to the receiver."
	| ctxt current ctxt1 |
	ctxt _ aContext.
	[ctxt == current or: [ctxt hasSender: self]]
		whileTrue: 
			[current _ ctxt.
			ctxt1 _ ctxt quickStep.
			ctxt1 ifNil: [self halt].
			ctxt _ ctxt1].
	^self stepToSendOrReturn! !

!Context methodsFor: 'system simulation' stamp: 'eem 8/11/2014 13:18'!
failPrimitiveWith: maybePrimFailToken
	"The receiver is a freshly-created context on a primitive method.  Skip the callPrimitive:
	 bytecode and store the primitive fail code if there is one and the method consumes it."
	self skipCallPrimitive.
	((self isPrimFailToken: maybePrimFailToken)
	  and: [method encoderClass isStoreAt: pc in: method]) ifTrue:
		[self at: stackp put: maybePrimFailToken last]! !

!Context methodsFor: 'system simulation' stamp: 'eem 7/2/2010 10:26'!
pushArgs: args "<Array>" from: sendr "<ContextPart>" 
	"Helps simulate action of the value primitive for closures.
	 This is used by ContextPart>>runSimulated:contextAtEachStep:"

	closureOrNil
		ifNil: [self error: 'context needs a closure!!']
		ifNotNil:
			["See BlockClosure>>asContextWithSender:"
			 stackp ~= (closureOrNil numArgs + closureOrNil numCopiedValues) ifTrue:
				[self error: 'stack pointer is incorrect!!'].].

	1 to: closureOrNil numArgs do:
		[:i| self at: i put: (args at: i)].
	sender := sendr! !

!Context methodsFor: 'system simulation' stamp: 'jmv 9/17/2016 18:18:56'!
quickStep
	"If the next instruction is a send, just perform it.
	Otherwise, do a normal step."

	self willSend ifTrue: [QuickStep _ self].
	^self step! !

!Context methodsFor: 'system simulation' stamp: 'eem 6/16/2008 15:39'!
runSimulated: aBlock contextAtEachStep: block2
	"Simulate the execution of the argument, aBlock, until it ends. aBlock 
	MUST NOT contain an '^'. Evaluate block2 with the current context 
	prior to each instruction executed. Answer the simulated value of aBlock."
	| current |
	aBlock hasMethodReturn
		ifTrue: [self error: 'simulation of blocks with ^ can run loose'].
	current := aBlock asContext.
	current pushArgs: Array new from: self.
	[current == self]
		whileFalse:
			[block2 value: current.
			current := current step].
	^self pop! !

!Context methodsFor: 'system simulation'!
step
	"Simulate the execution of the receiver's next bytecode. Answer the 
	context that would be the active context after this bytecode."

	^self interpretNextInstructionFor: self! !

!Context methodsFor: 'system simulation' stamp: 'ajh 1/24/2003 22:54'!
stepToCallee
	"Step to callee or sender"

	| ctxt |
	ctxt _ self.
	[(ctxt _ ctxt step) == self] whileTrue.
	^ ctxt! !

!Context methodsFor: 'system simulation' stamp: 'jmv 9/17/2016 18:19:05'!
stepToSendOrReturn
	"Simulate the execution of bytecodes until either sending a message or 
	 returning a value to the receiver (that is, until switching contexts)."

	| ctxt |
	[self willSend or: [self willReturn or: [self willReallyStore]]] whileFalse:
		[ctxt := self step.
		 ctxt == self ifFalse:
			[self halt. 
			 "Caused by mustBeBoolean handling"
			 ^ctxt]]! !

!Context methodsFor: 'testing' stamp: 'jmv 8/5/2011 18:47'!
atEnd
	^ self isExecutingBlock
		ifTrue: [ self closure startpc + self closure size - 1 = self pc ]
		ifFalse: [ self pc >= self method endPC ]! !

!Context methodsFor: 'private' stamp: 'eem 4/25/2012 10:48'!
aboutToReturn: result through: firstUnwindContext 
	"Called from VM when an unwindBlock is found between self and its home.
	 Return to home's sender, executing unwind blocks on the way."

	self methodReturnContext return: result through: firstUnwindContext! !

!Context methodsFor: 'private' stamp: 'jmv 3/2/2010 17:09'!
cannotReturn: result
	closureOrNil ifNotNil: [
		^self cannotReturn: result to: sender].
	Debugger
		openContext: thisContext
		label: 'computation has been terminated'
		contents: nil! !

!Context methodsFor: 'private' stamp: 'ajh 6/29/2003 15:32'!
cannotReturn: result to: homeContext
	"The receiver tried to return result to homeContext that no longer exists."

	^ BlockCannotReturn new
		result: result;
		deadHome: homeContext;
		signal! !

!Context methodsFor: 'private' stamp: 'ajh 1/24/2003 00:50'!
cut: aContext
	"Cut aContext and its senders from my sender chain"

	| ctxt callee |
	ctxt _ self.
	[ctxt == aContext] whileFalse: [
		callee _ ctxt.
		ctxt _ ctxt sender.
		ctxt ifNil: [aContext ifNotNil: [self error: 'aContext not a sender']].
	].
	callee privSender: nil.
! !

!Context methodsFor: 'private' stamp: 'SH 10/13/2016 20:48:36'!
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
		"Context>>closureCopy:copiedValues:; simulated to get startpc right"
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

!Context methodsFor: 'private' stamp: 'ajh 7/21/2003 09:59'!
insertSender: aContext
	"Insert aContext and its sender chain between me and my sender.  Return new callee of my original sender."

	| ctxt |
	ctxt _ aContext bottomContext.
	ctxt privSender: self sender.
	self privSender: aContext.
	^ ctxt! !

!Context methodsFor: 'private' stamp: 'di 1/14/1999 22:30'!
instVarAt: index put: value
	index = 3 ifTrue: [self stackp: value. ^ value].
	^ super instVarAt: index put: value! !

!Context methodsFor: 'private' stamp: 'jmv 8/16/2016 20:31:42'!
isPrimFailToken: anObject
	^(self objectClass: anObject) == Array
	  and: [anObject size = 2
	  and: [anObject first == self class primitiveFailToken]]! !

!Context methodsFor: 'private' stamp: 'ajh 1/23/2003 22:35'!
privSender: aContext 

	sender _ aContext! !

!Context methodsFor: 'private' stamp: 'di 1/11/1999 10:12'!
push: numObjects fromIndexable: anIndexableCollection
	"Push the elements of anIndexableCollection onto the receiver's stack.
	 Do not call directly.  Called indirectly by {1. 2. 3} constructs."

	1 to: numObjects do:
		[:i | self push: (anIndexableCollection at: i)]! !

!Context methodsFor: 'private' stamp: 'eem 7/22/2008 11:59'!
setSender: s receiver: r method: m arguments: args 
	"Create the receiver's initial state."

	sender := s.
	receiver := r.
	method := m.
	closureOrNil := nil.
	pc := method initialPC.
	self stackp: method numTemps.
	1 to: args size do: [:i | self at: i put: (args at: i)]! !

!Context methodsFor: 'private' stamp: 'eem 7/22/2008 12:00'!
setSender: s receiver: r method: m closure: c startpc: startpc
	"Create the receiver's initial state."

	sender := s.
	receiver := r.
	method := m.
	closureOrNil := c.
	pc := startpc.
	stackp := 0! !

!Context methodsFor: 'private'!
stackPtr  "For use only by the SystemTracer"
	^ stackp! !

!Context methodsFor: 'private' stamp: 'di 10/23/1999 17:31'!
stackp: newStackp
	"Storing into the stack pointer is a potentially dangerous thing.
	This primitive stores nil into any cells that become accessible as a result,
	and it performs the entire operation atomically."
	"Once this primitive is implemented, failure code should cause an error"

	<primitive: 76>
	self error: 'stackp store failure'.
"
	stackp == nil ifTrue: [stackp _ 0].
	newStackp > stackp  'effectively checks that it is a number'
		ifTrue: [oldStackp _ stackp.
				stackp _ newStackp.
				'Nil any newly accessible cells'
				oldStackp + 1 to: stackp do: [:i | self at: i put: nil]]
		ifFalse: [stackp _ newStackp]
"! !

!Context methodsFor: 'private' stamp: 'eem 7/22/2008 12:00'!
startpc
	^closureOrNil
		ifNil:	[self method initialPC]
		ifNotNil: [closureOrNil startpc]! !

!Context methodsFor: 'private' stamp: 'eem 8/11/2014 13:05'!
tryNamedPrimitiveIn: aCompiledMethod for: aReceiver withArgs: arguments
	"Invoke the named primitive for aCompiledMethod, answering its result, or,
	 if the primiitve fails, answering the error code."
	<primitive: 218 error: ec>
	ec ifNotNil:
		["If ec is an integer other than -1 there was a problem with primitive 218,
		  not with the external primitive itself.  -1 indicates a generic failure (where
		  ec should be nil) but ec = nil means primitive 218 is not implemented.  So
		  interpret -1 to mean the external primitive failed with a nil error code."
		 ec isInteger ifTrue:
			[ec = -1
				ifTrue: [ec := nil]
				ifFalse: [self primitiveFailed]]].
	^self class primitiveFailTokenFor: ec! !

!Context methodsFor: 'private-exceptions' stamp: 'SqR 8/28/2014 23:08'!
canHandleSignal: exception
	"Sent to handler (on:do:) contexts only.  If my exception class (first arg) handles exception then return true, otherwise forward this message to the next handler context.  If none left, return false (see nil>>canHandleSignal:)"

	^ (self exceptionClass handles: exception)
		or: [ self nextHandlerContext canHandleSignal: exception ].! !

!Context methodsFor: 'private-exceptions' stamp: 'SqR 11/15/2015 08:45'!
evaluateSignal: exception
	"The following primitive is just a marker used to find the evaluation context. 
	See MethodContext>>#isHandlerOrSignalingContext. "

	<primitive: 199>
	| value |
	exception pushHandlerContext: self contextTag.
	value := self exceptionHandlerBlock valueWithPossibleArgument: exception.	
	"return from self if not otherwise directed in handle block"
	self return: value! !

!Context methodsFor: 'private-exceptions' stamp: 'SqR 8/28/2014 22:55'!
exceptionClass

	^self tempAt: 1! !

!Context methodsFor: 'private-exceptions' stamp: 'SqR 8/28/2014 22:58'!
exceptionHandlerBlock
	"handler context only. access temporaries from BlockClosure>>#on:do:"

	^self tempAt: 2! !

!Context methodsFor: 'private-exceptions' stamp: 'SqR 11/15/2015 08:58'!
findNextHandlerContext
	"Return the next handler marked context, returning nil if there is none.  Search starts
	with self and proceeds up to nil.  If context isn't a handler context, it must be a signaling
	context.  When we reach a signaling context we must skip over any handlers that might
	be on the stack between the signaling context and the handler context for that signal."

	| context searchStartContext |
	context := self findNextHandlerOrSignalingContext.
	context isNil ifTrue: [^nil].
	context isHandlerContext ifTrue: [^context]. 
	searchStartContext := context exceptionClass topHandlerContext ifNil: [context].
	^searchStartContext nextHandlerContext! !

!Context methodsFor: 'private-exceptions' stamp: 'SqR 8/28/2014 22:59'!
findNextHandlerOrSignalingContext
	"Return the next handler/signaling marked context, answering nil if there is none. 
	Search starts with self and proceeds up to nil."

	<primitive: 197>
	| context |
	context := self.
	[ 
	context isHandlerOrSignalingContext
		ifTrue: [ ^ context ].
	(context := context sender) == nil ] whileFalse.
	^ nil! !

!Context methodsFor: 'private-exceptions' stamp: 'TPR 8/23/2000 16:37'!
findNextUnwindContextUpTo: aContext
	"Return the next unwind marked above the receiver, returning nil if there is none.  Search proceeds up to but not including aContext."

	| ctx |
	<primitive: 195>
	ctx _ self.
		[(ctx _ ctx sender) == nil or: [ctx == aContext]] whileFalse:
		[ ctx isUnwindContext ifTrue: [^ctx]].
	^nil! !

!Context methodsFor: 'private-exceptions' stamp: 'SqR 8/28/2014 23:07'!
handleSignal: exception
	"Sent to handler (on:do:) contexts only.  If my exception class (first arg) handles exception then execute my handle block (second arg), otherwise forward this message to the next handler context.  If none left, execute exception's defaultAction (see nil>>handleSignal:)."

	(self exceptionClass handles: exception)
		ifFalse: [ ^ self nextHandlerContext handleSignal: exception ].
	self evaluateSignal: exception! !

!Context methodsFor: 'private-exceptions' stamp: 'SqR 8/28/2014 23:02'!
isHandlerContext
	"is this context for #on:do:?"
	^self isHandlerOrSignalingContext and: [ self selector == #on:do: ]! !

!Context methodsFor: 'private-exceptions' stamp: 'SqR 8/28/2014 23:00'!
isHandlerOrSignalingContext
	"Both BlockClosure>>on:do: (handler) and ContextPart>>evaluateSignal: (signaling) 
	are marked with primitive 199."

	^method primitive = 199! !

!Context methodsFor: 'private-exceptions' stamp: 'tpr 2/24/2001 22:05'!
isUnwindContext
"is this context for  method that is marked?"
	^method primitive = 198! !

!Context methodsFor: 'private-exceptions' stamp: 'jmv 5/26/2015 10:43'!
nextHandlerContext

	^ self sender ifNotNil: [ :sndr | sndr findNextHandlerContext ]! !

!Context methodsFor: 'private-exceptions' stamp: 'tfei 3/23/1999 13:00'!
receiver: r

	receiver := r! !

!Context methodsFor: 'private-exceptions' stamp: 'ar 6/28/2003 00:10'!
restartWithNewReceiver: obj

	self
		swapReceiver: obj;
		restart! !

!Context methodsFor: 'private-exceptions' stamp: 'ajh 10/8/2001 23:56'!
swapReceiver: r

	receiver := r! !

!Context methodsFor: 'private-exceptions' stamp: 'ar 3/4/2009 14:59'!
unwindTo: aContext

	| ctx unwindBlock |
	ctx := self.
	[(ctx := ctx findNextUnwindContextUpTo: aContext) isNil] whileFalse: [
		(ctx tempAt: 2) ifNil:[
			ctx tempAt: 2 put: true.
			unwindBlock := ctx tempAt: 1.
			unwindBlock value]
	].
! !


!Context reorganize!
('accessing' activeHome activeOuterContext at: at:put: basicAt: basicAt:put: basicSize client closure contextForLocalVariables hasMethodReturn home isExecutingBlock method methodNode methodReturnContext outerContext receiver removeSelf size tempAt: tempAt:put:)
('closure support' asContext contextTag)
('controlling' closureCopy:copiedValues: hasSender: jump pop push: quickSend:to:with:super: restart resume resume: resume:through: resumeEvaluating: return return: return:through: return:to: runUntilErrorOrReturnFrom: send:to:with:lookupIn: send:to:with:super: terminate terminateTo: top)
('debugger access' contextStack depthBelow: errorReportOn: longStack methodClass namedTempAt: namedTempAt:put: print:on: releaseTo: selector sender shortStack singleRelease sourceCode stack stackOfSize: swapSender: tempNames tempsAndValues tempsAndValuesLimitedTo:indent:)
('initialization' privRefresh privRefreshWith:)
('inspecting' inspectorClass)
('instruction decoding' doDup doPop jump: jump:if: methodReturnConstant: methodReturnReceiver methodReturnTop popIntoLiteralVariable: popIntoReceiverVariable: popIntoRemoteTemp:inVectorAt: popIntoTemporaryVariable: pushActiveContext pushClosureCopyNumCopiedValues:numArgs:blockSize: pushConstant: pushLiteralVariable: pushNewArrayOfSize: pushReceiver pushReceiverVariable: pushRemoteTemp:inVectorAt: pushTemporaryVariable: return:from: send:super:numArgs: storeIntoLiteralVariable: storeIntoReceiverVariable: storeIntoRemoteTemp:inVectorAt: storeIntoTemporaryVariable:)
('instruction decoding (closures)' blockReturnTop pushConsArrayWithElements:)
('mirror primitives' object:basicAt: object:basicAt:put: object:eqeq: object:instVarAt: object:instVarAt:put: object:perform:withArguments:inClass: objectClass: objectSize:)
('objects from disk' storeDataOn:)
('printing' printDetails: printOn: printStack: printString)
('query' bottomContext copyStack copyTo: findContextSuchThat: findSecondToOldestSimilarSender findSimilarSender hasContext: isBottomContext isContext isDead secondFromBottom)
('system simulation' completeCallee: failPrimitiveWith: pushArgs:from: quickStep runSimulated:contextAtEachStep: step stepToCallee stepToSendOrReturn)
('testing' atEnd)
('private' aboutToReturn:through: cannotReturn: cannotReturn:to: cut: doPrimitive:method:receiver:args: insertSender: instVarAt:put: isPrimFailToken: privSender: push:fromIndexable: setSender:receiver:method:arguments: setSender:receiver:method:closure:startpc: stackPtr stackp: startpc tryNamedPrimitiveIn:for:withArgs:)
('private-exceptions' canHandleSignal: evaluateSignal: exceptionClass exceptionHandlerBlock findNextHandlerContext findNextHandlerOrSignalingContext findNextUnwindContextUpTo: handleSignal: isHandlerContext isHandlerOrSignalingContext isUnwindContext nextHandlerContext receiver: restartWithNewReceiver: swapReceiver: unwindTo:)
!

