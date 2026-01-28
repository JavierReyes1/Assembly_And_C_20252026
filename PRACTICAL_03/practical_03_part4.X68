*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here  
    
    
    ;Player attacks boss with weapon and deals 10 points of damage
    ;and moves 5 units, Player gets 25 player points
    LEA bossHealth, A1 ;
    SUB.B #10, (A1) ;
    
    LEA bossX, A1 ;
    ADD.B #5, (A1) ;
    
    LEA bossY, A1 ;
    ADD.B #5, (A1) ;
    
    LEA playerPoints, A1 ;
    ADD.B #25, (A1) ;
    
    ;Boss attacks player with fist attack and deals 20 points of damage
    ;and moves 10 units
    LEA health, A1  ;
    SUB.B #20, (A1) ;
    
    LEA playerX, A1 ;
    ADD.B #10, (A1) ;
    
    LEA playerY, A1 ;
    ADD.B #10, (A1) ;
    
    ;Player uses health potion and restores 5 health unit points
    LEA health, A1 ;
    ADD.B #5, (A1) ;
    
    ;Boss swings a devastating blow hitting player and dealing 50 points
    ;of damage, Player pushed 20 units 
    LEA health, A1 ;
    SUB.B #50, (A1) ;
    
    LEA playerX, A1 ;
    SUB.B #20, (A1) ;
    
    LEA playerY, A1 ;
    SUB.B #20, (A1) ;
    
    
    
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

