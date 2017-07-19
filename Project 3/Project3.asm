;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 	description: 	Connect 4 game! Starter Code		;
;			BME 303 - Spring 2015			;
;			Programming Assignment #3 		;
; 								;
;	file:		PA3.asm				        ;
;	author:		Ramesh Yerraballi 			;
;	date:		3/25/2015				;
;***************************************************************;
; Student Name:	Nabeel Naiyer					;
; UT EID: nn5363						;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.ORIG x4000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Main Program						;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	JSR INIT
ROUND
	JSR DISPLAY_BOARD
	JSR GET_MOVE
	JSR UPDATE_BOARD
	JSR UPDATE_STATE

	ADD R6, R6, #0		; R6 is 1 means game over
	BRz ROUND

	JSR DISPLAY_BOARD
	JSR GAME_OVER

	HALT
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Functions & Constants!!!				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	DISPLAY_TURN						;
;	description:	Displays the appropriate prompt.	;
;	inputs:		None!					;
;	outputs:	None!					;
;	assumptions:	TURN is set appropriately!		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISPLAY_TURN
	ST R0, DT_R0
	ST R7, DT_R7

	LD R0, TURN
	ADD R0, R0, #-1
	BRp DT_P2
	LEA R0, DT_P1_PROMPT
	PUTS
	BRnzp DT_DONE
DT_P2
	LEA R0, DT_P2_PROMPT
	PUTS

DT_DONE

	LD R0, DT_R0
	LD R7, DT_R7

	RET
DT_P1_PROMPT	.stringz 	"Player 1, pick a column: "
DT_P2_PROMPT	.stringz	"Player 2, pick a column: "
DT_R0		.blkw	1
DT_R7		.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	GET_MOVE						;
;	description:	gets a column from the user.		;
;			also checks whether the move is valid,	;
;			or not, by calling the CHECK_VALID 	;
;			subroutine!				;
;	inputs:		None!					;
;	outputs:	R6 has the user entered column number!	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_MOVE
	ST R0, GM_R0
	ST R7, GM_R7

GM_REPEAT
	JSR DISPLAY_TURN
	GETC
	OUT
	JSR CHECK_VALID
	LD R0, ASCII_NEWLINE
	OUT

	ADD R6, R6, #0
	BRp GM_VALID

	LEA R0, GM_INVALID_PROMPT
	PUTS
	LD R0, ASCII_NEWLINE
	OUT
	BRnzp GM_REPEAT

GM_VALID

	LD R0, GM_R0
	LD R7, GM_R7

	RET
GM_INVALID_PROMPT 	.stringz "Invalid move. Try again."
GM_R0			.blkw	1
GM_R7			.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	UPDATE_BOARD						;
;	description:	updates the game board with the last 	;
;			move!					;
;	inputs:		R6 has the column for last move.	;
;	outputs:	R5 has the row for last move.		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UPDATE_BOARD
	ST R1, UP_R1
	ST R2, UP_R2
	ST R3, UP_R3
	ST R4, UP_R4
	ST R6, UP_R6
	ST R7, UP_R7

	; clear R5
	AND R5, R5, #0
	ADD R5, R5, #6

	LEA R4, ROW6
	
UB_NEXT_LEVEL
	ADD R3, R4, R6

	LDR R1, R3, #-1
	LD R2, ASCII_NEGHYP

	ADD R1, R1, R2
	BRz UB_LEVEL_FOUND

	ADD R4, R4, #-7
	ADD R5, R5, #-1
	BRnzp UB_NEXT_LEVEL

UB_LEVEL_FOUND
	LD R4, TURN
	ADD R4, R4, #-1
	BRp UB_P2

	LD R4, ASCII_O
	STR R4, R3, #-1

	BRnzp UB_DONE
UB_P2
	LD R4, ASCII_X
	STR R4, R3, #-1

UB_DONE		

	LD R1, UP_R1
	LD R2, UP_R2
	LD R3, UP_R3
	LD R4, UP_R4
	LD R6, UP_R6
	LD R7, UP_R7

	RET
ASCII_X	.fill	x0058
ASCII_O	.fill	x004f
UP_R1	.blkw	1
UP_R2	.blkw	1
UP_R3	.blkw	1
UP_R4	.blkw	1
UP_R5	.blkw	1
UP_R6	.blkw	1
UP_R7	.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHANGE_TURN						;
;	description:	changes the turn by updating TURN!	;
;	inputs:		none!					;
;	outputs:	none!					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHANGE_TURN
	ST R0, CT_R0
	ST R1, CT_R1
	ST R7, CT_R7

	LD R0, TURN
	ADD R1, R0, #-1
	BRz CT_TURN_P2

	ST R1, TURN
	BRnzp CT_DONE

CT_TURN_P2
	ADD R0, R0, #1
	ST R0, TURN

CT_DONE
	LD R0, CT_R0
	LD R1, CT_R1
	LD R7, CT_R7

	RET
CT_R0	.blkw	1
CT_R1	.blkw	1
CT_R7	.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_WINNER						;
;	description:	checks if the last move resulted in a	;
;			win or not!				;
;	inputs:		R6 has the column of last move.		;
;			R5 has the row of last move.		;
;	outputs:	R4 has  0, if not winning move,		;
;				1, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_WINNER
	ST R5, CW_R5
	ST R6, CW_R6
	ST R7, CW_R7

	AND R4, R4, #0
	
	JSR CHECK_HORIZONTAL
	ADD R4, R4, #0
	BRp CW_DONE

	JSR CHECK_VERTICAL
	ADD R4, R4, #0
	BRp CW_DONE

	JSR CHECK_DIAGONALS

CW_DONE

	LD R5, CW_R5
	LD R6, CW_R6
	LD R7, CW_R7

	RET
CW_R5	.blkw	1
CW_R6	.blkw	1
CW_R7	.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	UPDATE_STATE						;
;	description:	updates the state of the game by 	;
;			checking the board. i.e. tries to figure;
;			out whether the last move ended the game;
; 			or not! if not updates the TURN! also	;
;			updates the WINNER if there is a winner!;
;	inputs:		R6 has the column of last move.		;
;			R5 has the row of last move.		;
;	outputs:	R6 has  1, if the game is over,		;
;				0, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UPDATE_STATE
	ST R0, US_R0
	ST R1, US_R1
	ST R4, US_R4
	ST R7, US_R7
	
	; checking if the last move resulted in a win or not!
	JSR CHECK_WINNER
	
	ADD R4, R4, #0
	BRp US_OVER
	
	; checking if the board is full or not!
	AND R6, R6, #0
		
	LD R0, NBR_FILLED
	ADD R0, R0, #1
	ST R0, NBR_FILLED

	LD R1, MAX_FILLED
	ADD R1, R0, R1
	BRz US_TIE

US_NOT_OVER
	JSR CHANGE_TURN
	BRnzp US_DONE

US_OVER
	ADD R6, R6, #1
	LD R0, TURN
	ST R0, WINNER
	BRnzp US_DONE

US_TIE
	ADD R6, R6, #1

US_DONE
	LD R0, US_R0
	LD R1, US_R1
	LD R4, US_R4
	LD R7, US_R7

	RET
NBR_FILLED	.fill	#0
MAX_FILLED	.fill	#-36
US_R0		.blkw	1
US_R1		.blkw	1
US_R4		.blkw	1
US_R7		.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	INIT							;
;	description:	simply sets the BOARD_PTR appropriately!;
;	inputs:		none!					;
;	outputs:	none!					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INIT
	ST R0, I_R0
	ST R7, I_R7

	LEA R0, ROW1
	ST R0, BOARD_PTR

	LD R0, I_R0
	LD R7, I_R7

	RET
I_R0	.blkw	1
I_R7	.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Global Constants!!!					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASCII_SPACE	.fill		x0020				;
ASCII_NEWLINE	.fill		x000A				;
TURN		.fill		1				;
WINNER		.fill		0				;
								;
ASCII_OFFSET	.fill		x-0030				;
ASCII_NEGONE	.fill		x-0031				;
ASCII_NEGSIX	.fill		x-0036				;
ASCII_NEGHYP	.fill	 	x-002d				;
								;
ROW1		.stringz	"------"			;
ROW2		.stringz	"------"			;
ROW3		.stringz	"------"			;
ROW4		.stringz	"------"			;
ROW5		.stringz	"------"			;
ROW6		.stringz	"------"			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;DO;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;NOT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;CHANGE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;ANYTHING;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;ABOVE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;THIS!!!;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	DISPLAY_BOARD						;
;	description:	Displays the board.			;
;	inputs:		None!					;
;	outputs:	None!					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISPLAY_BOARD
	ST	R7, SAVER7
	ADD	R1, R1, #0
	ADD	R1, R1, #6
	LD	R0,BOARD_PTR
DP_Loop	PUTS
	ST	R0, SAVER0
	AND 	R0, R0, #0
	ADD	R0, R0, #10
	PUTC
	LD	R0, SAVER0
	ADD	R0,R0,#7
	ADD 	R1, R1, #-1
	BRP	DP_Loop
	LD	R7, SAVER7
	RET
SAVER7	.BLKW	1
SAVER0	.BLKW	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	GAME_OVER						;
;	description:	checks WINNER and outputs the proper	;
;			message!				;
;	inputs:		none!					;
;	outputs:	none!					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GAME_OVER
	LD	R1, WINNER
	ADD	R1, R1, #-1
	BRz	P1WinO
	BRp	P2WinO
	BRn	TieGO
P1WinO
	LEA	R0, P1Win
	TRAP	x22
	BR	AYYY
P2WinO
	LEA	R0, P2Win
	TRAP	x22
	BR	AYYY
TieGO	
	LEA	R0, TieG
	TRAP	x22
	BR	AYYY
AYYY 	HALT
P1Win	.stringz	"Player 1 Wins."
P2Win	.stringz	"Plyaer 2 Wins."
TieG	.stringz	"Tie Game."

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_VALID						;
;	description:	checks whether a move is valid or not!	;
;	inputs:		R0 has the ASCII value of the move!	;
;	outputs:	R6 has:	0, if invalid move,		;
;				decimal col. val., if valid.    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_VALID
	ST	R0, TEMPR0
	ST	R1, TEMPR1
	ST	R2, TEMPR2
	ST	R3, TEMPR3
	ST	R4, TEMPR4
	ST	R5, TEMPR5
	ST	R6, TEMPR6
	ST	R7, TEMPR7
	ADD	R0, R0, x-0F
	ADD	R0, R0, x-0F
	ADD	R0, R0, x-0F
	ADD	R0, R0, #-3
	BRnz	FAULTY
	AND	R1, R1, #0
	ADD	R1, R1, #6
	NOT 	R1, R1
	ADD	R1, R1, #1
	ADD	R2, R0, R1
	BRp	FAULTY
	BRnz	FULLyn
FAULTY	AND	R6, R6, #0
	BR	BAD
FULLyn	LD	R3, BOARD_PTR
	ADD	R4, R0, #0
	ADD	R4, R4, #-1
	ADD	R3, R3, R4
	LDR	R3, R3, x00
	ADD	R3, R3, x-0F
	ADD	R3, R3, x-0F
	ADD	R3, R3, x-0F
	BRz	GOOD
	BRnp	BAD
GOOD	AND	R6, R6, #0
	ADD	R6, R6, R0
BAD	LD	R0, TEMPR0
	LD	R1, TEMPR1
	LD	R2, TEMPR2
	LD	R3, TEMPR3
	LD	R4, TEMPR4
	LD	R5, TEMPR5
	LD	R7, TEMPR7
	RET
TEMPR0	.BLKW	1
TEMPR1	.BLKW	1
TEMPR2	.BLKW	1
TEMPR3	.BLKW	1
TEMPR4	.BLKW	1
TEMPR5	.BLKW 	1
TEMPR6	.BLKW	1
TEMPR7	.BLKW	1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;USE THE FOLLOWING TO ACCESS THE BOARD!!!;;;;;;;;;;;;;;;;;;
;;;;;IT POINTS TO THE FIRST ELEMENT OF ROW1 (TOP-MOST ROW)!!!;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BOARD_PTR	.blkw	1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	BOARD_ADDRESS						;
;	description:	find the address for the last move  	;
;			played.					;
;	inputs:		R6 has the column of the last move.	;
;			R5 has the row of the last move.	;
;	outputs:	R0 holds address of last move		;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BOARD_ADDRESS
	ST	R0, TMPR0
	ST	R6, TMPR6
	ST	R5, TMPR5
	ST	R7, TMPR7
	AND	R0, R0, #0
	LD	R0, BOARD_PTR
	ADD	R6, R6, #-1
	ADD	R5, R5, #-1
CHKsix	ADD	R6, R6, #0
	BRz	CHKfive
	ADD	R0, R0, #1
	ADD	R6, R6, #-1
	BR	CHKsix
CHKfive	ADD	R5, R5, #0
	BRz	Reload
	ADD	R0, R0, #7
	ADD	R5, R5, #-1
	BR	CHKfive
Reload	LD	R5, TMPR5
	LD	R6, TMPR6
	LD	R7, TMPR7
	RET
TMPR0	.BLKW	1
TMPR5	.BLKW	1
TMPR6	.BLKW	1
TMPR7	.BLKW	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_HORIZONTAL					;
;	description:	horizontal check.			;
;	inputs:		R6 has the column of the last move.	;
;			R5 has the row of the last move.	;
;	outputs:	R4 has  0, if not winning move,		;
;				1, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_HORIZONTAL
	ST	R0, R0HOLD
	ST	R1, R1HOLD
	ST	R2, R2HOLD
	ST	R3, R3HOLD
	ST	R4, R4HOLD
	ST	R5, R5HOLD
	ST	R6, R6HOLD
	ST	R7, R7HOLD
	AND	R3, R3, #0
	ADD	R3, R3, #3
	JSR	BOARD_ADDRESS
	ST	R0, R0HOLD2
	LDR	R1, R0, #0
	NOT	R1, R1
	ADD	R1, R1, #1
CheckR	ADD	R6, R6, #1
	ADD	R0, R0, #1
	ADD	R4, R6, #0
	ADD	R4, R4, #-6
	BRp	MoveOn
	LDR	R2, R0, #0
	ADD	R7, R2, R1
	BRnp	MoveOn
	ADD	R3, R3, #-1
	BR	CheckR
MoveOn	LD	R6, R6HOLD
	LD	R0, R0HOLD2
CheckL	ADD	R6, R6, #-1
	ADD	R0, R0, #-1
	ADD	R6, R6, #0
	BRnz	CheckW
	LDR	R2, R0, #0
	ADD	R7, R2, R1
	BRnp	CheckW
	ADD	R3, R3, #-1
	BR	CheckL
CheckW	ADD	R3, R3, #0
	BRnz	HWin
	AND	R4, R4, #0
	BR	BBack
HWin	AND	R4, R4, #0
	ADD	R4, R4, #1
BBack	LD	R0, R0HOLD
	LD	R1, R1HOLD
	LD	R2, R2HOLD
	LD	R3, R3HOLD
	LD	R5, R5HOLD
	LD	R6, R6HOLD
	LD	R7, R7HOLD
	RET
R0HOLD	.BLKW	1
R0HOLD2	.BLKW	1
R1HOLD	.BLKW	1
R2HOLD	.BLKW	1
R3HOLD	.BLKW	1
R4HOLD	.BLKW	1
R5HOLD	.BLKW	1
R6HOLD	.BLKW	1
R7HOLD	.BLKW	1
ASCIIx	.FILL	#88
ASCIIo	.FILL	#79
ASCIId	.FILL	#45

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_VERTICAL						;
;	description:	vertical check.				;
;	inputs:		R6 has the column of the last move.	;
;			R5 has the row of the last move.	;
;	outputs:	R4 has  0, if not winning move,		;
;				1, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_VERTICAL
	ST	R1, HOLDR1
	ST	R2, HOLDR2
	ST	R3, HOLDR3
	ST	R4, HOLDR4
	ST	R5, HOLDR5
	ST	R6, HOLDR6
	ST	R7, HOLDR7
	AND	R3, R3, #0
	ADD	R3, R3, #3
	JSR	BOARD_ADDRESS
	ST	R0, R0HOLD2
	LDR	R1, R0, #0
	NOT	R1, R1
	ADD	R1, R1, #1
CheckV	ADD	R5, R5, #1
	ADD	R0, R0, #7
	ADD	R4, R5, #0
	ADD	R4, R4, #-6
	BRp	CheckK
	LDR	R2, R0, #0
	ADD	R7, R2, R1
	BRnp	CheckK
	ADD	R3, R3, #-1	
	BR	CheckV
CheckK	ADD	R3, R3, #0
	BRnz	VWin
	AND	R4, R4, #0
	BR	MBack
VWin	AND	R4, R4, #0
	ADD	R4, R4, #1
MBack	LD	R0, HOLDR0
	LD	R1, HOLDR1
	LD	R2, HOLDR2
	LD	R3, HOLDR3
	LD	R5, HOLDR5
	LD	R6, HOLDR6
	LD	R7, HOLDR7
	RET
HOLDR0	.BLKW	1
HOLDR1	.BLKW	1
HOLDR2	.BLKW	1
HOLDR3	.BLKW	1
R3Save	.BLKW	1
HOLDR4	.BLKW	1
HOLDR5	.BLKW	1
HOLDR6	.BLKW	1
HOLDR7	.BLKW	1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_DIAGONALS						;
;	description:	checks diagonals by calling 		;
;			CHECK_D1 & CHECK_D2.			;
;	inputs:		R6 has the column of the last move.	;
;			R5 has the row of the last move.	;
;	outputs:	R4 has  0, if not winning move,		;
;				1, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_DIAGONALS
	ST	R4, STAYR4
	ST	R7, STAYR7
	JSR	CHECK_D1
	ADD	R4, R4, #0
	BRp	D1Win
	BRnz	D2Time
D2Time	ST	R7, NSTAYR7
	JSR	CHECK_D2
	ADD	R4, R4, #0
	BRp	D2Go
	BRnz	Refresh
D1Win	AND	R4, R4, #0
	ADD	R4, R4, #1
D2Go	AND	R4, R4, #0	
	ADD	R4, R4, #1
Refresh	LD	R7, STAYR7	
	RET
STAYR4	.BLKW	1
STAYR7	.BLKW	1
NSTAYR7	.BLKW	1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_D1						;
;	description:	1st diagonal check.			;
;	inputs:		R6 has the column of the last move.	;
;			R5 has the row of the last move.	;
;	outputs:	R4 has  0, if not winning move,		;
;				1, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_D1
	ST	R0, PLACER0
	ST	R1, PLACER1
	ST	R2, PLACER2
	ST	R3, PLACER3
	ST	R4, PLACER4
	ST	R5, PLACER5
	ST	R6, PLACER6
	ST	R7, PLACER7
	AND	R3, R3, #0
	ADD	R3, R3, #3
	JSR	BOARD_ADDRESS
	ST	R0, NHOLDR0
	LDR	R1, R0, #0
	NOT	R1, R1
	ADD	R1, R1, #1
CHECKur	ADD	R0, R0, #-6
	ADD	R5, R5, #-1
	ADD	R6, R6, #1
	ADD	R4, R6, #0
	ADD	R4, R4, #-6
	BRp	GoOn
	ADD	R7, R5, #0
	BRnz	GoOn
	LDR	R2, R0, #0
	ADD	R2, R2, R1
	BRnp	GoOn
	ADD	R3, R3, #-1
	BR	CHECKur
GoOn	LD	R6, PLACER6
	LD	R5, PLACER5
	LD	R0, NHOLDR0
CHECKdl	ADD	R0, R0, #6
	ADD	R5, R5, #1
	ADD	R6, R6, #-1
	BRnz	DCheck
	ADD	R4, R5, #0
	ADD	R4, R4, #-6
	BRp	DCheck
	LDR	R2, R0, #0
	ADD	R2, R2, R1
	BRnp	DCheck
	ADD	R3, R3, #-1
	BR	CHECKdl
DCheck	ADD	R3, R3, #0
	BRnz	DWin
	AND	R4, R4, #0
	BR	BeBack
DWin	AND	R4, R4, #0
	ADD	R4, R4, #1
BeBack	LD	R0, PLACER0
	LD	R1, PLACER1
	LD	R2, PLACER2
	LD	R3, PLACER3
	LD	R5, PLACER5
	LD	R6, PLACER6
	LD	R7, PLACER7
	RET
PLACER0	.BLKW	1
PLACER1	.BLKW	1
PLACER2	.BLKW	1
PLACER3	.BLKW	1
PLACER4	.BLKW	1
PLACER5	.BLKW	1
PLACER6	.BLKW	1
PLACER7	.BLKW	1
NHOLDR0	.BLKW	1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_D2						;
;	description:	2nd diagonal check.			;
;	inputs:		R6 has the column of the last move.	;
;			R5 has the row of the last move.	;
;	outputs:	R4 has  0, if not winning move,		;
;				1, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_D2	
	ST	R0, HOMER0
	ST	R1, HOMER1
	ST	R2, HOMER2
	ST	R3, HOMER3
	ST	R4, HOMER4
	ST	R5, HOMER5
	ST	R6, HOMER6
	ST	R7, HOMER7
	AND	R3, R3, #0
	ADD	R3, R3, #3
	JSR	BOARD_ADDRESS
	ST	R0, NHOMER0
	LDR	R1, R0, #0
	NOT	R1, R1
	ADD	R1, R1, #1
CheckUL	ADD	R0, R0, #-8
	ADD	R5, R5, #-1
	ADD	R6, R6, #-1
	ADD	R4, R6, #0
	ADD	R4, R4, #-6
	BRp	Advance
	ADD	R7, R5, #0
	BRnz	Advance
	LDR	R2, R0, #0
	ADD	R2, R2, R1
	BRnp	Advance
	ADD	R3, R3, #-1
	BR	CheckUL
Advance	LD	R6, HOMER6
	LD	R5, HOMER5
	LD	R0, NHOMER0
CheckDR	ADD	R0, R0, #8
	ADD	R5, R5, #1
	ADD	R6, R6, #1
	BRnz	D2Check
	ADD	R4, R5, #0
	ADD	R4, R4, #-6
	BRp	D2Check
	LDR	R2, R0, #0
	ADD	R2, R2, R1
	BRnp	D2Check
	ADD	R3, R3, #-1
	BR	CheckDR
D2Check	ADD	R3, R3, #0
	BRnz	D2Win
	AND	R4, R4, #0
	BR	Backup
D2Win	AND	R4, R4, #0
	ADD	R4, R4, #1
Backup	LD	R0, HOMER0
	LD	R1, HOMER1
	LD	R2, HOMER2
	LD	R3, HOMER3
	LD	R5, HOMER5
	LD	R6, HOMER6
	LD	R7, HOMER7
	RET
HOMER0	.BLKW	1
HOMER1	.BLKW	1
HOMER2	.BLKW	1
HOMER3	.BLKW	1
HOMER4	.BLKW	1
HOMER5	.BLKW	1
HOMER6	.BLKW	1
HOMER7	.BLKW	1
NHOMER0	.BLKW	1


AYY	HALT
.END