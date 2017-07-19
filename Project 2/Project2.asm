; Programming Assignment 2
; Student Name: Nabeel Naiyer
; UT Eid: nn5363
; Statistics for a Course Exam
; There are 15 student scores stored at x3100 to x310E 
; Tasks need to be performed on the records (Not necessarily in this order):
;  a. Find the range, defined as the Max score - Min Score and write it to x310F 
;  b. Find class Median and write at x3110
;  c. Sort the records(in place) so the highest scoring student's record is the first    
	.ORIG x3000
	AND	R0, R0, #0	; Clear Registers 0-7
	AND	R1, R1, #0
	AND	R2, R2, #0
	AND	R3, R3, #0
	AND	R4, R4, #0
	AND	R5, R5, #0
	AND	R6, R6, #0
	AND	R7, R7, #0	; Line: x3007
	ADD	R0, R0, #15	; R0 holds exterior loop
EXT	AND	R1, R1, #0
	ADD	R1, R0, #-1	; Line: x300A --- R1 holds interior loop
	LD	R7, ARRAY
	ADD	R0, R0, #-1
	BRz	DONE
INT	LDR	R2, R7, x00	; R2 holds array value R7 with offset x00
	LDR	R3, R7, x01	; R3 holds array value R7 with offset x01
	ADD	R4, R3, #0	; Lines x3010 -- x3012 make R4 negative (R4=-R3)
	NOT	R4, R4		; ^	
	ADD	R4, R4, #1	; ^^
	ADD	R5, R2, R4	; R2 - R4
	BRp	SWAP
	ADD	R7, R7, #1
	ADD	R1, R1, #-1
	BRp	INT
	BRz	EXT
SWAP	LDR	R6, R7, x00	; Line x3019
	LDR	R5, R7, x01
	STR	R6, R7, x01
	STR	R5, R7, x00
	ADD	R7, R7, x01
	ADD	R1, R1, #-1
	BRz	EXT		; Line x301F
	BRp	INT
DONE				; Line x3021
	LDR	R2, R7, x0E	; Load last value of ARRAY into R2
	LDR	R6, R7, x00	; Load first value of ARRAY into R6
	ADD	R3, R6, #0	; Lines x3024 -- x3026 make R3 negative (R3=-R6)
	NOT	R3, R3		; ^
	ADD	R3, R3, #1	; ^^
	ADD	R5, R2, R3	; R2 - R3
	ST	R5, xE7		; Store R5 into memory location x310F
	LDR	R4, R7, x07	; Load x3107 value of ARRAY into R4
	ADD	R4, R4, #0	
	ST	R4, xE5		; Store R4 into memory location x3110
	TRAP x25
ARRAY	.FILL x3100
	.END

	 
	
