; Programming Project 1 starter file
; Student Name  : Nabeel Naiyer
; UTEid: nn5363
; Modify this code to satisfy the requirements of Project 1
; Read the Project Description on Canvas.
; This starter program takes a number M stored at
; x30F0 and leftrotates a constant number of times given in x30F1
; and puts the result in location x30F2
	.ORIG	x3000
	AND	R0, R0, #0	; Clearing Registers R0 - R4
	AND	R1, R1, #0
	AND	R2, R2, #0
	AND	R3, R3, #0
	AND	R4, R4, #0
	LEA	R2, xEB		; Loading Address (B)
	LDR	R3, R2, x00	; Loading Data (B)
	LEA	R0, xE8		; Loading Address (M)
	LDR	R1, R0, x00	; Loading Data (M)
	ADD	R3, R3, #0
	BRz	x0C		; PC -- x300B
	ADD	R1, R1, #0	; Loop Back Here
	BRp	x01
	BRn	x03
	ADD	R1, R1, R1	; R1 Holds Rotated 
	ADD	R1, R1, #0
	BRnzp	x03
	ADD	R1, R1, R1
	ADD	R1, R1, #1
	BRnzp 	x00
	ADD	R3, R3, #-1	; R3 Holds (B-1)
	BRp	#-13
	BRz	x00
	ST	R1, xDA		; Line -- x3018
	HALT
	.END