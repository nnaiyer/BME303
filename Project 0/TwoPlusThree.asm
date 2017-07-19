; This is a simple program to demonstrate four things:
; 1. What is an assembler
; 2. What are pseudo-ops
; 3. What is an assembly program
; 4. What does running a program mean
	.ORIG x3000	; Psuedo-op tells assembler where to place the program
	AND R0,R0,#0	; Clear R0
	ADD R1,R0,#2	; R1 has 2
	ADD R2,R0,#3	; R2 has 3
	ADD R3,R1,R2	; R3 has 2+3=5
	TRAP x25	; Tells the computer to halt (MUST be the last line of your code - Instructions)
	.END		; Pseudo-op tells assembler where the end of the program is