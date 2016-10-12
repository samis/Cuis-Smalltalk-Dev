'From Cuis 4.2 of 25 July 2013 [latest update: #2950] on 12 October 2016 at 1:19:44 am'!

!ProtoObject methodsFor: 'apply primitives' stamp: 'SH 10/12/2016 00:22:02'!
tryPrimitive: primIndex withArgs: argumentArray
	"This method is a template that the Smalltalk simulator uses to 
	execute primitives. See Object documentation whatIsAPrimitive."

	<primitive: 118 error: errorCode>
	^Context primitiveFailTokenFor: errorCode! !


!Debugger class methodsFor: 'instance creation' stamp: 'SH 10/12/2016 00:50:38'!
informExistingDebugger: aContext label: aString
	"Walking the context chain, we try to find out if we're in a debugger stepping situation.
	If we find the relevant contexts, we must rearrange them so they look just like they would
	if the methods were excuted outside of the debugger."
	| ctx quickStepMethod oldSender baseContext |
	ctx _ thisContext.
	quickStepMethod _ ContextPart compiledMethodAt: #quickSend:to:with:super:.
	[
	ctx sender == nil or: [ ctx sender method == quickStepMethod ]] whileFalse: [ ctx _ ctx sender ].
	ctx sender ifNil: [ ^ self ].
	baseContext _ ctx.
	"baseContext is now the context created by the #quickSend... method."
	oldSender _ ctx _ ctx sender home sender.
	"oldSender is the context which originally sent the #quickSend... method"
	[
	ctx == nil or: [ ctx receiver isKindOf: self ]] whileFalse: [ ctx _ ctx sender ].
	ctx == nil ifTrue: [ ^ self ].
	"ctx is the context of the Debugger method #doStep"
	ctx receiver labelString: aString.
	ctx receiver
		externalInterrupt: false;
		proceedValue: aContext receiver.
	baseContext swapSender: baseContext sender sender sender.
	"remove intervening contexts"
	thisContext swapSender: oldSender.
	"make myself return to debugger"
	ErrorRecursion _ false.
	^ aContext.! !


!BlockClosure methodsFor: 'system simulation' stamp: 'SH 10/12/2016 00:19:37'!
simulateValueWithArguments: anArray caller: aContext
	"Simulate the valueWithArguments: primitive. Fail if anArray is not an array of the right arity."
	| newContext sz |
	newContext _ (MethodContext newForMethod: outerContext method)
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


!Context class methodsFor: 'cached class state' stamp: 'SH 10/12/2016 01:15:59'!
primitiveFailToken
	"A unique object to be returned when a primitive fails during simulation"
	PrimitiveFailToken ifNil: [ PrimitiveFailToken _ Object new ].
	^ PrimitiveFailToken! !

!Context class methodsFor: 'instance creation' stamp: 'SH 10/12/2016 00:54:25'!
basicNew: size
	self error: 'Contexts must only be created with newForMethod:'! !

!Context class methodsFor: 'instance creation' stamp: 'SH 10/12/2016 00:55:30'!
new
	self error: 'Contexts must only be created with newForMethod:'! !

!Context class methodsFor: 'instance creation' stamp: 'SH 10/12/2016 00:56:41'!
new: size
	self error: 'Contexts must only be created with newForMethod:'! !

!Context class methodsFor: 'examples' stamp: 'SH 10/12/2016 01:08:48'!
tallyInstructions: aBlock
	"This method uses the simulator to count the number of occurrences of
	each of the Smalltalk instructions executed during evaluation of aBlock.
	Results appear in order of the byteCode set."
	| tallies |
	tallies _ Bag new.
	thisContext sender
		runSimulated: aBlock
		contextAtEachStep:
			[:current | tallies add: current nextByte].
	^tallies sortedElements
	" Context tallyInstructions: [3.14159 printString]"! !

!Context class methodsFor: 'examples' stamp: 'SH 10/12/2016 01:10:39'!
tallyMethods: aBlock
	"This method uses the simulator to count the number of calls on each method
	invoked in evaluating aBlock. Results are given in order of decreasing counts."
	| prev tallies |
	tallies _ Bag new.
	prev _ aBlock.
	thisContext sender
		runSimulated: aBlock
		contextAtEachStep:
			[:current |
			current == prev ifFalse: [ "call or return"
				prev sender ifNotNil: [ "call only"
					tallies add: current printString].
				prev _ current]].
	^tallies sortedCounts
	"Context tallyMethods: [3.14159 printString]"! !

!Context class methodsFor: 'examples' stamp: 'SH 10/12/2016 01:11:37'!
trace: aBlock
	"This method uses the simulator to print calls and returned values in the Transcript."
	Transcript clear.
	^ self trace: aBlock on: Transcript
	"Context trace: [3 factorial]"! !

!Context class methodsFor: 'examples' stamp: 'SH 10/12/2016 01:12:21'!
trace: aBlock on: aStream
	"This method uses the simulator to print calls and returned values to a file."
	| prev |
	prev _ aBlock.
	^ thisContext sender
		runSimulated: aBlock
		contextAtEachStep: [ :current |
			Sensor isAnyButtonPressed ifTrue: [^ nil].
			current == prev
				ifFalse: [
					prev sender ifNil: [
						aStream space; nextPut: $^.
						self carefullyPrint: current top on: aStream].
					aStream newLine.
					(current depthBelow: aBlock) timesRepeat: [aStream space].
					self carefullyPrint: current receiver on: aStream.
					aStream space; nextPutAll: current selector.
					prev _ current]]
	"Context trace: [3 factorial]"! !

!Context class methodsFor: 'examples' stamp: 'SH 10/12/2016 01:13:47'!
trace: aBlock onFileNamed: fileName
	"This method uses the simulator to print calls and returned values to a file."
	fileName asFileEntry forceWriteStreamDo: [ :stream |
	self trace: aBlock on: stream ]
	"Context trace: [3 factorial] onFileNamed: 'trace'"! !

!Context class methodsFor: 'simulation' stamp: 'SH 10/12/2016 01:06:42'!
primitiveFailTokenFor: errorCode
	"A unique object to be returned when a primitive fails during simulation"
	^ {self primitiveFailToken. errorCode}! !

!Context class methodsFor: 'simulation' stamp: 'SH 10/12/2016 01:01:47'!
runSimulated: aBlock
	"Simulate the execution of the argument, current. Answer the result it 
	returns."
	^ thisContext sender
		runSimulated: aBlock
		contextAtEachStep: [ :ignored |].
	"Context runSimulated: [Pen new defaultNib: 5; go: 100]"! !

!methodRemoval: Utilities class #initializeClosures!
Utilities class removeSelector: #initializeClosures!

!Context class reorganize!
('cached class state' primitiveFailToken releaseClassCachedState valueIndex)
('instance creation' basicNew: initializedInstance new new: newForMethod: sender:receiver:method:arguments:)
('special context creation' contextEnsure: contextOn:do:)
('private' carefullyPrint:on: isContextClass)
('examples' tallyInstructions: tallyMethods: trace: trace:on: trace:onFileNamed:)
('enumerating' allInstances allInstancesDo:)
('simulation' primitiveFailTokenFor: runSimulated:)
!

