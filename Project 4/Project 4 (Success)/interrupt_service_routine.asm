	.ORIG	x1500
	LDI	R0, KBDR
	LD	R5, qVal
	ADD	R5, R5, R0
	BRz	SetFlag
	
Alpha	AND	R1, R1, #0
	AND	R2, R2, #0
	ADD	R1, R1, #10
	ADD	R2, R2, #10
	AND	R5, R5, #0
	LD	R1, C1
	ADD	R5, R0, R1
	BRp	QUIT
	LD	R2, C2
	ADD	R2, R0, R2
	BRn	QUIT
	AND	R1, R1, #0
	AND	R2, R2, #0
	ADD	R1, R1, #10
	ADD	R2, R2, #10 
CAP	STI	R0, DDR
	ADD	R1, R1, #-1
	BRnp	CAP
	LD	R4, pos
	ADD	R0, R0, R4
LOW	STI	R0, DDR
	ADD	R2, R2, #-1
	BRnp	LOW
	LD	R0, ENT
	STI	R0, DDR
	BR	QUIT
SetFlag	AND	R5, R5, #0
	ADD	R5, R5, #-1
	STI	R5, Flag
	BR	QUIT

QUIT	
	RTI
Fin	HALT

KBDR	.FILL	XFE02
DDR	.FILL	XFE06
neg	.FILL	x-20
pos	.FILL	x20
ENT	.FILL	x0A
C1	.FILL	#-91
C2	.FILL	#-65
qVal	.FILL	#-113
Flag	.FILL	x4100

	.END