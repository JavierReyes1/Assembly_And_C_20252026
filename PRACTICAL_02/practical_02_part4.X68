*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    MOVE.B #%00001111,  $2000 ;
    MOVE.L #$100,       $1010  ;
    MOVE.W #10,         $1020   ;
    
    MOVE.B $2000, D0 ;
    MOVE.L $1010, D1 ;
    MOVE.W $1020, D3 ;
    
    MOVE.B #%01010101,  $1030 ;
    LEA $1030, A1 ;
    MOVE.B (A1), D4 ;
    
    MOVE.L #$7F, $1040 ;
    MOVE.L $1040, A2 ;
    MOVE.L (A2), D5 ;
    
    MOVE.B #20, $1050 ;
    MOVE.B $1050, D6 ;
    MOVE.B D6, D7 ;
    
    MOVE.W #$0B, $1060 ;
    MOVE.W $1060, D0 ;
    MOVE.W D0, D1 ;
    
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

