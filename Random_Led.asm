LIST P=16F877A ;PIC WAS DEFINED.
;To use registered PIC names 
INCLUDE "P16F877A.INC" ;
__CONFIG 0X3F32 

TIME1 EQU 0X20 ;0X20 is assigned to TIME1 to be used in DELAY subprogram
TIME2 EQU 0X21 ;
COUNTER EQU 0X22 ;Created a counter

BSF STATUS,5;Passing bank
MOVLW 0X07; Choose all PortA
MOVWF ADCON1 ;Set chosen pinnes as digital
BSF PORTB,0;Reducer button is assigned to PortB0 and set as input
BSF PORTB,1;Increaser button is assigned to PortB0 and set as input
CLRF TRISD ; PortD set to be output
BSF PORTA,0;PORTA,0 set to be input port
BSF PORTA,1; PORTA,1 set to be input port
BCF STATUS,5; Return back to Bank0


Main
 
 MOVF COUNTER,W;Counter values to be assigned to W
 CALL Table;Take 7 segment value from register
 BCF PORTA,1;By using clear PORTA,1 closed
 MOVWF SEGMENT_PORT1;Assign PORT1 To Segment_Port
 BSF PORTA,0;Setting porta,0 to see the value 
 CALL DELAY
 CALL Table;Table was called to install value to the segment,2
 BCF PORTA,0  
 MOVWF SEGMENT_PORT2; Value in Table sub-program
 BSF PORTA,1 
 CALL DELAY
 
Increaser
; If Portb,0=0 it will be decreased 
; If portb,0=1 it will be increased
	BTFSC PORTB,0 ;Portb will be going to Decreaser
	GOTO PORTB,1 ;
	CALL DELAY ;If button was pushed go to DELAY
	INCF COUNTER,F ;COUNTER++
	MOVLW 0X0A 
	SUBWF COUNTER,W ;To compare substract it from counter and assign to W
	BTFSC STATUS,Z 
	GOTO Decimal 
	GOTO Main 

Decreaser
	BTFSC PORTB,1 
	GOTO PORTB,0 

go	
	CALL DELAY ;
	DECF COUNTER,F ;COUNTER--
	MOVLW 0XFF ;Assign 0XFF to W
	SUBWF COUNTER,W ;Comparation
	BTFSS STATUS,Z ;If counter=! OXFF
	GOTO Main ;Main

 
 
 
Table
 
ADDWF PCL,F
RETLW 0X3F ;0 
RETLW 0X06 ;1
RETLW 0X5B ;2
RETLW 0X4F ;3
RETLW 0X66 ;4
RETLW 0X6D ;5
RETLW 0X7D ;6
RETLW 0X07 ;7
RETLW 0X7F ;8
RETLW 0X6F ;9 
 
 
DELAY
 
MOVLW .160 ;TIME1 adress 0XFF
MOVWF TIME1 ;
MOVLW 0XFF ;TIME2 adress 0xFF 
MOVWF TIME2
DECFSZ TIME2,F ;TIME2 --1 ; if TIME2= 0 GO 2 row down, else 1 row pass
GOTO $-1
DECFSZ TIME1,F ;TIME1 --1 ; TIME1=0 GO 2 row down, else 1 row pass
GOTO $-5 ;9 row above
RETURN 
END ;End of the program


