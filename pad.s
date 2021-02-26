#include <xc.inc>

global	readRow, readCol
extrn	LCD_delay_x4us
    

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