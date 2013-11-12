'From Squeak3.7 of ''4 September 2004'' [latest update: #5989] on 16 April 2008 at 4:23:49 am'!
	"Change the position of this morph and and all of its submorphs."

	| delta box |
	delta _ aPoint - "bounds topLeft"self position.
	(delta x = 0 and: [delta y = 0]) ifTrue: [^ self].  "Null change"
	box _ self fullBounds.
	(delta dotProduct: delta) > 100 ifTrue:[
		"e.g., more than 10 pixels moved"
		self invalidRect: box.
		self invalidRect: (box translateBy: delta).
	] ifFalse:[
		self invalidRect: (box merge: (box translateBy: delta)).
	].
	owner ifNotNil:[owner layoutChanged].! !