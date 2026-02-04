*-----------------------------------------------------------
* Title      : 
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    
    MOVE.B #100, $3000 ; Move health to memory location $3000
    
    LEA     $3000, A1 ; Load Memory addresss $300 into Address Register A1
    
    SUB.B   #20, (A1) ; Hit by NPC
    
    ADD.B   #10, (A1) ; Pickup Health Found


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source
    
    ;Review questions, what do the address 
    ;register mean and what is stored in 
    ;memory and why?
    
    ;Answer: 
    ;Address Register holds the location of memory, it acts as a pointer
    ;Address Register A1 holds memory location address $3000

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
