	.ORIG	x0100


	LDI	R0, KBDR
	LD	R1, CapA
	ADD	R1, R0, R1
	BRz	Solid
	LD	R1, CapC
	ADD	R1, R0, R1
	BRz	Solid
	LD	R1, CapG
	ADD	R1, R0, R1
	BRz	Solid
	LD	R1, CapT
	ADD	R1, R0, R1
	BRz	Solid
	BRnzp	Liquid

Solid	STI	R0, Get	
Liquid	RTI
	HALT



CapA	.FILL	x-41
CapC	.FILL	x-43
CapG	.FILL	x-47
CapT	.FILL	x-54
Get	.FILL	x4100
KBDR	.FILL	xFE02
DDR	.FILL	xFE06


	.END