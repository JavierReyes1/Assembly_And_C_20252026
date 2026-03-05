*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    ;TASK 0
    MOVE.B #0, D0       
    TRAP   #15
    
    LEA TASK_0,A1
    MOVE.W #6, D1
    TRAP #15
    
    ;TASK 1
    MOVE.B #1, D0   ;INSTRUCTION FOR TRAP
    
    LEA TASK_1, A1  
    MOVE.W  #6,D1
    TRAP #15
    
    
    ;TASK 2
    MOVE.B  #2, D0  ;INTRUCTION FOR TRAP, USE INPUT 
    
    TRAP #15
    
    MOVE.W D1, A1   ;MOVE VALUE FROM D1 TO A1
        ;DISPLAY INPUT LENGHT INTEGER
    
    ;TASK 3
    MOVE.B #3, D0   ;INSTRUCT TRAP TO DISPLAY INTEGER LENGTH
    TRAP #15
    
    ;TASK4
    MOVE.B #4, D0 ;INSTRUCT TRAP TO TAKE INTEGER FROM KEYBOARD
    TRAP   #15
    
    ;TASK5
    MOVE.B #5, D0 ; INSTRUCT TRAP TO TAKE ONE CHARACTER FROM KEYBOARD
    TRAP #15
    

    
    
    
    

    SIMHALT             ; halt simulator

* Put variables and constants here

TASK_0: DC.W 'TASK_0' 
TASK_1: DC.W 'TASK_1'
TASK_3: DC.W 'ENTER: ',0
;TASK_2: D
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
