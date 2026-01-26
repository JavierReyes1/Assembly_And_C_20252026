*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    LEA HEALTH, A3 ;
    SUB.B #10, (A3) ;
    
    LEA POWER, A2 ;
    MOVE.B (A2), D2 ;
    
    SUB.B D2, (A3) ;

    SIMHALT             ; halt simulator

* Put variables and constants here
HEALTH dc.b     $64 ;
POWER dc.b     $5A ;
    
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
