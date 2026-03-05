*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
	ORG $1000
*-------------------------------------------------------
*CHOOSE TO BE A MINI KNIGHT OR A TINY EXPLORER
*-------------------------------------------------------

*-------------------------------------------------------
*VALIDATION VALUES TO BE USED, MODIFY AS NEEDED
*-------------------------------------------------------
EXIT		EQU 0			;USED TO EXIT ASSEMBLY PROGRAM
MIN_POTIONS	EQU 1			;MIN NUMBER OF SMALL POTIONS
MAX_POTIONS	EQU 9			;MAX NUMBER OF SMALL POTIONS
MIN_WEAPONS	EQU 1			;MIN WEAPONS (NEEDLE SWORD, ACORN SHIELD)
MAX_WEAPONS	EQU 3			;MAX WEAPONS
WIN_POINT	EQU 5			;BRAVERY POINTS GAINED ON SUCCESS
LOSE_POINT	EQU 8			;BRAVERY POINTS LOST ON FAILURE

DANGER_LOC  EQU 100         ;USED FOR SIMPLE COLLISION DETECTION
                            ;* EXAMPLE FOR A HIT (GIANT FOOTSTEP)

*START OF GAME
START:
    MOVE.B  #100,$4000      ;PUT BRAVERY POINTS IN MEMORY LOCATION $4000
    LEA     $4000,A3        ;ASSIGN ADDRESS A3 TO THAT MEMORY LOCATION
    
    BSR     INIT            ;BRANCH TO INIT TO INITIALIZE OCEAN AND SHIPS
    BSR     WELCOME         ;BRANCH TO THE WELCOME SUBROUTINE
    ;BSR     INPUT           ;BRANCH TO THE INPUT SUBROUTINE
    BSR     GAME            ;BRANCH TO THE GAME SUBROUTINE

*GAME LOOP
    ORG     $3000           ;THE REST OF THE PROGRAM IS TO BE LOCATED FROM 3000 ONWARDS

*-------------------------------------------------------
*-------------------GAME SUBROUTINE---------------------
*-------------------------------------------------------
GAME:
    BSR     GAMELOOP        ;BRANCH TO GAMELOOP SUBROUTINE
    RTS                     ;RETURN FROM GAME: SUBROUTINE

*-------------------------------------------------------
*----------INIT: SET UP THE BOARD AT GAME START---------
* FILLS ALL 25 CELLS WITH 0 (OCEAN)
* THEN PLACES 3 SHIPS USING THEIR ROW/COL VALUES
*-------------------------------------------------------
INIT:
    *---STEP1: FILL ENTIRE BOARD WITH 0 (OCEAN) ----
    LEA     BOARD, A0       ;A0 POINTS TO START OF BOARD
    MOVE.B  #24,   D3       ;LOOP COUNTER =24 (25 CELLS, 0 TO 24)
INIT_LOOP:
    MOVE.B  #0, (A0)+       ;WRITE 0 TO COUNTER CELL, MOVE A0 FORWARD
    SUB.B   #1,    D3       ;DECREMENT COUNTER
    BNE     INIT_LOOP       ;REPEAT UNTIL D3 = 0
    MOVE.B  #0,    (A0)     ;WRITE THE LAST CELL (cell 25)
    
    *---STEP2: PLACE SHIP 1 ---
    LEA     BOARD, A0       ;RESET A0 TO START OF BOARD
    MOVE.B  SHIP1_ROW, D0   ;D0 = ROW
    MOVE.B  #5, D1
    MULU    D1, D0          ;D0 = ROW * 5
    ADD.B   SHIP1_COL, D0   ;D0 = (ROW * 5) + COL <- This formula will be used all the time
    MOVE.B  #1, (A0, D0)    ;BOARD[OFFSET] = 1 (SHIP!)
    
    *---STEP3: PLACE SHIP 2 ---
    MOVE.B  SHIP2_ROW, D0
    MOVE.B  #5, D1
    MULU    D1, D0
    ADD.B   SHIP2_COL, D0
    MOVE.B  #1, (A0, D0)    ;BOARD[OFFSET] = 1
    
    *---STEP3: PLACE SHIP 3 ---
    MOVE.B  SHIP3_ROW, D0
    MOVE.B  #5, D1
    MULU    D1, D0
    ADD.B   SHIP3_COL, D0
    MOVE.B  #1,  (A0, D0)   ;BOARD[OFFSET] = 1
    
    RTS                     ;RETURN FROM INIT
    
*-------------------------------------------------------
*----------DRAW_BOARD: PRINT THE 5x5 GRID--------------
*-------------------------------------------------------
DRAW_BOARD:
    LEA     BOARD, A0       ;A0 = START OF BOARD
    MOVE.B  #5, D5          ;D5 = ROW COUNTER (5 ROWS)
    
DB_ROW:
    MOVE.B  #5, D4          ;D4 = COL COUNTER (5 COLS)
    
DB_COL:
    MOVE.B  (A0)+, D2       ;D2 = CURRENT CELL VALUE, ADVANCE A0
    
    CMP.B   #2, D2          ;IS IT A HIT?
    BEQ     DB_HIT
    CMP.B   #3, D2          ;IS IT A MISS?
    BEQ     DB_MISS
    
DB_OCEAN:                    ; DEFAULT: SHOW OCEAN
    LEA     CELL_OCEAN, A1
    MOVE.B  #14, D0
    TRAP    #15
    BRA     DB_NEXT
DB_HIT:
    LEA     CELL_HIT, A1
    MOVE.B  #14, D0
    TRAP    #15
    BRA     DB_NEXT
    
DB_MISS:
    LEA     CELL_MISS, A1
    MOVE.B  #14, D0
    TRAP    #15
    
DB_NEXT:
    SUB.B   #1, D4          ;DECREMENT COL COUNTER
    BNE     DB_COL          ;NEXT COLUMN
    BSR     ENDL            ;END OF ROW = NEW LINE
    SUB.B   #1, D5          ;DECREMENT ROW COUNTER
    BNE     DB_ROW          ;NEXT ROW
    
    RTS

END:
    SIMHALT

*-------------------------------------------------------
*-------------------WELCOME SUBROUTINE------------------
*-------------------------------------------------------
WELCOME:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    LEA     WELCOME_MSG,A1  ;ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    BSR     CONTINUE        ;BRANCH TO CONTINUE SUBROUTINE 
    RTS                     ;RETURN FROM WELCOME: SUBROUTINE

*-------------------------------------------------------
*---------GAMEPLAY INPUT VALUES SUBROUTINE--------------
*-------------------------------------------------------    
INPUT:
    BSR     POTIONS         ;BRANCH TO POTION INPUT SUBROUTINE
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    BSR     WEAPONS         ;BRANCH TO WEAPONS INPUT SUBROUTINE

    RTS

*-------------------------------------------------------
*----------------GAMELOOP (MAIN LOOP)-------------------
*------------------------------------------------------- 
GAMELOOP:

    BSR     UPDATE          ;BRANCH TO UPDATE (UPDATE STATUS) 

    BSR     DRAW            ;BRANCH TO DRAW GAME SUBROUTINE (DRAW BOARD)           

    BSR     INPUT           ;BRANCH TO INPUT (ASK FOR SHOT)
    BSR     GAMEPLAY        ;BRANCH TO GAMEPLAY SUBROUTINE (PROCESS THE SHOT)   
    BSR     HUD             ;BRANCH TO HUD SUBROUTINE   (SHOW THE SCORE)

    BSR     REPLAY          ;BRANCH TO REPLAY SUBROUTINE (PLAY AGAIN?)
    BSR     CLEAR_SCREEN    ;CLEARS THE SCREEN  
    RTS                     ;RETURN FROM GAMELOOP: SUBROUTINE       

*-------------------------------------------------------
*----------------UPDATE QUEST PROGRESS------------------
*  COMPLETE QUEST
*------------------------------------------------------- 
UPDATE:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE   
    LEA     UPDATE_MSG,A1   ;ASSIGN MESSAGE TO ADDRESS REGISTER A1 
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE
    RTS                     

*-------------------------------------------------------
*-----------------DRAW QUEST UPDATES--------------------
* DRAW THE GAME PROGRESS INFORMATION, STATUS REGARDING
* QUEST
*------------------------------------------------------- 
DRAW:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE            
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE
    BSR     DRAW_BOARD      ;BRANCH TO DRAW BOARD    
    LEA     DRAW_MSG,A1     ;ASSIGN MESSAGE TO ADDRESS REGISTER A1     
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE
    RTS                     ;RETURN FROM DRAW: SUBROUTINE

*-------------------------------------------------------
*--------------------POTIONS: OVERWRITTEN!---------------------
*--------------------GET_ROW: ASK PLAYER FOR ROW(1-5----------- 
*------------------------------------------------------- 
POTIONS:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    LEA     POTIONS_MSG, A1 ;"Enter ROW to fire (1-5)
    MOVE.B  #14, D0
    TRAP    #15

    MOVE.B  #4,  D0         ;READ NUMBER INTO D1
    TRAP    #15
    
    SUB.B   #1, D1          ;CONVERT 1-5 TO 0-4 (FOR THE ARRAY INDEX)
    MOVE.B  D1, SHOT_ROW    ;SAVE IT
    RTS

*-------------------------------------------------------
*-------------------------WEAPONS-----------------------
* GET_COL: ASK PLAYER FOR COL (1-5)
*-------------------------------------------------------   
WEAPONS:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    LEA     WEAPONS_MSG,A1  ;"Enter Col to fire (1-5)
    MOVE.B  #14, D0
    TRAP    #15
    
    MOVE.B  #4, D0          ;READ NUMBER INTO D1
    TRAP    #15
    
    SUB.B   #1, D1          ;CONVERT 1-5 TO 0-4
    MOVE.B  D1, SHOT_COL    ;SAVE IT
    RTS                     ;RETURN FROM WEAPONS: SUBROUTINE

*-------------------------------------------------------
*---GAME PLAY (QUEST PROGRESS)--------------------------
*------------------------------------------------------- 
GAMEPLAY:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE
    LEA     GAMEPLAY_MSG,A1 ;ASSIGN MESSAGE TO ADDRESS REGISTER A1

    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE
    BSR     COLLISION       ;BRANCH TO COLLISION SUBROUTINE
    RTS                     ;RETURN FROM GAMEPLAY: SUBROUTINE

*-------------------------------------------------------
*-----------------HEADS UP DISPLAY (SCORE)--------------
*-------------------------------------------------------   
HUD:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE
    LEA     HUD_MSG,A1      ;ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    MOVE.B  (A3),D1         ;RETRIEVE THE VALUE A3 POINT TO AND MOVE TO D1
    MOVE.B  #3,D0           ;MOVE LITERAL 3 TO DO    
    TRAP    #15               
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE    
    RTS                     

*-------------------------------------------------------
*---COLLISION: CHECK IF SHOT HITS A SHIP----------------
* READS SHOT_ROW AND SHOT_COL
* CALCULATES OFFSET = (ROW * 5) + COL
* CHECKS BOARD[OFFSET] FOR 1 (SHIP)
* MARKS HIT (2) OR MISS (3) ON BOARD
*-------------------------------------------------------
COLLISION:                  
    LEA     BOARD, A0       ;A0 = START OF BOARD
    
    MOVE.B  SHOT_ROW, D0    ;D0 = ROW
    MOVE.B  #5, D1
    MULU    D1, D0          ;D0 = ROW * 5
    ADD.B   SHOT_COL, D0    ;D0 = (ROW * 5) + COL
    
    MOVE.B  (A0, D0), D2    ;D2 = BOARD[OFFSET]
    
    CMP.B   #1, D2          ;IS IT A SHIP?
    BEQ     REAL_HIT        ;YES -> HIT!
    BRA     REAL_MISS       ;NO -> MISS!
    
REAL_HIT:
    MOVE.B  #2, (A0, D0)    ;MARK BOARD[OFFSET] = 2 [HIT]
    SUB.B   #1, SHIPS_LEFT  ; ONE LESS SHIP
    LEA     HIT_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15
    RTS

REAL_MISS:
    MOVE.B  #3, (A0, D0)    ;MARK BOARD[OFFSET] = 3 (MISS)
    LEA     MISS_MSG, A1    ;
    MOVE.B  #14, D0
    TRAP    #15
    RTS

*-------------------------------------------------------
*--------------------------LOOP-------------------------
*-------------------------------------------------------
LOOP:
    MOVE.B  #5, D3          ;LOOP COUNTER D3=5
NEXT:
    LEA     LOOP_MSG,A1     ;ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO          
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    SUB     #1,D3           ;DECREMENT LOOP COUNTER
    BNE     NEXT            ;REPEAT UNTIL D0=0

*-------------------------------------------------------
*------------------SCREEN DECORATION--------------------
*-------------------------------------------------------
DECORATE:
    MOVE.B  #60, D3         ;LOOP COUNTER D3=60
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
OUT:
    LEA     LOOP_MSG,A1     ;ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    SUB     #1,D3           ;DECREMENT LOOP COUNTER
    BNE     OUT             ;REPEAT UNTIL D0=0
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    RTS                     ;RETURN FROM DECORATE: SUBROUTINE
    
CLEAR_SCREEN: 
    MOVE.B  #11,D0          ;CLEAR SCREEN
    MOVE.W  #$FF00,D1       ;SET COLOUR
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    RTS                     ;RETURN FROM CLEAR_SCREEN: SUBROUTINE                

*-------------------------------------------------------
*------------------------REPLAY-------------------------
*-------------------------------------------------------
REPLAY:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    LEA     REPLAY_MSG,A1   ;ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    
    MOVE.B  #4,D0           ;MOVE LITERAL 4 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0

    CMP     #EXIT,D1        ;COMPARE D1 TO EXIT
    BEQ     END             ;IF EQUAL, BRANCH TO END
    BSR     GAMELOOP        ;BRANCH TO GAMELOOP SUBROUTINE
    
*-------------------------------------------------------
*------------------------CONTINUE-------------------------
*-------------------------------------------------------
CONTINUE:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    LEA     CONTINUE_MSG,A1 ;ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    
    MOVE.B  #4,D0           ;MOVE LITERAL 4 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    RTS                     ;RETURN FROM SUBROUTINE 

ENDL:
    MOVEM.L D0/A1,-(A7)     ;SAVE D0 AND A1
    MOVE    #14,D0          ;MOVE LITERAL 14 TO DO
    LEA     CRLF,A1         ;ASSIGN CRLF TO ADDRESS REGISTER A1
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    MOVEM.L (A7)+,D0/A1     ;RESTORE D0 AND A1
    RTS                     ;RETURN FROM ENDL: SUBROUTINE
    
*-------------------------------------------------------
*-------------------DATA DECLARATIONS--------------------
*-------------------------------------------------------

CRLF:           DC.B    $0D,$0A,0
WELCOME_MSG:    DC.B    '************************************************************'
                DC.B    $0D,$0A
                DC.B    '       SPAIN vs ENGLAND - NAVAL BATTLE 1588 '
                DC.B    $0D,$0A
                DC.B    '     The Spanish Armada faces the English Fleet'
                DC.B    $0D,$0A
                DC.B    '************************************************************'
                DC.B    $0D,$0A,0
POTIONS_MSG:    DC.B    'Enter ROW to fire (1-5): ',0
WEAPONS_MSG:    DC.B    'Enter COL to fire (1-5):',0
GAMEPLAY_MSG:   DC.B    'Enter coordinates to fire cannons!',0
UPDATE_MSG:     DC.B    'Preparing battle status...',0
DRAW_MSG:       DC.B    'NAVAL GRID - NORTH ATLANTIC 1588...',0

HIT_MSG:        DC.B    '*** DIRECT HIT! A ship has been struck! ***',0
MISS_MSG:       DC.B    '... Cannonball splashes into the sea. MISS!',0

LOOP_MSG:       DC.B    '.',0
REPLAY_MSG:     DC.B    'ENTER 0 TO QUIT, ANY OTHER NUMBER TO REPLAY: ',0
CONTINUE_MSG:   DC.B    'PRESS ANYKEY TO CONTINUE: ',0

HUD_MSG:        DC.B    'CANNON HITS REMAINING: ',0

*---------------------------------------------------
* GAME BOARD - 5x5 GRID (25 BYTES)
* 0=OCEAN, 1=SHIP, 2=HIT, 3=MISS
*---------------------------------------------------

BOARD:          DS.B    25  ; RESERVE 25 BYTES FOR THE GRID

*---------------------------------------------------
* SHIP POSITIONS (ROW, COL) PAIRS - 3 SHIPS
* SHIP1 = GALLEON (ROW 0, COL 0)
* SHIP2 = FRIGATE(ROW 2, COL 3)
* SHIP3 = CARAVEL (ROW 4, COL 1)
*---------------------------------------------------
SHIP1_ROW:      DC.B    0   ;SHIP 1 ROW
SHIP1_COL:      DC.B    0   ;SHIP 1 COLUMN

SHIP2_ROW:      DC.B    2   ;SHIP 2 ROW
SHIP2_COL:      DC.B    3   ;SHIP 2 COL

SHIP3_ROW:      DC.B    4   ;SHIP 3 ROW
SHIP3_COL:      DC.B    1   ;SHIP 3 COL

SHIPS_LEFT:     DC.B    3   ;SHIPS STILL ALIVE
SHOT_ROW:       DS.B    1   ;PLAYER'S CHOSEN ROW
SHOT_COL:       DS.B    1   ;PLAYER'S CHOSEN COLUMN

HEALTH:         DS.W    1   ;PLAYERS HEALTH
SCORE:          DS.W    1   ;RESERVE SPACE FOR SCORE


*-----------OCEAN SYMBOLS-----------
CELL_OCEAN:     DC.B  '[~]',0
CELL_HIT:       DC.B  '[X]',0
CELL_MISS:      DC.B  '[0]',0


    END START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
