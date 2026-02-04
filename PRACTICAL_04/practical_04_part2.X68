*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    MOVE.B #100, $3000 ; MOVE HEALTH TO MEMORY LOCATION $3000
    
    ;Move location of player into data register
    ; X first byte 0 to 15
    ; Y second byte 0 to 15
    
    MOVE.B  #$12,   D2
    
    ; Move location of npc into data register
    ; X first byte 0 to 15
    ; Y second byte 0 to 15
    MOVE.B  #$22,    D3
    
    ;Bitwise AND D2 and D3
    ;Whats new location of player
    AND.B   D2,   D3
    
    OR.B    D2,   D3
    
    
    EOR.B   D3,   D3
         SDASDFASDFASDF
          
    LEA     $3000, A1 ; Load memory address $3000 into Address register A1
    
    SUB.B   #20, (A1) ;Hit by NPC
    
    ADD.B   #10, (A1) ; Pickup health found
    
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
