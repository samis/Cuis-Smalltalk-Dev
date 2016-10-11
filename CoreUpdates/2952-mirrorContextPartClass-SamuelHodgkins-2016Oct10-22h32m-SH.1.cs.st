'From Cuis 4.2 of 25 July 2013 [latest update: #2950] on 11 October 2016 at 11:51:30 pm'!

!Context class methodsFor: 'cached class state' stamp: 'SH 10/10/2016 22:52:38'!
primitiveFailToken
	"A unique object to be returned when a primitive fails during simulation"
	^ ContextPart primitiveFailToken! !

!Context class methodsFor: 'cached class state' stamp: 'SH 10/10/2016 22:53:22'!
primitiveFailTokenFor: errorCode
	"A unique object to be returned when a primitive fails during simulation"
	^ ContextPart primitiveFailTokenFor: errorCode.! !

!Context class methodsFor: 'cached class state' stamp: 'SH 10/10/2016 22:55:08'!
releaseClassCachedState
	ContextPart releaseClassCachedState.! !

!Context class methodsFor: 'cached class state' stamp: 'SH 10/11/2016 23:50:22'!
valueIndex
^ ContextPart valueIndex! !

!Context class methodsFor: 'instance creation' stamp: 'SH 10/10/2016 22:40:25'!
basicNew: size
ContextPart basicNew: size! !

!Context class methodsFor: 'instance creation' stamp: 'SH 10/10/2016 22:47:02'!
initializedInstance
^ nil! !

!Context class methodsFor: 'instance creation' stamp: 'SH 10/10/2016 22:48:52'!
new
ContextPart new! !

!Context class methodsFor: 'instance creation' stamp: 'SH 10/10/2016 22:49:36'!
new: size
	ContextPart new: size.! !

!Context class methodsFor: 'instance creation' stamp: 'SH 10/10/2016 22:51:18'!
newForMethod: aMethod
	"This is the only method for creating new contexts, other than primitive cloning.
	Any other attempts, such as inherited methods like shallowCopy, should be
	avoided or must at least be rewritten to determine the proper size from the
	method being activated.  This is because asking a context its size (even basicSize!!)
	will not return the real object size but only the number of fields currently
	accessible, as determined by stackp."

	^ ContextPart newForMethod: aMethod.! !

!Context class methodsFor: 'special context creation' stamp: 'SH 10/10/2016 22:44:20'!
contextEnsure: block
	"Create an #ensure: context that is ready to return from executing its receiver"
	^ ContextPart contextEnsure: block! !

!Context class methodsFor: 'special context creation' stamp: 'SH 10/10/2016 22:45:57'!
contextOn: exceptionClass do: block
	"Create an #on:do: context that is ready to return from executing its receiver"

	^ ContextPart contextOn: exceptionClass do: block! !

!Context class methodsFor: 'private' stamp: 'SH 10/10/2016 22:42:00'!
carefullyPrint: anObject on: aStream
ContextPart carefullyPrint: anObject on: aStream.! !

!Context class methodsFor: 'private' stamp: 'SH 10/10/2016 22:47:55'!
isContextClass
^ true! !

!Context class methodsFor: 'examples' stamp: 'SH 10/11/2016 23:31:33'!
tallyInstructions: aBlock
	"This method uses the simulator to count the number of occurrences of
	each of the Smalltalk instructions executed during evaluation of aBlock.
	Results appear in order of the byteCode set."
	^ ContextPart tallyInstructions: aBlock
	" Context tallyInstructions: [3.14159 printString]"! !

!Context class methodsFor: 'examples' stamp: 'SH 10/11/2016 23:44:18'!
tallyMethods: aBlock
	"This method uses the simulator to count the number of calls on each method
	invoked in evaluating aBlock. Results are given in order of decreasing counts."
	^ ContextPart tallyMethods: aBlock
	"Context tallyMethods: [3.14159 printString]"! !

!Context class methodsFor: 'examples' stamp: 'SH 10/11/2016 23:45:39'!
trace: aBlock
	"This method uses the simulator to print calls and returned values in the Transcript."
	^ ContextPart trace: aBlock
	"Context trace: [3 factorial]"! !

!Context class methodsFor: 'examples' stamp: 'SH 10/11/2016 23:48:11'!
trace: aBlock on: aStream
	"This method uses the simulator to print calls and returned values to a file."
	^ ContextPart trace: aBlock on: aStream
	"Context trace: [3 factorial]"! !

!Context class methodsFor: 'examples' stamp: 'SH 10/11/2016 23:49:08'!
trace: aBlock onFileNamed: fileName
	"This method uses the simulator to print calls and returned values to a file."
	^ ContextPart trace: aBlock onFileNamed: fileName
	"Context trace: [3 factorial] onFileNamed: 'trace'"! !

!Context class methodsFor: 'simulation' stamp: 'SH 10/10/2016 22:57:21'!
runSimulated: aBlock
	"Simulate the execution of the argument, current. Answer the result it 
	returns."
	^ ContextPart runSimulated: aBlock.
	"Context runSimulated: [Pen new defaultNib: 5; go: 100]"! !


!Context class reorganize!
('cached class state' primitiveFailToken primitiveFailTokenFor: releaseClassCachedState valueIndex)
('instance creation' basicNew: initializedInstance new new: newForMethod:)
('special context creation' contextEnsure: contextOn:do:)
('private' carefullyPrint:on: isContextClass)
('examples' tallyInstructions: tallyMethods: trace: trace:on: trace:onFileNamed:)
('simulation' runSimulated:)
!

