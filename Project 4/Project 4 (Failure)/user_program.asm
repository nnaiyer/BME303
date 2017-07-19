;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 	description: 	Texas Checkerboard			;
;			BME 303 - Spring 2015			;
;			Programming Assignment #4 		;
; 								;
;	file:		TEXAS				        ;
;	author:		Ramesh Yerraballi 			;
;	date:		3/25/2015				;
;***************************************************************;
; Student Name/ID:	Nabeel Naiyer/nn5363			;
; 			Alec Powell/ajp2959			;
;			Fatema Nagib/fn2399			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.ORIG	x3000
	LD	R0, KBIEN
	STI	R0, KBSR
	LD	R0, KBISR
	STI	R0, KBIVE
	LD	R6, SBase	


Loop	ST	R7, SaveR7
	LDI	R5, Flag
	BRp	OMEGA
	LEA	R0, L1
	PUTS
	LD	R0, Enter
	OUT
	JSR	DELAY
	LEA	R0, L2
	PUTS
	LD	R0, Enter
	OUT
	JSR	DELAY
	LD	R7, SaveR7
	BR	Loop


OMEGA	LD	R7, SaveR7
	HALT	
	



L1	.STRINGZ	"Texas       Texas       Texas       Texas"
L2	.STRINGZ	"       Texas       Texas       Texas"
Enter	.FILL	x0A
SaveR7	.blkw	1
KBIEN	.FILL	x4000
KBSR	.FILL	xFE00
KBIVE	.FILL	x0180
KBISR	.FILL	x1500
SBase	.FILL	x3000
Flag	.FILL	x4100


DELAY   ST  R1, SaveR1
        LD  R1, COUNT
REP     ADD R1,R1,#-1
        BRp REP
        LD  R1, SaveR1
        RET
COUNT   .FILL #25000
SaveR1  .BLKW 1

	.END