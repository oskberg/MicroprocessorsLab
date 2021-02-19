	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
	
largeDelay:
	movlw	0x00
ldLoop:	; There is only no carry when going from 0 -> 0xFF for both hi and low
	decf	lo, f, A
	subwfb	hi, f, A
	bc	ldLoop	    ; loop if carry
	return 0	    ; return when no carry

start:
	c0	equ 0x10    ; counter location
	len	equ 0xFFFF    ; lenght of delay
	hi	equ 0x20    ; high 16 bit
	lo	equ 0x21    ; low 16 bit
	outLim	equ 0x7F    ; break counting loop at this value
	
	movlw	0x00	    ; initialise counter to 0
	movwf	c0, A	    
	movwf	TRISC, A    ; set c to output mode
	

count:
	movlw	high(len)   ; reset delay value
	movwf	hi, A
	movlw	low(len)
	movwf	lo, A
	    
	call	largeDelay  ; call delay
	
	movf	c0, W, A    ; put counter value on port c
	movwf	PORTC, A    
	incf	c0, F, A    ; increment counter
	movlw	outLim	    ; break if counter larger than break value
	cpfsgt	c0, A
	bra	count

	bra	start
	
	
