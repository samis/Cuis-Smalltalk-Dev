'From Cuis 4.2 of 25 July 2013 [latest update: #2958] on 16 October 2016 at 3:41:05 am'!

!Context commentStamp: 'SH 10/16/2016 03:39:12' prior: 0!
To the instruction parsing ability of InstructionStream I add the actual semantics for execution. The execution state is stored in my indexable fields. This includes temporary variables and a stack of values used in evaluating expressions. The actual semantics of execution can be found in my category "system simulation" and "instruction decode". These methods exactly parallel the operation of the Smalltalk machine itself.
	
My instances hold all the dynamic state associated with the execution of either a method activation resulting from a message send or a block activation resulting from a block evaluation.  This includes the receiver (self), the closure for a BlockClosure activation (which is nil for a method activation), a CompiledMethod, and space in the variable part of the context for arguments and temporary variables.
	
Contexts, though normal in their variable size, are actually only used in two sizes, small and large, which are determined by the temporary space required by the method being executed.

Contexts must only be created using the method newForMethod:.  Note that it is impossible to determine the real object size of a Context except by asking for the frameSize of its method.  Any fields above the stack pointer (stackp) are truly invisible -- even (and especially!!) to the garbage collector.  Any store into stackp other than by the primitive method stackp: is potentially fatal.

The simulator is a group of my methods that do what the Smalltalk interpreter does: execute Smalltalk bytecodes. By adding code to the simulator, you may take statistics on the running of Smalltalk methods. For example,
	Transcript show: (Context runSimulated: [3 factorial]) printString.!


!Debugger class methodsFor: 'instance creation' stamp: 'SH 10/16/2016 03:31:20'!
informExistingDebugger: aContext label: aString
	"Walking the context chain, we try to find out if we're in a debugger stepping situation.
	If we find the relevant contexts, we must rearrange them so they look just like they would
	if the methods were excuted outside of the debugger."
	| ctx quickStepMethod oldSender baseContext |
	ctx _ thisContext.
	quickStepMethod _ Context compiledMethodAt: #quickSend:to:with:super:.
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


!Context class methodsFor: 'cached class state' stamp: 'SH 10/16/2016 03:40:06'!
releaseClassCachedState
	PrimitiveFailToken _ nil.
	QuickStep _ nil.
	ValueIndex _ nil. ! !

!Context class methodsFor: 'private' stamp: 'SH 10/16/2016 03:31:59'!
theReturnMethod

	| meth |
	meth _ Context lookupSelector: #return:.
	meth primitive = 0 ifFalse: [^ self error: 'expected #return: to not be a primitive'].
	^ meth! !

!Context class methodsFor: 'enumerating' stamp: 'SH 10/16/2016 03:33:20'!
allInstances
	"Answer all instances of the receiver."
	<primitive: 177>
	"The primitive can fail because memory is low.  If so, fall back on the old
	 enumeration code, which gives the system a chance to GC and/or grow.
	 Because aBlock might change the class of inst (for example, using become:),
	 it is essential to compute next before aBlock value: inst.
	 Only count until thisContext since this context has been created only to
	 compute the existing instances."
	| inst insts next |
	insts := WriteStream on: (Array new: 64).
	inst := self someInstance.
	[inst == thisContext or: [inst == nil]] whileFalse:
		[next := inst nextInstance.
		 insts nextPut: inst.
		 inst := next].
	^insts contents! !

!Context class methodsFor: 'enumerating' stamp: 'SH 10/16/2016 03:33:35'!
allInstancesDo: aBlock
	"Evaluate aBlock with each of the current instances of the receiver."
	| instances inst next |
	instances _ self allInstancesOrNil.
	instances ifNotNil: [
		instances do: aBlock.
		^self].
	"allInstancesOrNil can fail because memory is low.  If so, fall back on the old
	 enumeration code.  Because aBlock might change the class of inst (for example,
	 using become:), it is essential to compute next before aBlock value: inst.
	 Only count until thisContext since evaluation of aBlock will create new contexts."
	inst _ self someInstance.
	[inst == thisContext or: [inst == nil]] whileFalse: [
		next _ inst nextInstance.
		aBlock value: inst.
		inst _ next ]! !

