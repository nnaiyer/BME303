;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 	description: 	Stop Codon				;
;			BME 303 - Spring 2015			;
;			Programming Assignment #5 		;
; 								;
;	file:		Bio				        ;
;	author:		Ramesh Yerraballi 			;
;	date:		05/03/2015				;
;***************************************************************;
; Student Name/ID:	Nabeel Naiyer/nn5363			;			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

	.ORIG	x3000
	AND	R3, R3, #0
	STI	R3, Typed
	LD	R1, KBIEN
	STI	R1, KBSR
	LD	R1, KBISR
	STI	R1, KBIVE
	LD	R6, SBase
Alpha	LDI	R0, Typed
	BRz	Alpha
	LD	R1, CapT
	ADD	R1, R0, R1
	BRz	PostT
	OUT
	


	LD R1, COUNT
DELAY   ADD	R1, R1, #-1
        BRp 	DELAY
	LDI	R0, Typed
	AND	R0, R0, #0
	STI	R0, Typed
	BRnzp	Alpha	



PostT	OUT
	LD	R1, COUNT
DelayA	ADD	R1, R1, #-1
	BRp	DelayA
	LDI	R0, Typed
	AND	R0, R0, #0
	STI	R0, Typed
	JSR	READ
	LD	R1, CapA
	ADD	R1, R0, R1
	BRz	PostTA
	LD	R1, CapG
	ADD	R1, R0, R1
	BRz	PostTG
	BRnzp	Alpha



PostTA	OUT
	LD	R1, COUNT
DelayTA	ADD	R1, R1, #-1
	BRp	DelayTA
	LDI	R0, Typed
	AND	R0, R0, #0
	STI	R0, Typed
	JSR	READ
	BRz	PostTA
	LD	R1, CapA
	ADD	R1, R0, R1
	BRz	Omega
	LD	R1, CapG
	ADD	R1, R0, R1
	BRz	Omega
	BRnzp	Alpha



PostTG	OUT
	LD	R1, COUNT
DelayTG	ADD	R1, R1, #-1
	BRp	DelayTG
	LDI	R0, Typed
	AND	R0, R0, #0
	STI	R0, Typed
	JSR	READ
	BRz	PostTG
	LD	R1, CapA
	ADD	R1, R1, R0
	BRz	Omega
	BRnzp	Alpha




READ	
	LDI	R0, Typed
	BRz	READ
	RET

Omega	OUT
	HALT



CapA	.FILL	x-41
CapC	.FILL	x-43
CapG	.FILL	x-47
CapT	.FILL	x-54
KBIEN	.FILL	x4000
KBSR	.FILL	xFE00
KBIVE	.FILL	x0180
KBISR	.FILL	x0100
SBase	.FILL	x3000
Typed	.FILL	x4100
COUNT	.FILL	#3000


	.END