#include <xc.inc>

extrn	LCD_Setup, LCD_Write_Message, LCD_Clear_Screen, LCD_delay_ms, LCD_Cursor_Line_2, LCD_Write_Message_PM
extrn	readRow, readCol
extrn	testRoutine
    
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
rowVal:	    ds 1    ; reserve one byte for the row value
colVal:	    ds 1    ; reserve one byte for the column value

    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup UART
		;setup keypad
	call testRoutine
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

	; delay
	movlw	0xFE
	call	LCD_delay_ms
	movlw	0xFE
	call	LCD_delay_ms
	
	; write row input to lcd
	call	readRow		    ; move row reading into w
	movwf	rowVal, A	    ; move row reading int rowVal
	lfsr	2, rowVal
	movlw	1
	
	call	LCD_Write_Message   ; write message
	
	
;		; write to LCD from ram
;	movlw	myTable_l	; output message to LCD
;	addlw	0xff		; don't send the final carriage return to LCD
;	lfsr	2, myArray
;	call	LCD_Write_Message   ; write message

	; delay
	movlw	0xFE
	call	LCD_delay_ms
	movlw	0xFE
	call	LCD_delay_ms
	
	bra	writeLoop
	goto	$		; goto current line in code

	; a delay subroutine if you need one, times around loop in delay_count
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst