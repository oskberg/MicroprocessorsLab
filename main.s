#include <xc.inc>

extrn	LCD_Setup, LCD_Write_Message, LCD_Clear_Screen, LCD_delay_ms, LCD_Cursor_Line_2, LCD_Write_Message_PM, LCD_delay_x4us
;extrn	readRow, readCol
extrn	testRoutine
    
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
rowVal:	    ds 1    ; reserve one byte for the row value
colVal:	    ds 1    ; reserve one byte for the column value
padVal:	    ds 1    ; reserve one byte for the pad output value

    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup UART
		;setup keypad
;	call	testRoutine
	banksel PADCFG1
	bsf	REPU	    ; set pull-ups
	movlb	0
	clrf	LATE, A	    ; write 0s to lat register
	
	goto	start
	
	; setup buttons on F for input
	setf	TRISD, A

	
	; ******* Main programme ****************************************
start: 	

writeLoop:
    	
	; clear LCD
	call	LCD_Clear_Screen
	
	; write row input to lcd
	call	readRow		    ; move row reading into w
	movwf	rowVal, A	    ; move row reading int rowVal
	
	call	readCol		    ; move col reading into w
	movwf	colVal, A	    ; move col reading int rowVal
	
	iorwf	rowVal, W, A
	movwf	padVal, A
	
	
	
	
	
	lfsr	2, rowVal
	movlw	1
	call	LCD_Write_Message   ; write message
	lfsr	2, colVal
	movlw	1
	call	LCD_Write_Message   ; write message
	lfsr	2, padVal
	movlw	1
	call	LCD_Write_Message   ; write message
	
;		; write to LCD from ram
;	movlw	myTable_l	; output message to LCD
;	addlw	0xff		; don't send the final carriage return to LCD
;	lfsr	2, myArray
;	call	LCD_Write_Message   ; write message

	; delay
	movlw	100
	call	LCD_delay_ms
	
	bra	writeLoop
	goto	$		; goto current line in code

	; a delay subroutine if you need one, times around loop in delay_count
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return
	
readRow:	; read row output
	movlw	0x0f	    ; set 0-3 as input and 4-7 as output on PORT E
	movwf	TRISE, A
	movlw	0x10	    ; 40 us delay to let pin volatges settle
	call	LCD_delay_x4us ; delay
	
	movf	PORTE, W, A ; move result into w
	return
	
readCol:
	movlw	0xf0	    ; set 0-3 as OUTPUT and 4-7 as INPUT on PORT E
	movwf	TRISE, A    
	movlw	0x10	    ; 40 us delay to let pin volatges settle
	call	LCD_delay_x4us ; delay
	
	movf	PORTE, W, A ; move result into w
	return
	
	end	rst
