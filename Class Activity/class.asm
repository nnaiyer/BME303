	.ORIG	x3000
	LD	R0, N
	AND	R4, R4, #0	; Count of digits
Again	JSR	Div10
	ST	R0, QUOT
	ADD	R0, R1, #0
	JSR	PUSH
	ADD	R4, R4, #1
	LD	R0, QUOT
	BRp	Again
; Here means all digits have been pushed	
	LD	R2, ASCII
More	JSR	POP
	ADD	R0, R0, R2
	OUT
	ADD	R4, R4, #-1
	BRp	More

	HALT
N	.FILL	45
QUOT	.BLKW	1
ASCII	.FILL	x30
StkBase	.FILL	x3000
StkMin	.FILL	x2FFB


; Div10 returns in R0 the quotient from dividing R0 by 10
; R1 has the remainder

Div10
	AND	R1, R1, #0	; has remainder
	AND 	R2, R2, #0	; has quotient
DLoop	ADD	R3, R0, #-10
	BRn	DDone
	ADD	R2, R2, #1
	ADD	R0, R0, #-10
	BRnzp	DLoop


DDone	ADD	R1, R0, #0
	ADD	R0, R2, #0	; quotient must be in R0
	RET
	
;  This algorithm PUSHes on the stack the value stored in R0.
;  R5 is used to report success (R5=0) or failure (R5=1) of 
;  the PUSH operation.
;
PUSH           ST      R1,Save1      ; R1 is needed by this routine
               LEA     R1,StkMin
               NOT     R1,R1
               ADD     R1,R1,#1      ; R1 = - addr. of StackMax    
               ADD     R1,R1,R6      ; R6 = StackPointer
               BRz     Overflow      ; Full
               ADD     R6,R6,#-1     ; Adjust StackPointer for PUSH
               STR     R0,R6,#0      ; The actual PUSH
               BRnzp   Success_exit
Overflow       ST      R7,Save
               LEA     R0,OverflowMsg
               PUTS
               LD      R7,Save
               LD      R1, Save1     ; Restore R1
               AND     R5,R5,#0    
               ADD     R5,R5,#1      ; R5 <-- failure
               RET
Success_exit   LD      R1,Save1      ; Restore R1
               AND     R5,R5,#0      ; R5 <-- success
               RET
Save           .BLKW	1
Save1          .BLKW	1
OverflowMsg    .STRINGZ "Error: Stack is Full."

;  This algorithm POPs a value from the stack and puts it in
;  R0 before returning to the calling program.  R5 is used to
;  report success (R5=0) or failure (R5=1) of the POP operation.
POP            LEA     R0,StkBase
               NOT     R0,R0
               ADD     R0,R0,#1       ; R0 = -addr.ofStackBase 
               ADD     R0,R0,R6       ; R6 = StackPointer
               BRz     Underflow
               LDR     R0,R6,#0       ; The actual POP 
               ADD     R6,R6,#1      ; Adjust StackPointer
               AND     R5,R5,#0       ; R5 <-- success
               RET 
Underflow      ST      R7,SaveP        ; TRAP/RET needs R7
               LEA     R0,UnderflowMsg
               PUTS                   ; Print error message.
               LD      R7,SaveP        ; Restore R7
               AND     R5,R5,#0  
               ADD     R5,R5,#1       ; R5 <-- failure
               RET
SaveP           .FILL   x0000
UnderflowMsg   .FILL   x000A
               .STRINGZ "Error: Too Few Values on the Stack."


	.END