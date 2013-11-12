'From Squeak3.7 of ''4 September 2004'' [latest update: #5989] on 7 May 2008 at 12:48:54 am'!
	"Add standard halo items to the menu"

	| unlockables |

	self isWorldMorph ifTrue:
		[^ self addWorldHaloMenuItemsTo: aMenu hand: aHandMorph].

	aMenu add: 'send to back' translated action: #goBehind.

	self addFillStyleMenuItems: aMenu hand: aHandMorph.
	self addBorderStyleMenuItems: aMenu hand: aHandMorph.
	self addLayoutMenuItems: aMenu hand: aHandMorph.
	self addHaloActionsTo: aMenu.
	owner isTextMorph ifTrue:[self addTextAnchorMenuItems: aMenu hand: aHandMorph].
	aMenu addLine.
	self addToggleItemsToHaloMenu: aMenu.
	aMenu addLine.
	self addCopyItemsTo: aMenu.
	self addExportMenuItems: aMenu hand: aHandMorph.
	Preferences noviceMode ifFalse:
		[self addDebuggingItemsTo: aMenu hand: aHandMorph].

	aMenu addLine.
	aMenu defaultTarget: self.

	aMenu addLine.

	unlockables _ self submorphs select:
		[:m | m isLocked].
	unlockables size == 1 ifTrue:
		[aMenu
			add: ('unlock "{1}"' translated format: unlockables first externalName)
			action: #unlockContents].
	unlockables size > 1 ifTrue:
		[aMenu add: 'unlock all contents' translated action: #unlockContents.
		aMenu add: 'unlock...' translated action: #unlockOneSubpart].

	aMenu defaultTarget: aHandMorph.
! !