*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    LEA playerPoints, A1 ;
    LEA health, A2 ;
    LEA playerX, A3 ;
    LEA playerY, A4 ;
    LEA bossHealth, A5 ;
    LEA bossX, A6 ;
    LEA bossY, A7 ;
    
    ;Player attacks boss with weapon and deals 10 points of damage
    ;and moves 5 units
    SUB.B #10, (A5) ;
    ADD.B #5, (A6) ;
    ADD.B #5, (A7) ;
    
    ;Boss attacks player with fist attack and deals 20 points of damage
    ;and moves 10 units
    
    SUB.B #20, (A2) ;
    ADD.B #10, (A3) ;
    ADD.B #10, (A4) ;
    
    ;Player uses health potion and restores 5 health unit points
    ADD.B #5, (A2) ;
    
    ;Boss swings a devastating blow hitting player and dealing 50 points
    ;of damage, Player pushed 20 units 
    
    SUB.B #50, (A2) ;
    SUB.B #20, (A3) ;
    SUB.B #20, (A4) ;
    
    
    
    SIMHALT             ; halt simulator
    
* Put variables and constants here

playerPoints dc.b   $0 ;
health dc.b         $64 ;
playerX dc.b        $0 ;
playerY dc.b        $0 ;
bossHealth dc.b     $64 ;
bossX dc.b         $5 ;
bossY dc.b          $5 ;

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
