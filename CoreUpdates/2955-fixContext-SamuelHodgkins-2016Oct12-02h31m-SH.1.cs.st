'From Cuis 4.2 of 25 July 2013 [latest update: #2954] on 12 October 2016 at 2:37:01 am'!

!Context class methodsFor: 'instance creation' stamp: 'SH 10/12/2016 02:35:21'!
newForMethod: aMethod
	"This is the only method for creating new contexts, other than primitive cloning.
	Any other attempts, such as inherited methods like shallowCopy, should be
	avoided or must at least be rewritten to determine the proper size from the
	method being activated.  This is because asking a context its size (even basicSize!!)
	will not return the real object size but only the number of fields currently
	accessible, as determined by stackp."

	^ MethodContext newForMethod: aMethod.! !

